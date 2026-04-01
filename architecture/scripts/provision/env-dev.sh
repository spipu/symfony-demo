#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"
cd ../../../

source ./$ARCHITECTURE_FOLDER/scripts/provision/00-delivery-user.sh
source ./$ARCHITECTURE_FOLDER/scripts/provision/01-repo.sh
source ./$ARCHITECTURE_FOLDER/scripts/provision/02-upgrade.sh
source ./$ARCHITECTURE_FOLDER/scripts/provision/03-packages.sh
source ./$ARCHITECTURE_FOLDER/scripts/provision/03-packages-dev.sh
source ./$ARCHITECTURE_FOLDER/scripts/provision/04-ssl-dev.sh
source ./$ARCHITECTURE_FOLDER/scripts/provision/10-php.sh
source ./$ARCHITECTURE_FOLDER/scripts/provision/10-php-dev.sh
source ./$ARCHITECTURE_FOLDER/scripts/provision/11-apache.sh
source ./$ARCHITECTURE_FOLDER/scripts/provision/12-mysql.sh
source ./$ARCHITECTURE_FOLDER/scripts/provision/13-redis.sh
source ./$ARCHITECTURE_FOLDER/scripts/provision/20-composer.sh
source ./$ARCHITECTURE_FOLDER/scripts/provision/21-npm.sh
source ./$ARCHITECTURE_FOLDER/scripts/provision/22-yarn.sh
source ./$ARCHITECTURE_FOLDER/scripts/provision/23-mail-dev.sh
source ./$ARCHITECTURE_FOLDER/scripts/provision/30-symfony.sh
source ./$ARCHITECTURE_FOLDER/scripts/provision/40-project.sh
