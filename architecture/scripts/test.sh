#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"
cd ../../

ENV_TYPE="none"
ENV_DO_NOT_GENERATE="yes"
source ./architecture/conf/env.sh

echo "Test Services"

echo " => PHP"
php -v | grep cli
echo ""

echo " => MySQL"
export MYSQL_PWD=$DB_PASS
mysql -h localhost -P 3306 -u $DB_USER $DB_NAME -N -e "SHOW DATABASES like \"$DB_NAME\";"
echo ""

echo " => Redis - Cache"
redis-cli -h localhost -p 6379 ping
echo ""

echo " => Redis - Session"
redis-cli -h localhost -p 6380 ping
echo ""

echo "Finished"
