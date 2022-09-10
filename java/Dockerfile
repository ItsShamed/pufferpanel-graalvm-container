FROM ghcr.io/graalvm/jdk:java8 AS java8
FROM ghcr.io/graalvm/jdk:latest AS java17

FROM pufferpanel/pufferpanel:base-devel

COPY --from=java17 /usr/lib64/graalvm/graalvm22-ce-java17 /usr/lib/jvm/graalvm22-ce-java17
COPY --from=java8 /usr/lib64/graalvm/graalvm21-ce-java8 /usr/lib/jvm/graalvm21-ce-java8

RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
  apk update

# glibc compatibility
ENV GLIBC_REPO=https://github.com/sgerrand/alpine-pkg-glibc
ENV GLIBC_VERSION=2.30-r0

RUN wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
  &&  wget "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC_VERSION/glibc-$GLIBC_VERSION.apk" \
  &&  apk --no-cache add "glibc-$GLIBC_VERSION.apk" \
  &&  rm "glibc-$GLIBC_VERSION.apk" \
  &&  wget "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC_VERSION/glibc-bin-$GLIBC_VERSION.apk" \
  &&  apk --no-cache add "glibc-bin-$GLIBC_VERSION.apk" \
  &&  rm "glibc-bin-$GLIBC_VERSION.apk" \
  &&  wget "https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC_VERSION/glibc-i18n-$GLIBC_VERSION.apk" \
  &&  apk --no-cache add "glibc-i18n-$GLIBC_VERSION.apk" \
  &&  rm "glibc-i18n-$GLIBC_VERSION.apk" \
  && ls /usr/glibc-compat && sleep 10s \
  && mkdir temp && cd temp && \
  apk add zstd && \
  wget -q https://www.archlinux.org/packages/core/x86_64/zlib/download/ -O -  | unzstd | tar -xvf - && \
  cp -r usr/* /usr/glibc-compat/ && \
  cd .. && rm -rf temp \
  && ln -sfn /usr/glibc-compat/lib/libz.so /usr/lib/libz.so \
  && ln -sfn /usr/glibc-compat/lib/libz.so.1 /usr/lib/libz.so.1 \
  && ls /usr/glibc-compat && sleep 10s

# RUN set -ex && \
#   apk --update add libstdc++ curl ca-certificates && \
#   for pkg in glibc-${GLIBC_VERSION} glibc-bin-${GLIBC_VERSION}; \
#   do curl -sSL ${GLIBC_REPO}/releases/download/${GLIBC_VERSION}/${pkg}.apk -o /tmp/${pkg}.apk; done && \
#   apk add --allow-untrusted /tmp/*.apk && \
#   rm -v /tmp/*.apk && \
#   /usr/glibc-compat/sbin/ldconfig /lib /usr/glibc-compat/lib

ENV JAVA_HOME=/usr/lib/jvm/graalvm22-ce-java17
ENV JAVA17=/usr/lib/jvm/graalvm22-ce-java17
ENV JAVA8=/usr/lib/jvm/graalvm21-ce-java8


RUN ln -sfn ${JAVA_HOME}/bin/java /usr/bin/java && \
  ln -sfn ${JAVA_HOME}/bin/javac /usr/bin/javac && \
  ln -sfn ${JAVA8}/bin/java /usr/bin/java8 && \
  ln -sfn ${JAVA8}/bin/javac /usr/bin/javac8 && \
  ln -sfn ${JAVA17}/bin/java /usr/bin/java17 && \
  ln -sfn ${JAVA17}/bin/javac /usr/bin/javac17 && \
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

RUN rm -rf /var/cache/apk/*
