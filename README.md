# Pufferpanel with GraalVM as default JVM

- `latest` contains the dependencies for other servers (scrdc, NodeJS...)
- `java` contains only GraalVM

**Please note** that unlike the original image, this image does not provide
a `java8` executable. This is due to the original GraalVM images not providing
Java 16. Use `java17` instead, it might work as well for Minecraft 1.16
For older versions you can use the `java8` command.
