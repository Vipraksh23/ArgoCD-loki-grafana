#!/bin/sh

set -e

curl -s \
-X POST \
-u "${GRAFANA_ADMIN_USER}:${GRAFANA_ADMIN_PASSWORD}" \
-H "Content-Type: application/json" \
-d '{"name":"developers"}' \
$GRAFANA_URL/api/teams || true

curl -s \
-X POST \
-u "${GRAFANA_ADMIN_USER}:${GRAFANA_ADMIN_PASSWORD}" \
-H "Content-Type: application/json" \
-d '{"name":"devops"}' \
$GRAFANA_URL/api/teams || true

curl -s \
-X POST \
-u "${GRAFANA_ADMIN_USER}:${GRAFANA_ADMIN_PASSWORD}" \
-H "Content-Type: application/json" \
-d '{"name":"viewers"}' \
$GRAFANA_URL/api/teams || true

echo
echo "Teams created."