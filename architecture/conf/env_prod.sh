#!/bin/bash

ENV_TYPE="prod"
ENV_MODE="prod"
ENV_CODE="prod"
ENV_HOST="www.website.fr"
ENV_DO_NOT_GENERATE="yes"
WEB_FOLDER="current"

# MySQL
DB_PASS="xxxxxxxxxxxxxxxxxxxx"

# PHP
PHP_DISPLAY_ERRORS="False"

# SSL
SSL_CERT_FOLDER="/etc/website/certs"
SSL_CERT_PUBLIC="${SSL_CERT_FOLDER}/website.crt"
SSL_CERT_PRIVATE="${SSL_CERT_FOLDER}/website.key"

# Apache
APACHE_PROTECT_ADMIN="xx.xx.xx.xx"
EXPORT_FOLDER="$ENV_FOLDER/shared/var/export/"

# Symfony
APP_SECRET="xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
APP_MAILER="sendmail"

# SSH
ENV_USER_SUDO="ubuntu"
