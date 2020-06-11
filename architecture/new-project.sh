#!/usr/bin/env bash

set -e

bashSource=$(readlink -f "${BASH_SOURCE[0]}")
cd "$(dirname "$bashSource")"
cd ../

ENV_TYPE="none"
source ./architecture/scripts/include/init.sh

PROJECT_NAME="${ENV_NAME}"
PROJECT_FOLDER="./${WEB_FOLDER}"

echo "Create the project"
composer create-project symfony/website-skeleton=v4.4.99    ${PROJECT_FOLDER} --ignore-platform-reqs --no-install
echo ""

echo "Configure Composer"
composer config platform.php            "7.2.24" -d ${PROJECT_FOLDER}
composer config platform.ext-bcmath     "1"      -d ${PROJECT_FOLDER}
composer config platform.ext-ctype      "1"      -d ${PROJECT_FOLDER}
composer config platform.ext-gd         "1"      -d ${PROJECT_FOLDER}
composer config platform.ext-spl        "1"      -d ${PROJECT_FOLDER}
composer config platform.ext-dom        "1"      -d ${PROJECT_FOLDER}
composer config platform.ext-simplexml  "1"      -d ${PROJECT_FOLDER}
composer config platform.ext-mcrypt     "1"      -d ${PROJECT_FOLDER}
composer config platform.ext-hash       "1"      -d ${PROJECT_FOLDER}
composer config platform.ext-curl       "1"      -d ${PROJECT_FOLDER}
composer config platform.ext-iconv      "1"      -d ${PROJECT_FOLDER}
composer config platform.ext-intl       "1"      -d ${PROJECT_FOLDER}
composer config platform.ext-xsl        "1"      -d ${PROJECT_FOLDER}
composer config platform.ext-mbstring   "1"      -d ${PROJECT_FOLDER}
composer config platform.ext-openssl    "1"      -d ${PROJECT_FOLDER}
composer config platform.ext-zip        "1"      -d ${PROJECT_FOLDER}
composer config platform.ext-pdo_mysql  "1"      -d ${PROJECT_FOLDER}
composer config platform.ext-soap       "1"      -d ${PROJECT_FOLDER}
composer config platform.lib-libxml     "1"      -d ${PROJECT_FOLDER}
echo ""

echo "Install the packages"
composer install --no-interaction                -d ${PROJECT_FOLDER}
chmod +x ${PROJECT_FOLDER}/bin/*
echo ""

echo "Add useful Packages"
composer require       sensiolabs/security-checker      -d ${PROJECT_FOLDER} --no-update
composer remove        symfony/dotenv                   -d ${PROJECT_FOLDER} --no-update
composer remove  --dev symfony/test-pack                -d ${PROJECT_FOLDER} --no-update
composer remove  --dev symfony/web-server-bundle        -d ${PROJECT_FOLDER} --no-update
composer require --dev symfony/dotenv                   -d ${PROJECT_FOLDER} --no-update
composer require --dev symfony/browser-kit:*            -d ${PROJECT_FOLDER} --no-update
composer require --dev symfony/css-selector:*           -d ${PROJECT_FOLDER} --no-update
composer require --dev edgedesign/phpqa                 -d ${PROJECT_FOLDER} --no-update
composer require --dev jakub-onderka/php-parallel-lint  -d ${PROJECT_FOLDER} --no-update
composer require --dev pdepend/pdepend                  -d ${PROJECT_FOLDER} --no-update
composer require --dev phpmd/phpmd                      -d ${PROJECT_FOLDER} --no-update
composer require --dev phpmetrics/phpmetrics            -d ${PROJECT_FOLDER} --no-update
composer require --dev phpunit/phpunit                  -d ${PROJECT_FOLDER} --no-update
composer require --dev squizlabs/php_codesniffer        -d ${PROJECT_FOLDER} --no-update
composer update  --no-interaction                       -d ${PROJECT_FOLDER}
echo ""

echo "Remove Useless Files"
rm -f ${PROJECT_FOLDER}/.env
rm -f ${PROJECT_FOLDER}/.env.dist
rm -f ${PROJECT_FOLDER}/.env.test
echo ""

echo "Configure Symfony"
FOLDER_CONFIG="${PROJECT_FOLDER}/config/"

FILE_CONFIG="${FOLDER_CONFIG}packages/framework.yaml"
echo "imports:
    - { resource: ../app_default_configuration.yaml }
    - { resource: /etc/symfony/$PROJECT_NAME.yaml, ignore_errors: true  }

parameters:
    APP_SETTINGS_REDIS_CACHE_URL:   'redis://%APP_SETTINGS_REDIS_CACHE_HOST%:%APP_SETTINGS_REDIS_CACHE_PORT%/%APP_SETTINGS_REDIS_CACHE_DB%'
    APP_SETTINGS_REDIS_SESSION_URL: 'redis://%APP_SETTINGS_REDIS_SESSION_HOST%:%APP_SETTINGS_REDIS_SESSION_PORT%/%APP_SETTINGS_REDIS_SESSION_DB%'

$(cat ${FILE_CONFIG})" > ${FILE_CONFIG}

FILE_CONFIG="${FOLDER_CONFIG}app_default_configuration.yaml"
echo "parameters:
    APP_SETTINGS_APP_ENV:             'prod'
    APP_SETTINGS_APP_CODE:            'prod'
    APP_SETTINGS_APP_SECRET:          'TEMPORARY_SECRET'
    APP_SETTINGS_DATABASE_URL:        ''
    APP_SETTINGS_MAILER_URL:          ''
    APP_SETTINGS_CACHE_APP:           'cache.adapter.filesystem'
    APP_SETTINGS_REDIS_CACHE_DB:      ''
    APP_SETTINGS_REDIS_CACHE_HOST:    ''
    APP_SETTINGS_REDIS_CACHE_PORT:    ''
    APP_SETTINGS_REDIS_SESSION_DB:    ''
    APP_SETTINGS_REDIS_SESSION_HOST:  ''
    APP_SETTINGS_REDIS_SESSION_PORT:  ''
" > ${FILE_CONFIG}

FILES=`find ${FOLDER_CONFIG}/ -type f | grep -v "debug.yaml"`
for FILE in ${FILES}
do
    sed -i "s/%env(\([^:]*\))%/%APP_SETTINGS_\1%/g" ${FILE}
    sed -i "s/%env([^:]*:*\([^:]*\))%/%APP_SETTINGS_\1%/g" ${FILE}
done

rm -f ${PROJECT_FOLDER}/phpunit.xml.dist

echo "<?php return [];" > ${PROJECT_FOLDER}/.env.local.php

sed -i '/phpunit/d'           ${PROJECT_FOLDER}/.gitignore
sed -i '/\.env\.local\.php/d' ${PROJECT_FOLDER}/.gitignore

echo "###> ${PROJECT_NAME}
/node_modules/
/public/media/
###< ${PROJECT_NAME}

$(cat ${PROJECT_FOLDER}/.gitignore)" > ${PROJECT_FOLDER}/.gitignore

echo ""
