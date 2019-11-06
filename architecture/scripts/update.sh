#!/bin/bash

set -e

bashSource=$(readlink -f "${BASH_SOURCE[0]}")
cd "$(dirname "$bashSource")"
cd ../../

ENV_TYPE="none"
ENV_DO_NOT_GENERATE="yes"
source ./architecture/scripts/include/init.sh

showTitle "Update"

cd ${ENV_FOLDER}/${WEB_FOLDER}

composer install

redis-cli -p 6379 flushall

./bin/console doctrine:schema:update --force

rm -rf ./var/* > /dev/null 2>&1
sudo -u www-data rm -rf ./var/* > /dev/null 2>&1

sudo -u www-data ./bin/console spipu:fixtures:load
