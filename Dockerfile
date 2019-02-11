FROM golang:alpine3.8 AS build
LABEL MAINTAINER="Artyom Nosov <chip@unixstyle.ru>"
WORKDIR /src
ARG WEBHOOK_VERSION=2.6.9
RUN apk add --no-cache --virtual .build-deps curl libc-dev gcc libgcc
RUN curl -L --silent -o webhook.tar.gz https://github.com/adnanh/webhook/archive/${WEBHOOK_VERSION}.tar.gz \
 && tar -xzf webhook.tar.gz --strip 1 \
 && go get -d \
 && go build -o /usr/local/bin/webhook \
 && apk del --purge .build-deps \
 && rm -rf /var/cache/apk/* \
 && rm -rf /src


FROM docker:18
COPY --from=build /usr/local/bin/webhook /usr/local/bin/webhook
EXPOSE 9000
ENTRYPOINT ["/usr/local/bin/webhook"]