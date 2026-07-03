# API Security

## Why APIs Need Dedicated Security Attention

APIs are the connective tissue of modern applications - mobile apps, single-page apps, microservices, and third-party integrations all talk over APIs. Unlike traditional web apps, APIs:

- Expose application logic and data structures directly (no HTML/UI layer hiding implementation details)
- Are often consumed by many different, less-trusted clients (mobile apps, partners, public developer ecosystems)
- Are easy to enumerate and automate against (structured JSON/REST or GraphQL schemas)
- Frequently skip the browser's built-in protections (same-origin policy, CSP) since traffic is client-to-server, not browser-rendered

This makes broken authorization and excessive data exposure some of the most common and highest-impact API vulnerabilities.

## OWASP API Security Top 10 (2023)

| # | Risk | Description |
|---|------|--------------|
| API1 | Broken Object Level Authorization (BOLA) | API doesn't verify the requesting user owns/can access the specific object referenced by an ID |
| API2 | Broken Authentication | Weak, missing, or misconfigured authentication mechanisms |
| API3 | Broken Object Property Level Authorization | Excessive data exposure or mass assignment - clients can read/write properties they shouldn't |
| API4 | Unrestricted Resource Consumption | No rate limiting/quotas, enabling DoS or excessive cost |
| API5 | Broken Function Level Authorization | Users can invoke admin/privileged functions they shouldn't have access to |
| API6 | Unrestricted Access to Sensitive Business Flows | Automated abuse of business logic (e.g., bulk-buying limited stock, ticket scalping) |
| API7 | Server-Side Request Forgery (SSRF) | API fetches a remote resource based on unvalidated user-supplied URL |
| API8 | Security Misconfiguration | Missing hardening, verbose errors, unnecessary HTTP methods enabled |
| API9 | Improper Inventory Management | Unknown, undocumented, or outdated (shadow/zombie) API versions still reachable |
| API10 | Unsafe Consumption of APIs | Blindly trusting data/responses from third-party/upstream APIs |

## Deep Dive: The Most Common Real-World Issues

### Broken Object Level Authorization (BOLA/IDOR)

The single most reported API vulnerability. The API authenticates the user correctly but fails to check whether that user is *authorized* to access the specific object ID requested.

```text
GET /api/orders/12345   → returns order 12345, regardless of who is logged in
```

**Mitigation:** Enforce ownership/authorization checks server-side on every object access, not just at the endpoint level. Use non-guessable, non-sequential IDs (UUIDs) as defense in depth - but never as the only control.

### Broken Authentication

- Weak or missing token expiration, predictable API keys, tokens sent in URLs (logged/cached), missing MFA support for API-driven account actions.
- **Mitigation:** Use industry-standard OAuth 2.0 / OpenID Connect flows, short-lived access tokens with refresh tokens, and validate JWT signatures (reject `alg: none`).

### Excessive Data Exposure / Mass Assignment

APIs that return full internal objects (including fields the client should never see) or that blindly bind client-supplied JSON to internal models (allowing a client to set `isAdmin: true`).

**Mitigation:** Use explicit response DTOs/serializers (never return ORM objects directly) and explicit allow-lists for which fields can be set on write.

### Unrestricted Resource Consumption

No limits on payload size, pagination, query complexity (especially in GraphQL), or requests per minute.

**Mitigation:** Enforce rate limiting/throttling per client/API key, pagination limits, and query cost analysis for GraphQL.

### Server-Side Request Forgery (SSRF)

An API that fetches a URL supplied by the client (e.g., webhook registration, image-from-URL upload) can be tricked into calling internal services (cloud metadata endpoints, internal admin panels).

**Mitigation:** Validate and allow-list destination hosts, block requests to private/link-local IP ranges, disable redirects when fetching user-supplied URLs.

## API Security Controls Checklist

- [ ] Authentication required on every endpoint (no "internal-only" endpoints reachable without auth)
- [ ] Object-level authorization enforced on every request that references an ID
- [ ] Rate limiting and quota enforcement per API key/user
- [ ] Input validation via a strict schema (OpenAPI/JSON Schema) - reject unexpected fields
- [ ] Explicit response serialization - no direct database/ORM object exposure
- [ ] TLS enforced everywhere, no fallback to plaintext HTTP
- [ ] API inventory maintained - no undocumented or deprecated endpoints left reachable
- [ ] Logging and monitoring for anomalous request patterns (e.g., ID enumeration)
- [ ] Security testing includes authorization matrix testing (can User A access User B's data?)

## API Gateways and Their Security Role

An API gateway centralizes cross-cutting security controls so individual services don't have to reimplement them:

- Authentication/token validation
- Rate limiting and quota enforcement
- Request/response schema validation
- TLS termination and mTLS between gateway and backend
- Centralized logging and anomaly detection

Popular options: Kong, AWS API Gateway, Apigee, NGINX, Envoy.

## GraphQL-Specific Considerations

- **Query depth/complexity limits** - prevent deeply nested queries from causing resource exhaustion.
- **Disable introspection in production** - avoid exposing the full schema to unauthenticated clients.
- **Field-level authorization** - GraphQL's flexible querying makes it easy to accidentally expose fields without per-field authz checks.

## Credits/References

1. [OWASP API Security Top 10 (2023)](https://owasp.org/API-Security/editions/2023/en/0x00-header/)
2. [OWASP API Security Project](https://owasp.org/www-project-api-security/)
3. [OWASP REST Security Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/REST_Security_Cheat_Sheet.html)
4. [OWASP GraphQL Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/GraphQL_Cheat_Sheet.html)
