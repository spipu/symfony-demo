#!/bin/bash

set -e

bashSource=$(readlink -f "${BASH_SOURCE[0]}")
cd "$(dirname "$bashSource")"
cd ../../

ENV_DO_NOT_GENERATE="yes"
source ./architecture/scripts/include/init.sh

$ENV_FOLDER/architecture/scripts/provision.sh   "$ENV_TYPE"
$ENV_FOLDER/architecture/scripts/createDb.sh    "$ENV_TYPE"
$ENV_FOLDER/architecture/scripts/permissions.sh "$ENV_TYPE"

su "$ENV_USER" -c "$ENV_FOLDER/architecture/scripts/test.sh \"$ENV_TYPE\""
su "$ENV_USER" -c "$ENV_FOLDER/architecture/scripts/install.sh \"$ENV_TYPE\""
su "$ENV_USER" -c "$ENV_FOLDER/architecture/scripts/update-crontab.sh \"$ENV_TYPE\""
