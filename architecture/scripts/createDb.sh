#!/bin/bash

set -e

bashSource=$(readlink -f "${BASH_SOURCE[0]}")
cd "$(dirname "$bashSource")"
cd ../../

ENV_DO_NOT_GENERATE="yes"
source ./architecture/scripts/include/init.sh

showTitle "Create Database"

MYSQL_CMD="mysql"

function createUserAndDatabase() {
    MYSQL_HOST="$1"
    MYSQL_USER="$2"
    MYSQL_PASS="$3"
    MYSQL_DB="$4"

    $MYSQL_CMD -e "CREATE USER '$MYSQL_USER'@'$MYSQL_HOST' IDENTIFIED BY '$MYSQL_PASS';"
    $MYSQL_CMD -e "GRANT USAGE ON * . * TO '$MYSQL_USER'@'$MYSQL_HOST' IDENTIFIED BY '$MYSQL_PASS' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0;"
    $MYSQL_CMD -e "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DB\`;"
    $MYSQL_CMD -e "GRANT ALL PRIVILEGES ON \`$MYSQL_DB\`.* TO '$MYSQL_USER'@'$MYSQL_HOST' WITH GRANT OPTION;"
}

createUserAndDatabase "localhost" "$DB_USER" "$DB_PASS" "$DB_NAME"
#createUserAndDatabase "\%" "$DB_USER" "$DB_PASS" "$DB_NAME"
