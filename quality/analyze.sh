#!/bin/bash

cd "$( dirname "${BASH_SOURCE[0]}" )"
cd ../website/

LOG_FOLDER="../quality/build/"

rm -rf $LOG_FOLDER
mkdir -p $LOG_FOLDER

./vendor/bin/phpqa \
    --analyzedDirs "src" \
    --ignoredDirs "vendor" \
    --tools "phpmetrics,phploc,pdepend,phpcs:0,phpmd:0,phpcpd:0,parallel-lint:0" \
    --config "./" \
    --buildDir "$LOG_FOLDER" \
    --report "offline" \
    --execution "no-parallel"

firefox "${LOG_FOLDER}phpqa.html"
