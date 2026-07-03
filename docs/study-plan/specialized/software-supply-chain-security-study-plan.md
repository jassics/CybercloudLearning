# Software Supply Chain Security Study Plan

This page is updated based on [jassics/security-study-plan/software-supply-chain-security-study-plan](https://github.com/jassics/security-study-plan/blob/main/software-supply-chain-security-study-plan.md). Also, I assume you have already checked and are comfortable with the [Common Security Skills study plan](../common-skills-study-plan.md).

Software supply chain security is about securing everything that goes into building, packaging, and delivering software: source code, dependencies, build systems, CI/CD pipelines, artifacts, and runtime environments. It's more towards:

- Understanding how code and dependencies flow from dev laptops to production
- Securing dependencies and third-party components
- Hardening build and CI/CD systems
- Ensuring integrity of artifacts and deployments
- Responding to supply chain incidents quickly

It usually takes 8-16 weeks to be comfortable with software supply chain security fundamentals, depending on your background in AppSec, DevSecOps, and cloud.

## In Short

1. Software supply chain security is not just dependency scanning.
2. Think of it as end-to-end integrity: from source to production.
3. Be comfortable with version control, CI/CD, and package managers.
4. Know the basics of DevSecOps, Docker/Kubernetes, and cloud.
5. Understand how real-world incidents happened, to avoid repeating them.

## ToC

1. [Supply Chain Fundamentals](#supply-chain-fundamentals) - 2-3 weeks
2. [Dependencies and Package Ecosystems](#dependencies-and-package-ecosystems) - 2-3 weeks
3. [Build Systems and CI/CD Security](#build-systems-and-cicd-security) - 2-3 weeks
4. [Artifact Integrity, Signing and SBOM](#artifact-integrity-signing-and-sbom) - 2-3 weeks
5. [Historical Supply Chain Incidents](#historical-supply-chain-incidents) - 1-2 weeks
6. [Detection, Response and Governance](#detection-response-and-governance) - 2-3 weeks
7. [Books, Videos, Courses, Certifications](#books-videos-courses-certifications)
8. [Interview Questions](#interview-questions)

---

## Supply Chain Fundamentals
**Duration: 2-3 weeks**

Goal: understand what "software supply chain" actually means.

### Week 1-3: The Chain
1. Basic stages - developer workstation and source control, dependencies/package managers, build systems/CI/CD pipelines, artifact repositories/container registries, deployment/runtime environments
2. Read or refresh related plans: [Application Security](../cybersecurity/application-security-study-plan.md), [DevSecOps](../cybersecurity/devsecops-study-plan.md), [Docker Security](../cybersecurity/docker-security-study-plan.md), [Kubernetes Security](../cybersecurity/kubernetes-security-study-plan.md)
3. Map risks at each stage - source code tampering/credential theft, malicious or vulnerable dependencies, compromised build agents/pipelines, poisoned images/artifacts, deployment misconfigurations

---

## Dependencies and Package Ecosystems
**Duration: 2-3 weeks**

Dependencies are one of the largest attack surfaces.

### Week 4-6: Dependencies
1. Ecosystems - npm/yarn/pnpm (JS/TS), PyPI (Python), Maven/Gradle (Java), NuGet (.NET), etc.
2. Common risks - dependency confusion and typosquatting, malicious maintainers/compromised accounts, abandoned/unmaintained packages
3. Basic protections - lockfiles and deterministic builds, private registries/proxies, allowlists/blocklists for dependencies
4. Dependency scanning - understanding [SCA](../../product-security/application-security/sca.md), severity/exploitability/prioritization of dependency vulns

---

## Build Systems and CI/CD Security
**Duration: 2-3 weeks**

Focus on securing the build and delivery machinery.

### Week 7-9: Pipeline Security
1. Key components - CI servers/agents, build scripts/configuration, secrets used in pipelines (cloud creds, signing keys)
2. Common risks - attackers gaining access to CI agents/configuration, insecure secret storage/handling, unreviewed changes to build scripts
3. Basic hardening - least privilege for CI service accounts, separate build agents by trust level, code review/change control for build configs
4. Cross-link with the [DevSecOps Study Plan](../cybersecurity/devsecops-study-plan.md) for CI/CD details

---

## Artifact Integrity, Signing and SBOM
**Duration: 2-3 weeks**

This is about making sure what you build is exactly what gets deployed.

### Week 10-12: Integrity
1. Artifact repositories/registries - access control and environment separation, immutable artifacts where possible
2. Signing and verification (high level) - code signing concepts, image signing/verification
3. SBOM (Software Bill of Materials) - what it is, why it matters, how it helps in incident response and compliance (see the site's [SCA](../../product-security/application-security/sca.md) guide for SBOM tooling)
4. Simple practices - track which artifact versions are deployed where, ensure builds are reproducible and traceable

---

## Historical Supply Chain Incidents
**Duration: 1-2 weeks**

You'll learn a lot by understanding how major incidents happened.

### Week 13-14: Case Studies
1. **npm ecosystem attacks** - malicious packages published to steal credentials/exfiltrate data/run cryptominers, typosquatting attacks, compromised maintainer accounts leading to backdoored releases
2. **SHA-1 related attacks** - collision attacks against SHA-1 showed older hash algorithms may no longer be safe for integrity; understand why moving to stronger hashes matters for signing/integrity checks
3. **SolarWinds-style attacks** - attackers compromised the vendor's build system, malicious code was inserted into legitimate updates, customers trusted signed updates so the backdoor spread widely
4. For each incident, focus on: where in the chain the attacker gained control, what controls were missing/weak, and what changed afterward (more signing, better monitoring, stricter access control)

---

## Detection, Response and Governance
**Duration: 2-3 weeks**

Focus on how to detect/respond to supply chain issues and govern the program.

### Week 15-17: Operations
1. **Detection** - monitoring dependency changes/vulnerability feeds, alerting on unusual build/deployment behavior, logging around CI/CD and registries
2. **Response** - inventory of where components are used, rapid patching/rollback strategies, communication with stakeholders/customers
3. **Governance** - policies for dependency management/updates, standards for CI/CD and artifact handling, regular reviews/tabletop exercises based on real incidents

---

## Books, Videos, Courses, Certifications

**Books:** books on software supply chain or modern software security with supply-chain chapters; DevSecOps and cloud-native security books covering CI/CD and dependencies

**Videos:** conference talks on software supply chain attacks and defenses; deep dives on major incidents (vendor compromises, dependency attacks); talks on SBOMs, signing, and secure build pipelines

**Courses:** courses specifically on software supply chain security where available; DevSecOps courses with strong CI/CD and dependency-scanning coverage; cloud-native security courses that include supply chain topics

**Certifications:** general cloud security and DevSecOps certifications that include supply chain security; vendor-neutral or vendor-specific certs emphasizing secure SDLC and CI/CD

## Interview Questions

Reuse questions from Application Security, DevSecOps, and cloud security, plus supply chain focus:

1. How would you reduce the risk of malicious dependencies in a large organization?
2. What controls would you put around CI/CD systems to protect against supply chain attacks?
3. How would you respond if a widely used third-party library in your product was suddenly found to be compromised?
4. How would you explain the importance of SBOMs and artifact signing to engineering leadership?
