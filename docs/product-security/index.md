# Product Security Overview

Product Security is the practice of building security into a product end-to-end - the application code, the infrastructure it runs on, and the pipeline that ships it - rather than bolting it on after release. This section is organized around that lifecycle: how you write and review code, how you secure the network and cloud/container platforms it runs on, and how you automate all of it through DevSecOps.

## How to Use This Section

1. **New to product security?** Start with [Web Security Overview](web-security/web-security-overview.md) and [Application Security: Secure Coding](application-security/secure-coding.md) - the foundational concepts everything else builds on.
2. **Pick your track** - the tables below map each topic to where it lives, roughly in the order you'd learn them for a given specialization.
3. **Pair with the [Study Plans](../study-plan/index.md)** for a structured, week-by-week schedule instead of just a topic list.
4. **Self-test with [Interview Questions](../interview-questions/index.md)** once you've worked through a topic.

## Web & Network Security

| Topic | Focus |
|-------|-------|
| [Web Security Overview](web-security/web-security-overview.md) | Foundational web application security concepts |
| [OWASP Top 10 (2025)](web-security/owasp-top10.md) | The 10 most critical web application security risks, with vulnerable/fixed code examples |
| [Web Security Concepts](web-security/web-security-concepts.md) | Same-origin policy, CORS, cookies, CSP, TLS, CSRF |
| [Network Security Overview](network-security/network-security-overview.md) | Defense in depth, segmentation, firewalls, IDS/IPS, zero trust vs. perimeter |

## Application Security (Zero to Hero)

A full learning path from web/HTTP fundamentals through architecture-level reasoning, red teaming, and real-world incident analysis.

| Topic | Focus |
|-------|-------|
| [AppSec Preliminary Concepts](application-security/appsec-preliminary-concepts.md) | HTTP, client-server model, sessions/cookies - the vocabulary everything else assumes |
| [Secure Coding](application-security/secure-coding.md) | Core principles and vulnerability classes with mitigations |
| [Secure Code Review](application-security/secure-code-review.md) | Manual review methodology, risk-based prioritization, findings checklist |
| [Authentication & Session Security](application-security/authentication-security.md) | OAuth2/OIDC/SAML, JWT pitfalls, MFA, session hijacking |
| [Authorization & Access Control](application-security/authorization-security.md) | RBAC/ABAC/ReBAC, IDOR, BFLA, OPA/Rego policy engines |
| [Injection Security](application-security/injection-security.md) | Blind/second-order SQLi, command injection, NoSQL injection, XXE, SSTI |
| [XSS & Client-Side Security](application-security/xss-client-side-security.md) | Stored/reflected/DOM XSS, context-aware encoding, CSP, DOM clobbering |
| [Cryptography](application-security/cryptography.md) | Encryption, hashing, password storage, key management, TLS |
| [Threat Modeling](application-security/threat-modeling.md) | STRIDE, DFDs, trust boundaries, methodology comparison |
| [Secure Application Architecture](application-security/secure-application-architecture.md) | Reference architecture, defense in depth, ASVS/SAMM - with diagrams |
| [Business Logic Security](application-security/business-logic-security.md) | Race conditions, mass assignment, request smuggling, cache poisoning |
| [API Security](application-security/api-security.md) | OWASP API Security Top 10, BOLA, mass assignment, SSRF |
| [SAST](application-security/sast.md) | Static analysis tooling, CI/CD integration, tuning false positives |
| [SCA](application-security/sca.md) | Dependency/CVE scanning, SBOMs, remediation strategy |
| [AppSec Red Teaming & Labs](application-security/appsec-red-teaming-labs.md) | Testing methodology, tools, practice labs and CTFs |
| [Real-World AppSec Incidents](application-security/appsec-real-world-incidents.md) | Equifax, Capital One, Log4Shell, MOVEit - curated and sourced |
| [AppSec Resources](application-security/appsec-resources.md) | Standards, books, tools, labs, courses - go deeper on any topic above |

## Cloud Security

