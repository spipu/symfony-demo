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
echo "[${HOUR}]===[PROVISION]==="
ssh root@${ENV_HOST} -p ${ENV_SSH_PORT} $ENV_FOLDER/architecture/scripts/provision.sh "$ENV_TYPE"

HOUR=$(date +%H:%M:%S)
echo "[${HOUR}]===[CREATE DATABASE]==="
ssh root@${ENV_HOST} -p ${ENV_SSH_PORT} $ENV_FOLDER/architecture/scripts/createDb.sh "$ENV_TYPE"

HOUR=$(date +%H:%M:%S)
echo "[${HOUR}]===[PERMISSION]==="
ssh root@${ENV_HOST} -p ${ENV_SSH_PORT} $ENV_FOLDER/architecture/scripts/permissions.sh "$ENV_TYPE"

HOUR=$(date +%H:%M:%S)
echo "[${HOUR}]===[TEST]==="
ssh ${ENV_USER}@${ENV_HOST} -p ${ENV_SSH_PORT} $ENV_FOLDER/architecture/scripts/test.sh "$ENV_TYPE"

HOUR=$(date +%H:%M:%S)
echo "[${HOUR}]===[INSTALL]==="
ssh ${ENV_USER}@${ENV_HOST} -p ${ENV_SSH_PORT} $ENV_FOLDER/architecture/scripts/install.sh

HOUR=$(date +%H:%M:%S)
echo "[${HOUR}]===[RESTART HOST APACHE]==="
sudo systemctl restart apache2

HOUR=$(date +%H:%M:%S)
echo "[${HOUR}]===[FINISHED]==="
