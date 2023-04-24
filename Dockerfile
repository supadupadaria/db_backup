FROM alpine:3.17

RUN apk update && apk add --no-cache postgresql-client bash

WORKDIR /usr/schedule

COPY backup_script.sh .

ADD https://dl.minio.io/client/mc/release/linux-amd64/mc .

RUN chmod +x backup_script.sh; chmod +x mc

CMD /usr/schedule/mc alias set s3 http://$(nslookup s3_minio | grep -A1 s3_minio | grep Address | cut -d' ' -f2):9000 ${MINIO_ROOT_USER} ${MINIO_ROOT_PASSWORD}; echo "${SCHEDULE} bash /usr/schedule/backup_script.sh >> /var/log/postgresql_backup.log 2>&1" >> /var/spool/cron/crontabs/root && crond -f
