#!/bin/bash

echo " > Mail - Install maildev"

npm install maildev --loglevel=error --global > /dev/null

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
    /etc/init.d/maildev start > /dev/null
else
    rm -f /etc/systemd/system/maildev.service
    cp $CONFIG_FOLDER/maildev/maildev.service /etc/systemd/system/maildev.service
    chown root.root /etc/systemd/system/maildev.service
    chmod 644 /etc/systemd/system/maildev.service
    sed -i "s/{{MAILDEV_BIN}}/$MAILDEV_BIN/g" /etc/systemd/system/maildev.service

    systemctl -q enable maildev
    systemctl start maildev
fi
