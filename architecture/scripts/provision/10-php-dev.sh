#!/bin/bash

showMessage " > PHP - Install Dev Tools"

apt-get -qq -y install \
    php${PHP_VERSION}-xdebug \
    php${PHP_VERSION}-sqlite3 \
    > /dev/null

createFromTemplate "$CONFIG_FOLDER/php/xdebug.ini"   "/etc/${PHP_FOLDER}/fpm/conf.d/99-xdebug.ini"
createFromTemplate "$CONFIG_FOLDER/php/xdebug.ini"   "/etc/${PHP_FOLDER}/cli/conf.d/99-xdebug.ini"
