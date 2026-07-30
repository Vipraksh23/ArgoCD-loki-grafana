# Troubleshooting

## Application OutOfSync

Check

```bash
kubectl get applications -n argocd
```

Force Sync

```bash
argocd app sync <application>
```

---

## Bootstrap Job Not Running

Check

```bash
kubectl get jobs -n observability
```

Logs

```bash
kubectl logs job/grafana-bootstrap \
-n observability
```

---

## Grafana Not Accessible

Verify Service

```bash
kubectl get svc -n observability
```

Port Forward

```bash
kubectl port-forward \
svc/grafana \
3001:80 \
-n observability
```

---

## ConfigMap Not Updated

Render

```bash
kubectl kustomize grafana/bootstrap
```

Check Generated ConfigMap

```bash
kubectl get cm grafana-bootstrap-script \
-n observability \
-o yaml
```

---

## ArgoCD Not Syncing

Check reconciliation interval

```bash
kubectl get cm argocd-cm \
-n argocd \
-o jsonpath='{.data.timeout\.reconciliation}'
```

Restart Controller

```bash
kubectl rollout restart \
statefulset argocd-application-controller \
-n argocd
```