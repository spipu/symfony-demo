#!/bin/bash

set -e

bashSource=$(readlink -f "${BASH_SOURCE[0]}")
cd "$(dirname "$bashSource")"
cd ../

ENV_DO_NOT_GENERATE="yes"
source ./architecture/scripts/include/init.sh

if [[ ! "$ENV_USER_SUDO" ]]; then
    showError "This environment is not compatible"
    exit 1
fi

showTitle "Send Architecture"

showMessage " => Send folder"

ssh ${ENV_USER_SUDO}@${ENV_HOST} "rm -rf /home/${ENV_USER_SUDO}/architecture"
scp -qr ./architecture ${ENV_USER_SUDO}@${ENV_HOST}:/home/${ENV_USER_SUDO}/

showMessage " => Remove useless files"

ssh ${ENV_USER_SUDO}@${ENV_HOST} "rm -rf /home/${ENV_USER_SUDO}/architecture/vm"
ssh ${ENV_USER_SUDO}@${ENV_HOST} "rm -rf /home/${ENV_USER_SUDO}/architecture/*.sh"
ssh ${ENV_USER_SUDO}@${ENV_HOST} "rm -rf /home/${ENV_USER_SUDO}/architecture/*.ps1"

showMessage " => Remove other environments configuration"

for code in "${ENVIRONMENTS[@]}"; do
    if [[ "$ENV_TYPE" != "$code" ]]; then
        ssh ${ENV_USER_SUDO}@${ENV_HOST} "rm -rf /home/${ENV_USER_SUDO}/architecture/conf/env_$code.sh"
    fi
done

showMessage " => Add some links"

ssh ${ENV_USER}@${ENV_HOST} "rm -rf /home/${ENV_USER}/deliver.sh"
ssh ${ENV_USER}@${ENV_HOST} "rm -rf /home/${ENV_USER}/mysql.sh"
ssh ${ENV_USER}@${ENV_HOST} "ln -s /home/${ENV_USER_SUDO}/architecture/scripts/deliver.sh /home/${ENV_USER}/deliver.sh"
ssh ${ENV_USER}@${ENV_HOST} "ln -s /home/${ENV_USER_SUDO}/architecture/scripts/mysql.sh   /home/${ENV_USER}/mysql.sh"

showMessage " => Finished"
