#!/bin/sh

set -e

GRAFANA_URL=http://grafana.observability.svc.cluster.local

echo "Waiting for Grafana..."

until curl -s $GRAFANA_URL/api/health >/dev/null
do
    echo "Grafana not ready..."
    sleep 5
done

echo "Grafana is ready."

echo "Creating Developers Team..."

curl \
  -X POST \
  -u "${GRAFANA_ADMIN_USER}:${GRAFANA_ADMIN_PASSWORD}" \
  -H "Content-Type: application/json" \
  -d '{
        "name":"developers"
      }' \
  $GRAFANA_URL/api/teams

echo
echo "Bootstrap completed."