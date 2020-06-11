#!/bin/bash

if [[ ! "${WEB_FOLDER}" ]]; then
  echo "ERROR - You must not call this script directly"
  exit 1
fi

HOUR=$(date +%H:%M:%S)
echo "[${HOUR}]===[CLEAN]==="
sudo rm -rf ./${WEB_FOLDER}/var
echo ""

HOUR=$(date +%H:%M:%S)
echo "[${HOUR}]===[PREPAPE ALL]==="

ssh root@${ENV_HOST} -p ${ENV_SSH_PORT} $ENV_FOLDER/architecture/scripts/prepare-all.sh "$ENV_TYPE"

HOUR=$(date +%H:%M:%S)
echo "[${HOUR}]===[FINISHED]==="
