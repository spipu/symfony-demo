#!/bin/bash

echo " > SSL - Configuration"

SSL_FOLDER="/etc/ssl/dev-certs"
mkdir -p $SSL_FOLDER

rm -f $SSL_FOLDER/dev-cert.key
rm -f $SSL_FOLDER/dev-cert.crt

ln -s /etc/ssl/private/ssl-cert-snakeoil.key $SSL_FOLDER/dev-cert.key
ln -s /etc/ssl/certs/ssl-cert-snakeoil.pem   $SSL_FOLDER/dev-cert.crt

chmod 600 $SSL_FOLDER/*
