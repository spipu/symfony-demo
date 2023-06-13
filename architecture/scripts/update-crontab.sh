#!/bin/bash

set -e

bashSource=$(readlink -f "${BASH_SOURCE[0]}")
cd "$(dirname "$bashSource")"
cd ../../

ENV_TYPE="none"
ENV_DO_NOT_GENERATE="yes"
source ./architecture/scripts/include/init.sh

showTitle "Update Crontab"

CRONTAB_FILE="${MAIN_FOLDER}/config/crontab"
CRONTAB_FILE_REPLACED="${CRONTAB_FILE}.local"
if [[ -f "$CRONTAB_FILE_REPLACED" ]]; then
  rm -f "$CRONTAB_FILE_REPLACED"
fi
cp "$CRONTAB_FILE" "$CRONTAB_FILE_REPLACED"
remplaceVariablesInFile "$CRONTAB_FILE_REPLACED"

sudo -u www-data crontab "$CRONTAB_FILE_REPLACED"

showMessage "End"
