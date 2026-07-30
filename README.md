# ArgoCD GitOps Observability Stack

A complete GitOps-based Observability Platform running on Kubernetes using:

- ArgoCD
- Grafana
- Loki
- Promtail
- Helm Charts
- Kubernetes Jobs
- Kustomize
- KIND (Local Kubernetes)

This repository demonstrates how to deploy an entire observability stack using GitOps principles where every Kubernetes resource is managed from Git.

---

# Architecture

```
                     GitHub Repository
                             │
                             │
                  Watches Repository Changes
                             │
                             ▼
                        ArgoCD Root App
                             │
        ┌────────────────────┼────────────────────┐
        │                    │                    │
        ▼                    ▼                    ▼
   Grafana App          Loki App            Promtail App
        │
        ▼
 Helm Chart Deployment
        │
        ▼
 Kubernetes Resources
        │
        ▼
 Grafana Bootstrap Job
        │
        ▼
 Grafana HTTP API
        │
        ▼
Teams • Users • Folders • Permissions
```

---

# Technologies Used

| Technology | Purpose |
|------------|---------|
| Docker | Container Runtime |
| KIND | Local Kubernetes Cluster |
| Kubernetes | Container Orchestration |
| ArgoCD | GitOps Controller |
| Helm | Package Manager for Kubernetes |
| Kustomize | Generate ConfigMaps from scripts |
| Grafana | Dashboard Platform |
| Loki | Log Storage |
| Promtail | Log Collector |
| curl | REST API Calls |
| jq | JSON Processing |

---

# Repository Structure

```
.
├── argocd
│   ├── apps
│   │   ├── grafana.yaml
│   │   ├── grafana-bootstrap.yaml
│   │   ├── loki.yaml
│   │   └── promtail.yaml
│   │
│   └── root-app.yaml
│
├── grafana
│   └── bootstrap
│       ├── bootstrap.sh
│       ├── job.yaml
│       ├── kustomization.yaml
│       ├── secret.yaml
│       └── scripts
│           ├── teams.sh
│           ├── users.sh
│           ├── team-members.sh
│           ├── folders.sh
│           └── permissions.sh
│
├── helm
│   ├── grafana
│   │   └── values.yaml
│   ├── loki
│   │   └── values.yaml
│   └── promtail
│       └── values.yaml
│
├── ingress
│   └── argocd-ingress.yaml
│
├── kind
│   └── kind-config.yaml
│
├── namespaces
│   ├── argocd.yaml
│   └── observability.yaml
│
├── docs
│   └── CLUSTER.md
│
└── README.md
```

---

# Folder Explanation

## argocd/

Contains all ArgoCD Applications.

```
root-app.yaml
```

Root Application (App of Apps).

It deploys all other applications.

```
apps/
```

Contains child applications.

- Grafana
- Loki
- Promtail
- Grafana Bootstrap

---

## helm/

Contains Helm values only.

These customize upstream Helm Charts.

```
helm/
    grafana/
        values.yaml
```

Overrides Grafana defaults.

Example:

- admin password
- persistence
- datasources
- service

Same for Loki and Promtail.

---

## grafana/bootstrap/

Contains everything required to configure Grafana automatically.

Instead of manually configuring Grafana from UI, Kubernetes runs a Job.

---

### bootstrap.sh

Main script.

Execution order

```
bootstrap.sh

├── teams.sh
├── users.sh
├── team-members.sh
├── folders.sh
└── permissions.sh
```

---

### scripts/

Contains all Grafana API scripts.

Each file performs one responsibility.

| Script | Purpose |
|---------|----------|
| teams.sh | Create Teams |
| users.sh | Create Users |
| team-members.sh | Assign Users |
| folders.sh | Create Folders |
| permissions.sh | Apply Folder Permissions |

---

### job.yaml

Creates Kubernetes Job.

The Job

- waits for Grafana
- installs curl & jq
- runs bootstrap.sh

This Job executes after Grafana deployment using ArgoCD Hooks.

---

### secret.yaml

Stores

```
GRAFANA_ADMIN_USER

GRAFANA_ADMIN_PASSWORD
```

Injected as Environment Variables.

---

### kustomization.yaml

Generates ConfigMap automatically.

Instead of copying shell scripts into YAML manually,

Kustomize packages

```
bootstrap.sh

scripts/*
```

into a ConfigMap.

This removes duplicate code.

---

# namespaces/

