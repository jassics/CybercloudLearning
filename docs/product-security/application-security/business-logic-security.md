# Business Logic & Advanced Web Vulnerabilities

## Why Scanners Miss These

Every vulnerability class covered elsewhere on this site so far - injection, XSS, broken auth - is a case of the application doing something the developer didn't intend. Business logic flaws are the opposite: the code runs exactly as written, the workflow is technically correct, and it's still exploitable because the *design* didn't account for an adversarial user. SAST and DAST tools are largely blind to this category, because there's no bad pattern to match - the only way to find these is to think like an attacker about what a feature was supposed to prevent, then test whether it actually does. This maps to **OWASP A06:2025 Insecure Design**.

## Race Conditions / TOCTOU

Time-of-check to time-of-use: the gap between checking a condition ("does this user have enough balance?") and acting on it ("deduct the balance") is an exploitable window if the check and the action aren't atomic.

**Classic example:** a coupon-redemption endpoint checks "has this code been used?" then, in a separate step, marks it used and applies the discount. Firing 50 concurrent requests with the same code, before the first one finishes writing "used = true," can redeem the same one-time coupon dozens of times.

**Mitigations:**

- Wrap the check-and-act sequence in a database transaction with proper isolation, or use an atomic operation (e.g. a conditional `UPDATE ... WHERE used = false` that fails if another request already flipped the flag) instead of separate read-then-write steps.
- Idempotency keys on state-changing requests (a client-supplied unique key that the server uses to guarantee a given operation executes at most once, even if the request is retried or duplicated).
- Rate limiting reduces the practical window for abuse but does not fix the underlying race - treat it as defense in depth, not the fix.

## Mass Assignment (Beyond APIs)

[API Security](api-security.md) already covers mass assignment for JSON APIs - binding client-supplied fields directly onto an internal model, letting a client set fields like `isAdmin: true` that were never meant to be user-writable. The same failure mode shows up in traditional HTML form submissions too: a form only *rendering* a subset of fields doesn't stop an attacker from adding extra hidden `<input>` fields (or just crafting a raw POST body) that the server-side binding code accepts anyway. The fix is identical regardless of transport: explicit allow-lists of which fields a given request is permitted to set, never "bind everything the client sent."

## Price / Parameter Manipulation

Any value that affects cost, quantity, or discount and is sent from the client must be re-validated server-side against the authoritative source - never trusted as-is:

```text
POST /checkout
{ "item_id": 42, "quantity": 1, "unit_price": 0.01 }
```

If the server trusts `unit_price` from the request instead of looking it up from its own product catalog, the checkout total is whatever the attacker says it is. The same applies to hidden form fields, quantity fields that go negative (potentially crediting the attacker's account instead of charging it), and discount/coupon percentages passed as parameters.

## HTTP Request Smuggling

A higher-difficulty but real and high-impact attack class: when a request passes through a front-end server (load balancer, CDN, reverse proxy) before reaching a back-end application server, and the two disagree about **where one request ends and the next begins**, an attacker can smuggle a second, hidden request that the back-end processes as if it came from the front-end - potentially bypassing access controls, poisoning another user's session, or reading arbitrary responses meant for other users.

The disagreement usually stems from conflicting `Content-Length` and `Transfer-Encoding` headers in the same request (a CL.TE or TE.CL mismatch), where each server picks a different header to trust for framing the request body. This is genuinely subtle - PortSwigger's research (linked below) is the most authoritative, hands-on resource for understanding and testing for it; treat this page's summary as orientation, not a how-to.

## Web Cache Poisoning & Cache Deception

Two related but distinct attacks against shared caches:

- **Cache poisoning** - tricking a cache (CDN, reverse proxy cache) into storing a malicious or manipulated response, which is then served to every subsequent user who requests that same cached URL - turning a single crafted request into a mass-impact attack.
- **Cache deception** - tricking the cache into storing a response that contains one user's private data (e.g. by requesting `/account/settings/nonexistent.css` and having a misconfigured cache store the account page's response under that cacheable-looking URL), which then gets served to a different user who requests the same path.

Both stem from a cache making storage decisions based on the URL alone without fully accounting for how the origin server actually generates per-user or unkeyed responses.

## How to Actually Find Business Logic Flaws

There's no scanner for this - it's a mindset:

1. **Read every feature from an attacker's incentive, not the happy path.** What would I gain by breaking this specific workflow - free items, privilege escalation, bypassing a paywall or rate limit, denying service to someone else?
2. **Test workflow steps out of order.** Can you skip a payment-verification step and go straight to order confirmation? Can you replay or reorder a multi-step checkout/registration flow?
3. **Test boundary and impossible values.** Negative quantities, zero-cost items, extremely large numbers that might overflow, unicode/encoding edge cases in identifiers.
4. **Test concurrency.** Fire the same request many times in parallel - this is how most race conditions are actually found in practice, not through code reading alone.
5. **Ask "who else could reach this?"** Even correctly-implemented business logic can be reachable by the wrong role or the wrong tenant in a multi-tenant system - pair this with the authorization matrix testing covered in [Authorization & Access Control](authorization-security.md).

## Credits/References

1. [PortSwigger Web Security Academy: Business logic vulnerabilities](https://portswigger.net/web-security/logic-flaws)
2. [PortSwigger Web Security Academy: HTTP request smuggling](https://portswigger.net/web-security/request-smuggling)
3. [PortSwigger Web Security Academy: Web cache poisoning](https://portswigger.net/web-security/web-cache-poisoning)
4. [PortSwigger Web Security Academy: Web cache deception](https://portswigger.net/web-security/web-cache-deception)
5. [OWASP Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)
