# Kubernetes Attack Techniques

This page is the attacker's-eye-view counterpart to [Kubernetes Security](kubernetes-security.md) - that page tells you how to configure defenses; this one walks through how those defenses actually get bypassed in practice, so you know what you're really defending against (and what to log/alert on).

## Container Escape / Breakout

A container escape means an attacker with code execution *inside* a container gains access to the underlying node - at that point they're no longer confined to one workload, they own the host and everything else scheduled on it.

Common vectors:

- **Privileged containers** - `securityContext.privileged: true` effectively disables container isolation. A privileged container can access host devices, load kernel modules, and trivially escape. See [Kubernetes Security's hardened pod spec](kubernetes-security.md#vulnerable-vs-hardened-pod-spec) for why this should never be set on application workloads.
- **Dangerous host mounts** - a `hostPath` volume mounting `/`, `/var/run/docker.sock`, or `/proc` gives a compromised container direct read/write access to the host filesystem or the container runtime's control socket (mounting the Docker socket into a container is functionally equivalent to giving it root on the node).
- **Container runtime CVEs** - the container isolation boundary itself is enforced by code that occasionally has bugs. **CVE-2019-5736** is the canonical example: a flaw in `runc` (the low-level runtime used by Docker, containerd, and CRI-O) let a malicious container overwrite the host's `runc` binary via `/proc/self/exe` file-descriptor mishandling, achieving host root the next time `runc` was invoked - no privileged mode or unusual configuration required, just a malicious or compromised container image being run. This is why keeping the container runtime itself patched matters as much as hardening pod specs.

**Mitigation**: never run privileged containers or mount the container socket into a workload; keep the container runtime (runc/containerd/CRI-O) patched; use `readOnlyRootFilesystem` and dropped capabilities (see [Kubernetes Security](kubernetes-security.md)) to shrink what an attacker can do even before an escape; consider gVisor or Kata Containers for genuinely untrusted multi-tenant workloads where kernel-sharing itself is the risk.

## Privilege Escalation Within a Cluster

An attacker who compromises a low-privilege pod or steals a service account token doesn't stop there - they enumerate what that identity can actually do and look for an escalation path.

```bash
# The exact reconnaissance command an attacker (or an auditor) runs first
kubectl auth can-i --list --as=system:serviceaccount:payments:default
```

If that service account can `create` pods, patch `deployments`, or read `secrets` in a namespace it shouldn't need to touch, that's a path to broader compromise - a service account that can create pods can typically create a privileged pod, which is a path back to container escape above.

**Real historical example: CVE-2018-1002105**, described at the time as the most severe Kubernetes vulnerability found to date. It stemmed from incorrect handling of error responses to proxied upgrade requests in `kube-apiserver`: a specially crafted request let an attacker establish a connection through the API server to a backend (like the Kubelet API) and then send arbitrary follow-on requests directly to that backend - authenticated with the *API server's own* TLS credentials rather than the attacker's. In the default configuration this allowed **any authenticated user**, and in some configurations **unauthenticated users**, to escalate to full cluster-admin-equivalent access against any backend. It scored CVSS 3.0 9.8 (Critical) and affected all Kubernetes versions prior to v1.10.11, v1.11.5, and v1.12.3.

**Mitigation**: keep the control plane patched (this class of bug lives in the API server itself, no amount of RBAC hardening would have stopped it); apply least-privilege RBAC so even a fully-compromised service account has a small blast radius; routinely audit `ClusterRoleBinding`s and service account permissions with the same `kubectl auth can-i --list` command shown above.

## Cluster-to-Cloud Lateral Movement

This is one of the most consequential real-world attack chains in cloud-hosted Kubernetes, and maps directly to the OWASP Kubernetes Top 10's K08 (Cluster to Cloud Lateral Movement) - see [OWASP Kubernetes Top 10](owasp-kubernetes-top10.md) for the full category breakdown.

The pattern: a pod is granted a cloud IAM identity (AWS IAM Roles for Service Accounts/IRSA, GCP Workload Identity, Azure AD Workload Identity) so it can call cloud APIs - S3, Secrets Manager, whatever the workload needs. If that pod is compromised and the attached role is broader than the workload actually requires, the attacker's foothold in "one pod" becomes a foothold in "the cloud account." From inside a compromised pod, an attacker can also probe the cloud metadata service directly:

```bash
# The classic cloud-metadata-via-compromised-workload pattern (illustrative - endpoint varies by provider)
curl http://169.254.169.254/latest/meta-data/iam/security-credentials/
```

If the pod's network namespace has a route to the node's metadata endpoint and nothing blocks it, this can hand an attacker the node's own cloud credentials, not just the pod's - often a much bigger blast radius. See the [Tesla Kubernetes Dashboard incident](kubernetes-real-world-incidents.md) for exactly this pattern playing out in production.

**Mitigation**: scope every cloud IAM role attached to a workload to the minimum it needs (never reuse one broad role across every pod in a namespace); block pod-to-instance-metadata-service traffic with a NetworkPolicy or a metadata-service hop-limit/firewall where the cloud provider supports it; treat "which pods can reach cloud credentials" as its own explicit inventory during a security review.

## Secrets Exfiltration

An attacker with `exec` access into a pod, or code execution inside one, can read anything mounted into that pod - including Secret volumes and environment variables. This is exactly why [Kubernetes Security's Secrets Management section](kubernetes-security.md#secrets-management) stresses that base64-encoded Secrets aren't sufficient alone: base64 is trivially reversible, and *access* to the Secret object (via `exec`, a mounted volume, or direct API read) is the actual control boundary, not the encoding.

```bash
# What an attacker with exec access does immediately
kubectl exec -it compromised-pod -- env | grep -i -E 'key|token|secret|password'
kubectl exec -it compromised-pod -- cat /var/run/secrets/kubernetes.io/serviceaccount/token
```

**Mitigation**: encrypt Secrets at rest in etcd, restrict `exec` permissions via RBAC to only who genuinely needs debug access, use an external secrets manager for high-sensitivity values, and avoid injecting secrets as environment variables where a mounted file (which doesn't leak via `env` dumps or process listing) is an option.

## Supply Chain Compromise via Malicious or Vulnerable Images

Pulling an untrusted image from a public registry can hand an attacker a foothold before your application even starts - a backdoored base image, a compromised build step, or simply an image with known-exploitable CVEs baked in. This is the same "verify your artifact source before you run it" principle covered for AI model files in [AI Supply Chain Security](../../ai-security/ai-supply-chain-security.md) and for application dependencies in [SCA](../application-security/sca.md) - it applies just as directly to container images.

**Mitigation**: scan every image in CI before it ships (Trivy/Grype), restrict which registries the cluster will pull from via an admission policy, pin images by digest rather than a mutable tag, and prefer minimal/distroless base images to shrink what could be hiding in the image in the first place (see [Docker Security](docker-security.md)).

## Defender's Checklist: What to Actually Log and Alert On

- [ ] `kubectl exec` and `kubectl attach` events - especially into production namespaces, especially outside change windows
- [ ] Anomalous `kubectl auth can-i` / self-subject-access-review patterns (mass enumeration is reconnaissance, not routine use)
- [ ] Any pod created with `privileged: true`, `hostNetwork: true`, or a sensitive `hostPath` mount - this should be rare enough that every instance is worth reviewing
- [ ] Outbound connections from pods to `169.254.169.254` (the cloud metadata service) from workloads that have no legitimate reason to reach it
- [ ] RBAC changes, especially new `ClusterRoleBinding`s to `cluster-admin` or wildcard permissions
- [ ] Runtime behavioral anomalies (unexpected process execution, unexpected network connections) via a tool like **Falco**, which watches syscalls/eBPF events specifically for this kind of post-compromise activity

## Credits/References

1. [MITRE ATT&CK for Containers](https://attack.mitre.org/matrices/enterprise/containers/) - the official MITRE matrix mapping real container/Kubernetes attacker techniques
2. [CVE-2018-1002105 - NVD](https://nvd.nist.gov/vuln/detail/CVE-2018-1002105)
3. [CVE-2019-5736 - runc container escape, AWS writeup](https://aws.amazon.com/blogs/compute/anatomy-of-cve-2019-5736-a-runc-container-escape/)
4. [HackTricks - Kubernetes Pentesting](https://cloud.hacktricks.xyz/pentesting-cloud/kubernetes-security)
5. [Falco - Cloud Native Runtime Security](https://falco.org/)
