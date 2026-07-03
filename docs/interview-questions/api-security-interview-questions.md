# API Security Interview Questions

The [security-interview-questions](https://github.com/jassics/security-interview-questions) repo's API Security file is still empty upstream, so these questions are grounded directly in this site's [API Security](../product-security/application-security/api-security.md) guide instead. Expect them to get merged back once the source repo catches up.

## Authorization & Authentication

??? question "Q: What is BOLA (Broken Object Level Authorization), and why is it consistently the #1 API vulnerability?"
    BOLA happens when an API correctly authenticates a user but never checks whether that *specific user* is authorized to access the *specific object* referenced by an ID in the request - e.g. `GET /api/orders/12345` returns order 12345 regardless of who's logged in.

    It's the most common finding because authentication is easy to remember to implement (you need it for the app to work at all), but object-level authorization has to be re-checked on every single endpoint that takes an ID, and it's easy to miss one. Mitigation: enforce ownership checks server-side on every object access, and use non-guessable IDs (UUIDs) as defense in depth - never as the only control, since that's security by obscurity.

??? question "Q: How would you design authentication for a public API, and what's wrong with long-lived API keys sent in query strings?"
    Use OAuth 2.0 / OpenID Connect with short-lived access tokens and refresh tokens rather than long-lived static keys. Query-string API keys are a problem because URLs get logged everywhere - web server access logs, browser history, proxy logs, referrer headers on outbound links - so a "secret" in a query string leaks through channels nobody thinks to secure. Keys/tokens belong in headers (`Authorization: Bearer ...`), and JWTs specifically need signature validation on every request (reject `alg: none` - a classic bypass where the API is tricked into treating an unsigned token as valid).

??? question "Q: What's the difference between broken object-level authorization and broken function-level authorization?"
    **Object-level (BOLA)** - you can access data you shouldn't (someone else's order). **Function-level** - you can invoke an entire *capability* you shouldn't (a regular user hitting an admin-only endpoint like `POST /api/admin/users/delete`), often because the endpoint exists and works, it's just missing a role check on the server. Both are authorization failures, but function-level bugs tend to have a bigger blast radius since they expose whole categories of privileged actions rather than one record at a time.

## Data Exposure & Abuse

??? question "Q: What's mass assignment, and how would you prevent it in a REST API?"
    Mass assignment happens when an API blindly binds client-supplied JSON directly onto an internal model/object, so a client can set fields they were never meant to control - e.g. sending `{"email": "me@x.com", "isAdmin": true}` on a profile-update endpoint, and the API happily promotes them to admin because it just deserializes the whole payload onto the User object.

    Prevention: use explicit DTOs/serializers for both requests and responses (never bind directly to your ORM/domain model), and maintain an explicit allow-list of which fields a given endpoint is permitted to write - reject or silently drop anything else.

??? question "Q: How do you prevent an API from being abused for unrestricted resource consumption / DoS?"
    Enforce rate limiting and quotas per API key/user (not just per IP, which is trivially spoofed with rotating proxies), cap payload sizes, enforce pagination limits so a single request can't ask for the entire dataset, and - specifically for GraphQL - add query depth and complexity limits, since a deeply nested query can multiply cost exponentially even though it "looks like one request."

??? question "Q: An API needs to fetch a webhook URL or an image from a client-supplied URL. What attack does this open up, and how do you defend against it?"
    That's a textbook Server-Side Request Forgery (SSRF) setup - the client controls a URL the *server* fetches, which can be pointed at internal-only resources: cloud metadata endpoints (`169.254.169.254`), internal admin panels, or other services behind the perimeter that were never meant to be internet-reachable. Defenses: validate and allow-list the destination host, block requests to private/link-local/loopback IP ranges, resolve DNS and re-check the resolved IP (to catch DNS rebinding), and disable following redirects when fetching a user-supplied URL.

## Operations & Inventory

??? question "Q: What's a 'shadow API' or 'zombie API', and how do you find them?"
    A shadow API is one that exists and is reachable but isn't documented or tracked (a dev spun up an endpoint for testing and forgot to remove it); a zombie API is an old, deprecated version still running and reachable after everyone assumed it was retired. Both are dangerous because they're not covered by the security controls (auth requirements, rate limits, monitoring) applied to the "official" surface. Finding them requires active discovery: traffic analysis at the gateway/proxy layer to catch endpoints nobody documented, comparing what's actually deployed against the OpenAPI spec, and maintaining a real API inventory as a first-class artifact rather than trusting tribal knowledge.

??? question "Q: What role does an API gateway play in a security architecture, and what would you centralize there vs. leave to individual services?"
    A gateway centralizes cross-cutting concerns so every service doesn't reimplement them inconsistently: authentication/token validation, rate limiting and quotas, request/response schema validation, TLS termination (often with mTLS to backend services), and centralized logging for anomaly detection. What you'd typically still leave to individual services: object-level authorization (the gateway usually doesn't know your domain's ownership model) and business-logic-specific rate limiting (e.g. "no more than 3 password resets per hour," which is domain knowledge, not generic traffic shaping).

## Practice Next

- [API Security](../product-security/application-security/api-security.md)
- [API Security Study Plan](../study-plan/cybersecurity/api-security-study-plan.md)
- [OWASP API Security Top 10](https://owasp.org/API-Security/editions/2023/en/0x00-header/)
- [security-interview-questions](https://github.com/jassics/security-interview-questions) on GitHub for the canonical, evolving question set
