# Kubernetes Security Study Plan

This page is updated based on [jassics/security-study-plan/kubernetes-security-study-plan](https://github.com/jassics/security-study-plan/blob/main/kubernetes-security-study-plan.md)

This study plan is based on milestones. Check how much you can cover within the timeline - the more topics you cover, the better a candidate you are for roles requiring solid Kubernetes/orchestration security knowledge. Also, I assume you have already checked and are comfortable with the [Common Security Skills study plan](../common-skills-study-plan.md).

Kubernetes Security builds on Docker/container security and cloud security. You need to understand how Kubernetes works, how workloads are deployed and exposed, and what controls exist at cluster, namespace, and workload levels.

It leans more toward:

- Securing clusters and control-plane access
- Defining secure defaults for workloads (namespaces, RBAC, network policies)
- Integrating Kubernetes security checks into DevSecOps pipelines
- Working with platform/SRE teams to keep clusters hardened

It usually takes 6-10 weeks to be comfortable with Kubernetes Security fundamentals, assuming you already know basic Docker and some Kubernetes usage.

## In Short

1. Kubernetes Security is not just enabling a few network policies.
2. Think multi-layer defense: cluster, namespace, workload, network, and supply chain.
3. You should be comfortable with basic Kubernetes concepts (pods, deployments, services, ingress, configmaps, secrets).
4. You should understand how containers/images are built and scanned - see the [Docker Security Study Plan](docker-security-study-plan.md).
5. You should know how Kubernetes fits into DevSecOps and cloud-native security.

## ToC
1. [Kubernetes Fundamentals for Security](#kubernetes-fundamentals-for-security) - 1-2 weeks
2. [Cluster Hardening](#cluster-hardening) - 1-2 weeks
3. [Workload Security](#workload-security) - 1-2 weeks
4. [Network Policies and Multi-Tenancy](#network-policies-and-multi-tenancy) - 1-2 weeks
5. [Supply Chain and Runtime Security](#supply-chain-and-runtime-security) - 1-2 weeks
6. [Resources](#resources)
7. [Interview Questions](#interview-questions)

## Kubernetes Fundamentals for Security
**Duration: 1-2 weeks**

Be comfortable with how Kubernetes works before securing it. See this site's own [Kubernetes](../../product-security/container-security/kubernetes.md) guide alongside this section.

### Week 1-2: Core Concepts
1. **Architecture:** Control Plane (API Server, etcd, Scheduler, Controller Manager) vs Worker Nodes (Kubelet, kube-proxy, container runtime)
2. **Objects:** Pods, Deployments, Services, ConfigMaps, Secrets, Namespaces
3. **Networking:** CNI basics, pod-to-pod communication, service discovery
4. Map where security decisions are made: who can talk to the API server (authN/RBAC), which nodes run which workloads, how traffic flows in/out of the cluster
5. **Practice:** set up a cluster with `kind` or `minikube` and deploy a simple app

## Cluster Hardening
**Duration: 1-2 weeks**

Securing the infrastructure itself.

### Week 3-4: Hardening the Cluster
1. **CIS Benchmarks:** understand and apply the CIS Kubernetes Benchmark
2. **API Server Security:** disable anonymous access, enable audit logging, restrict access to etcd
3. **RBAC:** Roles vs ClusterRoles, Bindings, principle of least privilege
4. **Node Security:** OS hardening, kubelet security configuration

## Workload Security
**Duration: 1-2 weeks**

Securing what runs *inside* the cluster.

### Week 5-6: Securing Pods & Deployments
1. **Pod Security Standards (PSS):** Privileged, Baseline, Restricted profiles
2. **Security Context:** `runAsUser`, `runAsGroup`, `readOnlyRootFilesystem`, `allowPrivilegeEscalation: false`
3. **Secrets management:** Kubernetes Secrets (encryption at rest), external secret stores (Vault, AWS Secrets Manager)

## Network Policies and Multi-Tenancy
**Duration: 1-2 weeks**

Kubernetes networking is a big part of securing workloads.

1. Basic network model: pod-to-pod and pod-to-service communication, ingress controllers and load balancers
2. Network Policies: deny-by-default vs allow-by-default; writing simple network policies to restrict traffic
3. Multi-tenancy: combining namespaces, network policies, and RBAC for isolation; multi-tenant cluster vs dedicated clusters

## Supply Chain and Runtime Security
**Duration: 1-2 weeks**

Connects Kubernetes Security with Docker Security and DevSecOps.

### Week 7-8: Advanced Topics
1. **Admission controllers:** validating and mutating webhooks; policy engines (OPA Gatekeeper, Kyverno)
2. **Supply chain:** image registries and allowed registries, image scanning before deployment, image signing (Cosign)
3. **Runtime security:** detecting anomalies (Falco), sandboxed containers (gVisor, Kata Containers) if needed
4. Cross-link to other plans: [Docker Security Study Plan](docker-security-study-plan.md), [DevSecOps Study Plan](devsecops-study-plan.md), relevant cloud security study plans if running managed Kubernetes (EKS/AKS/GKE)

## Resources

**Certifications:** Kubernetes-related certifications that cover security (CKA/CKS and similar), or cloud security/cloud-native certifications where Kubernetes is a major component.

## Interview Questions
Reuse questions from Docker Security, DevSecOps, and cloud security, but focus on Kubernetes specifics:

1. How would you secure access to a Kubernetes cluster for multiple teams?
2. How would you restrict which services/pods can talk to each other?
3. What are the risks of running privileged containers, and how do you prevent it?
4. How would you ensure only trusted images are deployed in a cluster?

**Practice next:** this site's [Kubernetes Security](../../product-security/container-security/kubernetes-security.md) guide, and [jassics/security-study-plan](https://github.com/jassics/security-study-plan) for the latest updates to this plan.
