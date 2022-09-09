FROM ghcr.io/graalvm/jdk:java8 AS java8
FROM ghcr.io/graalvm/jdk:latest AS java17

FROM pufferpanel/pufferpanel:base-devel AS builder

FROM ubuntu:20.04

COPY --from=builder /pufferpanel /pufferpanel
EXPOSE 8080 5657

RUN mkdir -p /etc/pufferpanel && \
  mkdir -p /var/lib/pufferpanel

ARG DEBIAN_FRONTEND=noninteractive
ARG APTPROXY

RUN if [ -n "$APTPROXY" ] ; then \
  echo "deb $APTPROXY/ubuntu-focal/ focal main restricted universe multiverse" > /etc/apt/sources.list ; \
  echo "deb $APTPROXY/ubuntu-focal-updates/ focal-updates main restricted universe multiverse" >> /etc/apt/sources.list ; \
  echo "deb $APTPROXY//ubuntu-focal-backports/ focal-backports main restricted universe multiverse" >> /etc/apt/sources.list ;\
  fi

RUN apt-get update && \
  apt-get install -y git wget curl zip unzip musl


# GraalVM
COPY --from=java17 /usr/lib64/graalvm/graalvm22-ce-java17 /usr/lib/jvm/graalvm22-ce-java17
COPY --from=java8 /usr/lib64/graalvm/graalvm21-ce-java8 /usr/lib/jvm/graalvm21-ce-java8

ENV JAVA_HOME=/usr/lib/jvm/graalvm22-ce-java17
ENV JAVA17=/usr/lib/jvm/graalvm22-ce-java17
ENV JAVA8=/usr/lib/jvm/graalvm21-ce-java8

RUN update-alternatives --install /usr/bin/java java ${JAVA_HOME}/bin/java 30723 \
  --slave /usr/bin/javac javac ${JAVA_HOME}/bin/javac \
  --slave /usr/bin/jar jar ${JAVA_HOME}/bin/jar \
  --slave /usr/bin/jarsigner jarsigner ${JAVA_HOME}/bin/jarsigner \
  --slave /usr/bin/javadoc javadoc ${JAVA_HOME}/bin/javadoc && \
  update-alternatives --display java && \
  update-alternatives --install /usr/bin/java8 java8 ${JAVA8}/bin/java 30723 \
  --slave /usr/bin/javac8 javac8 ${JAVA8}/bin/javac \
  --slave /usr/bin/jar8 jar8 ${JAVA8}/bin/jar \
  --slave /usr/bin/jarsigner8 jarsigner8 ${JAVA8}/bin/jarsigner \
  --slave /usr/bin/javadoc8 javadoc8 ${JAVA8}/bin/javadoc && \
  update-alternatives --display java8 && \
  update-alternatives --install /usr/bin/java17 java17 ${JAVA17}/bin/java 30723 \
  --slave /usr/bin/javac17 javac17 ${JAVA17}/bin/javac \
  --slave /usr/bin/jar17 jar17 ${JAVA17}/bin/jar \
  --slave /usr/bin/jarsigner17 jarsigner17 ${JAVA17}/bin/jarsigner \
  --slave /usr/bin/javadoc17 javadoc17 ${JAVA17}/bin/javadoc && \
  update-alternatives --display java17 && \
  echo "Testing Javac 8 path" && \
  javac8 -version && \
  echo "Testing Java 8 path" && \
  java8 -version && \
  echo "Testing Javac 17 path" && \
  javac17 -version && \
  echo "Testing Java 17 path" && \
  java17 -version && \
  echo "Testing java path" && \
  java -version && \
  echo "Testing javac path" && \
  javac -version

# Node.Js
RUN apt-get install -y nodejs

# srcds
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN echo steam steam/question select "I AGREE" | debconf-set-selections && \
  echo steam steam/license note '' | debconf-set-selections

ENV LANG 'en_US.UTF-8'
ENV LANGUAGE 'en_US:en'

RUN dpkg --add-architecture i386 && \
  apt-get update -y && \
  apt-get install -y --no-install-recommends ca-certificates locales steamcmd && \
  locale-gen en_US.UTF-8 && \
  ln -s /usr/games/steamcmd /usr/bin/steamcmd

# Cleanup
RUN apt-get clean all && rm -rf /var/lib/apt/lists/*

ENV PUFFER_LOGS=/etc/pufferpanel/logs \
  PUFFER_PANEL_TOKEN_PUBLIC=/etc/pufferpanel/public.pem \
  PUFFER_PANEL_TOKEN_PRIVATE=/etc/pufferpanel/private.pem \
  PUFFER_PANEL_DATABASE_DIALECT=sqlite3 \
  PUFFER_PANEL_DATABASE_URL="file:/etc/pufferpanel/pufferpanel.db?cache=shared" \
  PUFFER_DAEMON_SFTP_KEY=/etc/pufferpanel/sftp.key \
  PUFFER_DAEMON_DATA_CACHE=/var/lib/pufferpanel/cache \
  PUFFER_DAEMON_DATA_SERVERS=/var/lib/pufferpanel/servers \
  PUFFER_DAEMON_DATA_MODULES=/var/lib/pufferpanel/modules

WORKDIR /pufferpanel

ENTRYPOINT ["/pufferpanel/pufferpanel"]
CMD ["run"]
