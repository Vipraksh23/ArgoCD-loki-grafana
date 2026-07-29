#!/bin/sh

set -e

AUTH="-u ${GRAFANA_ADMIN_USER}:${GRAFANA_ADMIN_PASSWORD}"

create_folder () {

curl -s \
-X POST \
$AUTH \
-H "Content-Type: application/json" \
-d "{\"title\":\"$1\"}" \
$GRAFANA_URL/api/folders || true

}

create_folder Development
create_folder Operations

echo
echo "Folders created."