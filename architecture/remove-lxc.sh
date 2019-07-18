#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"
cd ../

ENV_TYPE="lxc"
source ./architecture/conf/env.sh

ENV_IP=`getent hosts ${ENV_HOST} | awk '{ print $1 }'`

cd ./architecture/vm/

HOUR=$(date +%H:%M:%S)
echo "[${HOUR}]===[${ENV_TYPE}]==="

ssh-keygen -R "${ENV_HOST}"
ssh-keygen -R "${ENV_IP}"

sudo cremove ${ENV_NAME}

cd - > /dev/null
echo ""
