#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"
cd ../../../

source ./architecture/scripts/provision/00-delivery-user.sh
source ./architecture/scripts/provision/02-upgrade.sh
source ./architecture/scripts/provision/03-packages.sh
source ./architecture/scripts/provision/04-ssl-prod.sh
source ./architecture/scripts/provision/10-php.sh
source ./architecture/scripts/provision/11-apache.sh
source ./architecture/scripts/provision/12-mysql.sh
source ./architecture/scripts/provision/13-redis.sh
source ./architecture/scripts/provision/20-composer.sh
source ./architecture/scripts/provision/21-npm.sh
if [[ "$APP_USE_YARN" = "yes" ]]; then
    source ./architecture/scripts/provision/22-yarn.sh
fi
source ./architecture/scripts/provision/23-mail-dev.sh
source ./architecture/scripts/provision/30-symfony.sh
source ./architecture/scripts/provision/40-project.sh
