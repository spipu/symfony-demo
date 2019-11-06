#!/bin/bash

showMessage " > Yarn - Install"

curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - > /dev/null 2>&1
echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list

apt-get -qq update  > /dev/null
apt-get -qq install -y yarn    > /dev/null
