FROM alpine:latest
MAINTAINER Tom Grace <tom@penguinanddaemon.com>

RUN apk update && apk upgrade
RUN apk add nginx
RUN mkdir -p /run/nginx /srv/nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY index.html /srv/nginx/index.html

ENTRYPOINT nginx -g "daemon off;"
