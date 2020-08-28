#
# Dockerfile for openconnect
#

FROM alpine:edge
MAINTAINER kev <noreply@easypi.pro>

RUN set -xe \
    && apk add --no-cache \
               openconnect squid curl expect \
    && mkdir -p /etc/openconnect \
    && touch /etc/openconnect/openconnect.conf

ADD entrypoint.sh /entrypoint.sh

VOLUME /etc/openconnect

EXPOSE 3128/tcp

ENTRYPOINT ["/entrypoint.sh"]
