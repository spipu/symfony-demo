#!/bin/bash

showMessage " > Symfony - Configure"

if ! grep "APP_ENV" /etc/environment > /dev/null; then
    echo "export APP_ENV=$ENV_MODE" >> /etc/environment
fi

mkdir -p /etc/symfony
createFromTemplate "$CONFIG_FOLDER/symfony/app.yaml" "/etc/symfony/$ENV_NAME.yaml"

chmod 750 /etc/symfony
chmod 640 /etc/symfony/$ENV_NAME.yaml
chown root.www-data /etc/symfony
chown root.www-data /etc/symfony/$ENV_NAME.yaml
