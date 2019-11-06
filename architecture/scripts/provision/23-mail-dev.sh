#!/bin/bash

showMessage " > Mail DEV - Install"

npm install maildev --loglevel=error --global > /dev/null

NPM_PREFIX=$(npm config get prefix)
MAILDEV_BIN="${NPM_PREFIX}/bin/maildev"

showMessage " > Mail DEV - Configure"

if [[ "$ENV_TYPE" = "docker" ]]; then
    createFromTemplate "$CONFIG_FOLDER/maildev/maildev.sh" "/etc/init.d/maildev"
    remplaceVariableInFile "/etc/init.d/maildev" "MAILDEV_BIN" "$MAILDEV_BIN"

    chown root.root /etc/init.d/maildev
    chmod 755       /etc/init.d/maildev

    update-rc.d maildev defaults
    /etc/init.d/maildev start > /dev/null
else
    createFromTemplate "$CONFIG_FOLDER/maildev/maildev.service" "/etc/systemd/system/maildev.service"
    remplaceVariableInFile "/etc/systemd/system/maildev.service" "MAILDEV_BIN" "$MAILDEV_BIN"

    chown root.root /etc/systemd/system/maildev.service
    chown 644       /etc/systemd/system/maildev.service

    systemctl -q enable maildev
    systemctl start maildev
fi
