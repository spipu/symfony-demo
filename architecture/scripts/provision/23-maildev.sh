#!/bin/bash

echo " > Mail - Install maildev"

npm install maildev@0.14.0 --global > /dev/null

NPM_PREFIX=$(npm config get prefix)
MAILDEV_BIN="${NPM_PREFIX}/bin/maildev"
MAILDEV_BIN=$(echo $MAILDEV_BIN | sed -e 's/[]\/&$*.^[]/\\&/g')

echo " > Mail - Configure"

if [[ "$ENV_TYPE" = "docker" ]]; then
    rm -f /etc/init.d/maildev
    cp $CONFIG_FOLDER/maildev/maildev.sh /etc/init.d/maildev
    chown root.root /etc/init.d/maildev
    chmod 755       /etc/init.d/maildev
    sed -i "s/{{MAILDEV_BIN}}/$MAILDEV_BIN/g" /etc/init.d/maildev

    update-rc.d maildev defaults
    /etc/init.d/maildev start
else
    rm -f /etc/systemd/system/maildev.service
    cp $CONFIG_FOLDER/maildev/maildev.service /etc/systemd/system/maildev.service
    chown root.root /etc/systemd/system/maildev.service
    chmod 644 /etc/systemd/system/maildev.service
    sed -i "s/{{MAILDEV_BIN}}/$MAILDEV_BIN/g" /etc/systemd/system/maildev.service

    systemctl -q enable maildev
    systemctl start maildev
fi

echo " > Mail - Install ssmtp"

apt-get -qq install -y ssmtp > /dev/null

echo " > Mail - Configure ssmtp"

rm -f /etc/ssmtp/ssmtp.conf
cp $CONFIG_FOLDER/maildev/ssmtp.conf /etc/ssmtp/ssmtp.conf
chown root.root /etc/ssmtp/ssmtp.conf
chmod 644 /etc/ssmtp/ssmtp.conf
sed -i "s/{{ENV_HOST}}/$ENV_HOST/g" /etc/ssmtp/ssmtp.conf
