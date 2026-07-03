# Web Security Interview Questions

The [security-interview-questions](https://github.com/jassics/security-interview-questions) repo's Web Security file is still empty upstream, so these are grounded directly in this site's [OWASP Top 10](../product-security/web-security/owasp-top10.md) and [Web Security Concepts](../product-security/web-security/web-security-concepts.md) pages instead. Expect them to get merged back once the source repo catches up.

## OWASP Top 10 (2021) Deep Dives

??? question "Q: What's the difference between vertical and horizontal broken access control, and which is more common?"
    **Vertical** - a regular user reaches admin-only functionality because the server never re-checks the caller's role on that endpoint. **Horizontal (IDOR)** - a user accesses *another user's* data at the same privilege level by changing an ID (e.g. `GET /api/invoices/482` returning invoice 482 regardless of who's asking), because ownership is never verified server-side.

    IDOR/horizontal issues are the single most common finding in real audits, precisely because a functional test ("can I view my own invoice?") passes fine while the authorization test ("can I view *someone else's* invoice?") is the one that actually needs to be run. The fix in both cases: deny by default, and enforce authorization server-side on every request rather than trusting that IDs are hard to guess.

??? question "Q: Why was XSS folded into the Injection category in the 2021 OWASP Top 10 update, and how do you actually prevent it?"
    Both are the same root problem - untrusted input being interpreted as code rather than data, just in different contexts (a database query vs. the browser's DOM/JS parser). Prevention follows the same shape: never let untrusted input be interpreted as executable content. For XSS specifically: use a framework that auto-escapes output by default (React, Django templates, Vue) rather than hand-building HTML strings, and layer a Content-Security-Policy header as defense in depth - CSP's implicit blocking of inline `<script>` tags neutralizes most real-world XSS payloads even if an escaping bug slips through.

??? question "Q: A password is stored as an unsalted MD5 hash. What category of failure is this, and what's actually wrong with it (beyond 'MD5 is old')?"
    This is a Cryptographic Failure (A02). The specific problems: MD5 is a *fast* hash designed for speed, which is exactly the wrong property for password storage - it makes brute-force/rainbow-table attacks cheap. No salt means identical passwords produce identical hashes across users/systems, making precomputed rainbow tables directly usable. The fix is a slow, salted, purpose-built password hash like Argon2id or bcrypt, which are deliberately expensive to compute so brute-forcing millions of guesses is infeasible even after a database leak. See [Cryptography](../product-security/application-security/cryptography.md) for the full password-hashing picture.

??? question "Q: Explain SSRF with a concrete cloud example, and how you'd defend against it."
    Server-Side Request Forgery: the server fetches a remote resource using a URL the client controls, without validating where it actually points. Classic cloud example - an "import avatar from URL" feature that blindly fetches `http://169.254.169.254/latest/meta-data/iam/security-credentials/` (the AWS instance metadata endpoint), letting an attacker exfiltrate the instance's IAM credentials through a feature that was only ever meant to download images.

    Defenses: allow-list destination hosts rather than blocking a denylist, block requests to private/link-local IP ranges (including `169.254.169.254`) at the network layer, disable following redirects on user-supplied URLs (an attacker can bypass an allow-list with a redirect chain), and require IMDSv2 on AWS, which needs a session token that a basic SSRF request can't obtain.

## Browser & HTTP Mechanics

??? question "Q: What's the Same-Origin Policy, and why does CORS exist as an exception to it rather than a replacement?"
    The Same-Origin Policy is the browser's default boundary: a page can only freely read data from another page if they share the same origin (scheme + host + port, all three matching). Without it, any tab you had open could read your logged-in session data from another tab, like your bank. CORS exists so a server can *deliberately opt in* to letting specific other origins read its responses via response headers (`Access-Control-Allow-Origin`) - it's a controlled, server-authorized exception, not a general loosening of the browser's default-deny stance.

??? question "Q: What's wrong with an API that reflects the request's Origin header back as Access-Control-Allow-Origin?"
    Reflecting the `Origin` header dynamically effectively allows *any* origin to make cross-origin requests, since whatever origin sends the request gets echoed back as allowed - it defeats the purpose of an allow-list. It gets especially dangerous combined with `Access-Control-Allow-Credentials: true` (browsers technically block the literal combination of `*` with credentials, but a dynamically-reflected origin isn't literally `*`, so this combination does work and lets any origin make authenticated, credentialed requests on a victim's behalf). The fix is an explicit, server-side allow-list of trusted origins - never derive the allowed origin from the incoming request.

??? question "Q: Which cookie flag actually stops session-token theft via XSS, and why don't the others help?"
    `HttpOnly` - it makes the cookie inaccessible to JavaScript (`document.cookie` can't read it), so even if an XSS bug lets an attacker run script in the victim's browser, that script literally cannot read the session cookie to exfiltrate it. `Secure` only prevents the cookie from being sent over plaintext HTTP (defends against network-level MITM, not XSS), and `SameSite` controls cross-site request behavior (defends against CSRF, not XSS). All three matter, but if the question is specifically "how do you defend the session cookie against XSS," the answer is `HttpOnly`.

??? question "Q: Explain CSRF and why SameSite=Lax cookies have meaningfully reduced its real-world impact."
    CSRF: a malicious site tricks a victim's browser into making a state-changing request to a site the victim is already authenticated to (e.g. an `<img src="https://bank.com/transfer?to=attacker&amount=1000">` tag on an attacker's page), riding on the browser's automatic inclusion of the victim's existing cookies. It works because cookies are sent automatically regardless of which site initiated the request.

    `SameSite=Lax` (now the browser default) stops most cross-site cookie sending outright - the cookie simply isn't attached to most cross-site requests, so the forged request arrives unauthenticated and fails before it ever reaches application logic. This is why CSRF, once one of the most common web vulnerabilities, has become far less prevalent in practice: the defense moved from "every app must remember to implement CSRF tokens correctly" to "the browser does it by default." CSRF tokens remain useful defense in depth, especially for `SameSite=None` cases (e.g. legitimate cross-site embedding) - but note CSRF tokens don't help against XSS, and CSP doesn't help against CSRF; they're different threats.

## Practice Next

- [OWASP Top 10 (2021)](../product-security/web-security/owasp-top10.md)
- [Web Security Concepts](../product-security/web-security/web-security-concepts.md)
- [Web Security Testing Study Plan](../study-plan/cybersecurity/web-security-testing-study-plan.md)
- [security-interview-questions](https://github.com/jassics/security-interview-questions) on GitHub for the canonical, evolving question set
