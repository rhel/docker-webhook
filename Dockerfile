FROM golang:alpine3.8 AS build
LABEL MAINTAINER="Artyom Nosov <chip@unixstyle.ru>"
WORKDIR /go/src/github.com/adnanh/webhook
ARG WEBHOOK_VERSION=2.6.9
RUN apk add --no-cache --virtual .build-deps \
        curl \
        gcc \
        libgcc \
        libc-dev
RUN curl -L --silent -o webhook.tar.gz https://github.com/adnanh/webhook/archive/${WEBHOOK_VERSION}.tar.gz \
 && tar -xzf webhook.tar.gz --strip 1 \
 && go get -d \
 && go build -o /usr/local/bin/webhook \
 && apk del --purge .build-deps \
 && rm -rf /var/cache/apk/* \
 && rm -rf /go


FROM docker:18
COPY --from=build /usr/local/bin/webhook /usr/local/bin/webhook
COPY docker-entrypoint.sh /usr/local/bin
RUN apk add --no-cache su-exec \
 && rm -fr /var/cache/apk/*
EXPOSE 9000
ENTRYPOINT ["docker-entrypoint.sh"]