# AppSec Real-World Incidents

## Why Study Real Breaches

Attack taxonomies (the [OWASP Top 10](../web-security/owasp-top10.md)) stay abstract until you can point to a real, dated, named incident that fits each category. Three practical reasons this page exists:

- **Interview panels ask about real incidents** - being able to explain Equifax's root cause in two sentences signals real fluency, not memorized definitions.
- **Pattern-matching new headlines against known root causes is a core AppSec skill** - most breaches are a variation on a small set of failure modes: an unpatched known CVE, a missing access-control check, an injection flaw, a trusted third-party script.
- **Incidents make abstract mitigations concrete** - "patch known CVEs promptly" lands very differently once you've seen a $1.4B+ breach trace back to a patch that was available but not applied.

Every incident below is real and sourced - see each entry's citation in Credits/References.

## Injection & Remote Code Execution

**Equifax (2017) - Apache Struts Remote Code Execution**
Attackers exploited CVE-2017-5638, a critical Apache Struts vulnerability allowing remote code execution via a malicious `Content-Type` HTTP header, to compromise Equifax's systems between May and July 2017. A patch had been available since the day the CVE was disclosed (March 7, 2017); Equifax's own vulnerability scans on March 15 failed to detect the exposure. Personal data - names, Social Security numbers, birth dates, addresses, and in some cases driver's license numbers - for approximately 143 million U.S. consumers was exposed.
*Category: [Injection](../web-security/owasp-top10.md) (OGNL injection via the Struts framework) compounded by [Software Supply Chain Failures](../web-security/owasp-top10.md) - a known, patched CVE in a dependency left unremediated. Lesson: a patch existing doesn't help you if your vulnerability scanning and patch-management process fails to actually detect and apply it - see [SCA](sca.md) for how automated dependency scanning should catch this class of exposure continuously, not via periodic manual scans.*

**MOVEit Transfer Mass Exploitation (May 2023)**
The Clop ransomware group exploited CVE-2023-34362, a SQL injection vulnerability in Progress Software's MOVEit Transfer file-transfer product, to deploy a custom web shell (LEMURLOOT) and exfiltrate data at mass scale. Because MOVEit was widely deployed as third-party infrastructure, the single vulnerability cascaded into breaches at hundreds of organizations, including the BBC, British Airways, Zellis, and the government of Nova Scotia, via their shared use of the vulnerable software.
*Category: [Injection](../web-security/owasp-top10.md) (SQL injection) with a [Software Supply Chain Failures](../web-security/owasp-top10.md) blast radius - one vulnerable vendor product compromised many downstream organizations simultaneously. Lesson: your attack surface includes every third-party product with access to your data, not just code you wrote - see [SCA](sca.md) and [AI Supply Chain Security](../../ai-security/ai-supply-chain-security.md) for the general discipline of tracking what's really in your supply chain.*

## SSRF & Cloud Metadata Abuse

**Capital One (2019) - SSRF to Cloud Credential Theft**
An attacker exploited a Server-Side Request Forgery (SSRF) vulnerability in a misconfigured web application firewall running on an AWS EC2 instance to query the instance's metadata service and retrieve temporary IAM credentials attached to that instance's overly permissive role. Those stolen credentials were then used to access and download data from more than 700 S3 buckets, exposing personal data - including Social Security numbers and bank account information - for roughly 106 million credit card applicants.
*Category: SSRF combined with excessive IAM privilege (now folded into [Broken Access Control (A01:2025)](../web-security/owasp-top10.md) in the current OWASP Top 10). Lesson: SSRF is dangerous specifically because of what it can reach - an EC2 instance's metadata endpoint should never be reachable from application-controlled requests, and IAM roles attached to internet-facing services should carry the absolute minimum privilege needed; see [AWS IAM Security](../cloud-security/learning-aws-security/iam-security.md).*

## Client-Side & Supply Chain Attacks

**British Airways / Magecart Skimming (2018)**
Attackers compromised British Airways' website by modifying a JavaScript library (Modernizr) already loaded on the payment page, appending 22 lines of code that captured payment form data in real time and sent it to an attacker-controlled domain. The skimming ran for roughly 15 days (August 21 - September 5, 2018) before detection, exposing payment card details - including full card numbers, expiry dates, and CVVs - for more than 380,000 customers. The UK's ICO issued a £20 million fine for the associated GDPR failures.
*Category: client-side supply chain compromise, a "Magecart-style" attack - not a vulnerability in British Airways' own code, but in a trusted third-party script running with full access to the payment page's DOM. Lesson: any third-party JavaScript running on a page that handles sensitive data has the same access as your own code - see [XSS & Client-Side Security](xss-client-side-security.md) for Subresource Integrity (SRI) and CSP as mitigations that specifically defend against this pattern.*

## Access Control & Authorization Failures

**Peloton API Exposing Private Account Data (2021)**
Security researchers found that Peloton's API returned full account details - age, gender, city, weight, and workout data - for ANY user ID, without checking whether the requester was authorized to view that specific user's data, even when the target account was set to "private." Peloton was notified in January 2021 with a 90-day responsible-disclosure deadline; the deadline passed without a fix, and the issue was only resolved after press inquiries. The exposure affected data tied to an estimated 3 million users.
*Category: [Broken Access Control (A01:2025)](../web-security/owasp-top10.md) - specifically an IDOR/BOLA pattern (see [Authorization & Access Control](authorization-security.md) and [API Security](api-security.md)'s coverage of BOLA). Lesson: a "private" flag in application logic is meaningless if the API layer doesn't independently enforce it on every request - privacy settings and access control must be checked at the same layer that serves the data, not assumed from a UI setting.*

## Credits/References

1. [Apache Software Foundation: Media Alert on the Equifax Breach](https://news.apache.org/foundation/entry/media-alert-the-apache-software)
2. [Equifax Releases Details on Cybersecurity Incident](https://investor.equifax.com/news-events/press-releases/detail/237/equifax-releases-details-on-cybersecurity-incident)
3. [CISA: #StopRansomware - CL0P Ransomware Gang Exploits CVE-2023-34362 MOVEit Vulnerability](https://www.cisa.gov/news-events/cybersecurity-advisories/aa23-158a)
4. [Krebs on Security: What We Can Learn from the Capital One Hack](https://krebsonsecurity.com/2019/08/what-we-can-learn-from-the-capital-one-hack/)
5. [British Airways Data Breach - Wikipedia](https://en.wikipedia.org/wiki/British_Airways_data_breach)
6. [TechCrunch: Peloton's Leaky API Let Anyone Grab Riders' Private Account Data](https://techcrunch.com/2021/05/05/peloton-bug-account-data-leak/)
