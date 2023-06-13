#!/bin/bash

# Generic Parameters
ENV_NAME="symfonydemo"
ENV_HOST="${ENV_NAME}.lxc"
ENV_SSH_PORT="22"
ENV_MODE="dev"
ENV_CODE="dev"
ENV_USER="delivery"
ENV_FOLDER="/var/www/$ENV_NAME"
WEB_FOLDER="website"

# Hosts
ENV_HOST_SUB_HOSTS=(
)
ENV_HOST_SUB_HOSTS_TXT=""

# Delivery
GIT_PROJECT="git@github.com:spipu/symfony-demo.git"
GIT_BRANCH="master"
RELEASES_TO_KEEP=5

# MySQL
DB_NAME="$ENV_NAME"
DB_USER="$ENV_NAME"
DB_PASS="$ENV_NAME"

# PHP
PHP_DISPLAY_ERRORS="True"

# SSL
SSL_CERT_FOLDER="/etc/ssl/dev-certs"
SSL_CERT_PUBLIC="${SSL_CERT_FOLDER}/dev-cert.crt"
SSL_CERT_PRIVATE="${SSL_CERT_FOLDER}/dev-cert.key"
SSL_CERT_CHAIN="${SSL_CERT_FOLDER}/dev-cert.key"

# Apache
APACHE_PROTECT_ADMIN="all"
EXPORT_FOLDER="$ENV_FOLDER/$WEB_FOLDER/var/export/"

# Symfony
APP_SECRET="ce96b39e4a36d3541ec8b232186267ee"
APP_MAILER="smtp://127.0.0.1:1025"
APP_SESSION_HANDLER="app.session.handler"
