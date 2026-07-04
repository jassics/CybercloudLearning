# Authorization & Access Control

## Why This Page Exists

Broken Access Control is **A01:2025** in the OWASP Top 10 - the single highest-ranked risk category, and it has topped or near-topped every OWASP Top 10 edition for years. Unlike a memory-corruption bug, a broken access control flaw usually requires no exploit development at all - just noticing that an ID in a URL or JSON body isn't checked against the caller's identity. That combination (extremely common, trivially exploitable, high impact) is why it's the risk every security architect and engineer needs fluent, hands-on understanding of.

**Authentication vs. Authorization, in one sentence:** authentication answers "who are you?", authorization answers "what are you allowed to do?" - a system can authenticate a user perfectly and still be completely broken if it never checks authorization on the next step. See [Authentication & Session Security](authentication-security.md) for the "who are you" half; this page is entirely about the "what are you allowed to do" half.

## Access Control Models

| Model | How It Decides | Best For |
|-------|------------------|----------|
| **RBAC** (Role-Based) | User has one or more roles; each role has a fixed set of permissions | Simple, stable permission structures (admin/editor/viewer) |
| **ABAC** (Attribute-Based) | Decision evaluates attributes of the user, resource, and environment (e.g. "finance dept + business hours + document classified internal") | Fine-grained, context-dependent policies |
| **ReBAC** (Relationship-Based) | Decision follows a graph of relationships between subjects and objects (e.g. "can view because they're a member of the team that owns this document") | Complex, nested sharing models - the pattern behind Google Docs-style sharing, popularized by Google's Zanzibar system |

Most real applications start with RBAC because it's simple to reason about, then discover they actually need ABAC or ReBAC once "can this specific user see this specific document because of how it was shared with them" questions show up - which is most SaaS products within a year or two.

## IDOR: The Most Common Real-World Access Control Bug

Insecure Direct Object Reference (IDOR) happens when an application uses a client-supplied identifier to fetch a resource without verifying the requester is actually allowed to access *that specific object*. It's the single most frequently reported access control bug in bug bounty programs, precisely because it's so easy to test for (change an ID, see what comes back) and so easy to introduce (it looks like completely correct code if you only test with your own account).

```python
# Vulnerable - authenticated, but not authorized
@app.route("/api/invoices/<invoice_id>")
@login_required
def get_invoice(invoice_id):
    invoice = db.query(Invoice).filter_by(id=invoice_id).first()
    return jsonify(invoice.to_dict())
    # Any logged-in user can read ANY invoice by guessing/incrementing the ID

# Secure - ownership is checked as part of the query, not as an afterthought
@app.route("/api/invoices/<invoice_id>")
@login_required
def get_invoice(invoice_id):
    invoice = db.query(Invoice).filter_by(
        id=invoice_id,
        owner_id=current_user.id,   # <-- the actual authorization check
    ).first()
    if invoice is None:
        abort(404)  # 404, not 403 - don't confirm the ID even exists to a non-owner
    return jsonify(invoice.to_dict())
```

Notice the fix folds the ownership check *into* the query rather than fetching-then-checking - this avoids a whole class of bugs where the check is accidentally skipped, commented out, or bypassed by a code path that doesn't go through the "if" statement.

## Horizontal vs. Vertical Privilege Escalation

- **Horizontal escalation** - a user accesses another user's data or actions *at the same privilege level* (User A reads User B's private messages). This is what most IDOR bugs are.
- **Vertical escalation** - a lower-privileged user gains access to higher-privileged functionality (a regular user invokes an admin-only action). This is what Broken Function-Level Authorization usually looks like.

Both are "broken access control" - the distinction matters mainly for triage/severity (vertical escalation to full admin is usually rated more severely than horizontal access to one other user's record) and for how you test (horizontal: create two low-privilege test accounts and try to cross-access; vertical: create one low-privilege account and try to reach high-privilege endpoints).

## Broken Function-Level Authorization (BFLA)

A classic real-world pattern: the UI hides the "Delete User" button unless you're an admin, but the underlying API endpoint (`DELETE /api/users/{id}`) never checks the caller's role server-side - it only exists client-side. Any authenticated user who discovers the endpoint (browser dev tools, an API spec leaked in a JS bundle, simple guessing of REST conventions) can call it directly.

```text
# What the UI shows a regular user: no delete button visible
# What the API actually accepts, with zero server-side role check:
DELETE /api/users/42
Authorization: Bearer <any-valid-regular-user-token>
→ 200 OK, user 42 deleted
```

**The rule that prevents this entirely:** every authorization decision must be enforced server-side, on every request, regardless of what the UI does or doesn't show. Client-side hiding is a UX nicety, never a security control.

## Centralizing Authorization: Policy Engines

Scattering `if user.role == "admin":` checks through a codebase is how BFLA and IDOR bugs get introduced - every new endpoint is a fresh chance to forget the check, and there's no single place to audit "what can an editor actually do?" A policy engine centralizes these decisions into declarative rules, evaluated the same way everywhere.

[Open Policy Agent (OPA)](https://www.openpolicyagent.org/) with its Rego policy language is the most widely adopted open-source option:

```rego
package authz

default allow = false

# Allow if the user owns the resource
allow {
    input.action == "read"
    input.resource.owner_id == input.user.id
}

# Allow admins to do anything
allow {
    input.user.role == "admin"
}
```

The application calls out to OPA with `{user, action, resource}` and gets back an allow/deny decision - the policy logic lives in one auditable place instead of being smeared across every route handler.

## How to Test for Broken Access Control

The core technique is **authorization matrix testing**: enumerate every role and every resource/action, then systematically verify the matrix holds.

1. Create at least two accounts at each privilege level you support (e.g. two regular users, one admin).
2. For every endpoint that references an object by ID, try accessing another user's object with your own valid session (IDOR check).
3. For every privileged endpoint (admin, billing, user management), try calling it with a lower-privileged session (BFLA check).
4. Test both the "happy path" HTTP method and any alternates (if `GET /admin/users` is protected, is `POST`, `PUT`, `DELETE` on the same route also protected? Is the API version under `/v1/` protected the same as `/v2/`?).
5. Don't stop at 403/401 status codes alone - confirm the response body doesn't leak data before the check fails (some buggy implementations return the full object *then* a 403, which is itself a data leak).

This is exactly the skill interviewers are checking for when they ask "how would you test for broken access control" - walk through this matrix, not just "I'd try changing an ID in the URL."

## Checklist

- [ ] Every request that references an object by ID checks ownership/authorization as part of the query, not as an afterthought
- [ ] Every state-changing action is checked server-side, regardless of what the UI exposes
- [ ] Authorization logic is centralized (a policy engine or a single well-tested authz layer), not scattered as ad-hoc role checks
- [ ] IDs are unpredictable (UUIDs) as defense-in-depth - never as the only control
- [ ] Denial responses don't leak whether a resource exists to an unauthorized caller (404 over 403 where appropriate)
- [ ] Authorization matrix testing is part of the test suite, not just manual QA

## Credits/References

1. [OWASP Top 10:2025 - A01 Broken Access Control](https://owasp.org/Top10/2025/)
2. [OWASP Access Control Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Access_Control_Cheat_Sheet.html)
3. [OWASP Application Security Verification Standard (ASVS) 5.0 - V8 Authorization](https://owasp.org/www-project-application-security-verification-standard/)
4. [Zanzibar: Google's Consistent, Global Authorization System](https://research.google/pubs/zanzibar-googles-consistent-global-authorization-system/)
5. [Open Policy Agent Documentation](https://www.openpolicyagent.org/docs/latest/)
