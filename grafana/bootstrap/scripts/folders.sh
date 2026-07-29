#!/bin/sh

set -e

AUTH="-u ${GRAFANA_ADMIN_USER}:${GRAFANA_ADMIN_PASSWORD}"

create_folder() {

EXISTS=$(curl -s $AUTH \
$GRAFANA_URL/api/folders \
| jq -r ".[] | select(.title==\"$1\") | .uid")

if [ -z "$EXISTS" ]; then

    curl -s \
    -X POST \
    $AUTH \
    -H "Content-Type: application/json" \
    -d "{\"title\":\"$1\"}" \
    $GRAFANA_URL/api/folders

else

    echo "$1 already exists."

fi

}

create_folder Development
create_folder Operations

echo
echo "Folders created."