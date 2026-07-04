# OWASP Top 10 (2025)

## What This List Actually Is

The OWASP Top 10 is a data-driven consensus ranking of the most critical web application security risks, refreshed roughly every 3-4 years by OWASP from a combination of testing/tooling data and an industry practitioner survey. It's not an exhaustive vulnerability list - it's a prioritization tool, and it's one of the most commonly referenced lists in security interviews across every specialization, not just AppSec.

!!! info "This page covers the 2025 edition"
    OWASP published the **Top 10:2025** as the current edition, superseding **Top 10:2021**. If you learned the 2021 list, note the biggest shifts: Broken Access Control jumped to **#1** and absorbed SSRF (no longer a standalone category), Security Misconfiguration jumped from #5 to **#2** (OWASP found misconfiguration issues in 100% of tested applications), and two genuinely new categories appeared - **Software Supply Chain Failures** (#3) and **Mishandling of Exceptional Conditions** (#10). Make sure you can speak to the 2025 list and what changed in an interview - citing 2021 as current is a quick way to look out of date.

## The 2025 List

| # | Risk | Description | Real-World Example |
|---|------|--------------|---------------------|
| A01 | Broken Access Control | Users can act outside their intended permissions; now also covers what used to be standalone SSRF | A regular user edits `?acct=notmyacct` in a URL and views another user's account (IDOR) |
| A02 | Security Misconfiguration | Missing hardening, unnecessary features enabled, verbose errors, insecure security headers | Cloud storage bucket left publicly readable by default |
| A03 | Software Supply Chain Failures | Vulnerabilities or malicious changes introduced via third-party code, tools, or dependencies | The 2025 Shai-Hulud npm worm - the first successful self-propagating package attack, harvesting credentials and spreading across 500+ package versions |
| A04 | Cryptographic Failures | Sensitive data exposed due to weak/missing crypto | Passwords stored with unsalted MD5, or a site serving login forms over plain HTTP |
| A05 | Injection | Untrusted input is interpreted as code/commands (includes XSS) | Classic SQL injection via string-concatenated queries |
| A06 | Insecure Design | Missing or ineffective security controls baked into the design itself, not just a coding bug | A password reset flow that emails the new password in plaintext by design |
| A07 | Authentication Failures | Weak session management, credential stuffing exposure, weak password policies | No rate limiting on login, enabling credential-stuffing attacks |
| A08 | Software or Data Integrity Failures | Code/infrastructure that doesn't verify integrity of updates, CI/CD, or serialized data | Auto-updating software that installs unsigned packages from an untrusted source |
| A09 | Security Logging and Alerting Failures | Insufficient logging/alerting to detect and respond to breaches | A breach goes undetected for months because no one is monitoring failed-login spikes |
| A10 | Mishandling of Exceptional Conditions | Failing to prevent, detect, or safely respond to unusual/unpredictable runtime conditions | A file-upload handler that catches an exception without releasing resources, letting repeated uploads exhaust the system |

## Deep Dive: The Ones You'll Be Asked About Most

### A01: Broken Access Control

The single most common finding in real audits, and now the #1 risk outright. Two failure modes show up constantly:

- **Vertical**: a regular user reaches admin-only functionality because the server never re-checks role on that endpoint.
- **Horizontal (IDOR)**: a user accesses another user's data by changing an ID, because ownership is never verified.
- **SSRF** (folded into this category in 2025): the server fetches a remote resource using an unvalidated user-supplied URL, which can reach internal cloud metadata endpoints (`http://169.254.169.254/...`) and pull IAM credentials.

```text
# Vulnerable
GET /api/invoices/482       -> returns invoice 482 regardless of who's asking

# Fixed
GET /api/invoices/482       -> server checks invoice.owner_id == current_user.id, else 403
```

**Mitigation:** deny by default, enforce authorization server-side on every request, allow-list destination hosts and block private/link-local IP ranges for any server-side URL fetch, and test explicitly for "can User A reach User B's data" - don't rely on IDs being hard to guess. See [Authorization & Access Control](../application-security/authorization-security.md) for the full deep dive.

### A02: Security Misconfiguration

A "boring" category that produces some of the highest-impact real breaches, and one OWASP found in **100% of tested applications** in the 2025 dataset - because it's a configuration state, not a code bug, it often survives multiple code reviews unnoticed.

Common instances: unremoved sample apps/default credentials never changed, directory listing enabled (letting attackers enumerate and download compiled code to reverse-engineer access control flaws), verbose stack traces shown to users, unnecessary HTTP methods (`TRACE`, `PUT`) enabled, cloud storage with public-read left on by accident.

**Mitigation:** harden by default, automate configuration checks (policy-as-code tools like Checkov/OPA - see [Compliance as Code](../devsecops/compliance-as-code.md)), and disable anything not explicitly needed.

