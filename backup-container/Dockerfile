FROM alpine:latest

COPY ./scripts/daily/* /etc/periodic/daily

RUN chmod u+x /etc/periodic/daily/backup

RUN apk update && \
    apk upgrade && \
    apk add --no-cache mariadb-client