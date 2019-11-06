#!/bin/bash

showMessage " > SSL DEV - Configuration"

mkdir -p $SSL_CERT_FOLDER

rm -f $SSL_CERT_PUBLIC
rm -f $SSL_CERT_PRIVATE
ln -s /etc/ssl/certs/ssl-cert-snakeoil.pem   $SSL_CERT_PUBLIC
ln -s /etc/ssl/private/ssl-cert-snakeoil.key $SSL_CERT_PRIVATE

chown root.root $SSL_CERT_FOLDER/*
chmod 600       $SSL_CERT_FOLDER/*
