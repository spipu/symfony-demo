#!/bin/bash

if [[ "$ENV_ARCHITECTURE" != "arm" ]]; then
  source ./$ARCHITECTURE_FOLDER/scripts/provision/12-mysql-maria.sh
else
  source ./$ARCHITECTURE_FOLDER/scripts/provision/12-mysql-oracle.sh
fi
