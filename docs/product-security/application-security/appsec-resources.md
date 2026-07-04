# Application Security Resources

!!! tip "This page distills the highlights"
    For the full, continuously updated list, see [jassics/awesome-appsec-learning-resources](https://github.com/jassics/awesome-cybersecurity-learning-resources/blob/main/awesome-appsec-learning-resources.md) and [awesome-api-security-learning-resources](https://github.com/jassics/awesome-cybersecurity-learning-resources/blob/main/awesome-api-security-learning-resources.md) on GitHub.

Use this page as the "go deeper" reference for the whole Application Security section - organized so you can jump straight to standards, papers, tools, or hands-on practice depending on what you need right now.

## Standards & Verification Frameworks

| Framework | What It Covers |
|-----------|-----------------|
| [OWASP Top 10 (2025)](https://owasp.org/Top10/2025/) | The canonical web application risk taxonomy - see [OWASP Top 10](../web-security/owasp-top10.md) for the full deep dive |
| [OWASP API Security Top 10](https://owasp.org/API-Security/editions/2023/en/0x00-header/) | API-specific risk taxonomy - see [API Security](api-security.md) |
| [OWASP ASVS (Application Security Verification Standard)](https://owasp.org/www-project-application-security-verification-standard/) | Verifiable security requirements by risk level (L1/L2/L3) - see [Secure Application Architecture](secure-application-architecture.md) |
| [OWASP SAMM (Software Assurance Maturity Model)](https://owaspsamm.org/) | Organization-level AppSec program maturity assessment, the counterpart to ASVS's per-system focus |
| [OWASP Proactive Controls](https://owasp.org/www-project-proactive-controls/) | Top defensive techniques for developers, ordered by importance |
| [CWE Top 25 Most Dangerous Software Weaknesses](https://cwe.mitre.org/top25/) | MITRE's data-driven ranking of the most impactful weakness classes |
| [NIST SP 800-204 series](https://csrc.nist.gov/publications/detail/sp/800-204/final) | Microservices and API security guidance |

## Books

| Book | Notes |
|------|-------|
| [Agile Application Security](https://amzn.to/3YKVjxr) | Highly recommended - practical AppSec program building |
| The Web Application Hacker's Handbook | The classic reference for web exploitation |
| [Threat Modeling: Designing for Security](https://amzn.to/4fKtZX9) - Adam Shostack | The foundational threat modeling text - see [Threat Modeling](threat-modeling.md) |
| [Hacking APIs](https://nostarch.com/hacking-apis) - Corey J. Ball | Widely regarded as the best starter book for API pentesting |
| [API Security in Action](https://www.manning.com/books/api-security-in-action) - Neil Madden | Defensive, developer-focused: OAuth2, JWT, mTLS, gateways, rate limiting - see [Authentication Security](authentication-security.md) |
| [Advanced API Security: OAuth 2.0 and Beyond](https://link.springer.com/book/10.1007/978-1-4842-2050-4) - Prabath Siriwardena | Deep dive into OAuth2/OIDC/SCIM |
| [The Tangled Web](https://amzn.to/48Sobso) | Browser security model deep dive - see [XSS & Client-Side Security](xss-client-side-security.md) |
| [Application Security Program Handbook](https://amzn.to/3AOBbCu) | For engineers/leads building a program, not just writing code |

## Videos & Talks

- [OWASP Global AppSec conference talks](https://www.youtube.com/@owasp)
- [LocoMoco Security Conference - AppSec deep dives](https://www.youtube.com/@locomocosec)
- [LiveOverflow - web/binary exploitation](https://www.youtube.com/@LiveOverflow)
- [PwnFunction - web vulnerability concepts, including JWT attacks explained](https://www.youtube.com/@PwnFunction)
- [IppSec - HackTheBox walkthroughs](https://www.youtube.com/@ippsec)
- [OWASP API Security Top 10 - official walkthrough](https://www.youtube.com/watch?v=QPEAu3HvGrQ)
- [GraphQL Security - PortSwigger Research](https://www.youtube.com/watch?v=NPDp7GHmMa0)
- [Scaling AppSec with Semgrep's taint mode](https://www.youtube.com/watch?v=6MxMhFPkZlU) - see [SAST](sast.md)

## Courses & Certifications

| Course / Cert | Provider |
|----------------|----------|
| [PortSwigger Web Security Academy](https://portswigger.net/web-security) | Free - the gold standard for structured, hands-on web vuln labs |
| [APIsec University](https://university.apisec.ai/) | Free - full curriculum including API Security Fundamentals and Pentesting |
| [OWASP Juice Shop Companion Guide](https://pwning.owasp-juice.shop/) | Free walkthrough for OWASP's flagship vulnerable app |
| [SANS SEC522: Defending Web Applications Security Essentials](https://www.sans.org/cyber-security-courses/defending-web-applications-security-essentials/) | Paid |
| [SANS SEC540 / SEC542 / SEC642](https://www.sans.org/cyber-security-courses/?focus-area=offensive-operations) | Paid, offensive-operations focused |
| [Practical DevSecOps - Certified Application Security Practitioner](https://www.practical-devsecops.com/) | Paid, practitioner-level |
| [AppSec Engineer](https://community.wehackpurple.com/) - We Hack Purple / Tanya Janca | Paid |
| [CASA - Certified API Security Analyst](https://secops.group/product/certified-api-security-analyst/) | Offensive, API-specific |
| [CSSLP](https://www.isc2.org/certifications/csslp), [ISSAP](https://www.isc2.org/certifications/issap), [CISSP](https://www.isc2.org/certifications/cissp) | ISC2 - broader security architecture/lifecycle certs |

## Tools

Deep dives on SAST and SCA tooling already live on this site - see [SAST](sast.md) and [SCA](sca.md). Highlights and adjacent categories below.

### Secrets Scanning

| Tool | Notes |
|------|-------|
| [gitleaks](https://github.com/gitleaks/gitleaks) | Fast, widely used, easy CI integration |
| [TruffleHog](https://github.com/trufflesecurity/trufflehog) | Verifies many secret types live against the provider API |
| [detect-secrets (Yelp)](https://github.com/Yelp/detect-secrets) | Baseline-driven, good for large existing repos |
| [git-secrets (AWS)](https://github.com/awslabs/git-secrets) | AWS-focused pattern set |
| [GitGuardian](https://www.gitguardian.com/) | Commercial, org-wide scanning |

### Threat Modeling Tools

See [Threat Modeling](threat-modeling.md) for the methodology - these are the tools that operationalize it:

- [OWASP Threat Dragon](https://www.threatdragon.com/#/) - free, DFD-based
- [PyTM](https://github.com/izar/pytm) - threat modeling as code (Python)
- [STRIDE GPT](https://stridegpt.streamlit.app/) - LLM-assisted STRIDE generation
- [Microsoft Threat Modeling Tool](https://learn.microsoft.com/en-us/azure/security/develop/threat-modeling-tool)

### API-Specific Tools

| Tool | Purpose |
|------|---------|
| [Kiterunner](https://github.com/assetnote/kiterunner) | Content discovery built specifically for API endpoints |
| [Postman](https://www.postman.com/) | The most-used tool for API exploration and scripted testing |
| [Burp Suite](https://portswigger.net/burp) + extensions | Pair with `JWT Editor`, `Autorize` (BOLA/BFLA detection), `InQL` (GraphQL), `Param Miner` |
| [Schemathesis](https://github.com/schemathesis/schemathesis) | Property-based fuzzing of OpenAPI/GraphQL schemas |
| [RESTler (Microsoft)](https://github.com/microsoft/restler-fuzzer) | Stateful REST API fuzzer |
| [OWASP ZAP](https://www.zaproxy.org/) | Free, scriptable, with OpenAPI/GraphQL add-ons |
| [Open Policy Agent (OPA)](https://www.openpolicyagent.org/) | Fine-grained authorization for APIs/microservices - see [Authorization Security](authorization-security.md) |

## Hands-On Labs & CTFs

See [AppSec Red Teaming & Practice Labs](appsec-red-teaming-labs.md) for methodology - here's the full practice-target list:

| Lab / CTF | Focus |
|-----------|-------|
| [PortSwigger Web Security Academy](https://portswigger.net/web-security) | Free, browser-based, comprehensive - start here |
| [OWASP Juice Shop](https://owasp.org/www-project-juice-shop/) | Most popular intentionally vulnerable web app |
| [WebGoat](https://owasp.org/www-project-webgoat/) | OWASP's legacy but still useful Java learning app |
| [DVWA - Damn Vulnerable Web App](https://github.com/digininja/DVWA) | Classic, configurable difficulty levels |
| [Google Gruyere](https://google-gruyere.appspot.com/) | Small, guided, good for absolute beginners |
| [OWASP Security Shepherd](https://owasp.org/www-project-security-shepherd/) | Mobile + web CTF platform |
| [PentesterLab](https://pentesterlab.com/) | Hands-on exercises, free and paid tiers |
| [crAPI](https://github.com/OWASP/crAPI) | Intentionally vulnerable API covering the full OWASP API Top 10 |
| [VAmPI](https://github.com/erev0s/VAmPI) | Flask-based vulnerable REST API with vulnerable/secure modes |
| [DVGA - Damn Vulnerable GraphQL Application](https://github.com/dolevf/Damn-Vulnerable-GraphQL-Application) | Essential for GraphQL-specific attacks |
| [vAPI](https://github.com/roottusk/vapi) | Self-hosted API lab mapped to OWASP API Top 10 |
| [HackTheBox: Intro to API Pentesting](https://academy.hackthebox.com/module/details/230) | Paid academy path |

## Blogs, Newsletters & Communities

- [OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/) - the single best ongoing reference for "how do I actually implement this control"
- [tl;dr sec newsletter](https://tldrsec.com/) - Clint Gibler's weekly AppSec digest
- [We Hack Purple](https://community.wehackpurple.com/) - Tanya Janca's AppSec community and podcast
- [APISecurity.io newsletter](https://apisecurity.io/) - weekly API security digest by 42Crunch
- [PortSwigger Research](https://portswigger.net/research) - the source of most modern web cache deception, request smuggling, and API attack research
- [BOLA - why it's the #1 API vulnerability](https://apisecurity.io/issue-176-how-to-find-and-fix-bola-vulnerabilities/)
- [31 Days of API Security Tips (Inon Shkedy)](https://github.com/inonshk/31-days-of-API-Security-Tips)
- [API Security Checklist (Shieldfy)](https://github.com/shieldfy/API-Security-Checklist) - a classic, widely-referenced reference (some entries have aged, but the framework holds up)

## This Site's Own AppSec Toolkit

[jassics/awesome-claude-security](https://github.com/jassics/awesome-claude-security) is a Claude Code plugin marketplace with dedicated AppSec plugins you can install directly into a Claude Code session:

- `web-app-security` - OWASP Web Top 10, access control, injection testing
- `api-security` - OWASP API Top 10, BOLA/BFLA-focused review
- `sast-sca` - static analysis + dependency/SBOM review
- `threat-modeling` - STRIDE/PASTA-driven design review

Install with `/plugin marketplace add jassics/awesome-claude-security` inside a Claude Code session, then `/plugin install web-app-security@awesome-claude-security` (or any plugin above).

## Where to Go Next on This Site

- Start from zero: [AppSec Preliminary Concepts](appsec-preliminary-concepts.md)
- Core coding practice: [Secure Coding](secure-coding.md), [Secure Code Review](secure-code-review.md), [Cryptography](cryptography.md)
- Deep dives: [Authentication Security](authentication-security.md), [Authorization Security](authorization-security.md), [Injection Security](injection-security.md), [XSS & Client-Side Security](xss-client-side-security.md), [Business Logic Security](business-logic-security.md)
- Architecture & design: [Secure Application Architecture](secure-application-architecture.md), [Threat Modeling](threat-modeling.md)
- Tooling: [API Security](api-security.md), [SAST](sast.md), [SCA](sca.md)
- Practice: [AppSec Red Teaming & Practice Labs](appsec-red-teaming-labs.md)
- Learn from the past: [AppSec Real-World Incidents](appsec-real-world-incidents.md)

## Credits/References

1. [jassics/awesome-appsec-learning-resources](https://github.com/jassics/awesome-cybersecurity-learning-resources/blob/main/awesome-appsec-learning-resources.md) - the full, continuously updated source this page distills
2. [jassics/awesome-api-security-learning-resources](https://github.com/jassics/awesome-cybersecurity-learning-resources/blob/main/awesome-api-security-learning-resources.md)
3. [jassics/awesome-claude-security](https://github.com/jassics/awesome-claude-security) - Claude Code plugin marketplace for security work
4. [OWASP Foundation](https://owasp.org/)
