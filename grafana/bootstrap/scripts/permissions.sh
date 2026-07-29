#!/bin/sh

set -e

AUTH="-u ${GRAFANA_ADMIN_USER}:${GRAFANA_ADMIN_PASSWORD}"

DEV_FOLDER=$(curl -s $AUTH $GRAFANA_URL/api/folders \
| jq -r '.[] | select(.title=="Development") | .uid' \
| head -n1)

OPS_FOLDER=$(curl -s $AUTH $GRAFANA_URL/api/folders \
| jq -r '.[] | select(.title=="Operations") | .uid' \
| head -n1)

DEV_TEAM=$(curl -s $AUTH $GRAFANA_URL/api/teams/search?name=developers | jq -r '.teams[0].id')
OPS_TEAM=$(curl -s $AUTH $GRAFANA_URL/api/teams/search?name=devops | jq -r '.teams[0].id')
VIEW_TEAM=$(curl -s $AUTH $GRAFANA_URL/api/teams/search?name=viewers | jq -r '.teams[0].id')

curl -s \
-X POST \
$AUTH \
-H "Content-Type: application/json" \
-d "{
  \"items\": [
    {
      \"teamId\": $DEV_TEAM,
      \"permission\": 2
    },
    {
      \"teamId\": $VIEW_TEAM,
      \"permission\": 1
    }
  ]
}" \
$GRAFANA_URL/api/folders/$DEV_FOLDER/permissions

curl -s \
-X POST \
$AUTH \
-H "Content-Type: application/json" \
-d "{
  \"items\": [
    {
      \"teamId\": $OPS_TEAM,
      \"permission\": 2
    },
    {
      \"teamId\": $VIEW_TEAM,
      \"permission\": 1
    }
  ]
}" \
$GRAFANA_URL/api/folders/$OPS_FOLDER/permissions

echo
echo "Folder permissions applied."