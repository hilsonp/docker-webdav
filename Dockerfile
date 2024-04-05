FROM alpine:latest
LABEL Pierre Hilson

ENV PACKAGE_LIST="lighttpd lighttpd-mod_webdav lighttpd-mod_auth" \
    REFRESHED_AT='2024-04-05'

RUN apk add --no-cache ${PACKAGE_LIST}

VOLUME [ "/config", "/webdav" ]

ADD files/* /etc/lighttpd/
ADD ./entrypoint.sh /entrypoint.sh

EXPOSE 80

RUN chmod u+x  /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]