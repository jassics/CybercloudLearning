# Kubernetes Red Teaming & Labs

## Why Hands-On K8s Security Practice Matters

RBAC policy can look perfectly reasonable on paper and still grant a service account far more than it needs - you don't find that gap by reading YAML, you find it by actually asking the cluster "what can this identity do?" and following the answer. Cluster misconfigurations are largely invisible until someone actually tries to exploit them, which is why hands-on practice (in a lab, not production) is a core skill for anyone doing Kubernetes security work, not an optional extra.

Read [Kubernetes Security](kubernetes-security.md) and [OWASP Kubernetes Top 10](owasp-kubernetes-top10.md) first - testing without knowing what you're testing *for* just produces unstructured poking, not a defensible assessment.

## A Basic Kubernetes Security Assessment Methodology

1. **Enumerate what you actually have access to.** `kubectl auth can-i --list` tells you every action your current identity is authorized for - run it as different service accounts to find over-permissioned ones. Check for mounted service account tokens inside running pods (`/var/run/secrets/kubernetes.io/serviceaccount/token`) - a compromised pod inherits whatever that token can do.
2. **Check for exposed components.** Is the Kubernetes Dashboard reachable without authentication? Is the kubelet API (port 10250) reachable from outside the cluster? Is etcd's client port (2379) reachable from anywhere other than control-plane nodes? See [OWASP Kubernetes Top 10](owasp-kubernetes-top10.md)'s K06 category for why this matters.
3. **Audit RBAC bindings for over-permissioning.** Look for `ClusterRoleBinding`s to `cluster-admin` that shouldn't exist, and wildcard verbs/resources (`"*"`) on roles bound to workload service accounts.
4. **Check NetworkPolicy coverage.** Are there namespaces with zero NetworkPolicies, meaning every pod can reach every other pod by default? See [Kubernetes Security](kubernetes-security.md#network-policies-default-deny--allow-list).
5. **Check Pod Security Admission levels per namespace**, and look for individual workloads running privileged, as root, or with dangerous `hostPath` mounts.
6. **Check for cluster-to-cloud exposure.** Does a pod's service account map to an overly broad cloud IAM role (AWS IRSA, GCP Workload Identity)? See [Kubernetes Attack Techniques](kubernetes-attack-techniques.md) and [OWASP Kubernetes Top 10](owasp-kubernetes-top10.md)'s K08 category.

## Real Tools

| Tool | What It Does |
|------|----------------|
| **[kube-hunter](https://github.com/aquasecurity/kube-hunter)** (Aqua Security) | External/internal Kubernetes penetration testing scanner - finds exposed components and known misconfigurations automatically |
| **[kube-bench](https://github.com/aquasecurity/kube-bench)** (Aqua Security) | Checks a cluster against the CIS Kubernetes Benchmark |
| **[Peirates](https://github.com/inguardians/peirates)** | Kubernetes penetration testing framework - automates privilege escalation and lateral movement paths once you have initial pod access |
| **[kubescape](https://github.com/kubescape/kubescape)** (ARMO, CNCF incubating) | Scans against NSA, MITRE ATT&CK, and CIS frameworks in one tool |
| **[kubeaudit](https://github.com/Shopify/kubeaudit)** (Shopify) | Audits clusters for common security misconfigurations (missing security contexts, default service account usage, etc.) |

Run kube-bench and kubescape as a baseline first - they're fast and catch the low-hanging fruit. Use kube-hunter and Peirates for a more adversarial simulation once the basics are covered.

## Practice Labs

| Lab | Focus |
|-----|-------|
| **[Kubernetes Goat](https://madhuakula.com/kubernetes-goat/)** (MadhuAkula) | Vulnerable-by-design Kubernetes cluster - one of the most popular hands-on K8s security labs, with documented vulnerabilities and walkthroughs |
| **[Bust-a-Kube / ControlPlane Simulator](https://github.com/controlplaneio/simulator)** | Attack/defense simulator for practicing both offensive and defensive K8s skills |
| **[KillerCoda Kubernetes playgrounds](https://killercoda.com/playgrounds)** | Free, browser-based K8s environments - no local setup required |
| **[CNCF Capture the Flag (KubeCon archives)](https://github.com/cncf/k8s-ctf)** | Past KubeCon CTF challenges, reusable for self-study |

## Certification Path

- **[CKS - Certified Kubernetes Security Specialist](https://www.cncf.io/training/certification/cks/)** (CNCF/Linux Foundation) - the primary, hands-on Kubernetes security certification. Requires an active [CKA (Certified Kubernetes Administrator)](https://www.cncf.io/training/certification/cka/) as a prerequisite, since CKS assumes you already know how to operate a cluster and focuses purely on securing it.
- **[KCSA - Kubernetes and Cloud Native Security Associate](https://www.cncf.io/training/certification/kcsa/)** - an entry-level companion exam (launched 2024) for those who want a security-focused starting point before attempting CKS.
- **[Killer.sh](https://killer.sh/)** - the well-known CKS exam simulator, widely recommended as the closest practice environment to the real exam's live-cluster format.

## Credits/References

1. [NSA/CISA Kubernetes Hardening Guidance v1.2](https://media.defense.gov/2022/Aug/29/2003066362/-1/-1/0/CTR_KUBERNETES_HARDENING_GUIDANCE_1.2_20220829.PDF)
2. [CIS Kubernetes Benchmark](https://www.cisecurity.org/benchmark/kubernetes)
3. [kube-hunter](https://github.com/aquasecurity/kube-hunter), [kube-bench](https://github.com/aquasecurity/kube-bench), [Peirates](https://github.com/inguardians/peirates), [kubescape](https://github.com/kubescape/kubescape)
4. [Kubernetes Goat](https://madhuakula.com/kubernetes-goat/)
