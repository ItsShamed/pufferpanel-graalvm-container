# $1 = platform
# $2 = version

echo "$1"
echo "$2"

sleep 3s

if [ -z "$1" ]; then
  >&2 echo "No target platform specified. Are you running inside Docker?";
  exit 1;
fi

echo "Preparing download..."
mkdir /usr/lib/jvm

if [ "$1" = 'linux/amd64' ]; then

  echo "Target platform is amd64";
  echo "Trying to download GraalVM CE version $2...";

  echo "Downloading Java 17...";
  wget -q -O - "https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-$2/graalvm-ce-java17-linux-amd64-$2.tar.gz" | tar -xzvf - -C /usr/lib/jvm/;

  echo "Ensuring install of graalvm-ce-java17-$2..."
  ls /usr/lib/jvm
  if ls /usr/lib/jvm/ | grep "graalvm-ce-java17-$2"; then
    echo "Installation OK"
  else
    >&2 echo "Installation FAILED"
    exit 1
  fi

  echo "Downloading Java 11...";
  wget -q -O - "https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-$2/graalvm-ce-java11-linux-amd64-$2.tar.gz" | tar -xzvf - -C /usr/lib/jvm/;

  echo "Ensuring install of graalvm-ce-java11-$2..."
  ls /usr/lib/jvm
  if ls /usr/lib/jvm/ | grep "graalvm-ce-java11-$2"; then
    echo "Installation OK"
  else
    >&2 echo "Installation FAILED"
    exit 1
  fi

elif [ "$1" = 'linux/arm64' ]; then

  echo "Target platform is aarch64";
  echo "Trying to download GraalVM CE version $2...";

  echo "Downloading Java 17...";
  wget -q -O - "https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-$2/graalvm-ce-java17-linux-aarch64-$2.tar.gz" | tar -xzvf - -C /usr/lib/jvm/;

  echo "Ensuring install of graalvm-ce-java17-$2..."
  ls /usr/lib/jvm
  if ls /usr/lib/jvm/ | grep "graalvm-ce-java17-$2"; then
    echo "Installation OK"
  else
    >&2 echo "Installation FAILED"
    exit 1
  fi

  echo "Downloading Java 11...";
  wget -q -O - "https://github.com/graalvm/graalvm-ce-builds/releases/download/vm-$2/graalvm-ce-java11-linux-aarch64-$2.tar.gz" | tar -xzvf - -C /usr/lib/jvm/;

  echo "Ensuring install of graalvm-ce-java11-$2..."
  ls /usr/lib/jvm
  if ls /usr/lib/jvm/ | grep "graalvm-ce-java11-$2"; then
    echo "Installation OK"
  else
    >&2 echo "Installation FAILED"
    exit 1
  fi

else

  >&2 echo "Unsupported platform.";
  exit 1;

fi

echo "Download and extraction of GraalVM CE complete!";
