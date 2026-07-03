# Secure Coding

## What is Secure Coding?

Secure coding is the practice of writing software that is resistant to vulnerabilities, defects, and logic flaws that attackers could exploit. It shifts security left - catching issues at design and development time rather than after deployment, where fixes are far more expensive.

Secure coding is not a separate discipline from software engineering; it is a set of habits and guardrails applied throughout the normal development process.

## Why Secure Coding Matters

- Most breaches trace back to preventable coding mistakes - injection flaws, broken authentication, insecure deserialization, and misconfigured access controls.
- Fixing a vulnerability in production can cost far more than catching it during development, per long-standing NIST/IBM cost-of-fix research.
- Regulatory frameworks (PCI-DSS, HIPAA, GDPR) increasingly expect demonstrable secure development practices.

## Core Secure Coding Principles

| Principle | Description |
|-----------|-------------|
| **Least Privilege** | Code, services, and users should only have the minimum access required to function |
| **Defense in Depth** | Layer multiple controls so a single failure doesn't lead to compromise |
| **Fail Securely** | On error, default to a secure state (deny access) rather than an insecure one |
| **Never Trust User Input** | Validate, sanitize, and encode all input at trust boundaries |
| **Minimize Attack Surface** | Remove unused features, endpoints, and dependencies |
| **Secure Defaults** | Ship with the most secure configuration out of the box |
| **Separation of Duties** | No single component/user should control an entire critical process |
| **Keep It Simple** | Complex code hides bugs; simplicity aids review and reasoning |

## Common Vulnerability Classes and Mitigations

### Injection (SQL, Command, LDAP, NoSQL)

- Use parameterized queries / prepared statements - never string-concatenate user input into queries or commands.
- Use an ORM with proper escaping, but don't assume ORMs are automatically injection-proof (raw query methods still exist).
- Apply allow-lists for inputs that map to system commands or file paths.

```python
# Insecure
cursor.execute(f"SELECT * FROM users WHERE id = {user_id}")

# Secure
cursor.execute("SELECT * FROM users WHERE id = %s", (user_id,))
```

### Broken Authentication & Session Management

- Use vetted authentication libraries/frameworks instead of rolling your own.
- Store passwords with a slow, salted hash (bcrypt, scrypt, or Argon2) - never MD5/SHA1 alone.
- Invalidate sessions on logout, password change, and after a reasonable idle timeout.
- Enforce MFA for privileged or sensitive operations.

### Cross-Site Scripting (XSS)

- Encode output based on context (HTML, attribute, JavaScript, URL).
- Use frameworks that auto-escape by default (React, Angular, Django templates) and avoid `dangerouslySetInnerHTML` / `innerHTML` with untrusted data.
- Set a strict Content-Security-Policy (CSP) header as a defense-in-depth control.

### Insecure Deserialization

- Avoid deserializing untrusted data with native/native-like serializers (e.g., Python `pickle`, Java native serialization, PHP `unserialize`).
- Prefer safe data formats (JSON, protobuf) with schema validation.

### Sensitive Data Exposure

- Encrypt sensitive data at rest (AES-256) and in transit (TLS 1.2+).
- Never log secrets, tokens, or PII in plaintext.
- Use secret managers (Vault, AWS Secrets Manager, GCP Secret Manager) instead of hardcoding credentials.

### Broken Access Control

- Enforce authorization checks on every request server-side - never rely on hiding a UI element.
- Use centralized authorization logic rather than scattering checks across the codebase.
- Test for Insecure Direct Object Reference (IDOR) by attempting to access other users' resources.

### Security Misconfiguration

- Disable debug modes, verbose error messages, and default credentials in production.
- Automate configuration checks via infrastructure-as-code and policy-as-code (e.g., OPA, Checkov).

## Language/Framework-Specific Guidance

| Stack | Key Secure Coding Concerns |
|-------|------------------------------|
| **Python** | Avoid `eval`/`exec` on untrusted input, use `subprocess` with argument lists (not `shell=True`), pin dependency versions |
| **JavaScript/Node.js** | Avoid `eval`, validate JSON schemas, audit `npm` dependencies, beware prototype pollution |
| **Java** | Disable XML external entities (XXE), avoid unsafe deserialization, use `PreparedStatement` |
| **Go** | Use `html/template` (auto-escaping) instead of `text/template` for web output, check error returns |

## Secure SDLC Integration

1. **Requirements** - Define security/abuse-case requirements alongside functional ones.
2. **Design** - Perform threat modeling (see [Threat Modeling](threat-modeling.md)).
3. **Implementation** - Follow secure coding standards, use linters and pre-commit hooks.
4. **Verification** - Run SAST ([SAST](sast.md)), SCA ([SCA](sca.md)), and manual [Secure Code Review](secure-code-review.md).
5. **Release** - Gate deployments on passing security scans.
6. **Response** - Monitor, patch, and feed lessons learned back into coding standards.

## Secure Coding Checklists & Standards

- [OWASP Secure Coding Practices Quick Reference Guide](https://owasp.org/www-project-secure-coding-practices-quick-reference-guide/)
- [OWASP Application Security Verification Standard (ASVS)](https://owasp.org/www-project-application-security-verification-standard/)
- [CERT Secure Coding Standards](https://wiki.sei.cmu.edu/confluence/display/seccode)
- [SANS Top 25 Most Dangerous Software Errors](https://www.sans.org/top25-software-errors/)

## Credits/References

1. [OWASP Foundation](https://owasp.org/)
2. [OWASP Secure Coding Practices](https://owasp.org/www-project-secure-coding-practices-quick-reference-guide/)
3. [CERT Coding Standards, Carnegie Mellon SEI](https://wiki.sei.cmu.edu/confluence/display/seccode)
4. [NIST SP 800-218: Secure Software Development Framework](https://csrc.nist.gov/pubs/sp/800/218/final)
