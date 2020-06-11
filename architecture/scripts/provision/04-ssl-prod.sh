#!/bin/bash

showMessage " > SSL PROD - Check"

if [[ ! -f "$SSL_CERT_PUBLIC" ]]; then
    showError "The Public Certificat File is missing"
    exit 1
fi

if [[ ! -f "$SSL_CERT_PRIVATE" ]]; then
    showError "The Private Certificat File is missing"
    exit 1
fi

if [[ ! -f "$SSL_CERT_CHAIN" ]]; then
    showError "The Chain Certificat File is missing"
    exit 1
fi

chown root.root $SSL_CERT_FOLDER/*
chmod 600       $SSL_CERT_FOLDER/*
