#!/bin/bash

showMessage " > Symfony - Configure"

if ! grep "APP_ENV" /etc/environment > /dev/null; then
    echo "export APP_ENV=$ENV_MODE" >> /etc/environment
fi


# Create the etc folder
ETC_FOLDER="/etc/$ENV_NAME"
mkdir -p "$ETC_FOLDER"
chmod 750 "$ETC_FOLDER"
chown root.www-data "$ETC_FOLDER"

# Generate the keypair
KEY_PAIR_FILENAME="$ETC_FOLDER/key_pair.ppk"
if [[ ! -f "$KEY_PAIR_FILENAME" ]]; then
  php -r "echo sodium_bin2base64(sodium_crypto_box_keypair(), SODIUM_BASE64_VARIANT_ORIGINAL);" > "$KEY_PAIR_FILENAME"
  chown root.root "$KEY_PAIR_FILENAME"
  chmod 600 "$KEY_PAIR_FILENAME"
fi
KEY_PAIR=$(cat "$KEY_PAIR_FILENAME")

# Prepare the symfony configuration file
createFromTemplate "$CONFIG_FOLDER/symfony/app.yaml" "$ETC_FOLDER/symfony.yaml"
remplaceVariableInFile "$ETC_FOLDER/symfony.yaml" "APP_ENCRYPTOR_KEY_PAIR" "$KEY_PAIR"
chmod 640 "$ETC_FOLDER/symfony.yaml"
chown root.www-data "$ETC_FOLDER/symfony.yaml"
