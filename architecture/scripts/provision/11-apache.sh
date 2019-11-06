#!/bin/bash

showMessage " > Apache - Install"

apt-get -qq -y install \
    apache2 \
    libapache2-mod-xsendfile \
     > /dev/null

showMessage " > Apache - Configure"

a2enmod deflate    > /dev/null
a2enmod expires    > /dev/null
a2enmod headers    > /dev/null
a2enmod proxy_fcgi > /dev/null
a2enmod remoteip   > /dev/null
a2enmod rewrite    > /dev/null
a2enmod ssl        > /dev/null

if ! grep "$ENV_NAME" /etc/apache2/apache2.conf > /dev/null; then
    echo "# Added by $ENV_NAME Provisioning" >> /etc/apache2/apache2.conf
    echo "ServerName $ENV_HOST"              >> /etc/apache2/apache2.conf
fi

rm -f /etc/apache2/sites-available/*
rm -f /etc/apache2/sites-enabled/*

createFromTemplate "$CONFIG_FOLDER/apache/virtualhost.conf" "/etc/apache2/sites-available/$ENV_NAME.conf"
ln -s /etc/apache2/sites-available/$ENV_NAME.conf /etc/apache2/sites-enabled/

showMessage " > Apache - Prepare Document Root"
rm -rf /var/www/html
if [[ ! -d "$ENV_FOLDER/$WEB_FOLDER/public" ]]; then
    sudo -u $ENV_USER mkdir -p $ENV_FOLDER/$WEB_FOLDER/public
    echo "HTTPS Access Point" > $ENV_FOLDER/$WEB_FOLDER/public/index.php
    chown $ENV_USER.www-data $ENV_FOLDER/$WEB_FOLDER/public/index.php
fi

showMessage " > Apache - Service"

if [[ "$ENV_TYPE" = "docker" ]]; then
    /etc/init.d/apache2 restart > /dev/null
else
    systemctl restart apache2 > /dev/null
fi
