#!/bin/sh
set -u
set -e

if [ -z "$JAVA_VERSION" ]; then
  echo "JAVA_VERSION needs to be defined to use this module" >&2
  exit 1
fi
if [ -z "$JAVA_VENDOR" ]; then
  echo "JAVA_VENDOR needs to be defined to use this module" >&2
  exit 1
fi

# Clean up any java-* packages that have been installed that do not match
# our stated JAVA_VERSION-JAVA_VENDOR (e.g.: 11-openjdk; 1.8.0-openj9)
rpm -e --nodeps $(rpm -qa java-* | grep -v "^java-${JAVA_VERSION}-${JAVA_VENDOR}")

# workaround for <https://issues.redhat.com/browse/RHEL-3437>
# The alternative link groups touched here need to match up with those set in
# modules/jdk/*/configure.sh
_arch="$(uname -i)"
for alt in java javac java_sdk_openjdk jre_openjdk; do
  alternatives --set "$alt" "java-${JAVA_VERSION}-${JAVA_VENDOR}.${_arch}"
done
