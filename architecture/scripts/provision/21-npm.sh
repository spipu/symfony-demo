#!/bin/bash

showMessage " > Node - Repository"

NODE_MAJOR=20

mkdir -p /etc/apt/keyrings
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg  > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list
apt-get -qq update  > /dev/null

showMessage " > Node - Install"

apt-get -qq install -y nodejs > /dev/null

showMessage " > Node - NPM Update"

npm update -g npm > /dev/null

showMessage " > Node - Version"

node --version

showMessage " > Npm - Version"

npm --version
