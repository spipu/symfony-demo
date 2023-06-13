#!/bin/bash

set -e

bashSource=$(readlink -f "${BASH_SOURCE[0]}")
cd "$(dirname "$bashSource")"
cd ../../

ENV_TYPE="none"
ENV_DO_NOT_GENERATE="yes"
source ./architecture/scripts/include/init.sh

showTitle "Install"

cd ${ENV_FOLDER}/${WEB_FOLDER}

showMessage "Composer"
composer install

showMessage "Security Check"
symfony security:check

showMessage "Assets"
./bin/console assets:install --symlink --relative
./bin/console spipu:assets:install

showMessage "Redis"
redis-cli -p 6379 flushall

showMessage "Doctrine Schema"
./bin/console doctrine:schema:update --force --dump-sql

#showMessage "Run migrations"
#./bin/console doctrine:migrations:migrate --no-interaction

showMessage "Clean Symfony Cache"
set +e
rm -rf ./var/* > /dev/null 2>&1
sudo -u www-data rm -rf ./var/* > /dev/null 2>&1
set -e

showMessage "Fixtures"
sudo -u www-data ./bin/console spipu:fixtures:load

showMessage "End"
