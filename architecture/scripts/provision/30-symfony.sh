#!/bin/bash

echo " > Symfony - Configure"

if ! grep "APP_ENV" /etc/environment > /dev/null; then
    echo "export APP_ENV=$ENV_MODE" >> /etc/environment
fi

mkdir -p /etc/symfony
rm -f /etc/symfony/$ENV_NAME.yaml
cp $CONFIG_FOLDER/symfony/app.yaml  /etc/symfony/$ENV_NAME.yaml
sed -i "s/{{ENV_NAME}}/$ENV_NAME/g"     /etc/symfony/$ENV_NAME.yaml
sed -i "s/{{ENV_MODE}}/$ENV_MODE/g"     /etc/symfony/$ENV_NAME.yaml
sed -i "s/{{ENV_CODE}}/$ENV_CODE/g"     /etc/symfony/$ENV_NAME.yaml
sed -i "s/{{DB_NAME}}/$DB_NAME/g"       /etc/symfony/$ENV_NAME.yaml
sed -i "s/{{DB_USER}}/$DB_USER/g"       /etc/symfony/$ENV_NAME.yaml
sed -i "s/{{DB_PASS}}/$DB_PASS/g"       /etc/symfony/$ENV_NAME.yaml
sed -i "s/{{APP_SECRET}}/$APP_SECRET/g" /etc/symfony/$ENV_NAME.yaml

if [[ "${ENV_MODE}" == "dev" ]]; then
   sed -i "s/{{APP_MAILER}}/smtp\:\/\/127\.0\.0\.1\:1025\?encryption=\&auth_mode=/g" /etc/symfony/$ENV_NAME.yaml
fi

chmod 750 /etc/symfony
chmod 640 /etc/symfony/$ENV_NAME.yaml
chown root.www-data /etc/symfony
chown root.www-data /etc/symfony/$ENV_NAME.yaml
