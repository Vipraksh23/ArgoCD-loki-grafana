#!/bin/sh

set -e

AUTH="-u ${GRAFANA_ADMIN_USER}:${GRAFANA_ADMIN_PASSWORD}"

create_folder () {

NAME=$1

EXISTS=$(curl -s \
$AUTH \
$GRAFANA_URL/api/folders \
| jq -r ".[] | select(.title==\"$NAME\") | .uid" \
| head -n1)

if [ -z "$EXISTS" ]; then

curl -s \
-X POST \
$AUTH \
-H "Content-Type: application/json" \
-d "{\"title\":\"$NAME\"}" \
$GRAFANA_URL/api/folders

else

echo "$NAME folder already exists."

fi

}

create_folder Development
create_folder Operations

echo
echo "Folders created."