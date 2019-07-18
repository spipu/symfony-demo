#!/bin/bash

echo " > Symfony - Configure"

echo "export APP_ENV=dev" >> /etc/environment

mkdir -p /etc/symfony
rm -f /etc/symfony/$ENV_NAME.yaml
cp $CONFIG_FOLDER/symfony/app.yaml /etc/symfony/$ENV_NAME.yaml
sed -i "s/{{ENV_NAME}}/$ENV_NAME/g" /etc/symfony/$ENV_NAME.yaml

chmod 750 /etc/symfony
chmod 640 /etc/symfony/$ENV_NAME.yaml
chown root.www-data /etc/symfony
chown root.www-data /etc/symfony/$ENV_NAME.yaml
