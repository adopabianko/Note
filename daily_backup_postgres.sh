#!/bin/bash
#
# Backup database postgre perhari by ado ganteng.
# buat file di ~/.pgpass isinya localhost:5432:*:postgres:postgres
# buat crobjob 
# $ crontab -e isikan /home/ado/daily_backup_postgres.sh

BACKUP_DIR=/home/ado/backup_posgtres
DAYS_TO_KEEP=7
FILE_SUFFIX=_db_test.sql
HOST=localhost
DATABASE=db_test
USER=postgres

FILE=`date +"%Y%m%d%H%M"`${FILE_SUFFIX}

OUTPUT_FILE=${BACKUP_DIR}/${FILE}

# Backup db
pg_dump -U ${USER} -h ${HOST} --format=plain --no-owner --no-acl ${DATABASE} | sed -E 's/(DROP|CREATE|COMMENT ON) EXTENSION/-- \1 EXTENSION/g' > ${OUTPUT_FILE}

# gzip file backup nya
gzip $OUTPUT_FILE

# show result
echo "${OUTPUT_FILE}.gz was created:"
ls -l ${OUTPUT_FILE}.gz

# prune old backups
find $BACKUP_DIR -maxdepth 1 -mtime +$DAYS_TO_KEEP -name "*${FILE_SUFFIX}.gz" -exec rm -rf '{}' ';'
