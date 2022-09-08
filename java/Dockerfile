FROM ghcr.io/graalvm/jdk:java8 AS java8
FROM ghcr.io/graalvm/jdk:latest AS java17

FROM pufferpanel/pufferpanel:base

COPY --from=java17 /usr/lib64/graalvm/graalvm22-ce-java17 /usr/lib/jvm/graalvm22-ce-java17
COPY --from=java8 /usr/lib64/graalvm/graalvm21-ce-java8 /usr/lib/jvm/graalvm21-ce-java8

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