# Threat Modeling Study Plan

This page is updated based on [jassics/security-study-plan/threat-modeling-study-plan](https://github.com/jassics/security-study-plan/blob/main/threat-modeling-study-plan.md)

!!! important
    If you're in Product Security, Application Security, or Security Engineering, you'll need this study plan more than almost any other. Every security professional should still have a fair understanding of Threat Modeling fundamentals.

!!! note
    It should take 1-2 months to get a good understanding of Threat Modeling with some hands-on practice.

## What is Threat Modeling

Threat modeling is a structured approach for analyzing the security of an application - it identifies, quantifies, and addresses the security risks associated with it. Understanding likely threats and attacks lets an organization prioritize security initiatives more effectively and make better-informed risk-acceptance decisions. The site's own [Threat Modeling guide](../../product-security/application-security/threat-modeling.md) covers the STRIDE methodology and a worked example in depth.

!!! tip
    Read the [OWASP Threat Modeling Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Threat_Modeling_Cheat_Sheet.html) for the basics.

In short:

- Threat modeling is the process of identifying, analyzing, and mitigating potential security threats to a system or organization.
- It involves identifying the assets to protect, analyzing potential threats to them, and developing mitigation strategies.
- The earlier you threat model, the better the result.

### The Objective of Threat Modeling

1. The trust boundaries to and within the application
2. The actors that interact within and outside the trust boundaries
3. Information flows within, to, and from the trust boundaries
4. Information persistence within and outside trust boundaries
5. Threats to transgression of trust boundaries by actors, information flow, and persistence
6. Vulnerabilities at trust boundaries as accessed by actors, information flow, and persistence
7. Threat agents who can exploit the vulnerabilities
8. Impact of a threat agent exploiting a vulnerability
9. Decision tree to treat the risk

## ToC

1. [Threat Modeling Fundamentals](#threat-modeling-fundamentals) - 2 weeks
2. [Methodologies](#methodologies) - 2 weeks
3. [Process and Tools](#process-and-tools) - 2 weeks
4. [Advanced Topics and Practice](#advanced-topics-and-practice) - 2 weeks
5. [Resources](#resources)

## Threat Modeling Fundamentals
**Duration: 2 weeks**

### Week 1-2: Core Concepts

- **Definition:** Identifying, analyzing, and mitigating potential security threats
- **Why it matters:** Proactive identification, cost efficiency, prioritization
- **Key Elements:**
    - **Assets** - What are we protecting?
    - **Threats** - What can go wrong?
    - **Vulnerabilities** - Where are we weak?
    - **Mitigations** - What are we going to do about it?
- **The 4 Questions:** What are we building? What can go wrong? What are we going to do about it? Did we do a good job?

## Methodologies
**Duration: 2 weeks**

### Week 3-4: Frameworks

1. **STRIDE** - Spoofing, Tampering, Repudiation, Information Disclosure, Denial of Service, Elevation of Privilege (focus heavily on this)
2. **PASTA** - Process for Attack Simulation and Threat Analysis (risk-centric)
3. **Attack Trees** - visualizing attack paths
4. **Other models** - CVSS (scoring), DREAD (scoring), LINDDUN (privacy)

## Process and Tools
**Duration: 2 weeks**

### Week 5-6: Execution

1. **Data Flow Diagrams (DFDs)** - trust boundaries, processes, data stores, data flows, external entities
2. **The Process:** Define scope → Decompose application → Identify threats → Mitigate → Validate
3. **Tools:**
    - **OWASP Threat Dragon** - open source, web/desktop based
    - **Microsoft Threat Modeling Tool** - the classic standard
    - **Threagile** - agile, code-driven threat modeling

## Advanced Topics and Practice
**Duration: 2 weeks**

### Week 7-8: Scaling & Integration

1. **Integration** - fitting threat modeling into Agile/DevOps (Rapid Threat Modeling)
2. **Validation** - verifying mitigations through testing (pentesting, unit tests)
3. **Practice:**
    - Model a simple web app
    - Model a cloud infrastructure setup (e.g., an S3 bucket configuration)
    - Model a CI/CD pipeline

### Tools to Explore

1. [OWASP Threat Dragon](https://www.threatdragon.com/#/)
2. [Microsoft Threat Modeling Tool](https://learn.microsoft.com/en-us/azure/security/develop/threat-modeling-tool)
3. [STRIDE GPT](https://stridegpt.streamlit.app/)
4. [Threagile](https://run.threagile.io/)
5. [PyTM - a Pythonic Framework for Threat Modeling](https://github.com/izar/pytm)
6. [draw.io](https://www.drawio.com/) - also good for drawing threat model diagrams

## Resources

1. [OWASP Threat Dragon project](https://owasp.org/www-project-threat-dragon/)
2. [OWASP Threat Modeling community page](https://owasp.org/www-community/Threat_Modeling)
3. [Mindmap of a threat model used by Red Team](https://www.oreilly.com/library/view/hands-on-red-team/9781788995238/55d89c3e-e3f2-414a-872f-37620e9ab43f.xhtml)
4. [Cyber Threat Modeling by MITRE](https://www.mitre.org/sites/default/files/2021-11/prs-18-1174-ngci-cyber-threat-modeling.pdf)
5. [Clone Awesome Threat Modeling](https://github.com/hysnsec/awesome-threat-modelling) for more resources
6. [Threat Modeling Podcast by Chris Romeo](https://open.spotify.com/show/4q9BxNrRb0NWnLBpSmNqoP)
7. [Certified Threat Modeling Professional - Practical DevSecOps](https://www.practical-devsecops.com/certified-threat-modeling-professional/)
8. [Kubernetes Threat Modeling](https://www.trendmicro.com/vinfo/in/security/news/security-technology/a-deep-dive-into-kubernetes-threat-modeling)
9. [AWS S3 Threat Modeling](https://controlcatalog.trustoncloud.com/dashboard/aws/s3)

### Books

1. [Threat Modeling: Designing for Security](https://amzn.to/3zfKefb) by Adam Shostack
2. [Threat Modeling](https://amzn.to/4gEgbif) by Izar Tarandach

After learning Threat Modeling, connect it with monitoring and response by exploring the Blue Team / Detection & Response path, or reinforce it with [Secure Code Review](secure-code-review-study-plan.md) since both feed the same secure SDLC.

## Interview Questions

Threat modeling questions are commonly bundled into [Application Security interview questions](../../interview-questions/application-security-interview-questions.md).
