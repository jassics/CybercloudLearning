# Application Security Study Plan

This page is updated based on [jassics/security-study-plan/application-security-study-plan](https://github.com/jassics/security-study-plan/blob/main/application-security-study-plan.md)

This study plan is based on milestones. Check how much you can cover within the timeline - the more topics you cover, the better a candidate you are for the job role. Also, I assume you have already checked and are comfortable with the [Common Security Skills study plan](../common-skills-study-plan.md).

Application Security is different from Web Security, and different from what most people think of as offensive security or pentesting. Though it needs some pentester-aligned concepts, it's a different skill set altogether.

It leans more toward shift-left security - Threat Modeling, Secure Code Review, Secure Code Design, training developers, owning the overall SDL process, and of course the OWASP Top 10 for Web and API security. There's a separate ["API Security Study Plan"](https://github.com/jassics/security-study-plan/blob/main/api-security-study-plan.md) on GitHub because that skill needs dedicated time too.

## In Short

1. AppSec is not Pentesting or [Web Security Testing](web-security-testing-study-plan.md) (people often use the terms interchangeably).
2. Think more "combination of developer and attacker" than pure attacker.
3. Talking to developers, training them, or reading their code should not scare you.
4. Arguably tougher than pentesting (a topic of debate for another day).
5. You should be comfortable writing code for a PoC, exploit, or demo.
6. API security should be an area of interest - see the [API Security guide](../../product-security/application-security/api-security.md) on this site.
7. A good understanding of Identity and Access Management (IAM) helps with auth-related design and reviews.

It usually takes 6-12 months of consistent study to be job-ready at the entry level.

## ToC
1. [Web Application Concepts](#web-application-concepts) - 6 weeks
2. [Threat Modeling](#threat-modeling) - 2-3 weeks
3. [Secure Code Review](#secure-code-review) - 6-8 weeks
4. [Cryptography](#cryptography) - 3 weeks
5. [Security Development Lifecycle (SDL)](#security-development-lifecycle-sdl) - 4 weeks
6. [Books](#books)
7. [Videos](#videos)
8. [Courses](#courses) - complete at least 1-2 courses (1-2 months)
9. [Certifications](#certifications) - optional, based on your goals
10. [Interview Questions](#interview-questions)
11. [AppSec Tools](#appsec-tools)
12. [Whom to Follow on Twitter](#whom-to-follow-on-twitter)

## Web Application Concepts
**Duration: 6 weeks**

This overlaps with pentesting concepts, but think more like a defender than an offender. Go at your own pace, but make sure you deeply understand HTTP security response headers, bruteforce, CSRF, injection, JWT, cryptography, hashing, and encoding.

### Week 1-2: Basics
1. Understand [various HTTP methods](https://developer.mozilla.org/en-US/docs/Web/HTTP/Methods) - PUT vs POST, UPDATE vs PATCH, leveraging OPTIONS
2. Understand [response status codes](https://developer.mozilla.org/en-US/docs/Web/HTTP/Status):
   1. What does a 200 mean when you tried something malicious?
   2. What can you infer from a 403?
   3. What does a 500 reveal, and why?
   4. Understand every status code a pentester would love to see.
3. Understand [HTTP headers](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers) well, especially response headers
4. TCP three-way handshake
5. How SSL/TLS works
6. [Basics of security terminologies](https://github.com/jassics/cybersecurity-roadmap/blob/main/cybersecurity-terminologies.md)
7. [Essential security concepts](https://github.com/jassics/cybersecurity-roadmap/blob/main/security-concepts.md)

### Week 3-4: Security Concepts
Most of these concepts are covered at the [OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/index.html). For each one, understand what it is, how it can be vulnerable, and how to exploit or mitigate it.

1. How proper AuthN/AuthZ implementation contributes to robust security, what an attacker can exploit, and how to mitigate it
2. How sessions and cookies work, and how they can be vulnerable, bypassed, or exploited
3. [Session management](https://cheatsheetseries.owasp.org/cheatsheets/Session_Management_Cheat_Sheet.html) hardening
4. In-depth XSS - both exploitation and mitigation
5. REST concepts like CRUD
6. Injection types, especially SQLi, RFI, LFI, RCE
7. Mass assignment
8. Rate limiting, bruteforce, replay attacks, MITM, session fixation, session hijacking, credential stuffing
9. CORS
10. SSRF prevention
11. JWT tokens in depth
12. Encoding, decoding, hashing basics
13. Cryptography and its implementation in applications - see this site's [Cryptography guide](../../product-security/application-security/cryptography.md)
14. [SAST](../../product-security/application-security/sast.md) vs [SCA](../../product-security/application-security/sca.md)

### Week 5-6: Advanced Application Security Skills
1. Master [OWASP Top 10 for Web (2021)](https://owasp.org/Top10/) and [OWASP API Security Top 10](../../product-security/application-security/api-security.md)
2. Work through the [OWASP Code Review Guide](https://owasp.org/www-pdf-archive/OWASP_Code_Review_Guide_v2.pdf) - what to verify and how
3. Master [OWASP ASVS](https://owasp.org/www-pdf-archive/OWASP_Application_Security_Verification_Standard_4.0-en.pdf) - it's your job to make developers aware of it and use it during development
4. Go through [OWASP SAMM](https://owaspsamm.org/model/) if you're aiming for a security architect role
5. Understand what causes [BOLA](https://www.traceable.ai/blog-post/a-deep-dive-on-the-most-critical-api-vulnerability-bola-broken-object-level-authorization) and [BFLA](https://securityboulevard.com/2021/07/api-security-101-broken-function-level-authorization/), and get good at testing for them
6. Weak cipher suites - how to test, and how to make developers aware
7. [Authentication](https://cheatsheetseries.owasp.org/cheatsheets/Authentication_Cheat_Sheet.html) and [Authorization](https://cheatsheetseries.owasp.org/cheatsheets/Authorization_Cheat_Sheet.html) cheat sheets
8. Advanced SQL injection
9. [XML injection](https://cheatsheetseries.owasp.org/cheatsheets/XML_Security_Cheat_Sheet.html), JSON injection
10. [SAML](https://cheatsheetseries.owasp.org/cheatsheets/SAML_Security_Cheat_Sheet.html) and LDAP injection
11. NoSQL injection
12. [GraphQL injection](https://cheatsheetseries.owasp.org/cheatsheets/GraphQL_Cheat_Sheet.html)
13. [XXE attacks](https://cheatsheetseries.owasp.org/cheatsheets/XML_External_Entity_Prevention_Cheat_Sheet.html)
14. [Server-side template injection](https://portswigger.net/web-security/server-side-template-injection)
15. [Deserialization](https://cheatsheetseries.owasp.org/cheatsheets/Deserialization_Cheat_Sheet.html)
16. [Content Security Policy (CSP)](https://cheatsheetseries.owasp.org/cheatsheets/Content_Security_Policy_Cheat_Sheet.html)

## Threat Modeling
Read this site's [Threat Modeling](../../product-security/application-security/threat-modeling.md) guide, or the deeper [Threat Modeling Study Plan](https://github.com/jassics/security-study-plan/blob/main/threat-modeling-study-plan.md) on GitHub.

## Secure Code Review
Read this site's [Secure Code Review](../../product-security/application-security/secure-code-review.md) guide, or the [Secure Code Review Study Plan](https://github.com/jassics/security-study-plan/blob/main/secure-code-review-study-plan.md) on GitHub.

## Cryptography
Read this site's [Cryptography](../../product-security/application-security/cryptography.md) guide, or the [Cryptography Study Plan](https://github.com/jassics/security-study-plan/blob/main/cryptography-study-plan.md) on GitHub.

## Security Development Lifecycle (SDL)
Read the [Secure Software Development Lifecycle Study Plan](https://github.com/jassics/security-study-plan/blob/main/secure-software-development-lifecycle-study-plan.md) on GitHub.

## Mobile Application Security
If you work with mobile apps (Android/iOS), also check the [Mobile Application Security Study Plan](https://github.com/jassics/security-study-plan/blob/main/mobile-application-security-study-plan.md).

## Books
1. [Agile Application Security](https://www.amazon.in/Agile-Application-Security-Enabling-Continuous/dp/9352136292/)
2. [Application Security Program Handbook](https://www.manning.com/books/application-security-program-handbook)
3. [Writing Secure Code](https://www.amazon.in/Writing-Secure-Code-David-Leblanc/dp/0735617228/)
4. [The Tangled Web: A Guide to Securing Modern Web Applications](https://www.amazon.in/Tangled-Web-Securing-Modern-Applications/dp/1593273886)
5. [Alice and Bob Learn Application Security](https://www.amazon.in/Alice-Bob-Learn-Application-Security/dp/1119687357)
6. [OWASP Code Review Guide](https://owasp.org/www-pdf-archive/OWASP_Code_Review_Guide_v2.pdf)

## Videos
1. [Introduction to Application Security](https://www.youtube.com/watch?v=4shFba3eRAc)
2. [Scaling your AppSec Program with Semgrep](https://www.youtube.com/watch?v=rAwxFw25x3E)
3. [Building an AppSec Program from the Ground Up by Snyk](https://www.youtube.com/watch?v=hYcMynC0f_M)
4. [Application Security - Understanding, Exploiting and Defending Against Top Web Vulnerabilities by Cerner](https://www.youtube.com/watch?v=sY7pUJU8a7U)
5. [Securing Web Applications](https://www.youtube.com/watch?v=WlmKwIe9z1Q)
6. [Web Application Security: 10 Things Developers Need to Know](https://www.youtube.com/watch?v=qjrkV4RjgIU)
7. [Application Security from SANS Institute](https://www.youtube.com/watch?v=T_nyN24QjEY)

## Courses
1. [Software Security on Coursera](https://www.coursera.org/learn/software-security)
2. [Cloud Application Security](https://www.coursera.org/learn/cloud-application-security)
3. [Application Security Guide - Udemy](https://www.udemy.com/course/application-security-the-complete-guide/)
4. [SEC522: Application Security - Securing Web Apps, APIs, and Microservices (SANS)](https://www.sans.org/cyber-security-courses/application-security-securing-web-apps-api-microservices/) - excellent but costly
5. [Free OWASP Top 10 practice from Kontra Security](https://application.security/free/owasp-top-10)

## Certifications
1. [CSSLP: Certified Secure Software Lifecycle Professional](https://www.isc2.org/Certifications/CSSLP) - Recommended
2. [CASE: Certified Application Security Engineer](https://www.eccouncil.org/programs/application-security-training/) - Java and .NET tracks
3. [GWEB: GIAC Certified Web Application Defender](https://www.giac.org/certifications/certified-web-application-defender-gweb/)

## Interview Questions
[Application Security interview questions](https://github.com/jassics/security-interview-questions/blob/main/application-security-interview-questions.md) are maintained in a separate repo, kept aligned with the wider [cybersecurity-roadmap](https://github.com/jassics/cybersecurity-roadmap).

## AppSec Tools
1. Checkmarx or HCL AppScan (previously IBM AppScan) for SAST
2. Snyk Code (SAST) and Snyk Open Source (SCA)
3. [git-secrets](https://git-secret.io/), [gitleaks](https://github.com/zricethezav/gitleaks), or [trufflehog](https://github.com/trufflesecurity/trufflehog) for secret scanning
4. [Chef InSpec](https://docs.chef.io/inspec/)
5. [OWASP Dependency-Check](https://github.com/jeremylong/DependencyCheck) for SCA
6. [Bandit](https://bandit.readthedocs.io/en/latest/) for Python code
7. [SonarQube](https://www.sonarsource.com/products/sonarqube/) for SAST, with plugins like [FindSecBugs](https://github.com/find-sec-bugs/find-sec-bugs)
8. [RetireJS](https://retirejs.github.io/retire.js/) for JS libraries
9. [Contrast](https://www.contrastsecurity.com/contrast-assess) for IAST
10. [Coverity](https://scan.coverity.com/) from Synopsys
11. [Burp Suite Pro](https://portswigger.net/burp/pro) - a must
12. [Veracode](https://www.veracode.com/)
13. [InsightAppSec](https://www.rapid7.com/products/insight-platform/) from Rapid7

## Whom to Follow on Twitter
Security professionals are very active on Twitter/X, sharing great content often:

1. [Jim Manico](https://twitter.com/manicode)
2. [Gyan Chawdhary](https://twitter.com/gunnu)
3. [Abhay Bhargav](https://twitter.com/abhaybhargav)
4. [Inon Shkedy](https://twitter.com/InonShkedy)
5. [Chris Romeo](https://twitter.com/edgeroute)
6. [Tanya Janca](https://twitter.com/shehackspurple)
7. [Anant Shrivastava](https://twitter.com/anantshri)
8. [Sanjeev Jaiswal](https://twitter.com/jassics)
9. [Defcon](https://twitter.com/defcon)
10. [Nullcon](https://twitter.com/nullcon)
11. [OWASP](https://twitter.com/owasp)

**Practice next:** [jassics/security-study-plan](https://github.com/jassics/security-study-plan) for the latest updates to this plan, and [jassics/security-interview-questions](https://github.com/jassics/security-interview-questions) to test yourself before an interview.
