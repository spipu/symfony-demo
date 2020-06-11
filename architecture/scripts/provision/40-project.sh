#!/bin/bash

if [[ "$ENV_CODE" = "dev" ]]; then
    showMessage " > SASS - Install"

    npm install sass --loglevel=error --global > /dev/null

    showMessage " > Dev Scripts"

    rm -rf "/home/${ENV_USER}/mysql.sh"
    ln -s "/${ENV_FOLDER}/architecture/scripts/mysql.sh" "/home/${ENV_USER}/mysql.sh"
fi
