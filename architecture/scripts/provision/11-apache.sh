#!/bin/bash

echo " > Apache - Install"

apt-get -qq -y install \
    apache2 \
    libapache2-mod-xsendfile \
     > /dev/null

echo " > Apache - Configure"
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
cp $CONFIG_FOLDER/apache/virtualhost.conf   /etc/apache2/sites-available/$ENV_NAME.conf
sed -i "s/{{ENV_NAME}}/$ENV_NAME/g"         /etc/apache2/sites-available/$ENV_NAME.conf
sed -i "s/{{ENV_HOST}}/$ENV_HOST/g"         /etc/apache2/sites-available/$ENV_NAME.conf
sed -i "s/{{ENV_MODE}}/$ENV_MODE/g"         /etc/apache2/sites-available/$ENV_NAME.conf
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
