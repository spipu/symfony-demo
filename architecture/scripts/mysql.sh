#!/bin/bash

set -e

bashSource=$(readlink -f "${BASH_SOURCE[0]}")
cd "$(dirname "$bashSource")"
cd ../../

ENV_DO_NOT_GENERATE="yes"
source ./architecture/scripts/include/init.sh

if [[ "$2" ]]; then
  mysql -h localhost -u"$DB_USER" -p"$DB_PASS" "$DB_NAME" -e "$2"
else
  mysql -h localhost -u"$DB_USER" -p"$DB_PASS" "$DB_NAME"
fi
