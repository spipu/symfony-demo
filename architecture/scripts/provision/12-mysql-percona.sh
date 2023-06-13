#!/bin/bash

showMessage " > MySQL - Percona Repo"

wget -q https://repo.percona.com/apt/percona-release_latest.$(lsb_release -sc)_all.deb > /dev/null
dpkg -i percona-release_latest.$(lsb_release -sc)_all.deb > /dev/null
rm   -f percona-release_latest.$(lsb_release -sc)_all.deb
percona-release setup ps80 > /dev/null
apt-get -qq update > /dev/null

showMessage " > MySQL - Percona Install"

apt-get -qq -y install percona-server-server > /dev/null

showMessage " > MySQL - Configure"

mkdir -p /var/log/mysql
mkdir -p /etc/mysql/percona-server.conf.d
createFromTemplate "$CONFIG_FOLDER/mysql/mysql.cnf" "/etc/mysql/percona-server.conf.d/provision.cnf"

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
