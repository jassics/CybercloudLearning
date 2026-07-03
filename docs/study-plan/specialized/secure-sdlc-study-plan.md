# Security Development Lifecycle (SDL) Study Plan

This study plan is based on milestones, sourced from [jassics/security-study-plan/secure-software-development-lifecycle-study-plan](https://github.com/jassics/security-study-plan/blob/main/secure-software-development-lifecycle-study-plan.md). Also, I assume you have already checked and are comfortable with the [Common Security Skills study plan](../common-skills-study-plan.md).

SDL is about building security into each phase of software delivery - requirements, design, coding, testing, release, and maintenance - instead of treating security as a separate step at the end. It's more towards:

- Defining security activities and checkpoints in the SDLC
- Aligning developers, product, and security teams on expectations
- Integrating AppSec/DevSecOps/Product Security work into a repeatable process
- Giving organizations a structured way to measure and improve security maturity

It usually takes 6-12 weeks to be comfortable with SDL fundamentals and apply them in real projects.

## In Short

1. SDL is not just a document - it's how security is embedded into the way software is built.
2. Think of it as a framework connecting Application Security, DevSecOps, Product Security, and Architecture.
3. Be comfortable talking about SDLC phases and which security activities belong where.
4. Know how to keep SDL practical for agile and cloud-native teams.
5. Understand how to start small and evolve the SDL over time.

## ToC

1. [SDL Fundamentals](#sdl-fundamentals) - 1-2 weeks
2. [Security in Requirements and Design](#security-in-requirements-and-design) - 2-3 weeks
3. [Security in Implementation and Code Review](#security-in-implementation-and-code-review) - 2-3 weeks
4. [Security Testing and Verification](#security-testing-and-verification) - 2-3 weeks
5. [Release, Operations and Feedback](#release-operations-and-feedback) - 1-2 weeks
6. [Frameworks and Maturity Models](#frameworks-and-maturity-models) - 1-2 weeks
7. [Books, Videos, Courses, Certifications](#books-videos-courses-certifications)
8. [Interview Questions](#interview-questions)

---

## SDL Fundamentals
**Duration: 1-2 weeks**

Goal: understand what SDL is trying to achieve.

### Week 1-2: The Big Picture
1. Review basic SDLC models - waterfall vs iterative vs agile, and how modern teams actually deliver (Scrum/Kanban, CI/CD)
2. Understand SDL goals - reduce vulnerabilities introduced during development, catch issues earlier when they're cheaper to fix, provide traceability for security activities
3. Read or refresh related plans: [Application Security](../cybersecurity/application-security-study-plan.md), [DevSecOps](../cybersecurity/devsecops-study-plan.md), [Product Security](product-security-study-plan.md), [Security Architecture](security-architecture-study-plan.md)

---

## Security in Requirements and Design
**Duration: 2-3 weeks**

Security must start before code is written.

### Week 3-5: Shift Left
1. **Requirements phase** - define security/privacy requirements alongside functional ones (authN/authZ, logging, encryption, data retention, compliance); work with Product Security and GRC to capture constraints
2. **Design phase** - perform high-level architecture reviews, do threat modeling for new features/major changes (see [Threat Modeling Study Plan](../cybersecurity/threat-modeling-study-plan.md)), choose appropriate security patterns (gateway, zero trust, secure data flow)
3. **Deliverables** - documented security requirements, threat models/risk assessments, architecture diagrams with security controls marked

---

## Security in Implementation and Code Review
**Duration: 2-3 weeks**

Focus on day-to-day development activities.

### Week 6-8: Secure Build
1. **Secure coding practices** - follow language-specific secure coding guidelines (see this site's [Secure Coding](../../product-security/application-security/secure-coding.md) guide), use frameworks/libraries securely
2. **Code review** - integrate basic security checks into regular code reviews, use checklists for common issues
3. **Automation** - introduce [SAST](../../product-security/application-security/sast.md) and [SCA](../../product-security/application-security/sca.md) as part of the build; ensure findings are triaged and assigned, not ignored
4. Deepen code review skills with the [Secure Code Review Study Plan](../cybersecurity/secure-code-review-study-plan.md)

---

## Security Testing and Verification
**Duration: 2-3 weeks**

Testing must verify that controls are correctly implemented.

### Week 9-11: Verification
1. Unit and integration tests with security in mind where possible
2. DAST/API testing for running apps and services
3. Additional methods where relevant - IAST, fuzzing, penetration testing
4. Non-functional aspects - performance/reliability under attack conditions (e.g., rate limiting)
5. Ensure test results feed back into the backlog and SDL metrics

---

## Release, Operations and Feedback
**Duration: 1-2 weeks**

Security doesn't end at release.

### Week 12-13: Post-Release
1. **Pre-release** - security sign-off criteria for high-risk features, checklist to verify critical controls (auth, logging, encryption)
2. **Operations** - secure configuration management, monitoring/alerting for security-relevant events, patch/vulnerability management
3. **Feedback loop** - use incidents and pen test findings to improve earlier SDL phases; regular retrospectives on security issues

---

## Frameworks and Maturity Models
**Duration: 1-2 weeks**

Understand how SDL ties into broader frameworks.

### Week 14-15: Maturity
1. **OWASP SAMM** (Software Assurance Maturity Model) - high-level understanding of practice areas and maturity levels
2. Microsoft SDL concepts, at a summary level
3. How SDL relates to standards like ISO 27001, NIST, etc.
4. Use maturity models to assess current state and plan incremental improvements

---

## Books, Videos, Courses, Certifications

**Books:** books on building Application Security or Product Security programs (to see how SDL is implemented in practice); secure software development/secure coding books tied to SDLC

**Videos:** [Developing Secure Software (LFD121)](https://training.linuxfoundation.org/training/developing-secure-software-lfd121/) by The Linux Foundation (free); conference talks on secure SDLC in agile/DevOps environments; talks on OWASP SAMM and real-world program maturity journeys

**Courses:** courses focused on secure software development/secure SDLC; DevSecOps and Application Security courses on integrating security into pipelines and processes

**Certifications:** [CSSLP: Certified Secure Software Lifecycle Professional](https://www.isc2.org/Certifications/CSSLP); other secure software development or AppSec/DevSecOps certifications depending on your focus

## Interview Questions

Reuse many questions from the Application Security and Product Security interview sets, but think through the SDL lens:

1. How would you introduce security into an existing agile SDLC with minimal disruption?
2. Which security activities would you recommend at each phase of the SDLC and why?
3. How would you measure whether your SDL is working and improving over time?
