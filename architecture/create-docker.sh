#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"
cd ../

ENV_TYPE="docker"
source ./architecture/conf/env.sh

SSH_PUB=$(cat ~/.ssh/id_rsa.pub)

cd ./architecture/vm/

HOUR=$(date +%H:%M:%S)
echo "[${HOUR}]===[${ENV_TYPE}]==="

ssh-keygen -R "${ENV_HOST}" > /dev/null
ssh-keygen -R "${ENV_IP}"   > /dev/null

echo " => Prepare /etc/hosts file"
sudo sed "/${ENV_HOST}/d" -i /etc/hosts
echo "# Added for docker ${ENV_HOST}" | sudo tee -a /etc/hosts > /dev/null
echo "${ENV_IP} ${ENV_HOST}"         | sudo tee -a /etc/hosts > /dev/null

echo " => Docker"
sudo docker-compose down -v
sudo docker-compose build --build-arg ssh_pub_key="${SSH_PUB}" ${ENV_NAME}
sudo docker-compose up -d

cd - > /dev/null

sleep 3
ssh-keygen -R "${ENV_HOST}" > /dev/null 2>&1
ssh-keygen -R "${ENV_IP}"   > /dev/null 2>&1
ssh-keyscan ${ENV_HOST}     >> ~/.ssh/known_hosts 2> /dev/null
ssh-keyscan ${ENV_IP}       >> ~/.ssh/known_hosts 2> /dev/null
echo ""

source ./architecture/create-abstract.sh
