#!/bin/bash

echo " > Apache - Install"

PHP_VERSION="7.2"

apt-get -qq -y install \
    apache2 \
    libapache2-mod-xsendfile \
    libapache2-mod-php${PHP_VERSION} \
     > /dev/null

echo " > Apache - Configure"
a2enmod rewrite > /dev/null
a2enmod headers > /dev/null

echo "ServerName $ENV_HOST" >> /etc/apache2/apache2.conf

rm -f /etc/apache2/sites-available/*
cp $CONFIG_FOLDER/apache/virtualhost.conf   /etc/apache2/sites-available/$ENV_NAME.conf
sed -i "s/{{ENV_NAME}}/$ENV_NAME/g"         /etc/apache2/sites-available/$ENV_NAME.conf
sed -i "s/{{ENV_HOST}}/$ENV_HOST/g"         /etc/apache2/sites-available/$ENV_NAME.conf
sed -i "s/{{ENV_FOLDER}}/$ENV_FOLDER_SED/g" /etc/apache2/sites-available/$ENV_NAME.conf
sed -i "s/{{WEB_FOLDER}}/$WEB_FOLDER/g"     /etc/apache2/sites-available/$ENV_NAME.conf

rm -f /etc/apache2/sites-enabled/*
ln -s /etc/apache2/sites-available/$ENV_NAME.conf /etc/apache2/sites-enabled/

echo " > Apache - Service"

if [[ "$ENV_TYPE" = "docker" ]]; then
    /etc/init.d/apache2 restart > /dev/null
else
    systemctl restart apache2 > /dev/null
fi
