FROM docker:dind

ENV JAVA_OPTS="-XX:PermSize=1024m -XX:MaxPermSize=512m"
VOLUME [ "/etc/gitlab-runner/certs" ]
RUN ls -a -l /etc/gitlab-runner/certs
COPY docker-entrypoint.sh /
RUN apk update && apk upgrade && \
    apk add --no-cache bash maven git openssh openrc && \
    echo "oracle-java8-installer shared/accepted-oracle-license-v1-1 select true" | debconf-set-selections && \
    echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu xenial main" > /etc/apt/sources.list.d/webupd8team-java-trusty.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886 && \
    apt-get update && \
    apt-get install -y --no-install-recommends oracle-java8-installer oracle-java8-set-default && \
    apt-get clean all
RUN chmod 755 /docker-entrypoint.sh
RUN export MAVEN_OPTS="-Xms1024m -Xmx4096m -XX:PermSize=1024m" && export _JAVA_OPTIONS=-Xmx2048m
RUN java -XX:+PrintFlagsFinal -version | grep HeapSize
WORKDIR /usr/local/src
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD bash
