# Container Security Interview Questions

The [security-interview-questions](https://github.com/jassics/security-interview-questions) repo's Container Security file is still empty upstream, so these questions are grounded directly in this site's [Docker Security](../product-security/container-security/docker-security.md) and [Kubernetes Security](../product-security/container-security/kubernetes-security.md) guides instead. Expect them to get merged back once the source repo catches up.

## Image Hardening & Scanning

??? question "Q: Is a container a security boundary? What does that mean for how you think about container security?"
    No - a container is a *process isolation* mechanism, not a security boundary. Containers share the host kernel, so a container escape or kernel exploit can compromise the host and every other container running on it. That reframes the whole problem: container security isn't "make the container secure," it's "close the gaps between runs and runs safely" at every layer - the base image, the Dockerfile, the registry, the runtime flags, and the host itself.

??? question "Q: Walk through hardening a Dockerfile that currently runs a Python app as root on the `python:3.12` base image."
    Three changes matter most: (1) switch to a minimal/distroless-style base like `python:3.12-slim` to shrink the attack surface, (2) create and switch to a non-root user with `USER appuser` so a compromised process can't do much to the host or other containers sharing the kernel, and (3) if there's a build step, use a multi-stage build so compilers/dev dependencies never ship in the final image at all - only the compiled/runtime artifact does. Also: pin the base image to a digest or specific version instead of `:latest`, so builds are reproducible and you're not silently pulling a newer, unvetted image.

??? question "Q: Where do secrets baked into a Dockerfile actually end up, and why is `docker history` a problem?"
    An `ARG`/`ENV` value like `API_KEY=sk-abc123` gets written into that layer's history permanently - even if a later layer "overwrites" the environment variable, the original value is still extractable from the image's layer history via `docker history` or by anyone who pulls the image. The fix is to never bake secrets into the image at build time at all; inject them at runtime instead (container orchestrator secrets, environment variables set at container start, or a secrets manager).

??? question "Q: What would you check for in an image scanning pipeline, and where should the gate live?"
    Scan every image - built or pulled - for known CVEs before it runs (Trivy or Grype are the common open-source choices), and gate the CI/CD pipeline on critical/high findings so a vulnerable image can't reach production. It's not a one-time check either: rescan deployed images periodically, since new CVEs get published against base images you haven't rebuilt in weeks. For Kubernetes specifically, pair this with an admission controller (Kyverno, OPA Gatekeeper) that *blocks* unscanned or non-compliant images from being scheduled - catching it in CI is necessary but not sufficient if someone can still `kubectl apply` an unscanned image directly.

## Kubernetes RBAC & Network Policy

??? question "Q: Explain Kubernetes RBAC - Role vs. ClusterRole, and RoleBinding vs. ClusterRoleBinding."
    RBAC controls who (users/groups/service accounts) can do what (verbs like get/list/create/delete) to which resources. A **Role** grants permissions scoped to a single namespace; a **ClusterRole** grants permissions cluster-wide (or reusable across namespaces). A **RoleBinding** attaches a Role (or ClusterRole) to a subject within one namespace; a **ClusterRoleBinding** attaches a ClusterRole to a subject cluster-wide.

    The most common real-world mistake: binding `cluster-admin` to a service account "just to make it work" and never revisiting it - a compromised pod using that service account now has full cluster control. Audit for this directly: `kubectl get clusterrolebindings -o json | jq '.items[] | select(.roleRef.name=="cluster-admin")'`.

??? question "Q: By default, can any pod in a cluster talk to any other pod? How do you lock that down?"
    Yes - by default every pod can reach every other pod (and often the internet) on the cluster. The standard hardening pattern is default-deny plus explicit allow rules: apply a NetworkPolicy that denies all ingress/egress in a namespace, then add specific NetworkPolicies allowing only the traffic that's actually needed (e.g. "frontend pods can reach the payments-api pods on port 8080"). One catch worth flagging in an interview: NetworkPolicies only work if the cluster's CNI plugin enforces them (Calico, Cilium, etc.) - some default networking setups silently ignore NetworkPolicy objects entirely, which is an easy thing to miss in an audit.

??? question "Q: What's the difference between the `restricted` and `baseline` Pod Security Standards, and which would you pick for a typical application namespace?"
    Pod Security Admission enforces one of three levels per namespace: `privileged` (no restrictions), `baseline` (blocks the most obviously dangerous settings like privileged containers and most host namespace access, but is otherwise permissive), and `restricted` (the heavily hardened tier - blocks privileged containers and host namespaces, and requires running as non-root with dropped capabilities). For a typical application workload, `restricted` should be the default; `baseline` is a reasonable fallback only when a workload genuinely can't meet `restricted`'s requirements yet, and that should be treated as a tracked exception, not a permanent state.

## Secrets & Cluster Hardening

??? question "Q: Are Kubernetes Secrets actually secret? What's missing by default?"
    No - `Secret` objects are base64-encoded, not encrypted, by default. Base64 is an encoding, not encryption, so anyone with API read access to a namespace's secrets can trivially decode them. Two things fix this: enabling encryption at rest for etcd (via an `EncryptionConfiguration` with a KMS provider, since etcd is where Secrets actually live on disk), and for genuinely sensitive/regulated data, using an external secrets manager (Vault, cloud KMS via the External Secrets Operator) rather than relying on native Secrets alone.

??? question "Q: What are the highest-value API server and etcd hardening steps, and why does etcd matter so much?"
    etcd holds the entire cluster's state, including all Secrets - if etcd is compromised or its network access isn't restricted, the whole cluster's secrets are exposed regardless of any RBAC policy. Priorities: disable anonymous access to the API server, restrict etcd network access to control-plane nodes only, encrypt etcd traffic (TLS) and data at rest, enable API server audit logging so privileged actions (RBAC changes, secret reads) are traceable, and never expose the Kubernetes Dashboard publicly without authentication - several real-world breaches started exactly there.

## Practice Next

- [Docker Security](../product-security/container-security/docker-security.md)
- [Kubernetes Security](../product-security/container-security/kubernetes-security.md)
- [Kubernetes Security Study Plan](../study-plan/cybersecurity/kubernetes-security-study-plan.md)
- [Docker Security Study Plan](../study-plan/cybersecurity/docker-security-study-plan.md)
- [security-interview-questions](https://github.com/jassics/security-interview-questions) on GitHub for the canonical, evolving question set
