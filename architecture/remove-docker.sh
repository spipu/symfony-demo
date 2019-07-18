#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"
cd ../

ENV_TYPE="docker"
source ./architecture/conf/env.sh

cd ./architecture/vm/

HOUR=$(date +%H:%M:%S)
echo "[${HOUR}]===[${ENV_TYPE}]==="

ssh-keygen -R "${ENV_HOST}"
ssh-keygen -R "${ENV_IP}"

sudo sed "/${ENV_HOST}/d" -i /etc/hosts

sudo docker-compose down -v

cd - > /dev/null
echo ""
