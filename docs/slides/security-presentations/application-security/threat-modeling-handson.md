# Threat Modeling Hands-On

"The earlier the better" - a hands-on walkthrough of STRIDE threat modeling, including a Data Flow Diagram (DFD) exercise.

<iframe src="https://www.slideshare.net/slideshow/embed_code/key/4IE0M4B5eZFUXG?hostedIn=slideshare&page=upload" width="476" height="400" frameborder="0" marginwidth="0" marginheight="0" scrolling="no"></iframe>

## Key Takeaways

- **Threat modeling is:** a security-focused design/model of a system, a list of potential threats, mitigating actions for each, and validation that those actions actually work.
- **The 4 core questions:** What are we building? What can go wrong? What are we going to do about it? Did we do a good enough job?
- **When to threat model, per this talk:** the sooner the better - ideally at design time, whenever the system changes, after an incident, and arguably at every CI/CD run. (This site's own [Threat Modeling](../../../product-security/application-security/threat-modeling.md) guide covers the same idea with a slightly different trigger list - both agree "earlier is better" is the core principle.)
- **Three lenses used in the talk to approach threat modeling:** attacker-centric, application-centric, and asset-centric - a different but complementary framing from the STRIDE/PASTA/DREAD/LINDDUN methodology list in the full guide.
- **STRIDE** maps each threat to the security property it breaks: Spoofing → Authenticity, Tampering → Integrity, Repudiation → Non-repudiability, Information Disclosure → Confidentiality, Denial of Service → Availability, Elevation of Privilege → Authorization.
- **Risk vocabulary used in the talk:** Asset (what to protect), Threat (potential negative outcome), Vulnerability (spotted weakness), Attack (how the vulnerability gets exploited), Mitigation (how to reduce the damage). Note this is separate from the actual **DFD symbol set** (Process, Data Store, Data Flow, External Entity, Trust/Privilege Boundary) used to draw the diagram - the full guide's [DFD section](../../../product-security/application-security/threat-modeling.md#step-1-model-the-system-data-flow-diagrams) covers those symbols in more depth.
- Real-world framing used in the talk: a full STRIDE breakdown of the CIS Docker 1.12 Benchmark, and a "Batman's Threat Model" example mapping assets (Bat Cave, Alfred, emails, texts) against threats (police, the Joker, journalists).

## Go Deeper

- [Threat Modeling](../../../product-security/application-security/threat-modeling.md) - the full STRIDE/DFD guide on this site, including a worked login-flow example
- [Threat Modeling Study Plan](../../../study-plan/cybersecurity/threat-modeling-study-plan.md)
- [Application Security Interview Questions](../../../interview-questions/application-security-interview-questions.md)
