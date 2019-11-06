#!/bin/bash

set -e

bashSource=$(readlink -f "${BASH_SOURCE[0]}")
cd "$(dirname "$bashSource")"
cd ../

ENV_TYPE="docker"
source ./architecture/scripts/include/init.sh

cd ./architecture/vm/

HOUR=$(date +%H:%M:%S)
echo "[${HOUR}]===[${ENV_TYPE}]==="

sudo docker-compose up -d

HOUR=$(date +%H:%M:%S)
echo "[${HOUR}]===[Finish]==="
