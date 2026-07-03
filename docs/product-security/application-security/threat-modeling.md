# Threat Modeling

## What is Threat Modeling?

Threat modeling is a structured process for identifying, communicating, and understanding threats and mitigations to a system - done early in design, before code is written, so security issues are architected out rather than patched in later.

It answers four core questions (per Adam Shostack's framework):

1. **What are we building?**
2. **What can go wrong?**
3. **What are we going to do about it?**
4. **Did we do a good enough job?**

## Why Threat Model

- Design-level flaws (missing authentication on an internal API, trusting a client-side check) are often more expensive to fix post-launch than implementation bugs.
- Aligns security, development, and product teams on the same understanding of risk.
- Produces a prioritized, actionable list of security requirements before a single vulnerability is discovered in production.

## Step 1: Model the System (Data Flow Diagrams)

Build a Data Flow Diagram (DFD) showing:

- **External entities** - users, third-party services
- **Processes** - application components/services
- **Data stores** - databases, caches, file storage
- **Data flows** - arrows showing how data moves between the above
- **Trust boundaries** - lines marking where trust level changes (e.g., internet → DMZ → internal network)

```
[User] --(HTTPS)--> [Trust Boundary] --> [Web App] --> [Trust Boundary] --> [Database]
                                              |
                                         [Auth Service]
```

Trust boundaries are where the most interesting threats live - any data crossing one should be validated/authenticated.

## Step 2: Identify Threats (STRIDE)

STRIDE, developed at Microsoft, maps each threat category to the security property it violates:

| Category | Violates | Example |
|----------|----------|---------|
| **S**poofing | Authentication | Attacker impersonates a legitimate user or service |
| **T**ampering | Integrity | Attacker modifies data in transit or at rest |
| **R**epudiation | Non-repudiation | User denies performing an action, and there's no audit trail to prove otherwise |
| **I**nformation Disclosure | Confidentiality | Sensitive data exposed to unauthorized parties |
| **D**enial of Service | Availability | System made unavailable to legitimate users |
| **E**levation of Privilege | Authorization | User gains capabilities beyond what they're entitled to |

Walk through each element of the DFD (process, data store, data flow) and ask which STRIDE categories apply.

### Worked Example: Login Flow

| Element | Threat (STRIDE) | Description |
|---------|------------------|--------------|
| Login API | Spoofing | Credential stuffing / brute force against login endpoint |
| Login API → DB | Tampering | SQL injection modifying the query |
| Session token | Information Disclosure | Token leaked via logs or referrer headers |
| Audit log | Repudiation | No logging of failed/successful login attempts |
| Login API | Denial of Service | No rate limiting, allowing resource exhaustion |
| Admin panel | Elevation of Privilege | Regular user can access admin-only functions via missing authz check |

## Step 3: Prioritize and Mitigate

Rate each threat by likelihood and impact (a simple High/Medium/Low scale, or DREAD/CVSS for more rigor), then assign a mitigation:

| Threat | Mitigation |
|--------|-----------|
| Credential stuffing | Rate limiting, account lockout, CAPTCHA, MFA |
| SQL injection | Parameterized queries (see [Secure Coding](secure-coding.md)) |
| Token leakage | `Secure`, `HttpOnly` cookie flags; avoid tokens in URLs |
| Missing audit logging | Centralized, tamper-evident audit logs |
| No rate limiting | API gateway throttling |
| Missing authz check | Centralized authorization middleware, deny-by-default |

## Step 4: Validate

- Confirm mitigations are actually implemented (link threat model items to backlog tickets).
- Re-run the threat model when the architecture changes significantly (new component, new trust boundary, new data flow).
- Use it as an input to test planning - each threat is a candidate test case for security testing.

## Other Threat Modeling Methodologies

| Methodology | Focus |
|-------------|-------|
| **STRIDE** | Threat categorization per component (most widely used for general apps) |
| **PASTA** (Process for Attack Simulation and Threat Analysis) | Risk-centric, ties threats to business impact |
| **DREAD** | Threat scoring (Damage, Reproducibility, Exploitability, Affected users, Discoverability) |
| **LINDDUN** | Privacy-focused threat modeling (Linkability, Identifiability, Non-repudiation, Detectability, Disclosure of information, Unawareness, Non-compliance) |
| **Attack Trees** | Hierarchical breakdown of how an attacker could achieve a goal |
| **MITRE ATT&CK** | Real-world adversary tactics/techniques, useful for validating coverage against known TTPs |

## When to Threat Model

- New system/feature design (before implementation)
- Major architecture changes (new trust boundary, new third-party integration)
- Periodically for high-risk systems (e.g., annually, or on major version changes)
- When threat intelligence indicates new relevant attack patterns

## Tools

- **Microsoft Threat Modeling Tool** - free, DFD-based, generates STRIDE threats automatically per element
- **OWASP Threat Dragon** - open-source, web/desktop DFD threat modeling tool
- **IriusRisk / ThreatModeler** - commercial, integrate with SDLC/backlog tools

## Credits/References

1. [OWASP Threat Modeling](https://owasp.org/www-community/Threat_Modeling)
2. [Microsoft STRIDE Threat Model](https://learn.microsoft.com/en-us/azure/security/develop/threat-modeling-tool-threats)
3. Adam Shostack, *Threat Modeling: Designing for Security*
4. [OWASP Threat Dragon](https://owasp.org/www-project-threat-dragon/)
