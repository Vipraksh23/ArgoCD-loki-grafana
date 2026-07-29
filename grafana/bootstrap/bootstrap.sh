#!/bin/sh

set -e

echo "====================================="
echo " Grafana Bootstrap Started"
echo "====================================="

echo "Waiting for Grafana..."

until curl -s http://grafana.observability.svc.cluster.local/api/health >/dev/null
do
    echo "Grafana not ready..."
    sleep 5
done

echo "Grafana is reachable."

echo "Health response:"
curl -s http://grafana.observability.svc.cluster.local/api/health

echo
echo "Bootstrap completed successfully."