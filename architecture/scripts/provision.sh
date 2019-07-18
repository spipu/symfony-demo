#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"
cd ../../

if [[ ! "$1" ]]; then
    echo "ERROR - You must provide a env_type parameter: lxd|lxc|docker"
    exit 1
fi
ENV_TYPE="$1"
ENV_DO_NOT_GENERATE="yes"
source ./architecture/conf/env.sh

CONFIG_FOLDER="$ENV_FOLDER/architecture/conf/dev"


echo "Provisioning for [$ENV_TYPE]"

ENV_FOLDER_SED=$(echo "$ENV_FOLDER" | sed -e 's/[\/&]/\\&/g')

export DEBIAN_FRONTEND=noninteractive

export LC_ALL=C

source ./architecture/scripts/provision/00-upgrade.sh
source ./architecture/scripts/provision/01-packages.sh
source ./architecture/scripts/provision/10-php.sh
source ./architecture/scripts/provision/11-apache.sh
source ./architecture/scripts/provision/12-mysql.sh
source ./architecture/scripts/provision/13-redis.sh
source ./architecture/scripts/provision/20-composer.sh
source ./architecture/scripts/provision/21-npm.sh
source ./architecture/scripts/provision/22-yarn.sh
source ./architecture/scripts/provision/23-maildev.sh
source ./architecture/scripts/provision/30-symfony.sh

export DEBIAN_FRONTEND=dialog
