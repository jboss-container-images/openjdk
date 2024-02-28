eval $(crc oc-env)
VERSION=11

# Buildconfigs attempt to push to ubi9-openjdk-$VERSION-jmods, this needs to exist first
oc create imagestream ubi9-openjdk-$VERSION-jlink

# Assuming the buildconfig exists, we can now create the buildconfig
oc create -f jdk-$VERSION-buildconfig.yaml
oc start-build jlink-builder-jdk-$VERSION