# Kubernetes

Before this page, make sure you're comfortable with [Containers Overview](container-overview.md) and [Introduction to Docker](docker-introduction.md) - Kubernetes assumes you already understand what a container and an image are. This page covers what Kubernetes actually is and how it works; [Kubernetes Security](kubernetes-security.md) covers how to secure it.

## What is Kubernetes?

Kubernetes (often shortened to "K8s") is an open-source container orchestration platform, originally built at Google and now maintained by the Cloud Native Computing Foundation (CNCF). Where Docker runs a single container, Kubernetes runs and manages potentially thousands of containers across a fleet of machines - scheduling them, restarting them when they crash, scaling them up and down, and routing traffic to them.

If Docker answers "how do I package and run one container," Kubernetes answers "how do I run this reliably across 200 machines, self-heal when something fails, and roll out updates without downtime."

## Core Concepts

### Pods

The smallest deployable unit in Kubernetes - not a container, but a **pod**, which wraps one or more tightly-coupled containers that share networking and storage. Most pods run a single container; multi-container pods are used for sidecar patterns (e.g. a logging agent alongside your app).

### Deployments

A Deployment describes the desired state for a set of pods - which image, how many replicas, how to roll out updates. Kubernetes continuously reconciles actual state toward desired state: if a pod dies, the Deployment's controller creates a replacement automatically.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: web-app
  template:
    metadata:
      labels:
        app: web-app
    spec:
      containers:
        - name: web-app
          image: myregistry/web-app:1.4.2
          ports:
            - containerPort: 8080
```

### Services

Pods are ephemeral - they get recreated with new IP addresses constantly. A **Service** gives a stable network identity (a DNS name and virtual IP) that routes to whichever pods currently match its label selector, regardless of how many times they've been rescheduled.

### Namespaces

A way to partition a single cluster into multiple virtual clusters - useful for separating teams, environments (dev/staging/prod), or applications, and for scoping RBAC and network policies (see [Kubernetes Security](kubernetes-security.md)).

### Control Plane vs. Worker Nodes

| Component | Role |
|-----------|------|
| **API Server** | The front door - every `kubectl` command and internal component talks to the cluster through it |
| **etcd** | The cluster's database - stores all state (what should be running, current config, secrets) |
| **Scheduler** | Decides which node a new pod should run on |
| **Controller Manager** | Runs the reconciliation loops (Deployments, ReplicaSets, etc.) that keep actual state matching desired state |
| **kubelet** (worker nodes) | The agent on each node that actually starts/stops containers per the scheduler's instructions |
| **kube-proxy** (worker nodes) | Handles the networking rules that make Services work |

## A Minimal Workflow

```bash
# Apply a deployment + service definition
kubectl apply -f web-app-deployment.yaml
kubectl apply -f web-app-service.yaml

# Check what's running
kubectl get pods
kubectl get deployments
kubectl get services

# Scale it
kubectl scale deployment web-app --replicas=5

# Roll out a new image version with zero downtime
kubectl set image deployment/web-app web-app=myregistry/web-app:1.5.0

# Roll back if something's wrong
kubectl rollout undo deployment/web-app
```

## Why Teams Adopt Kubernetes

- **Self-healing** - crashed pods are automatically restarted, unresponsive nodes have their pods rescheduled elsewhere
- **Declarative rollouts and rollbacks** - describe the desired state in YAML, let Kubernetes reconcile toward it, and roll back with one command if a deploy goes wrong
- **Horizontal scaling** - scale pod replicas manually or automatically (Horizontal Pod Autoscaler) based on CPU/memory/custom metrics
- **Service discovery and load balancing** - built in, without needing an external tool
- **Portability** - the same manifests run on any conformant Kubernetes cluster (EKS, GKE, AKS, on-prem)

## What Kubernetes Does *Not* Give You For Free

Kubernetes' flexibility is also why it has a large attack surface if left at defaults: RBAC is permissive until you configure it, network traffic between pods is allowed by default until you write NetworkPolicies, and Secrets are only base64-encoded, not encrypted, unless you configure encryption at rest. That's the entire subject of [Kubernetes Security](kubernetes-security.md).

## Credits/References

1. [Kubernetes Official Documentation](https://kubernetes.io/docs/home/)
2. [Kubernetes Concepts](https://kubernetes.io/docs/concepts/)
3. [CNCF: Cloud Native Computing Foundation](https://www.cncf.io/)
