#!/bin/bash

showMessage " > Packages DEV - Install"

apt-get -qq -y install \
    graphviz \
    > /dev/null
