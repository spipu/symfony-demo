#!/bin/bash

echo " > Node - Install"

apt-get -qq install -y bzip2 xz-utils > /dev/null
apt-get -qq install -y nodejs npm > /dev/null
