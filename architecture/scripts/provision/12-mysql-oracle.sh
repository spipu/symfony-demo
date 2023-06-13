#!/bin/bash

showMessage " > MySQL - Oracle Install"

apt-get -qq -y install mysql-server > /dev/null

showMessage " > MySQL - Configure"

mkdir -p /var/log/mysql
createFromTemplate "$CONFIG_FOLDER/mysql/mysql.cnf" "/etc/mysql/mysql.conf.d/provision.cnf"

showMessage " > MySQL - Service"

if [[ "$ENV_TYPE" = "docker" ]]; then
    /etc/init.d/mysql stop   > /dev/null
    /etc/init.d/mysql start  > /dev/null
    /etc/init.d/mysql status > /dev/null
else
    systemctl stop mysql  > /dev/null
    systemctl start mysql      > /dev/null
    systemctl is-enabled mysql > /dev/null || systemctl enable mysql > /dev/null
    systemctl status mysql     > /dev/null
fi