Creates

```
argocd

observability
```

Namespaces.

---

# ingress/

Ingress configuration for ArgoCD.

Allows browser access.

Example

```
https://argocd.local
```

---

# kind/

Contains KIND cluster configuration.

Defines

- Cluster
- Node mapping
- Port mapping

---

# docs/

Additional documentation.

---

# Deployment Flow

```
Git Push
     │
     ▼
GitHub Repository
     │
     ▼
ArgoCD Detects Change
     │
     ▼
Application Sync
     │
     ▼
Helm Installs Grafana
     │
     ▼
Deployment Ready
     │
     ▼
PostSync Hook Starts
     │
     ▼
Bootstrap Job
     │
     ▼
Grafana API
     │
     ▼
Users
Teams
Folders
Permissions
```

---

# Helm Deployment

Grafana, Loki and Promtail are **not** stored inside this repository.

Instead,

ArgoCD downloads official Helm Charts.

Example

```
repoURL:

https://grafana.github.io/helm-charts
```

Then

```
values.yaml
```

is applied.

Result

```
Official Chart

+

Our Custom Values

=

Final Kubernetes Resources
```

---

# ArgoCD Applications

This project contains four Applications.

## Grafana

Deploys Grafana using Helm.

---

## Loki

Deploys Loki.

---

## Promtail

Deploys Promtail.

---

## Grafana Bootstrap

Deploys

```
Job

Secret

ConfigMap
```

using Kustomize.

Runs only after Grafana becomes Healthy.

---

# Bootstrap Flow

```
Job Starts

↓

Wait for Grafana

↓

Create Teams

↓

Create Users

↓

Assign Users

↓

Create Folders

↓

Apply Permissions

↓

Completed
```

---

# Grafana Objects Created

## Teams

- developers
- devops
- viewers

---

## Users

| User | Team |
|------|------|
| dev1 | developers |
| dev2 | developers |
| ops1 | devops |
| ops2 | devops |
| viewer1 | viewers |

---

## Folders

- Development
- Operations

---

## Folder Permissions

Development

| Team | Permission |
|------|------------|
| developers | Edit |
| viewers | View |

Operations

| Team | Permission |
|------|------------|
| devops | Edit |
| viewers | View |

---

# APIs Used

| API | Purpose |
|------|----------|
| GET /api/health | Wait for Grafana |
| POST /api/teams | Create Teams |
| POST /api/admin/users | Create Users |
| GET /api/users/lookup | User Lookup |
| GET /api/teams/search | Team Lookup |
| POST /api/teams/{id}/members | Assign Team Members |
| GET /api/folders | List Folders |
| POST /api/folders | Create Folder |
| POST /api/folders/{uid}/permissions | Apply Permissions |

---

# GitOps Workflow

```
Developer

↓

Git Commit

↓

Git Push

↓

GitHub

↓

ArgoCD detects change

↓

Sync

↓

Kubernetes Updated
```

No manual kubectl apply is required.

Git becomes the single source of truth.

---

# Kustomize

Instead of embedding shell scripts inside ConfigMap YAML,

Kustomize automatically generates the ConfigMap.

Example

```
configMapGenerator:
  - name: grafana-bootstrap-script
    files:
      - bootstrap.sh
      - scripts/teams.sh
      - scripts/users.sh
      - scripts/team-members.sh
      - scripts/folders.sh
      - scripts/permissions.sh
```

Advantages

- No duplicated scripts
- Easier maintenance
- Cleaner repository
- Git-friendly

---

# ArgoCD Sync

Auto Sync is enabled.

```
syncPolicy:

automated:

prune: true

selfHeal: true
```

Meaning

- Automatically deploy Git changes
- Remove deleted resources
- Restore manually modified resources

---

# Idempotency

Bootstrap scripts are safe to execute multiple times.

They

- Skip existing users
- Skip existing teams
- Skip existing folders
- Reapply permissions

This makes deployments repeatable.

---

# Local Development

The project was developed using

- Docker
- KIND
- kubectl
- Helm
- ArgoCD

without requiring any cloud provider.

---

# Result

After deployment the cluster contains

```
Grafana

↓

Loki

↓

Promtail

↓

Bootstrap Job

↓

Configured Grafana

├── Teams
├── Users
├── Folders
└── Permissions
```

Everything is deployed automatically from Git using ArgoCD, making the environment fully reproducible, version controlled, and GitOps compliant.