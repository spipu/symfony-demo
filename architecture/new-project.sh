#!/usr/bin/env bash

cd "$( dirname "${BASH_SOURCE[0]}" )"
cd ../

ENV_TYPE="none"
source ./architecture/conf/env.sh

PROJECT_NAME="${ENV_NAME}"
FOLDER_PROJECT="./${WEB_FOLDER}"

echo "Create the project"
composer create-project symfony/website-skeleton    ${FOLDER_PROJECT} --ignore-platform-reqs --no-install
echo ""

echo "Configure Composer"
composer config platform.php            "7.2.19" -d ${FOLDER_PROJECT}
composer config platform.ext-bcmath     "1"      -d ${FOLDER_PROJECT}
composer config platform.ext-ctype      "1"      -d ${FOLDER_PROJECT}
composer config platform.ext-gd         "1"      -d ${FOLDER_PROJECT}
composer config platform.ext-spl        "1"      -d ${FOLDER_PROJECT}
composer config platform.ext-dom        "1"      -d ${FOLDER_PROJECT}
composer config platform.ext-simplexml  "1"      -d ${FOLDER_PROJECT}
composer config platform.ext-mcrypt     "1"      -d ${FOLDER_PROJECT}
composer config platform.ext-hash       "1"      -d ${FOLDER_PROJECT}
composer config platform.ext-curl       "1"      -d ${FOLDER_PROJECT}
composer config platform.ext-iconv      "1"      -d ${FOLDER_PROJECT}
composer config platform.ext-intl       "1"      -d ${FOLDER_PROJECT}
composer config platform.ext-xsl        "1"      -d ${FOLDER_PROJECT}
composer config platform.ext-mbstring   "1"      -d ${FOLDER_PROJECT}
composer config platform.ext-openssl    "1"      -d ${FOLDER_PROJECT}
composer config platform.ext-zip        "1"      -d ${FOLDER_PROJECT}
composer config platform.ext-pdo_mysql  "1"      -d ${FOLDER_PROJECT}
composer config platform.ext-soap       "1"      -d ${FOLDER_PROJECT}
composer config platform.lib-libxml     "1"      -d ${FOLDER_PROJECT}
echo ""

echo "Install the packages"
composer install --no-interaction                -d ${FOLDER_PROJECT}
chmod +x ${FOLDER_PROJECT}/bin/*
echo ""

echo "Add useful Packages"
composer require       sensiolabs/security-checker      -d ${FOLDER_PROJECT} --no-update
composer remove        symfony/dotenv                   -d ${FOLDER_PROJECT} --no-update
composer remove  --dev symfony/test-pack                -d ${FOLDER_PROJECT} --no-update
composer remove  --dev symfony/web-server-bundle        -d ${FOLDER_PROJECT} --no-update
composer require --dev symfony/dotenv                   -d ${FOLDER_PROJECT} --no-update
composer require --dev symfony/browser-kit:*            -d ${FOLDER_PROJECT} --no-update
composer require --dev symfony/css-selector:*           -d ${FOLDER_PROJECT} --no-update
composer require --dev edgedesign/phpqa                 -d ${FOLDER_PROJECT} --no-update
composer require --dev jakub-onderka/php-parallel-lint  -d ${FOLDER_PROJECT} --no-update
composer require --dev pdepend/pdepend                  -d ${FOLDER_PROJECT} --no-update
composer require --dev phpmd/phpmd                      -d ${FOLDER_PROJECT} --no-update
composer require --dev phpmetrics/phpmetrics            -d ${FOLDER_PROJECT} --no-update
composer require --dev phpunit/phpunit                  -d ${FOLDER_PROJECT} --no-update
composer require --dev squizlabs/php_codesniffer        -d ${FOLDER_PROJECT} --no-update
composer update  --no-interaction                       -d ${FOLDER_PROJECT}
echo ""

echo "Remove Useless Files"
rm -f ${FOLDER_PROJECT}/.env
rm -f ${FOLDER_PROJECT}/.env.dist
rm -f ${FOLDER_PROJECT}/.env.test
echo ""

echo "Configure Symfony"
FOLDER_CONFIG="${FOLDER_PROJECT}/config/"

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

rm -f ${FOLDER_PROJECT}/phpunit.xml.dist

echo "<?php return [];" > ${FOLDER_PROJECT}/.env.local.php

sed -i '/phpunit/d'           ${FOLDER_PROJECT}/.gitignore
sed -i '/\.env\.local\.php/d' ${FOLDER_PROJECT}/.gitignore

echo "###> ${PROJECT_NAME}
/node_modules/
/public/media/
###< ${PROJECT_NAME}

$(cat ${FOLDER_PROJECT}/.gitignore)" > ${FOLDER_PROJECT}/.gitignore

echo ""
