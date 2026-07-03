# OWASP Top 10 (2021)

## What This List Actually Is

The OWASP Top 10 is a data-driven consensus ranking of the most critical web application security risks, refreshed roughly every 3-4 years by OWASP from a combination of testing/tooling data and an industry practitioner survey. It's not an exhaustive vulnerability list - it's a prioritization tool, and it's one of the most commonly referenced lists in security interviews across every specialization, not just AppSec.

## The 2021 List

| # | Risk | Description | Real-World Example |
|---|------|--------------|---------------------|
| A01 | Broken Access Control | Users can act outside their intended permissions | A regular user edits `?user_id=` in a URL and views another user's account (IDOR) |
| A02 | Cryptographic Failures | Sensitive data exposed due to weak/missing crypto (previously "Sensitive Data Exposure") | Passwords stored with unsalted MD5, or a site serving login forms over plain HTTP |
| A03 | Injection | Untrusted input is interpreted as code/commands (includes XSS as of 2021) | Classic SQL injection via string-concatenated queries |
| A04 | Insecure Design | Missing or ineffective security controls baked into the design itself, not just a coding bug | A password reset flow that emails the new password in plaintext by design |
| A05 | Security Misconfiguration | Insecure default configs, verbose errors, unnecessary features enabled | Cloud storage bucket left publicly readable by default |
| A06 | Vulnerable and Outdated Components | Using libraries/frameworks with known CVEs | An app running a Log4j version vulnerable to Log4Shell |
| A07 | Identification and Authentication Failures | Weak session management, credential stuffing exposure, weak password policies | No rate limiting on login, enabling credential-stuffing attacks |
| A08 | Software and Data Integrity Failures | Code/infrastructure that doesn't verify integrity of updates, CI/CD, or serialized data | Auto-updating software that installs unsigned packages from an untrusted source |
| A09 | Security Logging and Monitoring Failures | Insufficient logging/alerting to detect and respond to breaches | A breach goes undetected for months because no one is monitoring failed-login spikes |
| A10 | Server-Side Request Forgery (SSRF) | Server fetches a remote resource using an unvalidated user-supplied URL | An "import image from URL" feature used to reach internal cloud metadata endpoints |

## Deep Dive: The Ones You'll Be Asked About Most

### A01: Broken Access Control

The single most common finding in real audits. Two failure modes show up constantly:

- **Vertical**: a regular user reaches admin-only functionality because the server never re-checks role on that endpoint.
- **Horizontal (IDOR)**: a user accesses another user's data by changing an ID, because ownership is never verified.

```
# Vulnerable
GET /api/invoices/482       -> returns invoice 482 regardless of who's asking

# Fixed
GET /api/invoices/482       -> server checks invoice.owner_id == current_user.id, else 403
```

**Mitigation:** deny by default, enforce authorization server-side on every request, and test explicitly for "can User A reach User B's data" - don't rely on IDs being hard to guess.

### A02: Cryptographic Failures

The root cause is usually one of: not encrypting sensitive data at all, using a broken/weak algorithm, or mismanaging keys.

```python
# Vulnerable - fast hash, no salt, reversible with rainbow tables
password_hash = hashlib.md5(password.encode()).hexdigest()

# Fixed - slow, salted, purpose-built for passwords
from argon2 import PasswordHasher
password_hash = PasswordHasher().hash(password)
```

See [Cryptography](../application-security/cryptography.md) for the full picture on algorithm choice and key management.

### A03: Injection

Covers SQL/NoSQL/command/LDAP injection and, since 2021, XSS. The fix is almost always the same shape: never let untrusted input be interpreted as code.

```python
# Vulnerable
cursor.execute(f"SELECT * FROM users WHERE email = '{email}'")

# Fixed
cursor.execute("SELECT * FROM users WHERE email = %s", (email,))
```

For XSS specifically: use a framework that auto-escapes output by default (React, Django templates) and set a Content-Security-Policy header as defense in depth.

### A05: Security Misconfiguration

This is a "boring" category that produces some of the highest-impact real breaches - because it's a configuration state, not a code bug, it often survives multiple code reviews unnoticed.

Common instances: default credentials never changed, directory listing enabled, verbose stack traces shown to users, unnecessary HTTP methods (`TRACE`, `PUT`) enabled, cloud storage with public-read left on by accident.

**Mitigation:** harden by default, automate configuration checks (policy-as-code tools like Checkov/OPA), and disable anything not explicitly needed.

### A10: Server-Side Request Forgery (SSRF)

New as a standalone category in 2021, reflecting how common it's become with cloud metadata endpoints as a target.

```
POST /api/import-avatar
{"image_url": "http://169.254.169.254/latest/meta-data/iam/security-credentials/"}
```

If the server blindly fetches that URL, an attacker can pull cloud IAM credentials out of the instance metadata service.

**Mitigation:** allow-list destination hosts, block requests to private/link-local IP ranges (including `169.254.169.254`), disable following redirects on user-supplied URLs, and require IMDSv2 on AWS (which needs a token, defeating basic SSRF).

## How This Connects to the Rest of the Site

- [Web Security Concepts](web-security-concepts.md) covers the browser-side mechanics (CORS, cookies, CSP) that underpin several of these risks
- [API Security](../application-security/api-security.md) covers the API-specific equivalent (OWASP API Security Top 10), which overlaps but isn't identical
- [Secure Coding](../application-security/secure-coding.md) and [Secure Code Review](../application-security/secure-code-review.md) cover how to prevent/catch these during development

## Credits/References

1. [OWASP Top 10:2021](https://owasp.org/Top10/)
2. [OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/)
3. [OWASP Foundation](https://owasp.org/)
