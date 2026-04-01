#!/bin/bash

showMessage " > Packages - SourceList"

rm -f /etc/apt/sources.list.d/ubuntu.sources
cat "${CONFIG_FOLDER}/apt/source.${ENV_ARCHITECTURE}.list" > /etc/apt/sources.list
