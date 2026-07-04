# Container Security Resources

!!! tip "This page distills the highlights"
    For the full, continuously updated list, see [jassics/awesome-container-security-learning-resources](https://github.com/jassics/awesome-cybersecurity-learning-resources/blob/main/awesome-container-security-learning-resources.md) on GitHub - covering the full container lifecycle from image build through runtime and supply-chain integrity.

Use this page as the "go deeper" reference for the whole Container Security subsection - it covers both Docker and Kubernetes security resources together, since most tools and standards span the two.

## Standards & Frameworks

| Framework | What It Covers |
|-----------|-----------------|
| [CIS Docker Benchmark](https://www.cisecurity.org/benchmark/docker) | Bedrock configuration controls for Docker hosts and containers |
| [CIS Kubernetes Benchmark](https://www.cisecurity.org/benchmark/kubernetes) | Configuration controls for Kubernetes clusters |
| [NSA/CISA Kubernetes Hardening Guidance](https://media.defense.gov/2022/Aug/29/2003066362/-1/-1/0/CTR_KUBERNETES_HARDENING_GUIDANCE_1.2_20220829.PDF) | Government-published hardening guidance, widely cited |
| [OWASP Kubernetes Top 10](https://owasp.org/www-project-kubernetes-top-ten/) | The K01-K10 Kubernetes risk taxonomy - see [OWASP Kubernetes Top 10](owasp-kubernetes-top10.md) for a full deep dive |
| [OWASP Docker Top 10](https://owasp.org/www-project-docker-top-10/) | The Docker-specific equivalent risk taxonomy |
| [MITRE ATT&CK for Containers](https://attack.mitre.org/matrices/enterprise/containers/) | Real-world adversary tactics/techniques specifically against containerized environments |
| [Pod Security Standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/) | The `privileged`/`baseline`/`restricted` levels that replaced the deprecated PodSecurityPolicy |
| [The 4Cs of Cloud Native Security](https://kubernetes.io/docs/concepts/security/overview/) | Cloud, Cluster, Container, Code - the layered model behind [Kubernetes Architecture & Security](kubernetes-architecture-security.md) |

## Books

| Book | Author |
|------|--------|
| [Container Security](https://www.oreilly.com/library/view/container-security/9781492056690/) | Liz Rice (O'Reilly) - the definitive introduction: namespaces, cgroups, capabilities, seccomp |
| [Kubernetes Security and Observability](https://www.oreilly.com/library/view/kubernetes-security-and/9781098107093/) | Brendan Creane & Amit Gupta (O'Reilly) |
| [Hacking Kubernetes](https://www.oreilly.com/library/view/hacking-kubernetes/9781492081722/) | Andrew Martin & Michael Hausenblas (O'Reilly) - the offensive perspective |
| [Learn Kubernetes Security](https://www.packtpub.com/product/learn-kubernetes-security/9781839216503) | Kaizhe Huang & Pranjal Jumde (Packt) |
| [Docker Security (free chapter)](https://www.oreilly.com/library/view/using-docker/9781491915752/ch13.html) | Adrian Mouat |

## Videos & Talks

- [A Hacker's Guide to Kubernetes - Andrew Martin (KubeCon)](https://www.youtube.com/results?search_query=andrew+martin+hacking+kubernetes)
- [Container Security at Scale - KubeCon / CloudNativeSecurityCon talks](https://www.youtube.com/@cncf/search?query=container+security)
- [Liz Rice - Demo: A Container-Only Userspace](https://www.youtube.com/watch?v=8fi7uSYlOdc)
- [Jay Beale - Attacking and Defending Kubernetes](https://www.youtube.com/results?search_query=jay+beale+kubernetes)
- [eBPF for Security - Falco & Tetragon talks](https://www.youtube.com/results?search_query=ebpf+security+falco+tetragon)

## Courses & Certifications

| Course / Cert | Provider |
|----------------|----------|
| [Kubernetes Security (CKS path)](https://kodekloud.com/courses/kubernetes-security-cks) | KodeKloud |
| [Killer.sh CKS Simulator](https://killer.sh/) | Practice exam environment for the CKS |
| [Kubernetes Security Essentials (LFS260)](https://training.linuxfoundation.org/training/kubernetes-security-essentials-lfs260/) | Linux Foundation - official CKS prep |
| [Certified Container Security Expert (CCSE)](https://www.practical-devsecops.com/certified-container-security-expert/) | Practical DevSecOps |
| [SANS SEC584: Cloud Native Security](https://www.sans.org/cyber-security-courses/cloud-native-security-defending-containers-kubernetes/) | SANS |
| [Container Security Fundamentals (free)](https://learn.snyk.io/) | Snyk |
| **[CKS](https://www.cncf.io/training/certification/cks/)** | CNCF/Linux Foundation - the must-have Kubernetes security certification |
| **[KCSA](https://www.cncf.io/training/certification/kcsa/)** | CNCF - entry-level companion to CKS |
| **[KCNA](https://www.cncf.io/training/certification/kcna/)** | CNCF - foundational Kubernetes knowledge |
| **[CKA](https://www.cncf.io/training/certification/cka/)** | CNCF - prerequisite operational knowledge for CKS |
| [Red Hat Certified Specialist in Containers and Kubernetes](https://www.redhat.com/en/services/certification/rhcs-containers-kubernetes) | Red Hat |

## Tools

### Image & Registry Scanning

| Tool | Purpose |
|------|---------|
| [Trivy](https://github.com/aquasecurity/trivy) (Aqua) | De-facto open-source scanner for images, filesystems, repos, IaC, and Kubernetes manifests |
| [Grype + Syft](https://github.com/anchore/grype) (Anchore) | Vulnerability scanner plus SBOM generator |
| [Clair](https://github.com/quay/clair) (Quay/Red Hat) | Image vulnerability scanning |
| [Docker Scout](https://docs.docker.com/scout/) | Built-in scanning in Docker Desktop/Hub |

### Dockerfile & Config Linting

| Tool | Purpose |
|------|---------|
| [Hadolint](https://github.com/hadolint/hadolint) | Dockerfile linter |
| [Dockle](https://github.com/goodwithtech/dockle) | Container image linter aligned with the CIS Docker Benchmark |
| [Checkov](https://github.com/bridgecrewio/checkov) | IaC + Dockerfile + Kubernetes YAML scanning |
| [kube-linter](https://github.com/stackrox/kube-linter) (StackRox/Red Hat) | Kubernetes manifest linting |
| [Polaris](https://github.com/FairwindsOps/polaris) (Fairwinds) | Kubernetes configuration validation |

### Runtime & Detection

| Tool | Purpose |
|------|---------|
| [Falco](https://falco.org/) (CNCF graduated) | Runtime threat detection via eBPF/syscalls |
| [Tetragon](https://github.com/cilium/tetragon) (Isovalent) | eBPF-based runtime security |
| [Tracee](https://github.com/aquasecurity/tracee) (Aqua) | eBPF-based runtime security and forensics |
| [Sysdig Secure](https://sysdig.com/products/secure/) | Commercial runtime detection platform |

### Kubernetes Posture & Audit

See [Kubernetes Red Teaming & Labs](kubernetes-red-teaming-labs.md) for how to actually use kube-bench, kube-hunter, kubescape, kubeaudit, and Peirates in a real assessment.

### Admission Control & Policy

| Tool | Purpose |
|------|---------|
| [OPA / Gatekeeper](https://github.com/open-policy-agent/gatekeeper) | General-purpose policy engine with Kubernetes admission control integration |
| [Kyverno](https://kyverno.io/) (CNCF) | Kubernetes-native policy engine (no separate policy language required) |
| [Kubewarden](https://www.kubewarden.io/) | WASM-based admission policies |

### Network Policy & Service Mesh

| Tool | Purpose |
|------|---------|
| [Cilium](https://cilium.io/) (CNCF) | eBPF networking with L7-aware network policies |
| [Calico](https://www.tigera.io/project-calico/) | Network policy enforcement |
| [Istio](https://istio.io/) | Service mesh with mTLS and fine-grained authorization |
| [Linkerd](https://linkerd.io/) | Lightweight service mesh |

### Supply Chain, SBOM & Signing

| Tool | Purpose |
|------|---------|
| [Sigstore](https://www.sigstore.dev/) (cosign, rekor, fulcio) | Artifact signing and transparency logs |
| [SLSA framework](https://slsa.dev/) | Supply-chain integrity levels - see [AI Supply Chain Security](../../ai-security/ai-supply-chain-security.md) for a deep dive on the SLSA level structure, which applies to container images the same way it applies to ML model artifacts |
| [in-toto](https://in-toto.io/) | Supply-chain attestations |
| [Grafeas](https://grafeas.io/) | Software supply-chain metadata API |
| [Chainguard Images](https://www.chainguard.dev/chainguard-images) | Minimal, signed, distroless-style base images |

### Hardening Runtimes

| Tool | Purpose |
|------|---------|
| [gVisor](https://gvisor.dev/) (Google) | User-space kernel sandbox - stronger isolation than a default container runtime |
| [Kata Containers](https://katacontainers.io/) | Lightweight VM-based container runtime |
| [Bottlerocket OS](https://aws.amazon.com/bottlerocket/) (AWS) | Minimal, container-focused host OS |

## Hands-On Labs & CTFs

| Lab / CTF | Focus |
|-----------|-------|
| [Kubernetes Goat](https://madhuakula.com/kubernetes-goat/) | Vulnerable-by-design Kubernetes cluster - see [Kubernetes Red Teaming & Labs](kubernetes-red-teaming-labs.md) |
| [Bust-a-Kube / ControlPlane Simulator](https://github.com/controlplaneio/simulator) | Attack/defense Kubernetes simulator |
| [KillerCoda Playgrounds](https://killercoda.com/playgrounds) | Free, browser-based Kubernetes labs |
| [CNCF Capture the Flag (KubeCon archives)](https://github.com/cncf/k8s-ctf) | Past KubeCon CTF challenges |
| [TryHackMe](https://tryhackme.com/) | Has dedicated container/Kubernetes rooms |

## Blogs & Research

- [Aqua Security research blog](https://www.aquasec.com/blog/)
- [Sysdig research blog](https://sysdig.com/blog/)
- [Liz Rice - blog and talks](https://www.lizrice.com/)
- [Raesene (Rory McCune) - container/Kubernetes security research](https://raesene.github.io/)
- [ControlPlane research blog](https://control-plane.io/posts/)
- [CNCF TAG-Security whitepapers](https://github.com/cncf/tag-security)
- [Google - GKE hardening guide](https://cloud.google.com/kubernetes-engine/docs/how-to/hardening-your-cluster)

## Where to Go Next on This Site

- Start from zero: [Container Overview](container-overview.md), [Introduction to Docker](docker-introduction.md)
- Harden Docker: [Docker Security](docker-security.md)
- Learn Kubernetes: [Kubernetes](kubernetes.md), then [Kubernetes Security](kubernetes-security.md)
- Architecture & standards: [Kubernetes Architecture & Security](kubernetes-architecture-security.md), [OWASP Kubernetes Top 10](owasp-kubernetes-top10.md)
- Attack & defend: [Kubernetes Attack Techniques](kubernetes-attack-techniques.md), [Kubernetes Red Teaming & Labs](kubernetes-red-teaming-labs.md)
- Learn from the past: [Kubernetes Real-World Incidents](kubernetes-real-world-incidents.md)

## Credits/References

1. [jassics/awesome-container-security-learning-resources](https://github.com/jassics/awesome-cybersecurity-learning-resources/blob/main/awesome-container-security-learning-resources.md) - the full, continuously updated source this page distills
2. [CIS Benchmarks](https://www.cisecurity.org/cis-benchmarks)
3. [CNCF](https://www.cncf.io/)
