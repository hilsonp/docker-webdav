FROM alpine:latest
LABEL Pierre Hilson

ENV PACKAGE_LIST="lighttpd lighttpd-mod_webdav lighttpd-mod_auth apache2-utils" \
    REFRESHED_AT='2024-04-05'

# https://github.com/gliderlabs/docker-alpine/issues/386
#RUN echo -e "http://nl.alpinelinux.org/alpine/v3.19/main\nhttp://nl.alpinelinux.org/alpine/v3.19/community" > /etc/apk/repositories
#RUN sed -ie "s/https/http/g" /etc/apk/repositories

RUN apk update

RUN apk add --no-cache ${PACKAGE_LIST}

VOLUME [ "/config", "/webdav" ]

COPY files/* /etc/lighttpd/
COPY ./entrypoint.sh /entrypoint.sh

EXPOSE 80

RUN chmod u+x  /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]