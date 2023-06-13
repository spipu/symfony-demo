#!/bin/bash

showMessage " > Packages - Install"

apt-get -qq -y install \
    lsb-release gnupg inetutils-ping curl vim aptitude ca-certificates bash-completion \
    less lsof moreutils rsync net-tools screen strace tcpdump telnet \
    file unzip ntp acpid iotop dstat apt-transport-https tar wget zip bzip2 \
    sudo ssl-cert openssl gnupg2 git cron sshpass tzdata \
    > /dev/null

showMessage " > Timezone - Configure"

APP_TIMEZONE="Europe/Paris"

if [[ "$ENV_TYPE" = "docker" ]]; then
  ln -fs "/usr/share/zoneinfo/${APP_TIMEZONE}" /etc/localtime
  dpkg-reconfigure -f noninteractive tzdata
else
  timedatectl set-timezone "${APP_TIMEZONE}"
fi
