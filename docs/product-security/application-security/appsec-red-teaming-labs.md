# AppSec Red Teaming, Testing & Practice Labs

## Why Hands-On Practice Is a Different Skill Than Reading

Knowing the definition of IDOR doesn't mean you'll spot one in a real application - pattern-matching a vulnerability class against unfamiliar code, under time pressure, with an unfamiliar API, is a trained skill built through repetition. This page is the practice-and-methodology companion to the rest of the Application Security section: read [Secure Coding](secure-coding.md), [Injection Security](injection-security.md), [Authorization & Access Control](authorization-security.md), and [Business Logic Security](business-logic-security.md) first so you know *what* you're looking for before you start poking at a target.

## A Practical Testing Methodology

1. **Recon** - map the application: what endpoints exist, what parameters they accept, where authentication boundaries sit, what third-party components are in use (framework versions, JS libraries).
2. **Automated scanning as a baseline, not the finish line** - run [SAST](sast.md) against source if available and [DAST](../devsecops/dast-cicd.md) against a running instance to catch the low-hanging fruit fast, freeing manual time for what scanners miss.
3. **Manual testing of access control and business logic** - this is where real findings live. Build an authorization matrix (which roles/users should be able to reach which endpoints/resources) and systematically test it - see [Authorization & Access Control](authorization-security.md) for the technique. Test workflows out of order, with negative/extreme values, and under concurrency - see [Business Logic Security](business-logic-security.md).
4. **Reporting** - see below for what separates a finding that gets fixed from one that gets ignored.

## Tools of the Trade

| Tool | What It Does |
|------|----------------|
| **[Burp Suite](https://portswigger.net/burp)** | The industry-standard intercepting proxy and scanner - Community edition is free and covers most manual testing needs; Professional adds the active scanner and more extensions |
| **[OWASP ZAP](https://www.zaproxy.org/)** | Free, open-source alternative to Burp - a strong choice for CI/CD-integrated DAST as well as manual testing |
| **[Postman](https://www.postman.com/)** | The most widely used tool for exploring and scripting against APIs directly |
| **[Kiterunner](https://github.com/assetnote/kiterunner)** | Content-discovery tool purpose-built for APIs - finds undocumented/forgotten endpoints that generic directory brute-forcers miss |

## Practice Labs & CTFs

Build pattern-recognition on intentionally vulnerable applications before you're doing this against anything real:

- **[PortSwigger Web Security Academy](https://portswigger.net/web-security)** - free, the gold standard for structured, hands-on web vulnerability labs covering nearly every class discussed on this site
- **[OWASP Juice Shop](https://owasp.org/www-project-juice-shop/)** - the most popular modern intentionally-vulnerable web app, covers the current OWASP Top 10
- **[OWASP WebGoat](https://owasp.org/www-project-webgoat/)** - OWASP's long-running Java-based learning app, still useful for fundamentals
- **[DVWA (Damn Vulnerable Web App)](https://github.com/digininja/DVWA)** - classic, configurable difficulty levels
- **[Google Gruyere](https://google-gruyere.appspot.com/)** - a small, guided vulnerable app good for absolute beginners
- **[crAPI](https://github.com/OWASP/crAPI)** - intentionally vulnerable API covering the full OWASP API Security Top 10 (see [API Security](api-security.md))
- **[VAmPI](https://github.com/erev0s/VAmPI)** - Flask-based vulnerable REST API with a toggle between vulnerable and patched modes
- **[DVGA (Damn Vulnerable GraphQL Application)](https://github.com/dolevf/Damn-Vulnerable-GraphQL-Application)** - essential for GraphQL-specific attack practice

## Bug Bounty as a Practice Path

Public bug bounty programs (HackerOne, Bugcrowd, and individual company programs) are both a career path and a learning resource - reading disclosed reports teaches real-world exploitation patterns that labs can't fully replicate. [Pentester Land's writeup archive](https://pentester.land/writeups/) aggregates disclosed bug bounty writeups across many programs and is a genuinely rich, free source of real vulnerability chains, from simple IDORs to multi-step exploit chains.

## Writing a Finding That Actually Gets Fixed

A vague finding wastes everyone's time. A good AppSec finding includes:

1. **Clear reproduction steps** - exact requests (method, URL, headers, body) needed to trigger the issue, ideally as a raw HTTP request or curl command a developer can replay directly.
2. **Proof of concept** - the actual request/response pair demonstrating impact, not just "I believe this is exploitable."
3. **Impact/severity framing** - tie the technical finding to business impact (data exposure scope, financial impact, regulatory exposure) and reference [CVSS](https://www.first.org/cvss/) for a standardized severity score.
4. **Suggested remediation** - a concrete fix, ideally with a code-level example, not just "sanitize input."

The difference between a junior and a senior finding is rarely the vulnerability class - it's the depth of the impact story. "This is XSS" is junior. "This stored XSS in the support-ticket field executes in the context of any agent viewing the ticket queue, meaning a single unauthenticated submission compromises every support agent's session cookie, including admin agents - here's the exploit chain and a patch diff" is senior.

## Practice Next

- [AppSec Real-World Incidents](appsec-real-world-incidents.md) - see what these vulnerability classes look like at real-world scale
- [Authorization & Access Control](authorization-security.md) and [Business Logic Security](business-logic-security.md) - know what you're testing for
- [Application Security Interview Questions](../../interview-questions/application-security-interview-questions.md)

## Credits/References

1. [PortSwigger Web Security Academy](https://portswigger.net/web-security)
2. [OWASP Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)
3. [OWASP Juice Shop](https://owasp.org/www-project-juice-shop/)
4. [FIRST CVSS](https://www.first.org/cvss/)
