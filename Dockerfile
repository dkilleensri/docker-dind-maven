FROM docker:dind

VOLUME [ "/etc/gitlab-runner/certs" ]
RUN cp /etc/gitlab-runner/certs/lpwgitp01.npd.com.cert /usr/local/share/ca-certificates/ && update-ca-certificates
COPY docker-entrypoint.sh /
RUN apk update && apk upgrade && \
    apk add --no-cache openjdk8 bash maven git openssh openrc
RUN chmod 755 /docker-entrypoint.sh
WORKDIR /usr/local/src
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD bash
