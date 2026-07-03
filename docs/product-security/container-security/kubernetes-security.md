# Kubernetes Security

This builds directly on [Kubernetes](kubernetes.md) - if pods, Deployments, and the control plane aren't familiar yet, start there first.

## Why Kubernetes Needs Deliberate Hardening

Kubernetes ships flexible, not secure, by default: any pod can talk to any other pod on the same cluster unless you say otherwise, Secrets are base64-encoded (not encrypted) unless you turn on encryption at rest, and RBAC exists but grants nothing meaningful until you write policies. Real-world Kubernetes incidents overwhelmingly come from misconfiguration, not zero-days - an exposed dashboard, an overly permissive `ClusterRoleBinding`, or a pod running as root with a hostPath mount.

## RBAC (Role-Based Access Control)

RBAC governs who (users, groups, service accounts) can do what (verbs: get/list/create/delete) to which resources (pods, secrets, deployments), scoped to a namespace (`Role`) or cluster-wide (`ClusterRole`).

```yaml
# A Role scoped to one namespace - can only read pods, nothing else
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  namespace: payments
  name: pod-reader
rules:
  - apiGroups: [""]
    resources: ["pods"]
    verbs: ["get", "list", "watch"]
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: read-pods
  namespace: payments
subjects:
  - kind: ServiceAccount
    name: monitoring-agent
    namespace: payments
roleRef:
  kind: Role
  name: pod-reader
  apiGroup: rbac.authorization.k8s.io
```

**Common mistake:** binding `cluster-admin` to a service account "just to make it work," then never revisiting it. Audit `ClusterRoleBinding`s regularly:

```bash
kubectl get clusterrolebindings -o json | jq '.items[] | select(.roleRef.name=="cluster-admin")'
```

## Network Policies: Default-Deny + Allow-List

By default, every pod can reach every other pod on the cluster, and often the internet too. A default-deny policy plus explicit allow rules is the standard hardening pattern:

```yaml
# Deny all ingress and egress by default in this namespace
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: default-deny-all
  namespace: payments
spec:
  podSelector: {}
  policyTypes:
    - Ingress
    - Egress
---
# Then explicitly allow what's needed - e.g. frontend can reach the API on port 8080
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-frontend-to-api
  namespace: payments
spec:
  podSelector:
    matchLabels:
      app: payments-api
  ingress:
    - from:
        - podSelector:
            matchLabels:
              app: frontend
      ports:
        - protocol: TCP
          port: 8080
```

Note: NetworkPolicies require a CNI plugin that enforces them (Calico, Cilium, etc.) - some default cluster networking setups silently ignore them.

## Pod Security Standards

Kubernetes replaced the deprecated PodSecurityPolicy with **Pod Security Admission**, enforcing one of three levels (`privileged`, `baseline`, `restricted`) per namespace via a label:

```yaml
apiVersion: v1
kind: Namespace
metadata:
  name: payments
  labels:
    pod-security.kubernetes.io/enforce: restricted
```

`restricted` blocks privileged containers, host namespaces, and requires running as non-root - it's the right default for most application workloads.

### Vulnerable vs. Hardened Pod Spec

```yaml
# Vulnerable: runs as root, privileged, host network, writable root fs
spec:
  hostNetwork: true
  containers:
    - name: app
      image: myapp:latest
      securityContext:
        privileged: true
```

```yaml
# Hardened
spec:
  containers:
    - name: app
      image: myapp:1.4.2   # pinned, not :latest
      securityContext:
        runAsNonRoot: true
        runAsUser: 10000
        readOnlyRootFilesystem: true
        allowPrivilegeEscalation: false
        capabilities:
          drop: ["ALL"]
```

## Secrets Management

Kubernetes `Secret` objects are base64-encoded, not encrypted, by default - anyone with API read access to a namespace's secrets can trivially decode them. Two things to get right:

1. **Enable encryption at rest** for etcd (`EncryptionConfiguration` with a KMS provider) so secrets aren't stored in plaintext-equivalent form on disk.
2. **Consider an external secrets manager** (HashiCorp Vault, AWS Secrets Manager via [External Secrets Operator](https://external-secrets.io/), or cloud-native KMS integration) for anything sensitive in production - native Secrets are fine for low-sensitivity config, but raw K8s Secrets alone aren't a complete answer for regulated data.

## Image and Admission Security

- **Scan images before they run** - integrate [SCA](../application-security/sca.md)-style scanning (Trivy, Grype) into CI, and use an admission controller (e.g. Kyverno, OPA Gatekeeper) to *block* unscanned or non-compliant images from being scheduled at all, not just flag them after the fact.
- **Restrict image sources** - an admission policy that only allows images from your trusted registry prevents a compromised or malicious public image from ever running.

## API Server and etcd Hardening

- Disable anonymous access to the API server.
- Restrict the Kubernetes Dashboard (if used at all) - never expose it publicly without authentication; several real-world breaches started with an internet-facing, unauthenticated dashboard.
- Encrypt etcd traffic (TLS) and at-rest data, and restrict network access to etcd to control-plane nodes only - etcd holds the entire cluster's state, including Secrets.
- Enable audit logging on the API server so privileged actions (RBAC changes, secret access) are traceable.

## Kubernetes Hardening Checklist

- [ ] RBAC follows least privilege - no unnecessary `cluster-admin` bindings
- [ ] Default-deny NetworkPolicy per namespace, with explicit allow rules
- [ ] Pod Security Admission set to `restricted` (or `baseline` minimum) per namespace
- [ ] Containers run as non-root, with `allowPrivilegeEscalation: false` and dropped capabilities
- [ ] Images pinned to a digest/version, scanned in CI, and admission-controlled at the cluster
- [ ] Secrets encrypted at rest in etcd; sensitive secrets in an external secrets manager
- [ ] API server has anonymous access disabled and audit logging enabled
- [ ] Dashboard (if deployed) is not exposed without authentication
- [ ] etcd access restricted to control-plane nodes, encrypted in transit and at rest

## Credits/References

1. [Kubernetes Security Documentation](https://kubernetes.io/docs/concepts/security/)
2. [CIS Kubernetes Benchmark](https://www.cisecurity.org/benchmark/kubernetes)
3. [OWASP Kubernetes Security Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/Kubernetes_Security_Cheat_Sheet.html)
4. [Pod Security Standards](https://kubernetes.io/docs/concepts/security/pod-security-standards/)
5. [NSA/CISA Kubernetes Hardening Guide](https://media.defense.gov/2022/Aug/29/2003066362/-1/-1/0/CTR_KUBERNETES_HARDENING_GUIDANCE_1.2_20220829.PDF)
