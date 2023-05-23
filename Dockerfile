#
# Dockerfile for openconnect
#

FROM alpine:edge
MAINTAINER kev <noreply@easypi.pro>

RUN set -xe \
    && apk add --no-cache \
               openconnect squid curl expect openssh \
    && mkdir -p /etc/openconnect \
    && touch /etc/openconnect/openconnect.conf

ADD entrypoint.sh /entrypoint.sh
ADD squid.conf /tmp/squid.conf

VOLUME /etc/openconnect

EXPOSE 3128/tcp
EXPOSE 1080/tcp

ENTRYPOINT ["/entrypoint.sh"]
