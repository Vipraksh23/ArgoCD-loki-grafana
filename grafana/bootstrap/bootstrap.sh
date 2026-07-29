#!/bin/sh

set -e

GRAFANA_URL=http://grafana.observability.svc.cluster.local

export GRAFANA_URL

echo "Waiting for Grafana..."

until curl -s $GRAFANA_URL/api/health >/dev/null
do
    echo "Grafana not ready..."
    sleep 5
done

echo "Grafana is ready."

echo "==============================="
echo "Creating Teams..."
sh /scripts/teams.sh

echo "==============================="
echo "Creating Users..."
sh /scripts/users.sh

echo "==============================="
echo "Adding Users To Teams..."
sh /scripts/team-members.sh

echo "==============================="
echo "Creating Folders..."
sh /scripts/folders.sh

echo "==============================="
echo "Applying Permissions..."
sh /scripts/permissions.sh

echo
echo "Bootstrap completed."