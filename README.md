# Grafana Bootstrap using Kubernetes Job + ArgoCD

## Overview

This project bootstraps a fresh Grafana instance automatically after deployment.

Instead of manually creating users, teams, folders, and permissions through the Grafana UI, a Kubernetes Job performs all configuration using the Grafana HTTP API.

The Job is managed by ArgoCD, making the entire setup GitOps-driven and reproducible.

---

# What gets created

## Teams

- developers
- devops
- viewers

---

## Users

| User | Team |
|-------|------|
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

### Development Folder

| Team | Permission |
|------|------------|
| developers | Edit |
| viewers | View |

---

### Operations Folder

| Team | Permission |
|------|------------|
| devops | Edit |
| viewers | View |

---

# Project Structure

```
grafana/
│
├── bootstrap/
│   ├── configmap.yaml
│   ├── job.yaml
│   └── scripts/
│       ├── bootstrap.sh
│       ├── teams.sh
│       ├── users.sh
│       ├── team-members.sh
│       ├── folders.sh
│       └── permissions.sh
│
└── kustomization.yaml
```

---

# Bootstrap Flow

```
Bootstrap Job
      │
      ▼
Wait for Grafana API
      │
      ▼
Create Teams
      │
      ▼
Create Users
      │
      ▼
Add Users to Teams
      │
      ▼
Create Folders
      │
      ▼
Assign Folder Permissions
      │
      ▼
Job Completed
```

---

# Detailed Flow

```
                    +----------------------+
                    | Kubernetes Job Start |
                    +----------+-----------+
                               |
                               |
                               ▼
                Wait until Grafana is Healthy
                               |
                               ▼
                 POST /api/teams
                               |
                               ▼
              POST /api/admin/users
                               |
                               ▼
         GET Team IDs + GET User IDs
                               |
                               ▼
      POST /api/teams/{id}/members
                               |
                               ▼
            POST /api/folders
                               |
                               ▼
      POST /api/folders/{uid}/permissions
                               |
                               ▼
                  Bootstrap Finished
```

---

# Scripts

## bootstrap.sh

Responsible for:

- Waiting for Grafana
- Executing all bootstrap scripts in order

Execution order:

```
bootstrap.sh

├── teams.sh
├── users.sh
├── team-members.sh
├── folders.sh
└── permissions.sh
```

---

## teams.sh

Creates Grafana Teams.

API Used

```
POST /api/teams
```

Creates

- developers
- devops
- viewers

---

## users.sh

Creates Grafana Users.

API Used

```
POST /api/admin/users
```

Creates

- dev1
- dev2
- ops1
- ops2
- viewer1

---

## team-members.sh

Looks up Team IDs and User IDs before assigning users.

APIs Used

```
GET /api/teams/search
```

```
GET /api/users/lookup
```

```
POST /api/teams/{team_id}/members
```

Example request

```json
{
  "userId": 2
}
```

> **Grafana 12 Change**
>
> Grafana 12 requires the request body to be JSON:
>
> ```json
> {
>   "userId": 2
> }
> ```
>
> Older versions accepted `application/x-www-form-urlencoded`.

---

## folders.sh

Creates folders only if they do not already exist.

API

```
GET /api/folders
```

```
POST /api/folders
```

Folders

- Development
- Operations

---

## permissions.sh

Assigns Team permissions on folders.

API

```
POST /api/folders/{folder_uid}/permissions
```

Example payload

```json
{
  "items": [
    {
      "teamId": 1,
      "permission": 2
    },
    {
      "teamId": 3,
      "permission": 1
    }
  ]
}
```

Permission values

| Value | Meaning |
|--------|---------|
| 1 | View |
| 2 | Edit |
| 4 | Admin |

---

# ArgoCD Deployment Flow

```
Git Push
    │
    ▼
Git Repository
    │
    ▼
ArgoCD detects change
    │
    ▼
Sync Application
    │
    ▼
Create/Update ConfigMap
    │
    ▼
Create Bootstrap Job
    │
    ▼
Job Executes
    │
    ▼
Grafana Configured
```

---

# Required Environment Variables

These are injected into the Job.

```
GRAFANA_ADMIN_USER

GRAFANA_ADMIN_PASSWORD
```

---

# Idempotency

The bootstrap is designed to be re-runnable.

Repeated executions will:

- Skip existing teams
- Skip existing users
- Skip existing folders
- Reapply permissions
- Ignore users already added to teams

---

# APIs Used

| API | Purpose |
|------|----------|
| GET /api/health | Wait for Grafana |
| POST /api/teams | Create Teams |
| GET /api/teams/search | Lookup Team |
| POST /api/admin/users | Create Users |
| GET /api/users/lookup | Lookup User |
| POST /api/teams/{id}/members | Add Team Members |
| GET /api/folders | List Folders |
| POST /api/folders | Create Folder |
| POST /api/folders/{uid}/permissions | Apply Permissions |

---

# Example Log Output

```
Waiting for Grafana...

Grafana is ready.

Creating Teams...

Creating Users...

Adding Users To Teams...

Creating Folders...

Applying Permissions...

Bootstrap completed.
```

---

# Technologies Used

- Kubernetes
- Grafana 12
- ArgoCD
- GitOps
- curl
- jq
- Alpine Linux
- Shell Scripts

---

# Result

After deployment Grafana automatically contains:

```
Teams
 ├── developers
 ├── devops
 └── viewers

Users
 ├── dev1
 ├── dev2
 ├── ops1
 ├── ops2
 └── viewer1

Folders
 ├── Development
 └── Operations

Permissions

Development
    developers → Edit
    viewers → View

Operations
    devops → Edit
    viewers → View
```