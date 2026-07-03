# Security Architecture Study Plan

This study plan is based on milestones, sourced from [jassics/security-study-plan/security-architecture-study-plan](https://github.com/jassics/security-study-plan/blob/main/security-architecture-study-plan.md). Also, I assume you have already checked and are comfortable with the [Common Security Skills study plan](../common-skills-study-plan.md).

Security Architecture is different from just "doing AppSec" or "doing pentesting" - you need to design secure systems end-to-end across applications, infrastructure, cloud, data, and identities. It's more about:

- Defining guardrails and reference architectures
- Driving secure design decisions early
- Aligning with frameworks and standards
- Working closely with AppSec, Cloud, Infrastructure, and GRC teams

It usually takes 6-12 months to be good at Security Architecture fundamentals - enough for an entry-level role or a lateral move into an architect-type role.

## In Short

1. Security Architecture is not only pentesting or only AppSec.
2. Think of it as a combination of engineer, designer, and risk manager.
3. Talking to engineering leaders, architects, product owners, and GRC teams should not scare you.
4. Be comfortable with diagrams, data flows, and threat modeling.
5. Understand both on-prem and cloud architectures (at least one major CSP).
6. Be able to review designs and propose secure patterns with confidence.

## ToC

1. [Security Architecture Fundamentals](#security-architecture-fundamentals) - 4-6 weeks
2. [Frameworks, Standards and Models](#frameworks-standards-and-models) - 3-4 weeks
3. [Designing Secure Architectures](#designing-secure-architectures) - 4-6 weeks
4. [Threat Modeling and Risk Management](#threat-modeling-and-risk-management) - 3-4 weeks
5. [Secure SDLC and Architecture Governance](#secure-sdlc-and-architecture-governance) - 3-4 weeks
6. [Reference Architectures and Patterns](#reference-architectures-and-patterns) - 3-4 weeks
7. [Books, Videos, Courses, Certifications](#books-videos-courses-certifications)
8. [Interview Questions](#interview-questions)

---

## Security Architecture Fundamentals
**Duration: 4-6 weeks**

Goal: understand what security architecture means and where it fits in the overall security program.

### Week 1-6: Core Architecture
1. Understand the role of a Security Architect vs AppSec Engineer vs Cloud Security Engineer vs GRC
2. Understand high-level components of modern systems: applications/microservices, APIs and integration layers, databases/data stores, identity and access management, network/perimeter controls, observability and logging
3. Learn to read and create architecture diagrams (C4 model basics: context/container/component diagrams)
4. Understand core security goals (CIA, authenticity, non-repudiation, privacy by design, least privilege, defense in depth)
5. Map typical attack surfaces onto these diagrams

You'll use these fundamentals in almost every other section.

---

## Frameworks, Standards and Models
**Duration: 3-4 weeks**

You don't need to memorize everything, but you should know **what exists**, **when to use it**, and **where to look**.

### Week 7-10: Frameworks
1. High-level frameworks - SABSA (business-driven security architecture), TOGAF and how security fits into enterprise architecture, NIST CSF at a high level
2. Technical standards - NIST 800-53/800-171 basics, ISO 27001 controls at a high level, CIS Controls v8 (mapped to architecture capabilities)
3. Application/cloud-focused standards - [OWASP ASVS](https://owasp.org/www-project-application-security-verification-standard/), [OWASP SAMM](https://owaspsamm.org/), CSP-specific Well-Architected frameworks (AWS/Azure/GCP)

Understand how these frameworks translate into **concrete architecture requirements** (logging, segmentation, encryption, IAM, backups, resilience).

---

## Designing Secure Architectures
**Duration: 4-6 weeks**

Focus on how you design secure solutions from the start.

### Week 11-16: Design Patterns
1. **Network and segmentation** - DMZs, zero trust network concepts, micro-segmentation, north-south vs east-west traffic
2. **Identity and access architecture** - central IdP, SSO, SAML/OIDC, MFA, RBAC/ABAC, least privilege, just-in-time access
3. **Data security architecture** - data classification, encryption in transit/at rest, key management (KMS/HSM basics), tokenization/masking/pseudonymization
4. **Application and API architecture** - high-level secure web/API architectures (deep API details are in the [API Security Study Plan](../cybersecurity/api-security-study-plan.md))
5. **Resilience and availability** - redundancy, failover, backups/restore, designing for DDoS and capacity

Pick one or two small systems (side project, home lab, or existing app at work) and **draw** the "as-is" and "to-be" secure architecture.

---

## Threat Modeling and Risk Management
**Duration: 3-4 weeks**

Here you combine architecture diagrams with attacker thinking.

### Week 17-20: Threat Modeling
1. Read the [Threat Modeling Study Plan](../cybersecurity/threat-modeling-study-plan.md) and the site's own [Threat Modeling](../../product-security/application-security/threat-modeling.md) guide
2. Learn at least one methodology - STRIDE, or attack trees/kill-chain style
3. Learn how to identify assets/trust boundaries/entry points, identify threats and abuses per component, prioritize with simple risk scoring (likelihood × impact), and propose architectural mitigations

Repeat for at least 3-4 different architectures: a simple 3-tier web app, public APIs with a mobile/SPA client, and an internal line-of-business application.

---

## Secure SDLC and Architecture Governance
**Duration: 3-4 weeks**

Security architecture is only effective if it's built into how software is delivered.

### Week 21-24: Governance
1. Revisit the [Secure SDLC Study Plan](secure-sdlc-study-plan.md)
2. Understand where security architects engage in the SDLC - requirement/design reviews, architecture review boards/design review checklists, threat modeling as part of design, sign-off criteria and security non-functional requirements
3. Learn common governance practices - reference architectures/reusable patterns, exception management and technical debt tracking, security standards/baselines/guardrails

---

## Reference Architectures and Patterns
**Duration: 3-4 weeks**

Collect **reference architectures** for typical environments.

### Week 25-28: Reference Architectures
1. **On-prem/hybrid** - DMZ, VPN, identity, central logging, SIEM, bastion hosts
2. **Cloud** - secure VPC/VNet design, internet-facing vs private services, centralized logging/monitoring/alerting
3. **Common patterns** - zero trust access to internal apps, secure API gateway pattern, secure data pipeline/analytics architecture

Map each reference diagram to which controls are enforced where, and how attacks would flow through the system.

---

## Books, Videos, Courses, Certifications

**Books:**

- [Enterprise Security Architecture: A Business-Driven Approach](https://www.amazon.com/Enterprise-Security-Architecture-Business-Driven-Information/dp/1420091260)
- [Agile Application Security](https://www.amazon.in/Agile-Application-Security-Enabling-Continuous/dp/9352136292/) - good for seeing how architecture and AppSec work together
- [Security Engineering](https://www.cl.cam.ac.uk/~rja14/book.html) by Ross Anderson - classic reference on designing secure systems
- [The Tangled Web: A Guide to Securing Modern Web Applications](https://www.amazon.in/Tangled-Web-Securing-Modern-Applications/dp/1593273886)

**Videos:** search for "Security Architecture" talks from OWASP, Black Hat, or RSA; cloud provider "Well-Architected" security deep-dives (AWS, Azure, GCP official channels)

**Courses:** "Enterprise Security Architecture" or "Security Architecture and Design" courses from trusted platforms; cloud security architecture courses from your preferred CSP

**Certifications:**

- [CSSLP: Certified Secure Software Lifecycle Professional](https://www.isc2.org/Certifications/CSSLP)
- [CCSP: Certified Cloud Security Professional](https://www.isc2.org/Certifications/CCSP)
- Vendor-specific cloud security/architecture certifications (AWS, Azure, GCP)

## Interview Questions

Use the [Application Security interview questions](../../interview-questions/application-security-interview-questions.md) and think about how you'd answer them from an **architecture** perspective (design choices, trade-offs, patterns), then extend with:

1. How would you design a secure architecture for a public web application with APIs and mobile clients?
2. How would you design logging and monitoring for a critical payments system?
3. How would you approach threat modeling for a new microservices-based product?
