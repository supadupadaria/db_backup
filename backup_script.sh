#!/bin/bash

export PGPASSWORD

pg_dumpall -U postgres -h database | gzip -9 | /usr/schedule/mc pipe s3/backups/postgres-backup-$(date "+%Y-%m-%d_%H-%M").sql.gz
