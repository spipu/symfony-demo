#!/bin/bash

set -e

bashSource=$(readlink -f "${BASH_SOURCE[0]}")
cd "$(dirname "$bashSource")"
cd ../../

ENV_DO_NOT_GENERATE="yes"
source ./architecture/scripts/include/init.sh

# Security on user
if [[ "$(whoami)" != "$ENV_USER" ]]; then
    showError "You must use the $ENV_USER user"
    exit 1
fi

# Release folder
RELEASE_FOLDER=$(date +%Y%m%d_%H%M%S)
FULL_FOLDER="$ENV_FOLDER/releases/$RELEASE_FOLDER"

# Force Branch to use
if [[ "$2" ]]; then
    GIT_BRANCH="$2"
fi

# Shared Folders Management
function manageSharedFolder() {
    echo "   - [$1]"

    sharedFolder="$ENV_FOLDER/shared/$1"
    projectFolder="$FULL_FOLDER/website/$1"

    if [[ ! -d "$sharedFolder" ]]; then
      mkdir -p  "$sharedFolder"
    fi

    if [[ -d "$projectFolder" ]]; then
      rm -rf    "$projectFolder"
    fi

    chmod 775 "$sharedFolder"
    ln -s     "$sharedFolder" "$projectFolder"
}

showMessage "Start"

# Resume
echo "Project Delivery"
echo "  url:    $GIT_PROJECT"
echo "  branch: $GIT_BRANCH"
echo "  folder: $FULL_FOLDER"
echo ""

# The release folder must not exist
if [[ -d "$FULL_FOLDER" ]]; then
    showError "Release folder already exists"
    exit 1
fi

echo " => Prepare Folders"
mkdir -p "$ENV_FOLDER/releases"
mkdir -p "$ENV_FOLDER/shared"

echo " => Clone from GIT"
git clone "$GIT_PROJECT" -q -b "$GIT_BRANCH" "$FULL_FOLDER"
# The release folder must exist
if [[ ! -d "$FULL_FOLDER" ]]; then
    showError "Release folder does not exist"
    exit 1
fi

echo " => Clean release"
rm -rf "$FULL_FOLDER/.git"
rm -rf "$FULL_FOLDER/.gitignore"
rm -rf "$FULL_FOLDER/architecture"
rm -rf "$FULL_FOLDER/doc"
rm -rf "$FULL_FOLDER/quality"

echo " => Permissions"
chmod +x  $FULL_FOLDER/website/bin/*
mkdir -p  "$FULL_FOLDER/website/var"
chmod 775 "$FULL_FOLDER/website/var"

echo " => Shared Folders"
manageSharedFolder "public/media"
manageSharedFolder "var/log"
manageSharedFolder "var/export"
manageSharedFolder "var/import"
mkdir -p  "$ENV_FOLDER/shared/public/media/config"
chmod 775 "$ENV_FOLDER/shared/public/media/config"

echo " => Composer Install"
composer install -n -d "$FULL_FOLDER/website"
if [[ "$?" -ne 0 ]]; then
  showError "On composer install"
  exit 1
fi

echo " => Flush Redis Cache"
redis-cli -p 6379 flushall > /dev/null

echo " => Schema Update"
"$FULL_FOLDER/website/bin/console" doctrine:schema:update --force --dump-sql --complete
if [[ "$?" -ne 0 ]]; then
  showError "On schema update"
  exit 1
fi

echo " => Clean Cache"
rm -rf "$FULL_FOLDER/website/var/cache" > /dev/null 2>&1
sudo -u www-data rm -rf "$FULL_FOLDER/website/var/cache" > /dev/null 2>&1
redis-cli -p 6379 flushall > /dev/null

echo " => Load Fixtures"
sudo -u www-data "$FULL_FOLDER/website/bin/console" spipu:fixtures:load
if [[ "$?" -ne 0 ]]; then
  showError "On load fixtures"
  exit 1
fi

echo " => Active"
rm -f "$ENV_FOLDER/current"
ln -s "$FULL_FOLDER/website" "$ENV_FOLDER/current"

echo " => Clean PHP-FPM cache"
sudo systemctl reload php7.2-fpm.service

CRONTAB_FILE="$FULL_FOLDER/website/config/crontab"
if [[ -f "$CRONTAB_FILE" ]]; then
    echo " => Configure Crontab - www-data"
    remplaceVariablesInFile "$CRONTAB_FILE"
    sudo -u www-data crontab "$CRONTAB_FILE"
fi

echo " => Clean Old Releases"
RELEASES=$(find "$ENV_FOLDER/releases" -mindepth 1 -maxdepth 1 -type d | sort | head -n "-$RELEASES_TO_KEEP")
for RELEASE in ${RELEASES} ; do
    echo "  - $RELEASE"
    sudo -u www-data rm -rf $RELEASE/website/var/* > /dev/null 2>&1
    rm -rf "$RELEASE" > /dev/null
done

showMessage "Finished"
