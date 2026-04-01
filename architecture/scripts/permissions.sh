#!/bin/bash

set -e

CURRENT_SCRIPT=$(readlink -f "${BASH_SOURCE[0]}")
ARCHITECTURE_FOLDER=$(basename "$(dirname "$(dirname "$CURRENT_SCRIPT")")")

cd "$(dirname "$CURRENT_SCRIPT")"
cd ../../

ENV_DO_NOT_GENERATE="yes"
source ./$ARCHITECTURE_FOLDER/scripts/include/init.sh

showTitle "Permissions"

mkdir -p ${MAIN_FOLDER}/var
chown -R www-data:www-data ${MAIN_FOLDER}/var
chmod -R 666 ${MAIN_FOLDER}/var
chmod -R +X ${MAIN_FOLDER}/var

chmod +x ${MAIN_FOLDER}/bin/*

rm -rf   ${MAIN_FOLDER}/public/media/config > /dev/null
mkdir -p ${MAIN_FOLDER}/public/media/config
chown -R www-data:www-data ${MAIN_FOLDER}/public/media/config
chmod -R 775               ${MAIN_FOLDER}/public/media/config
