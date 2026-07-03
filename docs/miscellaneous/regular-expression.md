# Regular Expression Essentials

## Why Security Engineers Need Regex

Regex shows up constantly in security work: writing SAST/secret-scanning rules, parsing logs during incident response, extracting IOCs from threat intel, and building input-validation allow-lists. This page is a practical primer, not a full regex course - enough to be dangerous (in a good way) in an interview or on the job.

## Syntax Primer

| Token | Meaning | Example |
|-------|---------|---------|
| `^` `$` | Start / end of string (or line, in multiline mode) | `^ERROR` matches lines starting with ERROR |
| `.` | Any character except newline | `a.c` matches `abc`, `a1c` |
| `*` `+` `?` | 0-or-more, 1-or-more, 0-or-1 | `ab*` matches `a`, `ab`, `abbb` |
| `{n,m}` | Between n and m repetitions | `\d{3,5}` matches 3-5 digits |
| `[...]` | Character class | `[A-Za-z0-9]` matches any alphanumeric |
| `[^...]` | Negated character class | `[^0-9]` matches anything except a digit |
| `\d` `\w` `\s` | Digit, word character, whitespace | `\d+` matches one or more digits |
| `(...)` | Capturing group | `(\d{3})-(\d{4})` captures two groups |
| `(?:...)` | Non-capturing group | Groups without capturing, faster/cleaner |
| `\|` | Alternation (OR) | `cat\|dog` matches either |
| `(?=...)` | Positive lookahead | `foo(?=bar)` matches `foo` only if followed by `bar` |
| `(?!...)` | Negative lookahead | `foo(?!bar)` matches `foo` only if NOT followed by `bar` |
| `(?<=...)` | Positive lookbehind | `(?<=\$)\d+` matches digits only if preceded by `$` |

## Security-Relevant Patterns

### Matching IP Addresses

```regex
\b(?:[0-9]{1,3}\.){3}[0-9]{1,3}\b
```

Quick and dirty - matches the shape of an IPv4 address but doesn't validate each octet is 0-255. For real validation (e.g. in input handling, not just log grepping), use your language's IP-parsing library instead of a regex - this is a common interview trap ("write a regex to validate an IP" often has a better answer: "don't, use `ipaddress.ip_address()` in Python").

### Extracting Emails/URLs from Logs

```regex
[\w.+-]+@[\w-]+\.[\w.-]+          # email (good enough for log triage, not RFC-complete)
https?://[^\s"'<>]+               # URL
```

### Detecting Common Secret Patterns

Basic building blocks for a homegrown secret-scanner rule (tools like gitleaks/TruffleHog use much more refined versions of these):

```regex
AKIA[0-9A-Z]{16}                       # AWS Access Key ID
-----BEGIN (RSA|EC|OPENSSH|DSA) PRIVATE KEY-----   # Private key header
[a-zA-Z0-9_-]{32,45}                   # Generic-looking API key/token (very broad - high false positive rate)
gh[pousr]_[A-Za-z0-9]{36,}             # GitHub personal access token
```

These are exactly the kind of patterns backing the [secret-scan skill](../resources/index.md) type of tooling and pre-commit hooks - see [Git Essentials](git-basics.md) for the workflow around preventing secrets from ever being committed.

### Log Parsing One-Liners

```bash
# Find all failed SSH login attempts and the source IPs
grep "Failed password" /var/log/auth.log | grep -oE '([0-9]{1,3}\.){3}[0-9]{1,3}' | sort | uniq -c | sort -rn

# Find lines with a suspicious base64-looking blob (common in obfuscated payloads)
grep -oE '[A-Za-z0-9+/]{40,}={0,2}' access.log

# Extract all unique User-Agent strings from an access log
grep -oE '"[^"]*Mozilla[^"]*"' access.log | sort -u
```

## ReDoS: When Regex Itself Is the Vulnerability

**Regular Expression Denial of Service (ReDoS)** happens when a regex has catastrophic backtracking - certain crafted inputs cause the regex engine to take exponential time to fail a match, hanging the process.

```regex
(a+)+$        # classic vulnerable pattern
```

Given an input like `"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa!"` (many `a`s followed by a character that doesn't match), this pattern can take minutes or hours to fail, because the engine tries every possible way to partition the `a`s among the nested groups before giving up.

**Mitigation:**

- Avoid nested quantifiers over the same characters (`(a+)+`, `(a*)*`, `(a|a)*`)
- Use atomic groups or possessive quantifiers where your regex engine supports them
- Set a timeout on regex execution against untrusted input
- Test regex rules used in input validation against adversarial inputs, not just valid examples - this is now its own line item in some SAST rulesets (flagging ReDoS-prone patterns in source code)

## Credits/References

1. [OWASP Regular Expression Denial of Service (ReDoS)](https://owasp.org/www-community/attacks/Regular_expression_Denial_of_Service_-_ReDoS)
2. [regex101.com](https://regex101.com/) - interactive regex tester with explanation
3. [gitleaks](https://github.com/gitleaks/gitleaks) - real-world example of regex-based secret detection rules
