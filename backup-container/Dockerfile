FROM alpine:latest

COPY ./scripts/daily/* /etc/periodic/daily
COPY ./scripts/daily/* /etc/periodic/15min

RUN chmod u+x /etc/periodic/daily/backup.sh

RUN apk update && \
    apk upgrade && \
    apk add --no-cache mariadb-client && \
    chmod a+x /etc/periodic/daily/*