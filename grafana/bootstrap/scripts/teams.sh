#!/bin/sh

set -e

AUTH="-u ${GRAFANA_ADMIN_USER}:${GRAFANA_ADMIN_PASSWORD}"

create_team () {

curl -s \
-X POST \
$AUTH \
-H "Content-Type: application/json" \
-d "{\"name\":\"$1\"}" \
$GRAFANA_URL/api/teams || true

}

create_team developers
create_team devops
create_team viewers

echo
echo "Teams created."