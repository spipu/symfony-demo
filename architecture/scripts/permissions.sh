#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"
cd ../../

ENV_TYPE="none"
ENV_DO_NOT_GENERATE="yes"
source ./architecture/conf/env.sh

MAIN_FOLDER="${ENV_FOLDER}/${WEB_FOLDER}"

mkdir -p ${MAIN_FOLDER}/var
chown -R www-data.www-data ${MAIN_FOLDER}/var
chmod -R 664 ${MAIN_FOLDER}/var
chmod -R +X ${MAIN_FOLDER}/var

chmod +X ${MAIN_FOLDER}/bin/*

rm -rf   ${MAIN_FOLDER}/public/media/config > /dev/null
mkdir -p ${MAIN_FOLDER}/public/media/config
chown -R www-data.www-data ${MAIN_FOLDER}/public/media/config
chmod -R 775               ${MAIN_FOLDER}/public/media/config
