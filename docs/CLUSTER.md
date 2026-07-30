# Kubernetes Cluster

## Overview

This project runs entirely on a local Kubernetes cluster created using **Kind (Kubernetes in Docker)**.

The Kind cluster hosts the complete observability platform, including:

- ArgoCD
- Grafana
- Loki
- Promtail
- NGINX Ingress Controller

No cloud provider is required.

---

# Cluster Information

| Item | Value |
|------|-------|
| Kubernetes Distribution | Kind |
| Cluster Name | observability |
| Control Plane Nodes | 1 |
| Worker Nodes | 0 |
| Container Runtime | Docker |

---

# Cluster Architecture

```
Docker
   │
   ▼
Kind Control Plane Container
   │
   ▼
Kubernetes API Server
   │
   ▼
Namespaces
├── argocd
└── observability
```

---

# Namespaces

## argocd

Contains:

- ArgoCD Server
- Repo Server
- Application Controller
- Redis
- Dex
- Notifications

---

## observability

Contains:

- Grafana
- Loki
- Promtail
- Bootstrap Job

---

# Verify Cluster

```bash
kind get clusters
```

```bash
kubectl cluster-info
```

```bash
kubectl get nodes
```

---

# Check Namespaces

```bash
kubectl get ns
```

---

# View Running Pods

```bash
kubectl get pods -A
```

---

# View Services

```bash
kubectl get svc -A
```

---

# Docker Containers

Kind runs Kubernetes nodes as Docker containers.

List running containers:

```bash
docker ps
```

List downloaded images:

```bash
docker images
```

---

# Delete Cluster

```bash
kind delete cluster --name observability
```

---

# Recreate Cluster

```bash
kind create cluster \
--name observability \
--config kind/kind-config.yaml
```