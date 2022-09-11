# Pufferpanel with GraalVM as default JVM

This repo contains the Dockerfiles of custom Pufferpanel images with
GraalVM included.

You can also use pull them from the GitHub container registry:
- `latest` contains the dependencies for other servers (scrdc, NodeJS...)
- `java` contains only GraalVM

__**PLEASE NOTE**__ that these images do NOT provide `java8` and `java16` commands.
For Java 8 use `java11` instead. For Java 16 use `java17` instead.
