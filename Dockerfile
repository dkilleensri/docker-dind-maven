FROM docker:dind

VOLUME [ "/etc/gitlab-runner/certs" ]
RUN ls -a -l /etc/gitlab-runner/certs
COPY docker-entrypoint.sh /
RUN apk update && apk upgrade && \
    apk add --no-cache openjdk8 bash maven git openssh openrc
RUN chmod 755 /docker-entrypoint.sh
WORKDIR /usr/local/src
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD bash
