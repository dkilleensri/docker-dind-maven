FROM docker:dind

COPY docker-entrypoint.sh /
RUN apk update && apk upgrade && \
    apk add --no-cache openjdk8 bash maven git openssh
RUN chmod 755 /docker-entrypoint.sh
WORKDIR /usr/local/src
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD bash
