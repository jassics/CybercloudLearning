# OWASP Kubernetes Top 10

The OWASP Kubernetes Top 10 (2025) is the standard risk taxonomy for Kubernetes cluster security - the same role the [OWASP Top 10](../web-security/owasp-top10.md) plays for web applications. Several of these categories are already covered in depth elsewhere on this site; this page gives every category a home and goes deep on the ones that aren't covered yet.

## The List

| # | Risk | Covered In Depth |
|---|------|--------------------|
| K01 | Insecure Workload Configurations | [Kubernetes Security - Pod Security Standards](kubernetes-security.md#pod-security-standards) |
| K02 | Overly Permissive Authorization Configurations | [Kubernetes Security - RBAC](kubernetes-security.md#rbac-role-based-access-control) |
| K03 | Secrets Management Failures | [Kubernetes Security - Secrets Management](kubernetes-security.md#secrets-management) |
| K04 | Lack Of Cluster Level Policy Enforcement | [Kubernetes Security - Image and Admission Security](kubernetes-security.md#image-and-admission-security) |
| K05 | Missing Network Segmentation Controls | [Kubernetes Security - Network Policies](kubernetes-security.md#network-policies-default-deny--allow-list) |
| K06 | Overly Exposed Kubernetes Components | Deep dive below |
| K07 | Misconfigured And Vulnerable Cluster Components | Deep dive below |
| K08 | Cluster To Cloud Lateral Movement | Deep dive below |
| K09 | Broken Authentication Mechanisms | Deep dive below |
| K10 | Inadequate Logging And Monitoring | Deep dive below |

## K01-K05: Already Covered

These map directly onto hardening guidance [Kubernetes Security](kubernetes-security.md) already treats in depth with real YAML - K01 (insecure Pod specs: privileged containers, root execution, writable root filesystems) is fixed by Pod Security Admission's `restricted` level; K02 (overly broad RBAC, unnecessary `cluster-admin` bindings) is fixed by least-privilege `Role`/`RoleBinding` design; K03 (Secrets stored as plaintext-equivalent base64) is fixed by etcd encryption at rest plus an external secrets manager; K04 (no admission control blocking non-compliant workloads) is fixed by Kyverno/OPA Gatekeeper policy enforcement; K05 (flat pod-to-pod networking) is fixed by default-deny NetworkPolicies. Follow those links for the concrete configuration.

## K06: Overly Exposed Kubernetes Components

Kubernetes exposes several APIs beyond the main API server, and each one is a separate thing that must be independently secured:

- **The kubelet API** (port 10250 by default) - if reachable without authentication, it can be used to list/exec into pods, retrieve logs, and in older/misconfigured setups even run arbitrary commands on the node. This has been a real, repeatedly-found misconfiguration in internet-facing clusters.
- **The Kubernetes Dashboard** - a web UI that, if deployed with the (deprecated, but still sometimes seen) `--enable-skip-login` flag or an overly permissive service account, gives an unauthenticated visitor full cluster control. Several real-world cluster compromises (including cryptomining incidents) trace back to an exposed, unauthenticated Dashboard.
- **etcd's client port** (2379) - if reachable from outside the control plane network, an attacker can read the entire cluster's Secrets directly, bypassing RBAC entirely.

**Mitigation:** never expose the kubelet API, Dashboard, or etcd to the public internet or even the general internal network - restrict them to the control-plane network segment, require authentication on everything (the kubelet API supports authn/authz modes - enable them), and if you don't actively need the Dashboard, don't deploy it.

## K07: Misconfigured And Vulnerable Cluster Components

Beyond application-level misconfigurations, the Kubernetes control-plane and add-on components themselves need patching and hardening like any other software:

- Run [kube-bench](https://github.com/aquasecurity/kube-bench) (a CIS Kubernetes Benchmark scanner) regularly against your cluster - it checks control-plane and node configuration against the published CIS benchmark, not just workload configuration.
- Keep the Kubernetes version itself patched - K8s has had real, exploitable CVEs (e.g. CVE-2018-1002105, a privilege-escalation vulnerability in the API server's proxy request handling that allowed unauthenticated users to escalate to cluster-admin-level access on affected versions).
- Third-party add-ons (ingress controllers, CNI plugins, admission webhooks) run with significant cluster privilege - treat their supply chain (image provenance, version pinning) with the same rigor as your own workloads (see [SCA](../application-security/sca.md)).

## K08: Cluster To Cloud Lateral Movement

This is one of the most consequential real-world attack chains in cloud-hosted Kubernetes, and it's easy to miss in a review that only looks "inside" the cluster.

Most managed Kubernetes services let you attach a **cloud IAM identity directly to a pod** (AWS IRSA - IAM Roles for Service Accounts, GCP Workload Identity, Azure Workload Identity) so the pod can call cloud APIs without embedding long-lived credentials. This is good practice for avoiding static secrets - but if that IAM role is over-scoped, compromising the *pod* (via any of K01/K06/K07 above, or an application vulnerability) hands the attacker that pod's cloud credentials, and from there, whatever the role can reach in the cloud account: other services, storage buckets, or - if the role is broad enough - the ability to create new IAM principals and fully pivot beyond the cluster entirely.

**Mitigation:**

- Scope every pod's cloud IAM role to the absolute minimum it needs - see [IAM Security](../cloud-security/learning-aws-security/iam-security.md) for the same least-privilege discipline applied here.
- Never attach a broad, shared IAM role to every pod in a namespace "for convenience" - one compromised low-value pod inherits the same access as your most privileged workload.
- Treat "which pods have which cloud IAM roles" as a first-class item in your cluster's access-control review, not an afterthought bolted on after the RBAC review is done.

## K09: Broken Authentication Mechanisms

Kubernetes doesn't have a single built-in user database - authentication is pluggable (client certificates, static tokens, OIDC, webhook token authentication). Common failures:

- Long-lived, unrotated service account tokens (the older auto-mounted token style) that, once leaked, remain valid indefinitely.
- Client certificates issued with no expiration/rotation process.
- No integration with centralized identity (OIDC/SSO) for human users, leading to shared or poorly-tracked credentials for `kubectl` access.

**Mitigation:** use the modern, time-bound service account token mechanism (`TokenRequest` API / projected volume tokens, which expire and are audience-bound, instead of the old auto-mounted long-lived tokens); integrate human `kubectl` access with your organization's OIDC/SSO provider rather than distributing static kubeconfig credentials; rotate client certificates on a defined schedule.

## K10: Inadequate Logging And Monitoring

Without cluster-level audit logging, a privileged action (an RBAC change, a Secret read, an `exec` into a production pod) leaves no trace to investigate after the fact - directly undermining incident response.

**What to actually log:**

- **Kubernetes audit logs** - configure an audit policy that captures at minimum: RBAC/RoleBinding changes, Secret reads, `exec`/`attach` into pods, and any request to the kubelet API.
- **Runtime behavior**, not just API-level events - a compromised container might not touch the API server at all. [Falco](https://falco.org/) (CNCF graduated) uses eBPF/syscall monitoring to detect anomalous *runtime* behavior (an unexpected shell spawned inside a container, an unexpected outbound connection, a write to a sensitive file path) that audit logs alone would never surface.
- Ship both audit logs and Falco alerts somewhere durable and queryable outside the cluster itself - if the cluster is compromised, on-cluster-only logs can be tampered with or destroyed by the attacker.

## Credits/References

1. [OWASP Kubernetes Top 10](https://owasp.org/www-project-kubernetes-top-ten/)
2. [CIS Kubernetes Benchmark](https://www.cisecurity.org/benchmark/kubernetes)
3. [NSA/CISA Kubernetes Hardening Guidance v1.2](https://media.defense.gov/2022/Aug/29/2003066362/-1/-1/0/CTR_KUBERNETES_HARDENING_GUIDANCE_1.2_20220829.PDF)
4. [Falco](https://falco.org/)
5. [kube-bench](https://github.com/aquasecurity/kube-bench)

## Continue Learning

- [Kubernetes Architecture & Security](kubernetes-architecture-security.md) - the architecture/trust-boundary lens these risks map onto
- [Kubernetes Security](kubernetes-security.md) - hardening guidance with real YAML for K01-K05
- [Kubernetes Attack Techniques](kubernetes-attack-techniques.md) - how these risks are actually exploited
- [Kubernetes Red Teaming & Labs](kubernetes-red-teaming-labs.md) - practice environments
