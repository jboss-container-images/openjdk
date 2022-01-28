#!/bin/sh
# Configure module
set -e

SCRIPT_DIR=$(dirname $0)
ARTIFACTS_DIR=${SCRIPT_DIR}/artifacts

chown -R jboss:root $SCRIPT_DIR
chmod -R ug+rwX $SCRIPT_DIR
chmod ug+x ${ARTIFACTS_DIR}/opt/jboss/container/openjdk/jdk/*

pushd ${ARTIFACTS_DIR}
cp -pr * /
popd

alternatives --install /usr/bin/java java /opt/ibm/ibm-semeru-certified-11-jdk/bin/java 20000
alternatives --install /usr/bin/javac javac /opt/ibm/ibm-semeru-certified-11-jdk/bin/javac 20000

# Update securerandom.source for quicker starts
JAVA_SECURITY_FILE=/opt/ibm/ibm-semeru-certified-11-jdk/conf/security/java.security
SECURERANDOM=securerandom.source
if grep -q "^$SECURERANDOM=.*" $JAVA_SECURITY_FILE; then
    sed -i "s|^$SECURERANDOM=.*|$SECURERANDOM=file:/dev/urandom|" $JAVA_SECURITY_FILE
else
    echo $SECURERANDOM=file:/dev/urandom >> $JAVA_SECURITY_FILE
fi
