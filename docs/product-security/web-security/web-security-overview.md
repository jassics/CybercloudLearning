# Web Security Overview

## What is Web Security?

Web security is the practice of protecting websites, web applications, and web services from attacks that target the way browsers, servers, and users exchange data over HTTP(S). Almost everything you do online - checking email, banking, messaging, streaming - runs through a browser talking to a web application, which makes the web layer one of the largest and most consistently attacked surfaces in all of security.

Unlike network security (which protects the wires and routers data travels over) or infrastructure security (which protects the servers themselves), web security focuses on the application logic and the browser-server trust relationship: is this really the site you think it is, is your data protected in transit and at rest, and can an attacker manipulate the application into doing something it shouldn't.

## Why Web Security Matters

- The web application layer is the most externally-exposed part of most organizations - it's reachable by anyone on the internet, unlike internal systems behind a VPN or firewall.
- The [OWASP Top 10](owasp-top10.md) has tracked the same handful of vulnerability classes (broken access control, injection, cryptographic failures) topping the list release after release - these are well-understood, well-documented risks, yet they remain the leading cause of real-world breaches because they keep getting re-introduced in new code.
- Web vulnerabilities are also some of the easiest to discover and exploit at scale - automated scanners can probe thousands of sites for common misconfigurations in minutes, which is why unpatched, publicly known web flaws are a favorite target for opportunistic attackers, not just targeted ones.

## The Trust Questions Every Web Security Control Answers

Before diving into specific vulnerability classes, it helps to frame web security around the questions a user (and the browser, on their behalf) is implicitly asking every time they load a page:

| Question | What Answers It |
|----------|-------------------|
| Is this really the site I think it is? | TLS certificates, HSTS, DNS security - prevents spoofing/impersonation |
| Is my data protected while it travels? | HTTPS/TLS encryption in transit |
| Is my data protected once it's stored? | Encryption at rest, proper hashing for credentials |
| Can this site do things on my behalf without my consent? | CSRF protections, SameSite cookies |
| Can another site read my data from this one? | Same-origin policy, CORS configuration |
| Is the code running in my browser actually from this site? | Content Security Policy (CSP), Subresource Integrity |

Each of these maps to concrete mechanisms covered in [Web Security Concepts](web-security-concepts.md) - same-origin policy, CORS, cookie flags, CSP, and TLS basics.

## Where the Vulnerabilities Actually Come From

Most web vulnerabilities exist because a web application does one of a small number of things wrong:

- **Trusts user input** without validating or encoding it (leads to injection, XSS)
- **Fails to check authorization** on every request, not just authentication (leads to broken access control, IDOR)
- **Mismanages sessions/credentials** (leads to session hijacking, credential stuffing)
- **Misconfigures security-relevant settings** (leads to exposed admin panels, verbose error messages, permissive CORS)
- **Uses cryptography incorrectly or not at all** (leads to data exposure in transit or at rest)

The [OWASP Top 10 2021](owasp-top10.md) organizes the current, industry-consensus ranking of these failure classes with vulnerable-vs-fixed code examples for each.

## How to Approach Learning Web Security

1. **Start with the mechanics** - [Web Security Concepts](web-security-concepts.md) covers the browser-level primitives (same-origin policy, cookies, CORS, CSP) that every vulnerability class either exploits or depends on for its fix.
2. **Learn the vulnerability classes** - [OWASP Top 10 2021](owasp-top10.md) walks through each risk category with real code.
3. **Practice offensively** - deliberately vulnerable practice apps (OWASP Juice Shop, DVWA, PortSwigger's Web Security Academy) let you exploit these classes yourself, which builds far more durable understanding than reading alone.
4. **Practice defensively** - pair this with [Secure Coding](../application-security/secure-coding.md) to see the same vulnerability classes from the "how do I prevent this in my own code" side.
5. **Test yourself** - see the [Web Security Study Plan](../../study-plan/cybersecurity/web-security-testing-study-plan.md) and [Web Security Interview Questions](../../interview-questions/web-security-interview-questions.md) for a structured path and self-check.

## Credits/References

1. [OWASP Top Ten Project](https://owasp.org/www-project-top-ten/)
2. [OWASP Web Security Testing Guide](https://owasp.org/www-project-web-security-testing-guide/)
3. [Mozilla Web Security Guidelines](https://infosec.mozilla.org/guidelines/web_security)
4. [PortSwigger Web Security Academy](https://portswigger.net/web-security)
