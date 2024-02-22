jlink_preflight_check()
{
    # preflight check: do we have what we need?
    if [ "$JAVA_VERSION" -lt 11 ]; then
      echo "Jlink integration not available for JDK${JAVA_VERSION}!"
      echo "Jlink integration is only supported for JDK versions 11 and newer."
    fi
    if [ ! -d /usr/lib/jvm/java/jmods ]; then
      echo "Jlink integration requires the jmods RPM to be installed in the builder image, e.g."
      echo "        microdnf install -y java-${JAVA_VERSION}-openjdk-jmods"
    fi
}
