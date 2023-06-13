#!/bin/bash

showMessage " > Node - Repository"

curl -fsSL https://deb.nodesource.com/setup_18.x | bash - > /dev/null
apt-get -qq update  > /dev/null

showMessage " > Node - Install"

apt-get -qq install -y nodejs > /dev/null
npm install -g npm@9 > /dev/null

showMessage " > Node - Version"

node --version

showMessage " > Npm - Version"

npm --version
