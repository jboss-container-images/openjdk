#!/bin/bash
set -euo pipefail
shopt -s globstar

function generate_deps() {
  #Test that file dependencies exist
  test -f "$JAVA_APP_JAR"
  test -d "$JAVA_LIB_DIR"

  # Create a temporary directory for a module path
  # This works around "Module java.xml.bind not found, required by java.ws.rs"
  mkdir dependencies
  find $JAVA_LIB_DIR -type f -name '*.jar' -print0 | xargs -r0 cp -vt dependencies

  $JAVA_HOME/bin/jdeps --multi-release $JAVA_VERSION -R -s \
    --module-path dependencies \
    "$JAVA_APP_JAR" \
    "$JAVA_LIB_DIR"/**/*.jar \
    > deps.txt
}