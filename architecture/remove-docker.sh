#!/bin/bash

set -e

if [[ -d "/opt/homebrew/opt/gnu-sed/libexec/gnubin" ]]; then
  PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"
  bashSource=$(greadlink -f "${BASH_SOURCE[0]}")
elif [[ -d "/opt/local/opt/gnu-sed/libexec/gnubin" ]]; then
  PATH="/opt/local/opt/gnu-sed/libexec/gnubin:$PATH"
  bashSource=$(greadlink -f "${BASH_SOURCE[0]}")
else
  bashSource=$(readlink -f "${BASH_SOURCE[0]}")
fi

cd "$(dirname "$bashSource")"
cd ../

ENV_TYPE="docker"
source ./architecture/scripts/include/init.sh

cd ./architecture/vm/

HOUR=$(date +%H:%M:%S)
echo "[${HOUR}]===[${ENV_TYPE}]==="

ssh-keygen -R "${ENV_HOST}"
ssh-keygen -R "${ENV_IP}"

sudo sed "/${ENV_HOST}/d" -i /etc/hosts

sudo docker-compose down -v

cd - > /dev/null
echo ""
