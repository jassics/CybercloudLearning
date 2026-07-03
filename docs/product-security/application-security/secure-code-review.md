# Secure Code Review

## What is Secure Code Review?

Secure code review is the process of manually and/or automatically examining an application's source code to find security flaws that could be exploited - logic errors, missing authorization checks, injection points, insecure use of cryptography, and more.

It complements [SAST](sast.md) tools: automated scanners are good at pattern-matching known bad practices, while a human reviewer understands business logic, context, and intent - things a scanner cannot reason about.

## Why Manual Review Still Matters

Automated tools (SAST/SCA) are necessary but not sufficient because they typically miss:

- **Business logic flaws** - e.g., a discount code that can be applied multiple times, or a workflow that skips an approval step.
- **Authorization gaps** - a function is authenticated correctly but doesn't check *ownership* of the resource being accessed (IDOR).
- **Context-dependent issues** - a supposedly "safe" library used in an unsafe way.
- **Chained vulnerabilities** - individually low-severity issues that combine into a critical exploit path.

## Secure Code Review Methodology

### 1. Preparation

- Understand the application's architecture, trust boundaries, and data flows (a lightweight [threat model](threat-modeling.md) helps).
- Identify the technology stack and known risk areas for that stack.
- Define scope: full review, diff/PR review, or focused review of a specific feature (auth, payments, file upload).

### 2. Prioritize by Risk

Focus review effort where impact is highest:

| Priority | Area |
|----------|------|
| Critical | Authentication, authorization, session management |
| Critical | Cryptography and secrets handling |
| High | Input handling at trust boundaries (APIs, file uploads, deserialization) |
| High | Data access layer (SQL/NoSQL queries, ORM usage) |
| Medium | Logging (ensure no sensitive data is logged) |
| Medium | Error handling (ensure no stack traces/internals leak) |

### 3. Review Techniques

- **Top-down (data flow)** - Trace untrusted input from entry point (API, form, file) to where it's used (query, command, output) and confirm it's validated/encoded at each trust boundary.
- **Checklist-driven** - Walk through a standard checklist (e.g., OWASP Code Review Guide, ASVS) category by category.
- **Diff-based** - For PR reviews, focus on what changed, but check the surrounding context for regressions.
- **Search for known-bad patterns** - `grep` for risky sinks like `eval(`, `exec(`, `pickle.loads(`, string-concatenated SQL, `innerHTML`, disabled TLS verification, hardcoded secrets.

### 4. Common Findings Checklist

- [ ] All user input is validated and/or encoded appropriately for its context
- [ ] All database queries use parameterization, not string concatenation
- [ ] Authorization is checked server-side for every sensitive action (not just authentication)
- [ ] Secrets are not hardcoded or committed to source control
- [ ] Cryptographic primitives are modern and correctly used (no ECB mode, no home-grown crypto)
- [ ] Errors don't leak stack traces, internal paths, or system details
- [ ] Logging doesn't capture passwords, tokens, or PII
- [ ] File uploads validate type/size and are stored outside the web root
- [ ] Dependencies are free of known critical/high CVEs (cross-check with [SCA](sca.md))
- [ ] Rate limiting/throttling exists on sensitive or expensive endpoints

### 5. Reporting Findings

A good finding includes:

1. **Title** - short, descriptive
2. **Location** - file/line or function name
3. **Severity** - based on impact and exploitability (e.g., CVSS or a simple Critical/High/Medium/Low scale)
4. **Description** - what the issue is and why it's exploitable
5. **Proof of concept** - a concrete input/scenario that demonstrates the issue
6. **Remediation** - a specific, actionable fix

## Manual Review vs. Automated Scanning

| Aspect | Manual Review | SAST/Automated |
|--------|---------------|-----------------|
| Business logic flaws | Strong | Weak |
| Known vulnerability patterns | Moderate | Strong |
| Speed/scale | Slow | Fast |
| False positives | Low (context-aware) | Can be high |
| Consistency | Depends on reviewer | Consistent |

The best programs use both: automated scanning on every commit/PR, plus periodic manual deep-dives on high-risk components.

## Tools That Assist Manual Review

- **grep/ripgrep** - fast pattern search across a codebase for risky sinks
- **Semgrep** - customizable, semantic pattern matching (bridges manual and automated review)
- **IDE security plugins** - inline hints while reading code
- **Code review checklists baked into PR templates** - nudges reviewers to check the right things

## Credits/References

1. [OWASP Code Review Guide](https://owasp.org/www-project-code-review-guide/)
2. [OWASP Application Security Verification Standard (ASVS)](https://owasp.org/www-project-application-security-verification-standard/)
3. [OWASP Foundation](https://owasp.org/)
