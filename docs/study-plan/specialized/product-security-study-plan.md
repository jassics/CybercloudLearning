# Product Security Study Plan

This study plan is based on milestones, sourced from [jassics/security-study-plan/product-security-study-plan](https://github.com/jassics/security-study-plan/blob/main/product-security-study-plan.md). Also, I assume you have already checked and are comfortable with the [Common Security Skills study plan](../common-skills-study-plan.md).

Product Security is different from a pure "pentesting" role. It's closer to Application Security, but more embedded with product teams, helping them ship secure features quickly while balancing risk, user experience, and business goals. It's more towards:

- Enabling and coaching product & engineering teams
- Building and improving security into the product lifecycle
- Driving secure design, threat modeling, and remediation
- Partnering with AppSec, Cloud, and GRC to make security a feature of the product

It usually takes 6-12 months to be good at Product Security fundamentals for an entry-level role, or to move laterally from AppSec/engineering into a Product Security role.

## In Short

1. Product Security is not only bug hunting or pentesting.
2. Think of it as a combination of application security engineer, product engineer, and security program owner.
3. You work very closely with PMs, tech leads, architects, and developers.
4. Be comfortable talking about risk, trade-offs, and timelines.
5. Know enough AppSec, Cloud, and SDLC to help teams make good decisions.
6. Be able to translate technical issues into business impact and priorities.

## ToC

1. [Product Security Fundamentals](#product-security-fundamentals) - 3-4 weeks
2. [Working with Product and Engineering](#working-with-product-and-engineering) - 2-3 weeks
3. [Secure SDLC in Product Teams](#secure-sdlc-in-product-teams) - 4-6 weeks
4. [Threat Modeling and Risk-Based Prioritization](#threat-modeling-and-risk-based-prioritization) - 3-4 weeks
5. [Metrics, Backlog and Communication](#metrics-backlog-and-communication) - 2-3 weeks
6. [Integrations with AppSec, Cloud and GRC](#integrations-with-appsec-cloud-and-grc) - 2-3 weeks
7. [Books, Videos, Courses, Certifications](#books-videos-courses-certifications)
8. [Interview Questions](#interview-questions)

---

## Product Security Fundamentals
**Duration: 3-4 weeks**

Goal: understand what Product Security is and where it sits between AppSec, engineering, and the rest of the security org.

### Week 1-4: The Role & Lifecycle
1. How Product Security differs from Application Security, Security Architecture, and Pentesting; typical responsibilities - partnering with product teams, reviewing designs, threat modeling, triaging findings, guiding remediation
2. Read or refresh: [Application Security](../cybersecurity/application-security-study-plan.md), [API Security](../cybersecurity/api-security-study-plan.md), [Security Architecture](security-architecture-study-plan.md)
3. Typical feature lifecycle - idea/requirements → design → implementation → testing → release and monitoring
4. Map where Product Security adds value at each step

---

## Working with Product and Engineering
**Duration: 2-3 weeks**

Product Security is a **people and process** heavy role.

### Week 5-7: Integration & Culture
1. How product management works - roadmap, backlog, epics, user stories, OKRs/business goals/customer requests
2. How engineering teams work - Agile/Scrum/Kanban basics, sprint planning, stand-ups, demos, retros
3. Integrate security into these workflows - security requirements in user stories, "definition of done" including security checks, security champions model
4. Practice communication - explaining issues in business terms, proposing mitigations that fit team constraints, writing clear tickets/documentation

---

## Secure SDLC in Product Teams
**Duration: 4-6 weeks**

Make the Secure SDLC **practical** for product teams.

### Week 8-13: Practical SDLC
1. Read the [Secure SDLC Study Plan](secure-sdlc-study-plan.md)
2. Map SDL activities to real product workflows - when to run security design reviews, when to run [SAST](../../product-security/application-security/sast.md)/[SCA](../../product-security/application-security/sca.md)/DAST/IAST and what to do with results, how to handle sign-off for high-risk features
3. Tools and automation (examples, not endorsements) - SAST, SCA/dependency scanning, secret scanning, container/IaC scanning
4. Define and roll out simple, opinionated security guardrails - minimum controls per feature type (auth, logging, encryption, rate limiting), checklists for new services/APIs, SDLC security activity baselines

---

## Threat Modeling and Risk-Based Prioritization
**Duration: 3-4 weeks**

Threat modeling is a key part of Product Security.

### Week 14-17: Threat Modeling
1. Read the [Threat Modeling Study Plan](../cybersecurity/threat-modeling-study-plan.md) and the site's [Threat Modeling](../../product-security/application-security/threat-modeling.md) guide
2. Practice at least one structured method (STRIDE or similar)
3. Practical threat modeling in product teams - short facilitated sessions, using architecture diagrams/data flows, capturing a small actionable mitigation list
4. Risk-based prioritization - simple risk scoring (likelihood × impact), aligning with internal risk ratings (Critical/High/Medium/Low), when to accept risk vs push for fixes

---

## Metrics, Backlog and Communication
**Duration: 2-3 weeks**

Help leadership understand where the product stands.

### Week 18-20: Reporting & Strategy
1. Basic security metrics - open issues by severity/age, mean time to remediate (MTTR) by severity, coverage of critical controls across services
2. Managing a security backlog - grouping issues by theme, balancing tactical fixes vs strategic improvements
3. Reporting practice - short monthly/quarterly updates, showing trends instead of isolated numbers, highlighting wins (reduced risk, improved coverage, closed gaps)

---

## Integrations with AppSec, Cloud and GRC
**Duration: 2-3 weeks**

Product Security sits in the middle of several other teams.

### Week 21-23: Cross-Functional Collaboration
1. **With Application Security** - share findings/patterns across products, reuse AppSec guidelines/standards, coordinate on SAST/DAST/SCA and code review approaches
2. **With Cloud/Infrastructure Security** - understand cloud security baselines, ensure teams follow secure cloud patterns, collaborate on network/IAM/data protection
3. **With GRC/Compliance** - map product controls to policies/frameworks (ISO, SOC 2, GDPR), help prepare for audits/customer security reviews, turn compliance requirements into concrete product controls

---

## Books, Videos, Courses, Certifications

**Books:** there's no single canonical "Product Security" book, but these help - [Application Security Program Handbook](https://www.manning.com/books/application-security-program-handbook), [Agile Application Security](https://www.amazon.in/Agile-Application-Security-Enabling-Continuous/dp/9352136292/), [Alice and Bob Learn Application Security](https://www.amazon.in/Alice-Bob-Learn-Application-Security/dp/1119687357), plus a good product management book to understand PM language/priorities

**Videos:** talks on building/scaling Product Security or AppSec programs (recent OWASP/BSides/Black Hat talks); secure SDLC/DevSecOps videos emphasizing product-engineering collaboration; threat modeling and secure design talks

**Courses:** courses on building Application Security/Product Security programs; DevSecOps/Secure SDLC courses integrating with CI/CD and product workflows; threat modeling/architecture courses on cross-functional collaboration

**Certifications:** [CSSLP: Certified Secure Software Lifecycle Professional](https://www.isc2.org/Certifications/CSSLP); cloud security certifications (AWS/Azure/GCP) if your products are cloud-native; Application Security or DevSecOps-oriented certifications

## Interview Questions

Reuse many questions from the [Application Security interview questions](../../interview-questions/application-security-interview-questions.md), but think about them in terms of **how you'd embed security into product teams**. Additional Product Security-focused questions:

1. How would you integrate security into a team that ships features every 1-2 weeks?
2. How do you decide which security issues must be fixed before release and which can go into the backlog?
3. How would you introduce threat modeling into a product team that has never done it before?
4. How would you communicate a critical security issue to product and engineering leadership?
