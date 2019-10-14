#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"
cd ../../

ENV_TYPE="none"
ENV_DO_NOT_GENERATE="yes"
source ./architecture/conf/env.sh

cd ${ENV_FOLDER}/${WEB_FOLDER}

composer install

yarn install
yarn run encore dev

redis-cli -p 6379 flushall

./bin/console doctrine:schema:update --force

rm -rf ./var/* > /dev/null 2>&1
sudo -u www-data rm -rf ./var/* > /dev/null 2>&1

sudo -u www-data ./bin/console spipu:fixtures:load
