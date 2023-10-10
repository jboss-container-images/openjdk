#!/bin/bash
set -euo pipefail
shopt -s globstar

jarfile=$JAVA_APP_JAR
libdir=$JAVA_LIB_DIR

function generate_deps() {
  #Test that file dependencies exist
  test -f "$jarfile"
  test -d "$libdir"

  # Create a temporary directory for a module path
  # This works around "Module java.xml.bind not found, required by java.ws.rs"
  mkdir dependencies
  find $libdir -type f -name '*.jar' -print0 | xargs -r0 cp -vt dependencies

  $JAVA_HOME/bin/jdeps --multi-release $JAVA_VERSION -R -s \
    --module-path dependencies \
    "$jarfile" \
    "$libdir"/**/*.jar \
    > deps.txt
}