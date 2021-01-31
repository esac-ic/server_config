FROM alpine:latest

COPY ./scripts/15min/* /etc/periodic/15min

RUN apk update && \
    apk upgrade && \
    apk add --no-cache mariadb-client && \
    chmod a+x /etc/periodic/daily/*