# Authentication & Session Security

## Scope of This Page

[Secure Coding](secure-coding.md) already covers the basics (use vetted auth libraries, hash passwords properly, enforce MFA on sensitive operations) and [Cryptography](cryptography.md) covers Argon2id password hashing in depth - this page doesn't repeat either. Instead, it goes deep on the **authentication flow itself**: how modern token-based auth actually works, where it breaks, and how session management fails in practice.

## Multi-Factor Authentication: Not All Factors Are Equal

MFA means proving your identity with more than one factor (something you know, have, or are). But the factors are not interchangeable in security value:

| Factor | Example | Phishing Resistance |
|--------|---------|------------------------|
| SMS OTP | 6-digit code texted to your phone | **Weakest** - vulnerable to SIM-swapping (an attacker socially engineers your carrier into porting your number to their SIM), SS7 network interception, and real-time phishing proxies that relay the OTP as you type it |
| TOTP (authenticator app) | Google Authenticator, Authy | Better than SMS - not interceptable via telecom attacks - but still phishable via a real-time adversary-in-the-middle proxy that relays the code |
| WebAuthn / Passkeys | FIDO2 hardware key or platform authenticator (Face ID, Windows Hello) | **Strongest, phishing-resistant** - the credential is cryptographically bound to the exact origin (domain) it was registered for, so it simply won't work on a look-alike phishing domain, and the private key never leaves the device |

**NIST SP 800-63B (Rev. 4, 2024)** has formally downgraded SMS OTP - it no longer counts as sufficient for AAL2 (the practical baseline for most regulated workloads) - and ranks FIDO2/WebAuthn as the strongest, phishing-resistant tier. If you're designing MFA for a new system today, default to WebAuthn/passkeys and treat SMS OTP as a legacy fallback at best, not a first-class factor.

## OAuth 2.0 vs. OpenID Connect vs. SAML

These three get confused constantly, including by experienced developers - and the confusion itself causes vulnerabilities.

| Standard | What Problem It Actually Solves | Format |
|----------|-----------------------------------|--------|
| **OAuth 2.0** | *Delegated authorization*: "can this third-party app perform action X on my behalf, without me giving it my password?" | JSON/REST, bearer tokens |
| **OpenID Connect (OIDC)** | *Authentication*, built as an identity layer on top of OAuth2: "who is this user?" - adds the ID Token | JWT-based ID Token on top of OAuth2 |
| **SAML** | Older enterprise SSO standard, mostly authentication - predates OAuth2 | XML, browser-redirect based |

**The classic mistake:** using a raw OAuth2 **access token** as proof of identity. An access token proves "this client is authorized to call this API with these scopes" - it says nothing verified about *who* the end user is, because access tokens are opaque-by-design and their format/content is an implementation detail the client shouldn't parse. If you need to know who the user is, you need an OIDC **ID token** (a JWT with verified identity claims), not an OAuth2 access token. Building "login with Google" using only an access token, without validating an ID token, is a real, still-common vulnerability pattern.

### Common OAuth2 Vulnerabilities

- **`redirect_uri` validation bypass** - if the authorization server doesn't strictly validate the `redirect_uri` against a pre-registered allow-list (e.g. allowing any subdomain, or matching only a prefix), an attacker can register `https://evil.com/callback` (or find an open redirect on the legitimate domain) and receive the authorization code or token intended for the victim.

    ```text
    # Vulnerable: any URI starting with the registered value is accepted
    Registered:  https://myapp.com/callback
    Accepted:    https://myapp.com/callback.evil.com/  ← attacker-controlled, passes a naive "startswith" check

    # Secure: exact match against a pre-registered allow-list, no wildcards
    Registered:  https://myapp.com/callback
    Accepted:    https://myapp.com/callback  (exact match only)
    ```

