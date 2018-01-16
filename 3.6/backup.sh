#!/bin/bash
set -e

echo "Job started: $(date)"

DATE=$(date +%Y%m%d_%H%M%S)
FILE="/data/backup/backup-$DATE.tar.gz"

mkdir -p dump
mongodump -h $MONGO_HOST -p $MONGO_PORT --username $MONGO_USER --password $MONGO_PASS
tar -zcvf $FILE dump/
rm -rf dump/

echo "Job finished: $(date)"
