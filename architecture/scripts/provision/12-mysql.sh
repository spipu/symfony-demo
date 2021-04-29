#!/bin/bash

showMessage " > MySQL - MariaDB Repo"

apt-get -qq -y install software-properties-common > /dev/null
apt-key adv --fetch-keys 'https://mariadb.org/mariadb_release_signing_key.asc'  > /dev/null 2>&1
add-apt-repository 'deb [arch=amd64,arm64,ppc64el] https://ftp.igh.cnrs.fr/pub/mariadb/repo/10.4/ubuntu focal main'  > /dev/null

apt-get -qq update > /dev/null

showMessage " > MySQL - MariaDB Install"

apt-get -qq -y install mariadb-server > /dev/null

showMessage " > MySQL - Configure"

mkdir -p /var/log/mysql
mkdir -p /etc/mysql/conf.d
createFromTemplate "$CONFIG_FOLDER/mysql/mysql.cnf" "/etc/mysql/conf.d/provision.cnf"

showMessage " > MySQL - Service"

if [[ "$ENV_TYPE" = "docker" ]]; then
    mkdir -p /var/run/mysqld
    chown mysql.root /var/run/mysqld

    createFromTemplate "$CONFIG_FOLDER/mysql/mysql.sh" "/etc/init.d/mysql"

    chown root.root /etc/init.d/mysql
    chmod 755       /etc/init.d/mysql

    update-rc.d mysql defaults
    /etc/init.d/mysql start > /dev/null
else
    systemctl stop mysql  > /dev/null
    systemctl start mysql      > /dev/null
    systemctl is-enabled mysql > /dev/null || systemctl enable mysql > /dev/null
    systemctl status mysql     > /dev/null
fi
