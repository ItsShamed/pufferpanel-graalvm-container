FROM ghcr.io/itsshamed/pufferpanel-graalvm-container:base AS builder

FROM ubuntu:20.04

ARG GRAALVM_VERSION=22.2.0
ARG TARGETPLATFORM

COPY --from=builder /pufferpanel /pufferpanel
EXPOSE 8080 5657

RUN mkdir -p /etc/pufferpanel && \
  mkdir -p /var/lib/pufferpanel

ARG DEBIAN_FRONTEND=noninteractive
ARG APTPROXY

RUN if [ -n "$APTPROXY" ] ; then \
  echo "deb $APTPROXY/ubuntu-focal/ focal main restricted universe multiverse" > /etc/apt/sources.list ; \
  echo "deb $APTPROXY/ubuntu-focal-updates/ focal-updates main restricted universe multiverse" >> /etc/apt/sources.list ; \
  echo "deb $APTPROXY/ubuntu-focal-backports/ focal-backports main restricted universe multiverse" >> /etc/apt/sources.list ;\
  fi

RUN apt-get update && \
  apt-get install -y git wget curl zip unzip musl

ENV JAVA_HOME=/usr/lib/jvm/graalvm-ce-java17-${GRAALVM_VERSION}
ENV JAVA17=/usr/lib/jvm/graalvm-ce-java17-${GRAALVM_VERSION}
ENV JAVA11=/usr/lib/jvm/graalvm-ce-java11-${GRAALVM_VERSION}

COPY download_java.sh .
RUN chmod +x download_java.sh && \
  ./download_java.sh ${TARGETPLATFORM} ${GRAALVM_VERSION} && \
  update-alternatives --install /usr/bin/java java ${JAVA_HOME}/bin/java 30723 \
  --slave /usr/bin/javac javac ${JAVA_HOME}/bin/javac \
  --slave /usr/bin/jar jar ${JAVA_HOME}/bin/jar \
  --slave /usr/bin/jarsigner jarsigner ${JAVA_HOME}/bin/jarsigner \
  --slave /usr/bin/javadoc javadoc ${JAVA_HOME}/bin/javadoc && \
  update-alternatives --display java && \
  update-alternatives --install /usr/bin/java11 java11 ${JAVA11}/bin/java 30723 \
  --slave /usr/bin/javac11 javac11 ${JAVA11}/bin/javac \
  --slave /usr/bin/jar11 jar11 ${JAVA11}/bin/jar \
  --slave /usr/bin/jarsigner11 jarsigner11 ${JAVA11}/bin/jarsigner \
  --slave /usr/bin/javadoc11 javadoc11 ${JAVA11}/bin/javadoc && \
  update-alternatives --display java11 && \
  update-alternatives --install /usr/bin/java17 java17 ${JAVA17}/bin/java 30723 \
  --slave /usr/bin/javac17 javac17 ${JAVA17}/bin/javac \
  --slave /usr/bin/jar17 jar17 ${JAVA17}/bin/jar \
  --slave /usr/bin/jarsigner17 jarsigner17 ${JAVA17}/bin/jarsigner \
  --slave /usr/bin/javadoc17 javadoc17 ${JAVA17}/bin/javadoc && \
  update-alternatives --display java17 && \
  echo "Testing Javac 11 path" && \
  javac11 -version && \
  echo "Testing Java 11 path" && \
  java11 -version && \
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