### A03: Software Supply Chain Failures

New as a standalone top-3 category in 2025, reflecting how much real-world damage this class has caused: the 2019 **SolarWinds** breach (malware in a trusted vendor's update compromised ~18,000 organizations), the 2025 **Bybit theft** (a supply-chain attack in wallet software that triggered maliciously only under specific conditions), the 2025 **Shai-Hulud npm worm** (the first successful self-propagating package attack, spreading across 500+ package versions), and known-vulnerable components like Struts 2 (CVE-2017-5638, the root cause of the Equifax breach) and Log4j (CVE-2021-44228, "Log4Shell").

**Mitigation:** generate and maintain a Software Bill of Materials (SBOM), track direct *and* transitive dependencies continuously, monitor CVE/NVD/OSV feeds, source components only from official/trusted repositories, and use staged rollouts instead of simultaneous fleet-wide deployment. See [SCA](../application-security/sca.md) and [AI Supply Chain Security](../../ai-security/ai-supply-chain-security.md) (if you're also dealing with ML model/dependency risk) for the full tooling and process picture.

### A04: Cryptographic Failures

The root cause is usually one of: not encrypting sensitive data at all, using a broken/weak algorithm, or mismanaging keys.

```python
# Vulnerable - fast hash, no salt, reversible with rainbow tables
password_hash = hashlib.md5(password.encode()).hexdigest()

# Fixed - slow, salted, purpose-built for passwords
from argon2 import PasswordHasher
password_hash = PasswordHasher().hash(password)
```

See [Cryptography](../application-security/cryptography.md) for the full picture on algorithm choice and key management.

### A05: Injection

Covers SQL/NoSQL/command/LDAP injection and XSS. The fix is almost always the same shape: never let untrusted input be interpreted as code.

```python
# Vulnerable
cursor.execute(f"SELECT * FROM users WHERE email = '{email}'")

# Fixed
cursor.execute("SELECT * FROM users WHERE email = %s", (email,))
```

For XSS specifically: use a framework that auto-escapes output by default (React, Django templates) and set a Content-Security-Policy header as defense in depth. See [Injection & Input Validation](../application-security/injection-security.md) for the deep dive across every injection subtype, and [XSS & Client-Side Security](../application-security/xss-client-side-security.md) for the browser-side half.

### A10: Mishandling of Exceptional Conditions

Genuinely new in 2025 - it captures a pattern that was always damaging but never had its own category: applications that don't prevent, detect, or safely respond to unusual runtime states.

Three concrete failure shapes, all real and common:

```python
# 1. Resource exhaustion - catches the exception but never releases the resource,
# so repeated failed uploads exhaust disk/memory/file-handle capacity
try:
    save_upload(file)
except UploadError:
    pass  # resource never cleaned up - DoS via repeated failed uploads

# 2. Information disclosure via error message
except DatabaseError as e:
    return HttpResponse(str(e), status=500)  # leaks schema/version details to the attacker

# 3. Fail-open on a partially completed multi-step transaction
try:
    debit(account_a)
    credit(account_b)
except TransferError:
    pass  # no rollback - account_a debited, account_b never credited
```

**Mitigation:** catch exceptions as close to the source as possible and handle them meaningfully (not just swallow them), design transactions to **fail closed** with complete rollback on error, apply rate limiting/quotas/resource throttling, return generic error messages to users while logging full detail server-side, and centralize logging/monitoring/alerting so failures are visible instead of silent.

## How This Connects to the Rest of the Site

- [Web Security Concepts](web-security-concepts.md) covers the browser-side mechanics (CORS, cookies, CSP) that underpin several of these risks
- [API Security](../application-security/api-security.md) covers the API-specific equivalent (OWASP API Security Top 10), which overlaps but isn't identical
- [Secure Coding](../application-security/secure-coding.md) and [Secure Code Review](../application-security/secure-code-review.md) cover how to prevent/catch these during development
- [Secure Application Architecture](../application-security/secure-application-architecture.md) maps each of these risks onto a reference architecture diagram

## Credits/References

1. [OWASP Top 10:2025](https://owasp.org/Top10/2025/)
2. [OWASP Top 10:2025 - A01 Broken Access Control](https://owasp.org/Top10/2025/A01_2025-Broken_Access_Control/)
3. [OWASP Top 10:2025 - A03 Software Supply Chain Failures](https://owasp.org/Top10/2025/A03_2025-Software_Supply_Chain_Failures/)
4. [OWASP Top 10:2025 - A10 Mishandling of Exceptional Conditions](https://owasp.org/Top10/2025/A10_2025-Mishandling_of_Exceptional_Conditions/)
5. [OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/)
6. [OWASP Foundation](https://owasp.org/)
