#!/bin/bash

PHP_VERSION="7.4"
PHP_FOLDER="php/7.4"

showMessage " > PHP - Install ${PHP_VERSION}"

apt-get -qq -y install \
    php${PHP_VERSION}-cli \
    php${PHP_VERSION}-fpm \
    php${PHP_VERSION}-bcmath \
    php${PHP_VERSION}-common \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-gd \
    php${PHP_VERSION}-iconv \
    php${PHP_VERSION}-intl \
    php${PHP_VERSION}-json \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-mysql \
    php${PHP_VERSION}-pdo \
    php${PHP_VERSION}-pdo-mysql \
    php${PHP_VERSION}-redis \
    php${PHP_VERSION}-readline \
    php${PHP_VERSION}-ssh2 \
    php${PHP_VERSION}-simplexml \
    php${PHP_VERSION}-soap \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-xsl \
    php${PHP_VERSION}-zip \
    > /dev/null

showMessage " > PHP - Configure"

mkdir -p  /var/log/php/
chown www-data.www-data /var/log/php
chmod 775 /var/log/php/

mkdir -p /etc/${PHP_FOLDER}/cli/conf.d/
mkdir -p /etc/${PHP_FOLDER}/fpm/conf.d/
mkdir -p /etc/${PHP_FOLDER}/fpm/pool.d/
rm -f /etc/${PHP_FOLDER}/fpm/pool.d/*

createFromTemplate "$CONFIG_FOLDER/php/cli.ini"   "/etc/${PHP_FOLDER}/cli/conf.d/99-provision.ini"
createFromTemplate "$CONFIG_FOLDER/php/fpm.ini"   "/etc/${PHP_FOLDER}/fpm/conf.d/99-provision.ini"
createFromTemplate "$CONFIG_FOLDER/php/pool.conf" "/etc/${PHP_FOLDER}/fpm/pool.d/$ENV_NAME.conf"

showMessage " > PHP - Service"

if [[ "$ENV_TYPE" = "docker" ]]; then
    /etc/init.d/php${PHP_VERSION}-fpm stop   > /dev/null
    /etc/init.d/php${PHP_VERSION}-fpm start  > /dev/null
    /etc/init.d/php${PHP_VERSION}-fpm status > /dev/null
else
    systemctl restart php${PHP_VERSION}-fpm
fi
