# Web Security Testing Study Plan

This page is updated based on [jassics/security-study-plan/web-pentest-study-plan](https://github.com/jassics/security-study-plan/blob/main/web-pentest-study-plan.md)

This study plan is based on milestones. Check how much you can cover and close the checkboxes - the more you close, the better a candidate you are for the job role. Also, I assume you have already checked and are comfortable with the [Common Security Skills study plan](../common-skills-study-plan.md).

Web security testing (pentesting) is different from bug bounty hunting, red teaming, and vulnerability assessment - though excelling at any of those requires being good at pentesting first.

**In short:**

1. Pentesters are offensive security folks who try to find as many security vulnerabilities as possible, assess the risk, and exploit as much as possible - playing as internal or external attackers for the organization.
2. Red Teamers care less about finding all security gaps; their goal is to find one way in, exploit it, then escalate laterally to reach the juiciest data.
3. Whether you join a bug bounty platform is entirely up to your preference and available time.

Read more about [Pentesting vs Red Team](https://www.mitnicksecurity.com/blog/red-team-operations-vs.-penetration-testing).

It usually takes about 6 months to be good at the fundamentals and land an entry-level role. If you also test Android or iOS apps, read the [Mobile Application Security Study Plan](https://github.com/jassics/security-study-plan/blob/main/mobile-application-security-study-plan.md) alongside this one.

## ToC
1. [Pentesting Concepts](#pentesting-concepts) - 6 weeks
2. [Tools of the Trade](#tools-of-the-trade) - 2 weeks
3. [Lab Practice](#lab-practice) - 8 weeks
4. [Books](#books) - 2-3 months
5. [Videos](#videos)
6. [Courses](#courses) - complete at least one course (1-2 months)
7. [Certifications](#certifications)
8. [Interview Questions](#interview-questions)

## Pentesting Concepts
**Duration: 6 weeks**

Go at your own pace, but make sure you deeply understand HTTP security response headers, bruteforce, DoS, XSS, CSRF, injection, IDOR, JWT, and similar core concepts.

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
Most of these are covered at the [OWASP Cheat Sheet Series](https://cheatsheetseries.owasp.org/index.html). Understand what each is, how it can be vulnerable, and how to exploit or mitigate it.

1. How proper AuthN/AuthZ implementation contributes to robust security, and what an attacker can exploit
2. How sessions and cookies can be vulnerable, bypassed, or exploited
3. In-depth XSS
4. REST concepts like CRUD
5. Injection types, especially SQLi, RFI, LFI
6. Mass assignment
7. CSP concepts
8. SSRF
9. Automated bruteforce
10. Credential stuffing
11. JWT tokens
12. Encoding, decoding, hashing basics
13. Session fixation, session hijacking
14. Third-party vulnerability checks and exploitation
15. Black-box vs white-box testing
16. [SAST](../../product-security/application-security/sast.md) vs DAST
17. CORS

### Week 5-6: Advanced Security Skills
1. Master the OWASP Web Security Testing Guide hands-on
2. Learn how to leverage a vulnerability to achieve RCE
3. Learn to test for OS command injection
4. Understand what causes BOLA and BFLA, and get good at testing for them
5. Weak cipher suites
6. Advanced SQL injection
7. XML injection, JSON injection
8. SAML and LDAP injection
9. NoSQL injection
10. GraphQL injection
11. XXE attacks
12. Template injection
13. Deserialization

## Tools of the Trade
**Duration: 2 weeks**

Tools aren't everything, but they make you a more efficient pentester. Don't be a tool junkie - understand each tool's functionality and when to use it. Kali OS ships with almost everything you'll need; a few worth calling out explicitly:

### Week 7-8: Essential Tools
1. Kali Linux
2. Burp Suite Pro or OWASP ZAP - your bread and butter
3. Metasploit
4. Nmap - you'll use it every time you start a pentest
5. dirb
6. Nikto
7. Fierce
8. dnsenum
9. sqlmap
10. Shodan
11. BeEF
12. Arachni
13. Wireshark
14. Hydra
15. Cain and Abel
16. w3af

## Lab Practice
**Duration: 8 weeks**

### Week 9-16: Hands-On Practice
1. [Kontra for OWASP Top 10 for Web](https://application.security/free/owasp-top-10)
2. [Hack The Box](https://www.hackthebox.com/)
3. [TryHackMe](https://tryhackme.com/)
4. [OWASP WebGoat](https://owasp.org/www-project-webgoat/)
5. [OWASP Juice Shop](https://owasp.org/www-project-juice-shop/)
6. [PentesterLab](https://pentesterlab.com/)
7. [AttackDefense Lab](https://attackdefense.com/) - recommended, needs a paid subscription
8. [DVWA](https://dvwa.co.uk/)

## Books
1. [The Web Application Hacker's Handbook](https://www.oreilly.com/library/view/the-web-application/9781118026472/) - start here, or with the Web Security Academy
2. [OWASP Web Security Testing Guide](https://owasp.org/www-project-web-security-testing-guide/stable/) - read this second
3. [The Hacker Playbook 3: Practical Guide To Penetration Testing](https://www.amazon.in/Hacker-Playbook-Practical-Penetration-Testing/dp/1980901759)
4. [Real World Bug Hunting](https://www.amazon.in/Real-World-Bug-Hunting-Field-Hacking/dp/1593278616/)
5. [Web Hacking 101 by Peter Yaworski](https://digtvbg.com/files/books-for-hacking/Web%20Hacking%20101%20-%20How%20to%20Make%20Money%20Hacking%20Ethically%20by%20Peter%20Yaworski.pdf)

## Videos
1. [Penetration Testing for Beginners](https://www.youtube.com/watch?v=X4eRbHgRawI)
2. [Web Security Course - Playlist](https://www.youtube.com/playlist?list=PL1y1iaEtjSYiiSGVlL1cHsXN_kvJOOhu-)

## Blogs / Other References
1. [Exploit-DB](https://www.exploit-db.com/)
2. [CVE](https://cve.mitre.org/cve/)
3. [Schneier on Security](https://www.schneier.com/)
4. [Krebs on Security](https://krebsonsecurity.com/)

## Courses
Choose lab-based courses to test how much you actually understand:

1. [Cybrary](https://www.cybrary.it/catalog/refined/?q=owasp)
2. [Pentester Academy](https://www.pentesteracademy.com/) - notably Python for Pentesters, JavaScript for Pentesters, Pentesting with Metasploit, WAP Challenges, Web Application Pentesting
3. [Introduction to Web Security from Stanford](https://online.stanford.edu/courses/xcs100-introduction-web-security)
4. [Pentesting for Beginners](https://www.udemy.com/course/learn-website-hacking-penetration-testing-from-scratch/)
5. [Pentesting from EdX](https://www.edx.org/learn/penetration-testing)
6. [Web Security Academy](https://portswigger.net/web-security) - you can skip the Web Application Hacker's Handbook if learning here
7. [Computer Systems Security from MIT](https://ocw.mit.edu/courses/6-858-computer-systems-security-fall-2014/video_galleries/video-lectures/)
8. [pwn.guide](https://pwn.guide/)

## Certifications
Certifications get you an HR call, but real hands-on experience beats anything.

1. [CEH](https://www.eccouncil.org/programs/certified-ethical-hacker-ceh/) - not highly recommended, but a fine start if you're new
2. [eJPT](https://elearnsecurity.com/product/ejpt-certification/)
3. [eWPTXv2](https://elearnsecurity.com/product/ewptxv2-certification/)
4. [OSCP](https://www.offensive-security.com/pwk-oscp/)
5. [OSWE](https://www.offensive-security.com/awae-oswe/)
6. [GPEN](https://www.giac.org/certifications/penetration-tester-gpen/)
7. [GWAPT](https://www.giac.org/certifications/web-application-penetration-tester-gwapt/)

See the [full list of cybersecurity certifications](https://github.com/jassics/cybersecurity-roadmap/blob/main/cybersecurity-certifications.md) for more.

## Networking Matters
Once you're on track and understand the fundamentals, it's time to:

1. Make good LinkedIn contacts in the security domain
2. Find a mentor
3. Make connections through security conferences, online or offline
4. Publish a few good hacking articles - basic concepts are fine, but publish
5. Join webinars and conferences
6. Help a beginner who's struggling

By the time you've worked through this checklist, you'll already be on your way to a strong start in a web security job role. All the best!

## Whom to Follow on Twitter
1. [Dave Kennedy](https://twitter.com/HackingDave)
2. [Kevin Mitnick](https://twitter.com/kevinmitnick)
3. [The Hacker News (THN)](https://twitter.com/TheHackersNews)
4. [PortSwigger](https://twitter.com/PortSwigger)
5. [Dark Reading](https://twitter.com/DarkReading)
6. [Defcon](https://twitter.com/defcon)
7. [Nullcon](https://twitter.com/nullcon)
8. [NahamSec](https://twitter.com/NahamSec)
9. [TryHackMe](https://twitter.com/RealTryHackMe)
10. [HackerOne](https://twitter.com/Hacker0x01)
11. [BugCrowd](https://twitter.com/Bugcrowd)
12. [OWASP](https://twitter.com/owasp)
13. [Troy Hunt](https://twitter.com/troyhunt)
14. [Jason Haddix](https://twitter.com/Jhaddix)
15. [Parisa Tabriz](https://twitter.com/laparisa)
16. [Binni Shah](https://twitter.com/binitamshah)
17. [Random Robbie](https://twitter.com/Random_Robbie)
18. [TomNomNom](https://twitter.com/TomNomNom)
19. [Aditya Shende](https://twitter.com/ADITYASHENDE17)
20. [Infosec Community](https://twitter.com/InfoSecComm)
21. [Hacking Articles](https://twitter.com/hackinarticles)
22. [Harsh Bothra](https://twitter.com/harshbothra_)

## Interview Questions
[Web Security interview questions](https://github.com/jassics/security-interview-questions/blob/main/web-security-interview-questions.md) are maintained in a separate repo, kept aligned with the wider [cybersecurity-roadmap](https://github.com/jassics/cybersecurity-roadmap).

**Practice next:** [jassics/security-study-plan](https://github.com/jassics/security-study-plan) for the latest updates to this plan.
