#!/bin/bash

echo " > MySQL - Install"

apt-get -qq -y install mysql-client mysql-server > /dev/null

echo " > MySQL - Configure"

rm -f /etc/mysql/mysql.conf.d/provision.cnf
ln -s $CONFIG_FOLDER/mysql/mysql.cnf /etc/mysql/mysql.conf.d/provision.cnf

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
