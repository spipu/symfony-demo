#!/bin/bash

set -e

bashSource=$(readlink -f "${BASH_SOURCE[0]}")
cd "$(dirname "$bashSource")"
cd ../../

ENV_DO_NOT_GENERATE="yes"
source ./architecture/scripts/include/init.sh

showTitle "Test Services"

showMessage " => PHP"
php -v | grep cli
echo ""

showMessage " => MySQL"
mysql -h localhost -u"$DB_USER" -p"$DB_PASS" "$DB_NAME" -N -e "SHOW DATABASES like \"$DB_NAME\";"
echo ""

showMessage " => Redis - Cache"
redis-cli -h localhost -p 6379 ping
echo ""

showMessage " => Redis - Session"
redis-cli -h localhost -p 6380 ping
echo ""

showMessage "Finished"
