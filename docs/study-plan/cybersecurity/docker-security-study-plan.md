# Docker Security Study Plan

This page is updated based on [jassics/security-study-plan/docker-security-study-plan](https://github.com/jassics/security-study-plan/blob/main/docker-security-study-plan.md)

This study plan is based on milestones. Check how much you can cover within the timeline - the more topics you cover, the better a candidate you are for roles requiring solid Docker/container security knowledge. Also, I assume you have already checked and are comfortable with the [Common Security Skills study plan](../common-skills-study-plan.md).

Docker Security is a focused subset of cloud-native security and DevSecOps. You need to understand how images and containers work, what can go wrong, and how to build and run them securely across the SDLC.

It leans more toward:

- Building minimal and secure container images
- Understanding runtime hardening and isolation
- Integrating image scanning into CI/CD
- Working with DevSecOps/Platform teams on secure base images

It usually takes 4-8 weeks to be comfortable with Docker Security fundamentals, assuming you already know basic Docker usage - see this site's [Introduction to Docker](../../product-security/container-security/docker-introduction.md) if you don't.

## In Short

1. Docker Security is not just running a scanner on images.
2. Think "image hygiene + least privilege + secure defaults."
3. You should be comfortable writing and reviewing Dockerfiles.
4. You must understand how containers differ from VMs, and what isolation they do (and don't) provide.
5. You should know where Docker Security fits into DevSecOps and cloud security.

## ToC
1. [Docker and Container Fundamentals](#docker-and-container-fundamentals) - 1-2 weeks
2. [Image Build and Supply Chain Security](#image-build-and-supply-chain-security) - 1-2 weeks
3. [Runtime Hardening and Host Security](#runtime-hardening-and-host-security) - 1-2 weeks
4. [Scanning, Policies and CI/CD Integration](#scanning-policies-and-cicd-integration) - 1-2 weeks
5. [Resources](#resources)
6. [Interview Questions](#interview-questions)

## Docker and Container Fundamentals
**Duration: 1-2 weeks**

Be very comfortable with how Docker works before going deep into security.

### Week 1-2: Core Concepts
1. Revisit basic Docker concepts: images, layers, containers; Dockerfile instructions (`FROM`, `RUN`, `COPY`, `CMD`, `ENTRYPOINT`, `EXPOSE`, `USER`, etc.); volumes and networking basics
2. Containers vs VMs: namespaces and cgroups at a high level; shared-kernel model and what isolation it gives - see this site's [Containers vs Virtual Machines](../../product-security/container-security/container-overview.md#containers-vs-virtual-machine)
3. Practice: build simple images from base images (alpine, debian, etc.); run containers, inspect them, and play with basic commands

## Image Build and Supply Chain Security
**Duration: 1-2 weeks**

Focus on building secure images and understanding supply-chain risk.

### Week 3-4: Secure Images
1. Secure Dockerfile practices: minimal base images, avoid unnecessary packages/tools, never run as root (use `USER` properly), separate build/runtime stages (multi-stage builds), keep secrets out of images
2. Dependency/base image risk: how vulnerabilities in base images affect you, tracking and updating base images regularly
3. Basic supply-chain concepts: image registries and access controls, image signing/provenance at a high level
4. Practice: take an existing Dockerfile and harden it step by step; compare image sizes/contents before vs after

## Runtime Hardening and Host Security
**Duration: 1-2 weeks**

Even with secure images, runtime and host configuration matter a lot.

### Week 5-6: Runtime Security
1. Runtime security basics: dropping capabilities, read-only filesystems where possible, limiting resources via cgroups
2. Networking/exposure: avoid unnecessary open ports, use networks to separate services
3. Host hardening: keep the Docker engine and OS patched, limit who can run Docker (the `docker` group is effectively root), log and monitor the Docker daemon and containers
4. Orchestration integration: how these concepts map into Kubernetes or other orchestrators - see the [Kubernetes Security Study Plan](kubernetes-security-study-plan.md)

## Scanning, Policies and CI/CD Integration
**Duration: 1-2 weeks**

This is where Docker Security meets DevSecOps.

### Week 7-8: Automation & Policies
1. Image scanning: what scanners typically check (OS packages, app libs), severity/fix-availability/risk-based triage, where to scan (CI, registry, and/or runtime) - see this site's [SCA guide](../../product-security/application-security/sca.md)
2. Policies and baselines: no `latest` tags, specific allowed registries, minimal base images, no root user by default - enforced through CI checks and registry policies
3. CI/CD integration: cross-link with the [DevSecOps Study Plan](devsecops-study-plan.md); add image build and scan stages into pipelines; decide when to block vs warn

## Resources

**Certifications:** container or cloud-native security certifications where Docker is a key part of the curriculum; general cloud security certifications (AWS/Azure/GCP) if you deploy Docker workloads to the cloud.

## Interview Questions
Reuse some questions from Application Security and DevSecOps, but focus on containers:

1. How would you harden a Dockerfile for a typical web application?
2. What are common security risks in container images, and how do you detect them?
3. How would you integrate image scanning into a CI/CD pipeline?
4. What are the implications of giving developers access to the `docker` group on a host?

**Practice next:** this site's [Docker Security](../../product-security/container-security/docker-security.md) guide, and [jassics/security-study-plan](https://github.com/jassics/security-study-plan) for the latest updates to this plan.
