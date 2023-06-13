#!/bin/bash

showMessage " > Packages - SourceList"

cat "${CONFIG_FOLDER}/apt/source.${ENV_ARCHITECTURE}.list" > /etc/apt/sources.list
