#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"
cd ../../

ENV_TYPE="none"
ENV_DO_NOT_GENERATE="yes"
source ./architecture/conf/env.sh

cd ${ENV_FOLDER}/${WEB_FOLDER}

composer install

./bin/console doctrine:schema:update --force
./bin/console assets:install --no-interaction
./bin/console spipu:assets:install --no-interaction

sudo -u www-data rm -rf ./website/var/* > /dev/null 2>&1
rm -rf ./website/var/* > /dev/null 2>&1
