# Threat Modeling Hands-On

"The earlier the better" - a hands-on walkthrough of STRIDE threat modeling, including a Data Flow Diagram (DFD) exercise.

<iframe src="https://www.slideshare.net/slideshow/embed_code/key/4IE0M4B5eZFUXG?hostedIn=slideshare&page=upload" width="476" height="400" frameborder="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>

## Key Takeaways

- **Threat modeling is:** a security-focused design/model of a system, a list of potential threats, mitigating actions for each, and validation that those actions actually work.
- **The 4 core questions:** What are we building? What can go wrong? What are we going to do about it? Did we do a good enough job?
- **When to threat model:** the sooner the better - ideally at design time, whenever the system changes, after an incident, and arguably at every CI/CD run.
- **Three types:** attacker-centric, application-centric, and asset-centric.
- **STRIDE** maps each threat to the security property it breaks: Spoofing → Authenticity, Tampering → Integrity, Repudiation → Non-repudiability, Information Disclosure → Confidentiality, Denial of Service → Availability, Elevation of Privilege → Authorization.
- **DFD building blocks:** Asset (what to protect), Threat (potential negative outcome), Vulnerability (spotted weakness), Attack (how the vulnerability gets exploited), Mitigation (how to reduce the damage) - drawn with Process, Data Store, Data Flow, External Entity, and Trust/Privilege Boundary symbols.
- Real-world framing used in the talk: a full STRIDE breakdown of the CIS Docker 1.12 Benchmark, and a "Batman's Threat Model" example mapping assets (Bat Cave, Alfred, emails, texts) against threats (police, the Joker, journalists).

## Go Deeper

- [Threat Modeling](../../../product-security/application-security/threat-modeling.md) - the full STRIDE/DFD guide on this site, including a worked login-flow example
- [Threat Modeling Study Plan](../../../study-plan/cybersecurity/threat-modeling-study-plan.md)
- [Application Security Interview Questions](../../../interview-questions/application-security-interview-questions.md)
