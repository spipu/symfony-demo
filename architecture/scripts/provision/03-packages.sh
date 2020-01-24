#!/bin/bash

showMessage " > Packages - Install"

apt-get -qq -y install \
    lsb-release gnupg inetutils-ping curl vim aptitude ca-certificates bash-completion \
    less lsof moreutils rsync net-tools screen strace tcpdump telnet \
    file unzip ntp acpid iotop dstat apt-transport-https tar wget zip bzip2 \
    sudo ssl-cert openssl gnupg2 \
    > /dev/null
