#!/bin/bash

PHP_VERSION="7.2"
PHP_FOLDER="php/7.2"

echo " > PHP - Install ${PHP_VERSION}"

apt-get -qq -y install \
    php${PHP_VERSION}-cli \
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
    php${PHP_VERSION}-simplexml \
    php${PHP_VERSION}-soap \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-xsl \
    php${PHP_VERSION}-zip \
    > /dev/null

echo " > PHP - Configure"

mkdir -p  /var/log/php/
chown www-data.www-data /var/log/php
chmod 775 /var/log/php/

mkdir -p /etc/${PHP_FOLDER}/cli/conf.d/
mkdir -p /etc/${PHP_FOLDER}/apache2/conf.d/

rm -f /etc/${PHP_FOLDER}/cli/conf.d/99-provision.ini
rm -f /etc/${PHP_FOLDER}/apache2/conf.d/99-provision.ini

ln -s $CONFIG_FOLDER/php/cli.ini    /etc/${PHP_FOLDER}/cli/conf.d/99-provision.ini
ln -s $CONFIG_FOLDER/php/apache.ini /etc/${PHP_FOLDER}/apache2/conf.d/99-provision.ini
