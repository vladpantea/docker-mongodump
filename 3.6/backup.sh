#!/bin/bash

set -e

echo "Cleanup backup job started at: $(date)"
#directory with database dump
DIRECTORY=/data/backup/*
#1 week old date(decimal)
WEEKOLD=$(date -d last-week +%s)

#check all dump files age
for file in $DIRECTORY
do
    FILEAGE=$(date -r $file +%s)
    
    if [ ${WEEKOLD#*.} \> ${FILEAGE#*.} ];    
    then
        echo "Delete $file ..."
        rm $file
    fi    
done

echo "Backup job started at: $(date)"
DATE=$(date +%Y%m%d_%H%M%S)
FILE="/data/backup/backup-$DATE.tar.gz"

mkdir -p dump
mongodump -h $MONGO_HOST -p $MONGO_PORT
tar -zcvf $FILE dump/
rm -rf dump/
echo "Job finished: $(date)"