| Topic | Focus |
|-------|-------|
| [Cloud Security Essentials](cloud-security/cloud-security-essentials.md) | Shared responsibility model, IaaS/PaaS/SaaS, foundational checklist |
| [OWASP Top 10 Cloud](cloud-security/owasp-top10-cloud.md) | Common cloud misconfiguration risk categories |
| [AWS Security](cloud-security/learning-aws-security/aws-security-overview.md) | IAM, S3, CloudTrail, GuardDuty, KMS - hands-on with real CLI/policy examples |
| [GCP Security](cloud-security/learning-gcp-security/gcp-security-overview.md) | Cloud IAM, Security Command Center, Cloud KMS, VPC Service Controls |
| [Azure Security](cloud-security/learning-azure-security/azure-security-overview.md) | Defender for Cloud, Entra ID, Key Vault, Sentinel |

## Container Security

| Topic | Focus |
|-------|-------|
| [Container Overview](container-security/container-overview.md) | What containers are, containers vs. VMs, use cases |
| [Introduction to Docker](container-security/docker-introduction.md) | Docker fundamentals, images vs. containers |
| [Docker Security](container-security/docker-security.md) | Image hardening, scanning, secrets, non-root containers |
| [Docker Isolation Architecture](container-security/docker-container-isolation-architecture.md) | Namespaces, cgroups, capabilities, seccomp/AppArmor - with diagrams |
| [Docker Attack Techniques](container-security/docker-attack-techniques.md) | Socket breakout, runc escape (CVE-2019-5736), privileged-container abuse |
| [Docker Red Teaming & Labs](container-security/docker-red-teaming-labs.md) | Assessment methodology, Vulhub, Docker-specific test cases |
| [Docker Real-World Incidents](container-security/docker-real-world-incidents.md) | Docker Hub breach, cryptomining images - curated and sourced |
| [Kubernetes](container-security/kubernetes.md) | Core concepts - pods, deployments, services, control plane |
| [Kubernetes Security](container-security/kubernetes-security.md) | RBAC, network policies, Pod Security Standards, secrets management |
| [Kubernetes Architecture & Security](container-security/kubernetes-architecture-security.md) | 4Cs model, control-plane trust boundaries, attack-surface map - with diagrams |
| [OWASP Kubernetes Top 10](container-security/owasp-kubernetes-top10.md) | K01-K10 (2025), cross-linked to existing RBAC/NetworkPolicy/Secrets coverage |
| [Kubernetes Attack Techniques](container-security/kubernetes-attack-techniques.md) | Container escape, privilege escalation, cluster-to-cloud lateral movement |
| [Kubernetes Red Teaming & Labs](container-security/kubernetes-red-teaming-labs.md) | kube-hunter, kube-bench, Peirates, Kubernetes Goat, CKS certification path |
| [Kubernetes Real-World Incidents](container-security/kubernetes-real-world-incidents.md) | Tesla cryptojacking, CVE-2018-1002105 - curated and sourced |
| [Container Security Resources](container-security/container-security-resources.md) | Docker & Kubernetes standards, tools, labs, courses |

## DevSecOps

| Topic | Focus |
|-------|-------|
| [DevSecOps Fundamentals](devsecops/devsecops-fundamentals.md) | Shift-left, core practice areas, how the pipeline pieces fit together |
| [DevSecOps Maturity Model](devsecops/devsecops-maturity.md) | Self-assessment levels from manual review to fully automated gates |
| [Vulnerability Management](devsecops/vulnerability-management.md) | Full lifecycle, CVSS/EPSS/KEV-based prioritization, SLAs |
| [Compliance as Code](devsecops/compliance-as-code.md) | Policy-as-code (OPA/Rego, Checkov), mapping checks to frameworks |
| [SDL in CI/CD](devsecops/sdl-cicd.md) | Embedding SDL gates stage-by-stage in a pipeline |
| [SCA in CI/CD](devsecops/sca-cicd.md) | Concrete dependency-scanning pipeline integration |
| [DAST in CI/CD](devsecops/dast-cicd.md) | Running DAST against ephemeral/staging environments in CI |
| [Ansible](devsecops/ansible.md) | Security automation and hardening at scale |
| [Terraform](devsecops/terraform.md) | IaC security scanning, secure state management |
| [Pulumi](devsecops/pulumi.md) | IaC security with general-purpose languages, Policy as Code |
| [Jenkins](devsecops/jenkins.md) | Securing the CI/CD tool itself - credentials, RBAC, plugin risk |

## Credits/References

- [OWASP Foundation](https://owasp.org/)
- [NIST Secure Software Development Framework (SP 800-218)](https://csrc.nist.gov/pubs/sp/800/218/final)
- [jassics/security-study-plan](https://github.com/jassics/security-study-plan) for structured study schedules covering these same domains
