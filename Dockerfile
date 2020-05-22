FROM docker:dind

# ENV JAVA_HOME="/usr/lib/jvm/java-9-openjdk/"
ENV JAVA_OPTS="-XX:PermSize=1024m -XX:MaxPermSize=512m"
VOLUME [ "/etc/gitlab-runner/certs" ]
RUN ls -a -l /etc/gitlab-runner/certs
COPY docker-entrypoint.sh /
RUN apk update && apk upgrade && \
    apk add --no-cache openjdk9 bash maven git openssh openrc
RUN chmod 755 /docker-entrypoint.sh
RUN export MAVEN_OPTS="-Xms1024m -Xmx4096m -XX:PermSize=1024m" && export _JAVA_OPTIONS=-Xmx2048m
WORKDIR /usr/local/src
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD bash
