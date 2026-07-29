#!/bin/sh

set -e

create_user () {

curl -s \
-X POST \
-u "${GRAFANA_ADMIN_USER}:${GRAFANA_ADMIN_PASSWORD}" \
-H "Content-Type: application/json" \
-d "{
\"name\":\"$1\",
\"email\":\"$2\",
\"login\":\"$3\",
\"password\":\"$4\"
}" \
$GRAFANA_URL/api/admin/users || true

}

create_user dev1 dev1@example.com dev1 Dev12345!
create_user dev2 dev2@example.com dev2 Dev12345!

create_user ops1 ops1@example.com ops1 Dev12345!
create_user ops2 ops2@example.com ops2 Dev12345!

create_user viewer1 viewer1@example.com viewer1 Dev12345!

echo
echo "Users created."