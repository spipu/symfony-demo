#!/bin/bash

ENV_TYPE="preprod"
ENV_MODE="prod"
ENV_CODE="preprod"
ENV_HOST="preprod.website.fr"
ENV_DO_NOT_GENERATE="yes"
WEB_FOLDER="current"

# MySQL
DB_PASS="xxxxxxxxxxxxxxxxxxxx"

# SSL
SSL_CERT_FOLDER="/etc/website/certs"
SSL_CERT_PUBLIC="${SSL_CERT_FOLDER}/website.crt"
SSL_CERT_PRIVATE="${SSL_CERT_FOLDER}/website.key"

# Apache
EXPORT_FOLDER="$ENV_FOLDER/shared/var/export/"

# Symfony
APP_SECRET="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"

# SSH
ENV_USER_SUDO="ubuntu"
