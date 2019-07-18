#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"
cd ../

ENV_TYPE="lxc"
source ./architecture/conf/env.sh

ENV_IP=`getent hosts ${ENV_HOST} | awk '{ print $1 }'`

cd ./architecture/vm/

HOUR=$(date +%H:%M:%S)
echo "[${HOUR}]===[${ENV_TYPE}]==="

ssh-keygen -R "${ENV_HOST}" > /dev/null
ssh-keygen -R "${ENV_IP}"   > /dev/null
sudo cremove ${ENV_NAME}
sudo cdeploy

cd - > /dev/null

sleep 2
ENV_IP=""
while [ ! "$ENV_IP" ] ; do
    ENV_IP=`getent hosts ${ENV_HOST} | awk '{ print $1 }'`
done
echo "  => $ENV_IP"
ssh-keygen -R "${ENV_HOST}" > /dev/null 2>&1
ssh-keygen -R "${ENV_IP}"   > /dev/null 2>&1
ssh-keyscan ${ENV_HOST}     >> ~/.ssh/known_hosts 2> /dev/null
ssh-keyscan ${ENV_IP}       >> ~/.ssh/known_hosts 2> /dev/null
echo ""

ssh root@${ENV_HOST} rm -f /etc/apt/apt.conf.d/10-smile-proxy.conf

source ./architecture/create-abstract.sh
