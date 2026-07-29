#!/bin/sh

set -e

AUTH="-u ${GRAFANA_ADMIN_USER}:${GRAFANA_ADMIN_PASSWORD}"

TEAM_DEV=$(curl -s $AUTH $GRAFANA_URL/api/teams/search?name=developers | jq -r '.teams[0].id')
TEAM_OPS=$(curl -s $AUTH $GRAFANA_URL/api/teams/search?name=devops | jq -r '.teams[0].id')
TEAM_VIEW=$(curl -s $AUTH $GRAFANA_URL/api/teams/search?name=viewers | jq -r '.teams[0].id')

add_member () {

TEAM=$1
USER=$2

curl -s \
-X POST \
$AUTH \
-H "Content-Type: application/json" \
-d "{\"loginOrEmail\":\"$USER\"}" \
$GRAFANA_URL/api/teams/$TEAM/members || true

}

add_member $TEAM_DEV dev1
add_member $TEAM_DEV dev2

add_member $TEAM_OPS ops1
add_member $TEAM_OPS ops2

add_member $TEAM_VIEW viewer1

echo
echo "Members added."