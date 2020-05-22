FROM docker:dind

ENV LANG C.UTF-8
ENV JDK "8u45-b14"

ENV JAVA_OPTS="-XX:PermSize=1024m -XX:MaxPermSize=512m"
VOLUME [ "/etc/gitlab-runner/certs" ]
RUN ls -a -l /etc/gitlab-runner/certs
COPY docker-entrypoint.sh /
RUN apk update && apk upgrade && \
    apk add --no-cache bash maven git openssh openrc
RUN apk add --update wget ca-certificates 

RUN URL="http://download.oracle.com/otn-pub/java/jdk/$JDK/jdk-`echo "$JDK" | sed 's@-[^-]*$@@g'`-linux-x64.tar.gz" \
 && mkdir -p /usr/lib/jvm/java-8-oracle \
 && cd /tmp \
 && wget --quiet --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "$URL" -O jdk8.tgz \
 && tar zxf jdk8.tgz && rm jdk8.tgz \
 && mv /tmp/jdk*/* /usr/lib/jvm/java-8-oracle/ \
 && mkdir -p /usr/lib/jvm/java-8-oracle/jre/lib/security \
 && rm -rf /tmp/*

RUN POLICY_URL="http://download.oracle.com/otn-pub/java/jce/8/jce_policy-8.zip" \
 && POLICY_DIR="UnlimitedJCEPolicyJDK8" \
 && wget --quiet --no-cookies --no-check-certificate \
           --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" \
          "$POLICY_URL" -O /tmp/policy.zip \
 && cd /tmp \
 && unzip /tmp/policy.zip \
 && mv /tmp/$POLICY_DIR/*.jar /usr/lib/jvm/java-8-oracle/jre/lib/security/ \
 && rm -rf /tmp/*

ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

RUN cd /tmp \
 && wget "https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-2.21-r2.apk" \
 && wget "https://circle-artifacts.com/gh/andyshinn/alpine-pkg-glibc/6/artifacts/0/home/ubuntu/alpine-pkg-glibc/packages/x86_64/glibc-bin-2.21-r2.apk" \
 && apk add --allow-untrusted glibc-2.21-r2.apk glibc-bin-2.21-r2.apk \
 && /usr/glibc/usr/bin/ldconfig /lib /usr/glibc/usr/lib \
 && echo 'hosts: files mdns4_minimal [NOTFOUND=return] dns mdns4' >> /etc/nsswitch.conf \
 && ln -s "java-${JAVA_VERSION}-oracle" $JAVA_HOME \
 && ln -s $JAVA_HOME/bin/java /usr/bin/java \
 && ln -s $JAVA_HOME/bin/javac /usr/bin/javac \
 && rm -rf $JAVA_HOME/*src.zip \
 && rm -rf $JAVA_HOME/lib/missioncontrol \
           $JAVA_HOME/lib/visualvm \
           $JAVA_HOME/lib/*javafx* \
           $JAVA_HOME/jre/lib/plugin.jar \
           $JAVA_HOME/jre/lib/ext/jfxrt.jar \
           $JAVA_HOME/jre/bin/javaws \
           $JAVA_HOME/jre/lib/javaws.jar \
           $JAVA_HOME/jre/lib/desktop \
           $JAVA_HOME/jre/plugin \
           $JAVA_HOME/jre/lib/deploy* \
           $JAVA_HOME/jre/lib/*javafx* \
           $JAVA_HOME/jre/lib/*jfx* \
           $JAVA_HOME/jre/lib/amd64/libdecora_sse.so \
           $JAVA_HOME/jre/lib/amd64/libprism_*.so \
           $JAVA_HOME/jre/lib/amd64/libfxplugins.so \
           $JAVA_HOME/jre/lib/amd64/libglass.so \
           $JAVA_HOME/jre/lib/amd64/libgstreamer-lite.so \
           $JAVA_HOME/jre/lib/amd64/libjavafx*.so \
           $JAVA_HOME/jre/lib/amd64/libjfx*.so \
 && rm -rf $JAVA_HOME/jre/bin/jjs \
           $JAVA_HOME/jre/bin/keytool \
           $JAVA_HOME/jre/bin/orbd \
           $JAVA_HOME/jre/bin/pack200 \
           $JAVA_HOME/jre/bin/policytool \
           $JAVA_HOME/jre/bin/rmid \
           $JAVA_HOME/jre/bin/rmiregistry \
           $JAVA_HOME/jre/bin/servertool \
           $JAVA_HOME/jre/bin/tnameserv \
           $JAVA_HOME/jre/bin/unpack200 \
           $JAVA_HOME/jre/lib/ext/nashorn.jar \
           $JAVA_HOME/jre/lib/jfr.jar \
           $JAVA_HOME/jre/lib/jfr \
           $JAVA_HOME/jre/lib/oblique-fonts \
 &&  rm /tmp/* /var/cache/apk/*
 
RUN chmod 755 /docker-entrypoint.sh
RUN export MAVEN_OPTS="-Xms1024m -Xmx4096m -XX:PermSize=1024m" && export _JAVA_OPTIONS=-Xmx2048m
RUN java -XX:+PrintFlagsFinal -version | grep HeapSize
WORKDIR /usr/local/src
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD bash
