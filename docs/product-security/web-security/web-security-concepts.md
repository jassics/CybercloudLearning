# Web Security Concepts

## Why These Mechanics Matter

The [OWASP Top 10](owasp-top10.md) tells you *what* can go wrong. This page covers the underlying browser/HTTP mechanics that either cause those risks or defend against them - the stuff interviewers probe to check you understand the "why," not just the checklist.

## Same-Origin Policy (SOP)

The browser's foundational security boundary: a page can only freely read data from another page if they share the same **origin** - scheme + host + port, all three.

```
https://app.example.com:443   vs   https://api.example.com:443   -> different origin (different host)
https://example.com:443       vs   http://example.com:443        -> different origin (different scheme)
```

Without SOP, any website you visit could read your logged-in session data from your bank's tab. It's why CORS exists at all - CORS is the *controlled exception* to SOP, not a replacement for it.

## CORS (Cross-Origin Resource Sharing)

A server opts in to letting specific other origins read its responses via response headers:

```
Access-Control-Allow-Origin: https://trusted-app.com
Access-Control-Allow-Credentials: true
```

**Common misconfigurations** (these come up constantly in real audits and interviews):

- Reflecting the request's `Origin` header back verbatim as `Access-Control-Allow-Origin: *` while also setting `Access-Control-Allow-Credentials: true` - browsers actually block this combination, but many APIs get caught mirroring the origin dynamically to work around it, effectively allowing any origin to make authenticated requests.
- Setting `Access-Control-Allow-Origin: *` on an endpoint that returns sensitive, user-specific data.
- Whitelisting overly broad origin patterns (e.g. `*.example.com` when a subdomain is attacker-controlled or user-generated content is hosted there).

**Mitigation:** explicit allow-list of trusted origins, never `*` alongside credentials, and treat CORS config changes as a security review item, not just a "make the frontend work" fix.

## Cookies: the Three Flags That Matter

| Flag | What it does | Why it matters |
|------|---------------|------------------|
| `Secure` | Cookie only sent over HTTPS | Prevents leaking the cookie over a plaintext connection (e.g. on a coffee-shop WiFi MITM) |
| `HttpOnly` | Cookie inaccessible to JavaScript (`document.cookie`) | Blocks session-token theft via XSS |
| `SameSite` | Controls whether the cookie is sent on cross-site requests (`Strict`, `Lax`, `None`) | Primary modern defense against CSRF |

```
Set-Cookie: session=abc123; Secure; HttpOnly; SameSite=Strict
```

If you're asked "how do you prevent session hijacking via XSS," the answer starts with `HttpOnly` - even if an XSS bug exists, the attacker's injected script literally cannot read the cookie.

## Content Security Policy (CSP)

A response header that restricts what a page is allowed to load/execute, as defense in depth against XSS:

```
Content-Security-Policy: default-src 'self'; script-src 'self' https://cdn.trusted.com; object-src 'none'
```

This means: only load scripts from the page's own origin or the named CDN, block plugins entirely (`object-src 'none'`), and implicitly block inline `<script>` tags unless you explicitly allow them (which you generally shouldn't - inline scripts are exactly what most XSS payloads rely on).

## HTTPS/TLS at the Web Layer

- HTTPS wraps HTTP in TLS, providing confidentiality (encryption), integrity (tamper detection), and authentication (the certificate proves you're talking to the domain you think you are).
- **HSTS** (`Strict-Transport-Security` header) tells the browser to *never* attempt plain HTTP for this domain again, closing the window for SSL-stripping downgrade attacks on subsequent visits.
- See [Cryptography](../application-security/cryptography.md) for the underlying TLS mechanics (cipher suites, certificate validation).

## Session Management

- Session identifiers should be long, random, and generated with a cryptographically secure RNG - never derived from predictable data (timestamps, sequential IDs, usernames).
- Regenerate the session ID on privilege change (login, logout, privilege escalation) to prevent **session fixation** - where an attacker sets a victim's session ID before they authenticate, then reuses it after.
- Sessions should expire both on inactivity (idle timeout) and after an absolute maximum lifetime, regardless of activity.

## CSRF and How Tokens Prevent It

**Cross-Site Request Forgery**: a malicious site tricks a victim's browser into making a state-changing request to a site the victim is already authenticated to, riding on their existing cookies.

```html
<!-- Hosted on evil.com, victim is logged into bank.com -->
<img src="https://bank.com/transfer?to=attacker&amount=1000">
```

Because cookies are sent automatically by the browser regardless of which site initiated the request, `bank.com` sees what looks like a legitimate, authenticated request.

**Defenses:**

1. **CSRF tokens** - a unique, unpredictable token embedded in forms/requests that an attacker's cross-site request can't know or include.
2. **`SameSite=Lax` or `Strict` cookies** - stops the cookie from being sent on cross-site requests in the first place, which is why modern browsers defaulting to `SameSite=Lax` has meaningfully reduced CSRF's real-world impact.
3. Checking the `Origin`/`Referer` header as a secondary signal (not sufficient alone, but useful defense in depth).

Note CSRF and XSS are often confused in interviews: CSRF forges a request *from* the victim's browser using their existing session; XSS injects and runs attacker script *inside* the victim's browser session. They're different threats with overlapping mitigations (both benefit from `HttpOnly`/`SameSite` cookies, but CSRF tokens don't help against XSS and CSP doesn't help against CSRF).

## Credits/References

1. [OWASP Top 10 (2021)](owasp-top10.md)
2. [MDN: Same-origin policy](https://developer.mozilla.org/en-US/docs/Web/Security/Same-origin_policy)
3. [OWASP CSRF Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Cross-Site_Request_Forgery_Prevention_Cheat_Sheet.html)
4. [OWASP Session Management Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Session_Management_Cheat_Sheet.html)