- **Missing/predictable `state` parameter** - `state` is OAuth2's built-in CSRF protection for the authorization flow. Without a unique, unguessable `state` value validated on callback, an attacker can trick a victim into completing an OAuth flow bound to the attacker's account (login CSRF).
- **Authorization code interception** - on public clients (mobile/SPA apps that can't keep a secret), a stolen authorization code can be redeemed by an attacker. **PKCE** (Proof Key for Code Exchange, RFC 7636) closes this by requiring the client to prove it initiated the original request via a code verifier/challenge pair - PKCE is now recommended for all OAuth2 clients, not just public ones.

## JWT (JSON Web Token) Pitfalls

JWTs are the most common self-contained token format for modern APIs - but they're also one of the most consistently misimplemented pieces of AppSec.

### `alg: none`

A JWT's header declares its own signing algorithm. Some early/naive JWT libraries would honor `"alg": "none"` in the header and skip signature verification entirely - meaning anyone could forge a token by just setting `alg` to `none` and omitting the signature. Modern libraries reject this by default, but it remains a real finding in poorly-configured or custom JWT handling code.

### Algorithm Confusion (RS256 → HS256)

A more subtle, still-current attack: many services use **RS256** (asymmetric - server holds a private key, exposes the matching **public key**, often at a public `/.well-known/jwks.json` endpoint for anyone to fetch). An attacker who can fetch that public key can:

1. Forge a JWT with the header changed to `"alg": "HS256"` (symmetric).
2. Sign it using the server's own **public key as the HMAC secret**.
3. If the server's verification code accepts whatever `alg` the token *claims* rather than pinning the expected algorithm, it computes the same HMAC with the same "secret" (the public key) - the forged signature validates, and the attacker has a token for any identity they chose.

This is entirely preventable, but requires the fix to be explicit:

```python
import jwt  # PyJWT

# Vulnerable: trusts whatever algorithm the token header claims
payload = jwt.decode(token, key, algorithms=jwt.get_unverified_header(token)["alg"])

# Secure: pin the exact expected algorithm(s) - never derive it from the token itself
payload = jwt.decode(token, public_key, algorithms=["RS256"])
```

### Other JWT Mistakes

- **Missing expiration validation** - always set and enforce `exp`; a JWT with no expiry is a credential that never needs re-issuing, i.e. a permanent key if leaked.
- **Treating JWTs as encrypted** - a standard JWT is *signed*, not *encrypted*. Anyone can base64-decode the payload and read it (try it on [jwt.io](https://jwt.io/)) - never put secrets or sensitive PII in a standard JWT payload. If you need confidentiality, use a JWE (JSON Web Encryption), not a signed-only JWT.

RFC 8725 (JWT Best Current Practices) codifies these lessons - see Credits/References.

## Session Management

Even with token-based auth increasingly common, classic server-side sessions remain widespread and have their own attack patterns:

- **Session fixation** - an attacker sets a known session ID on the victim (e.g. via a URL parameter or a cookie set before login) and waits for the victim to authenticate under that same session ID, which the attacker already knows. **Mitigation:** always issue a brand-new session ID on successful login/privilege change - never reuse a pre-authentication session ID post-authentication.
- **Session hijacking** - an attacker steals a valid session ID (via XSS reading a non-`HttpOnly` cookie, network sniffing without TLS, or a leaked log). Cookie flags (`Secure`, `HttpOnly`, `SameSite`) are the primary defense here and are covered in depth in [Web Security Concepts](../web-security/web-security-concepts.md) - this page focuses on the session lifecycle itself, not the cookie attributes.
- **Timeout strategy** - use both an **idle timeout** (session dies after N minutes of inactivity) and an **absolute timeout** (session dies after N hours regardless of activity) - relying on only one leaves a gap (idle-only never expires an actively-refreshed session; absolute-only leaves an abandoned-but-active session valid until the deadline).
- **"Remember me" tradeoffs** - a long-lived persistent login token is convenience traded directly for security exposure window; if you offer it, use a separate, revocable, rotating token (never just extend the normal session's lifetime), and always allow users to see and revoke active "remembered" sessions/devices.

## Credits/References

1. [RFC 8725: JSON Web Token Best Current Practices](https://datatracker.ietf.org/doc/html/rfc8725)
2. [RFC 7636: Proof Key for Code Exchange (PKCE)](https://datatracker.ietf.org/doc/html/rfc7636)
3. [OWASP Authentication Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html)
4. [OWASP Session Management Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Session_Management_Cheat_Sheet.html)
5. [OWASP JSON Web Token Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/JSON_Web_Token_for_Java_Cheat_Sheet.html)
6. [PortSwigger: JWT Algorithm Confusion Attacks](https://portswigger.net/web-security/jwt/algorithm-confusion)
7. [NIST SP 800-63B: Digital Identity Guidelines - Authentication](https://pages.nist.gov/800-63-4/sp800-63b.html)
8. [FIDO Alliance: Passkeys](https://fidoalliance.org/passkeys/)

## Practice Next

- [Secure Coding](secure-coding.md) and [Cryptography](cryptography.md) for the broader secure-coding and password-hashing context
- [Authorization Security](authorization-security.md) for the "what can this authenticated user actually do" half of the identity problem
- [API Security](api-security.md) for how these auth patterns apply specifically to API design
