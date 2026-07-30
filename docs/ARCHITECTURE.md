# Project Architecture

```
Developer
    │
    ▼
Git Commit
    │
    ▼
GitHub Repository
    │
    ▼
ArgoCD Root Application
    │
    ├──────────────┬──────────────┬──────────────┐
    ▼              ▼              ▼              ▼
 Grafana         Loki         Promtail      Bootstrap
    │
    ▼
Helm Chart
    │
    ▼
Kubernetes Deployment
    │
    ▼
Grafana Service
    │
    ▼
PostSync Job
    │
    ▼
Grafana REST API
    │
    ▼
Teams
Users
Folders
Permissions
```

---

# Deployment Sequence

```
Git Push

↓

ArgoCD Detects Changes

↓

Sync Application

↓

Helm Installs Resources

↓

Pods Become Healthy

↓

PostSync Hook Executes

↓

Bootstrap Job Starts

↓

Grafana Configured

↓

Job Deleted
```

---

# Kubernetes Resources

| Resource | Purpose |
|----------|---------|
| Namespace | Resource Isolation |
| Deployment | Grafana |
| StatefulSet | Loki |
| DaemonSet | Promtail |
| Service | Network Access |
| Secret | Credentials |
| ConfigMap | Bootstrap Scripts |
| Job | One-time Automation |

---

# GitOps Workflow

```
Git Repository

↓

Desired State

↓

ArgoCD

↓

Compare Live State

↓

Detect Drift

↓

Reconcile

↓

Cluster Updated
```