#!/bin/bash

echo " > MySQL - Install"

apt-get -qq -y install mysql-server > /dev/null

echo " > MySQL - Configure"

ln -s $CONFIG_FOLDER/mysql/mysql.cnf /etc/mysql/conf.d/99-provision.cnf

echo " > MySQL - Service"

if [[ "$ENV_TYPE" = "docker" ]]; then
    /etc/init.d/mysql stop  > /dev/null
    /etc/init.d/mysql start mysql > /dev/null
    /etc/init.d/mysql status mysql > /dev/null
else
    systemctl stop mysql  > /dev/null
    systemctl start mysql      > /dev/null
    systemctl is-enabled mysql > /dev/null || systemctl enable mysql > /dev/null
    systemctl status mysql     > /dev/null
fi
