#!/bin/bash

echo " > Node - Install"

curl -sSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | apt-key add -  > /dev/null 2>&1
echo 'deb https://deb.nodesource.com/node_10.x bionic main'     >  /etc/apt/sources.list.d/nodesource.list
echo 'deb-src https://deb.nodesource.com/node_10.x bionic main' >> /etc/apt/sources.list.d/nodesource.list

apt-get -qq update  > /dev/null
apt-get -qq install -y nodejs > /dev/null
