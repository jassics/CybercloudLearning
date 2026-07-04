# AppSec Preliminary Concepts

## Who This Page Is For

You don't need a computer science degree to start in AppSec, but the rest of this section assumes you're comfortable with a handful of web fundamentals. If terms like "HTTP method," "session," or "three-tier architecture" are fuzzy, start here before [Secure Coding](secure-coding.md).

## The Client-Server Model

A "web application" is, at its core, two programs talking to each other over a network:

- **The client** - usually a browser, but could be a mobile app or another server - sends requests.
- **The server** - your application code, running somewhere - receives requests, does work (reads a database, runs logic), and sends back a response.

Almost every web security concept exists because this conversation happens over an untrusted network, between two parties that don't inherently trust each other. The client can lie about who it is; the server's response can be intercepted or altered in transit. Every control you'll learn about - TLS, authentication, input validation - exists to compensate for that lack of inherent trust.

## HTTP: The Protocol Underneath Everything

HTTP (HyperText Transfer Protocol) is the request/response protocol the web runs on. A request has a method, a path, headers, and (often) a body; a response has a status code, headers, and a body.

### Methods and Why They Matter for Security

| Method | Intended Use | Security Implication |
|--------|---------------|------------------------|
| `GET` | Retrieve data, no side effects | Should be **idempotent** (safe to repeat) - never use GET for actions that change state (delete, transfer money). GET URLs get logged, cached, and bookmarked, so **never put secrets or tokens in a GET query string**. |
| `POST` | Create data / submit a form | Not idempotent by default - resubmitting can duplicate an action (this is why "don't double-click submit" was a real UX problem before idempotency keys existed). |
| `PUT` | Replace a resource entirely | Should be idempotent - calling it twice with the same body should produce the same result. |
| `DELETE` | Remove a resource | State-changing - must be protected by the same authorization checks as any other mutating action. |
| `PATCH` | Partially update a resource | Same authorization requirements as PUT/DELETE. |

A classic real-world mistake: building a "delete account" or "transfer funds" action behind a `GET` request (e.g. a link in an email). Since GET requests have no side-effect expectation, they get prefetched by browsers, crawled by bots, and cached by proxies - turning an innocuous-looking link into an accidental (or attacker-triggered) action.

### Status Codes Worth Recognizing

| Range | Meaning | Security-Relevant Pattern |
|-------|---------|------------------------------|
| 2xx | Success | A `200 OK` on a request that should have been denied is a classic authorization-bug signal during testing. |
| 3xx | Redirection | Open redirects (`3xx` to an attacker-controlled URL) are a real phishing/token-theft vector - see [OWASP Top 10](../web-security/owasp-top10.md). |
| 4xx | Client error | `401` = not authenticated, `403` = authenticated but not authorized - confusing these two in your own API design is a common source of information leakage (a `404` instead of `403` can be the *correct* choice to avoid confirming a resource exists to an unauthorized user). |
| 5xx | Server error | Verbose `500` error pages leaking stack traces are a security misconfiguration - see [Secure Coding](secure-coding.md). |

### Headers Worth Knowing Now (Deeper Coverage Later)

- `Set-Cookie` - how the server hands the browser a session token (see below).
- `Authorization` - carries credentials/tokens on subsequent requests (`Authorization: Bearer <token>`).
- `Content-Type` - tells the receiver how to parse the body; mismatched or attacker-controlled content types are behind several real vulnerability classes.

Full header-level security coverage lives in [Web Security Concepts](../web-security/web-security-concepts.md).

## Cookies and Sessions: Giving a Stateless Protocol Memory

HTTP is **stateless** - by default, the server has no memory of a previous request when a new one arrives. But almost every application needs to know "is this the same user who just logged in?" The bridge is the **cookie**:

1. User logs in successfully.
2. Server generates a random **session ID**, stores it server-side (or encodes state into the token itself, as with JWTs), and sends it back via `Set-Cookie`.
3. The browser automatically attaches that cookie to every subsequent request to the same domain.
4. The server looks up the session ID to know who's making the request.

This bolted-on statefulness is exactly why sessions are such a common attack target: whoever holds a valid session ID *is* the authenticated user, as far as the server can tell. Session and cookie security gets a full deep dive in [Authentication & Session Security](authentication-security.md).

## Three-Tier Architecture and Trust Boundaries

Most traditional web applications are conceptually split into three tiers:

```text
Presentation Tier  →  Application Tier  →  Data Tier
   (browser/UI)         (business logic)    (database)
```

Why this matters for security: each arrow is a **trust boundary** - a point where data crosses from one level of trust to another. The presentation tier runs on hardware you don't control (the user's device), so **nothing arriving from it can be trusted** without validation, no matter how much client-side validation exists (client-side checks are a UX feature, not a security control - see [Secure Coding](secure-coding.md)'s "Never Trust User Input" principle). The application tier is where your enforceable security logic lives. The data tier should only ever be reachable through the application tier, never directly from the presentation tier.

Modern architectures (microservices, serverless) multiply the number of tiers and trust boundaries rather than eliminating them - see [Threat Modeling](threat-modeling.md) for how to map trust boundaries in more complex systems.

## Concept → Why It Matters for AppSec

| Concept | Security Implication |
|---------|------------------------|
| HTTP is stateless | Sessions are bolted on via cookies/tokens - and become a prime attack target |
| GET requests are logged, cached, bookmarked | Never put secrets, tokens, or state-changing actions behind a GET |
| Client-side code is untrusted | Every check that matters must be re-verified server-side |
| Status codes carry meaning | `401` vs. `403` vs. `404` choices can themselves leak information |
| Three-tier trust boundaries | Data crossing a boundary (browser → app, app → database) must be validated at that boundary, not assumed safe from an earlier check |

## What's Next

- [Secure Coding](secure-coding.md) - core secure coding principles and vulnerability classes, building directly on the concepts above
- [Authentication & Session Security](authentication-security.md) - a full deep dive on the cookie/session mechanics introduced here

## Credits/References

1. [MDN Web Docs: HTTP Overview](https://developer.mozilla.org/en-US/docs/Web/HTTP/Overview)
2. [MDN Web Docs: HTTP Request Methods](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods)
3. [OWASP Application Security Verification Standard (ASVS)](https://owasp.org/www-project-application-security-verification-standard/)
