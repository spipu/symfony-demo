#!/bin/bash

showMessage " > PHP - Install Dev Tools"

apt-get -qq -y install \
    php${PHP_VERSION}-xdebug \
    php${PHP_VERSION}-sqlite3 \
    > /dev/null
