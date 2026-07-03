# DevSecOps Study Plan

This page is updated based on [jassics/security-study-plan/devsecops-study-plan](https://github.com/jassics/security-study-plan/blob/main/devsecops-study-plan.md)

This study plan is based on milestones. Check how much you can cover within the timeline - the more topics you cover, the better a candidate you are for roles requiring solid DevSecOps knowledge. Also, I assume you have already checked and are comfortable with the [Common Security Skills study plan](../common-skills-study-plan.md).

DevSecOps is not just "adding security tools to CI/CD." It's about building security into how software is planned, built, tested, delivered, and operated - with as much automation and feedback as possible.

It leans more toward:

- Working closely with developers, SRE/DevOps, and AppSec
- Integrating security checks into pipelines and platforms
- Defining secure defaults and guardrails
- Enabling teams to ship fast **and** safely

It usually takes 6-12 months to be job-ready at the entry level, or to move laterally from AppSec/DevOps into a DevSecOps role.

## In Short

1. DevSecOps is not a separate silo - it's how development, security, and operations work together.
2. Think "developer + DevOps/SRE + security engineer" combined.
3. You should be comfortable with CI/CD systems, containers, and basic cloud concepts.
4. You should know enough Application Security to choose and tune the right checks.
5. Automation, feedback loops, and culture change matter as much as tools.

## ToC
1. [DevSecOps Fundamentals](#devsecops-fundamentals) - 3-4 weeks
2. [CI/CD and Automation Basics](#cicd-and-automation-basics) - 3-4 weeks
3. [Security Testing in the Pipeline](#security-testing-in-the-pipeline) - 4-6 weeks
4. [Cloud, Containers and IaC Security](#cloud-containers-and-iac-security) - 4-6 weeks
5. [Platform Guardrails and Governance](#platform-guardrails-and-governance) - 3-4 weeks
6. [Metrics, Feedback and Culture](#metrics-feedback-and-culture) - 2-3 weeks
7. [Resources](#resources)
8. [Interview Questions](#interview-questions)

## DevSecOps Fundamentals
**Duration: 3-4 weeks**

Understand what DevSecOps is and what problems it tries to solve.

### Week 1-2: Evolution & Goals
1. Understand the evolution: Dev &rarr; DevOps &rarr; DevSecOps, and why traditional "security at the end" doesn't work.
2. Read or refresh related plans:
   1. [Application Security Study Plan](application-security-study-plan.md)
   2. [Secure SDLC Study Plan](../specialized/secure-sdlc-study-plan.md)
   3. The relevant cloud security study plan(s) - [AWS](../cloud-security/aws-security-study-plan.md), [Azure](../cloud-security/azure-security-study-plan.md), [GCP](../cloud-security/gcp-security-study-plan.md)

### Week 3-4: Responsibilities & Shift Left
1. Understand the main DevSecOps goals:
   1. Shift security left (earlier in the SDLC) and right (monitoring in production)
   2. Make security part of the delivery pipeline, not a blocking afterthought
   3. Provide self-service security capabilities for product teams
2. Know typical DevSecOps responsibilities:
   1. Designing and maintaining security checks in CI/CD
   2. Working with platform/DevOps teams to define secure defaults
   3. Helping AppSec/Product Security scale via automation

## CI/CD and Automation Basics
**Duration: 3-4 weeks**

You cannot do DevSecOps effectively without a solid grasp of CI/CD.

### Week 5-6: Platforms & Stages
1. Learn one or two CI/CD platforms in depth (GitHub Actions, GitLab CI, [Jenkins](../../product-security/devsecops/jenkins.md), Azure DevOps, CircleCI - depending on your environment)
2. Understand common pipeline stages: build, unit/integration tests, security tests, packaging/artifacts, deployment

### Week 7-8: Infrastructure & Practice
1. Learn the infrastructure around pipelines: repositories/branching strategies, environments (dev/test/stage/prod), secrets management for pipelines
2. Practice: build a simple app with a basic CI pipeline (build + tests), then plan where security checks will plug in ([SAST](../../product-security/application-security/sast.md), [SCA](../../product-security/application-security/sca.md), etc.)

## Security Testing in the Pipeline
**Duration: 4-6 weeks**

Focus on what security checks you can automate, and where.

### Week 9-11: SAST, SCA & Secrets
1. **SAST** - see this site's [SAST guide](../../product-security/application-security/sast.md) and [SDL in CI/CD](../../product-security/devsecops/sdl-cicd.md); understand its strengths/limitations, where to run it (typically PR/merge), and how to configure gates
2. **SCA / dependency scanning** - see [SCA](../../product-security/application-security/sca.md) and [SCA in CI/CD](../../product-security/devsecops/sca-cicd.md); vulnerable dependencies, license risk, SBOM basics
3. **Secrets detection** - preventing API keys/passwords from being committed, pre-commit hooks vs pipeline checks

### Week 12-14: DAST & Container Scanning
1. **DAST/API testing** - see [DAST in CI/CD](../../product-security/devsecops/dast-cicd.md); black-box testing against running apps/APIs, and where to run it (e.g. pre-prod)
2. **Container/image scanning** - base image vulnerabilities, app packages inside containers, integrating scanning into image builds - see [Docker Security Study Plan](docker-security-study-plan.md)

You don't need to be an expert in every tool, but you should understand which type of test fits which risk, and where in the pipeline it belongs.

## Cloud, Containers and IaC Security
**Duration: 4-6 weeks**

Most DevSecOps work today happens around cloud-native stacks.

### Week 15-17: Containers & Orchestration
1. Docker basics (images, containers, Dockerfile) - see [Docker Security Study Plan](docker-security-study-plan.md)
2. Kubernetes/orchestration basics (pods, services, deployments, namespaces) - see [Kubernetes Security Study Plan](kubernetes-security-study-plan.md)
3. Common container security risks: running as root, capabilities, image provenance

### Week 18-20: IaC & Baselines
1. **Infrastructure as Code:** [Terraform](../../product-security/devsecops/terraform.md), CloudFormation, ARM/Bicep, [Pulumi](../../product-security/devsecops/pulumi.md), [Ansible](../../product-security/devsecops/ansible.md); typical misconfigurations (open security groups, public buckets, missing encryption)
2. Cloud security baselines: align with your cloud study plan(s), understand provider-native services (Security Center, Config, GuardDuty)
3. DevSecOps role: integrate image and IaC scanning into pipelines; enforce baseline policies via policy-as-code (OPA/Conftest, admission controllers) - see [Compliance as Code](../../product-security/devsecops/compliance-as-code.md)

## Platform Guardrails and Governance
**Duration: 3-4 weeks**

DevSecOps is also about secure platforms, not only individual pipelines.

### Week 21-24: Guardrails & Governance
1. Internal developer platforms, golden paths, and templates
2. Typical security guardrails: standardized service templates with logging/monitoring/security defaults, centralized identity/access patterns, network policies and ingress/egress controls
3. Governance and approvals - when they're necessary, and automating so humans mainly handle exceptions
4. Work with Product Security/AppSec/Cloud Security to define minimal required controls and an exception/risk-acceptance process

## Metrics, Feedback and Culture
**Duration: 2-3 weeks**

DevSecOps is as much about people and feedback as it is about tools.

### Week 25-27: Metrics & Culture
1. Metrics: findings per pipeline/service (and trend), MTTR for security issues, adoption of security checks
2. Feedback loops: making scanner results visible/understandable to developers, fast PR feedback, security office hours
3. Culture and enablement: security champions, training developers on interpreting/fixing findings, keeping friction low - see [Vulnerability Management](../../product-security/devsecops/vulnerability-management.md) and [DevSecOps Maturity Model](../../product-security/devsecops/devsecops-maturity.md)

## Resources

**Certifications:** cloud security certs for your primary provider (AWS/Azure/GCP), DevOps/cloud-native certs covering CI/CD and containers, Application Security/Secure SDLC certs if you want to emphasize the security side.

## Interview Questions
You can reuse many questions from [Application Security interview questions](../../interview-questions/application-security-interview-questions.md), and from cloud/security interviews generally - but focus on how you would **automate** and **integrate** security into pipelines and platforms.

Additional DevSecOps-focused questions to prepare for:

1. How would you add security checks into an existing CI/CD pipeline without slowing teams down too much?
2. How do you decide which security tools to run on pull requests vs in nightly builds?
3. How would you integrate container and IaC scanning into the delivery process?
4. How would you measure the success of a DevSecOps initiative over 6-12 months?

**Practice next:** [jassics/security-study-plan](https://github.com/jassics/security-study-plan) for the latest updates to this plan, and [DevSecOps interview questions](../../interview-questions/devsecops-interview-questions.md) for DevSecOps-specific questions.
