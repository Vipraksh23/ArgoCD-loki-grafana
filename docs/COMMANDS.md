# Useful Commands

This document contains the most commonly used commands while working with this project.

---

# Kubernetes

## Nodes

```bash
kubectl get nodes
```

---

## Namespaces

```bash
kubectl get ns
```

---

## Pods

```bash
kubectl get pods -A
```

```bash
kubectl get pods -n observability
```

```bash
kubectl get pods -n argocd
```

Describe a Pod

```bash
kubectl describe pod <pod-name> -n <namespace>
```

Logs

```bash
kubectl logs <pod-name> -n <namespace>
```

---

## Services

```bash
kubectl get svc -A
```

Describe Service

```bash
kubectl describe svc grafana -n observability
```

---

## ConfigMaps

```bash
kubectl get cm -A
```

View ConfigMap

```bash
kubectl get cm grafana-bootstrap-script \
-n observability \
-o yaml
```

---

## Secrets

```bash
kubectl get secrets
```

Decode Secret

```bash
kubectl get secret argocd-initial-admin-secret \
-n argocd \
-o jsonpath="{.data.password}" | base64 -d
```

---

# Jobs

List Jobs

```bash
kubectl get jobs -n observability
```

Describe Job

```bash
kubectl describe job grafana-bootstrap \
-n observability
```

Job Logs

```bash
kubectl logs job/grafana-bootstrap \
-n observability
```

Delete Job

```bash
kubectl delete job grafana-bootstrap \
-n observability
```

---

# ArgoCD

Applications

```bash
kubectl get applications -n argocd
```

Application Details

```bash
kubectl describe application grafana \
-n argocd
```

Refresh

```bash
argocd app sync grafana
```

Sync Everything

```bash
argocd app sync root-app
```

---

# Kustomize

Render Manifests

```bash
kubectl kustomize grafana/bootstrap
```

---

# Helm

List Releases

```bash
helm list -A
```

Values

```bash
helm get values grafana \
-n observability
```

---

# Docker

Containers

```bash
docker ps
```

Images

```bash
docker images
```

Volumes

```bash
docker volume ls
```

---

# Kind

Clusters

```bash
kind get clusters
```

Delete Cluster

```bash
kind delete cluster --name observability
```

Create Cluster

```bash
kind create cluster \
--name observability \
--config kind/kind-config.yaml
```

---

# Git

Status

```bash
git status
```

Commit

```bash
git add .

git commit -m "message"
```

Push

```bash
git push origin master
```

---

# Grafana

Port Forward

```bash
kubectl port-forward \
svc/grafana \
3001:80 \
-n observability
```

---

# Loki

```bash
kubectl logs statefulset/loki \
-n observability
```

---

# Promtail

```bash
kubectl logs daemonset/promtail \
-n observability
```