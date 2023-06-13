#!/bin/bash

showMessage " > Yarn - Repo"

curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee /usr/share/keyrings/yarnkey.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | tee /etc/apt/sources.list.d/yarn.list > /dev/null
apt-get -qq update  > /dev/null

showMessage " > Yarn - Install"

apt-get -qq install -y yarn    > /dev/null
