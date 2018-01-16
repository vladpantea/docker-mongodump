#!/bin/bash

set -e

CRON_SCHEDULE=${CRON_SCHEDULE:-0 1 * * *}
MONGO_HOST=${MONGO_HOST:-"mongo"}
MONGO_PORT=${MONGO_PORT:-"27017"}
MONGO_USER=${MONGO_USER:-"johndoe"}
MONGO_PASS=${MONGO_PASS:-"secret"}

if [[ "$1" == 'no-cron' ]]; then
    exec /backup.sh
else
    LOGFIFO='/var/log/cron.fifo'
    if [[ ! -e "$LOGFIFO" ]]; then
        mkfifo "$LOGFIFO"
    fi
    
    CRON_ENV="MONGO_HOST='$MONGO_HOST'"
    CRON_ENV="$CRON_ENV\nMONGO_PORT='$MONGO_PORT'"
    CRON_ENV="$CRON_ENV\nMONGO_USER='$MONGO_USER'"
    CRON_ENV="$CRON_ENV\nMONGO_PASS='$MONGO_PASS'"
    echo -e "$CRON_ENV\n$CRON_SCHEDULE /backup.sh > $LOGFIFO 2>&1" | crontab -
    crontab -l
    cron
    tail -f "$LOGFIFO"
fi
