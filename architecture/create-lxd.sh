#!/bin/bash

set -e

bashSource=$(readlink -f "${BASH_SOURCE[0]}")
cd "$(dirname "$bashSource")"
cd ../

ENV_TYPE="lxd"
source ./architecture/scripts/include/init.sh

cd ./architecture/vm/

HOUR=$(date +%H:%M:%S)
echo "[${HOUR}]===[${ENV_TYPE}]==="

lxd-remove
lxd-deploy
echo ""

cd - > /dev/null

source ./architecture/create-abstract.sh
