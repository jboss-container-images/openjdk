#!/bin/bash
set -euo pipefail
shopt -s globstar

function generate_deps() {
  # Create a temporary directory for a module path
  # This works around "Module java.xml.bind not found, required by java.ws.rs"
  mkdir dependencies

  if [[ -v JAVA_LIB_DIR ]]; then
      # copy dependencies found in libs to dependencies
      find $JAVA_LIB_DIR -type f -name '*.jar' -print0 | xargs -r0 cp -vt dependencies
      echo "Working with: "
      echo $JAVA_APP_JAR
      echo $JAVA_LIB_DIR
      # generate the dependency list
      $JAVA_HOME/bin/jdeps --multi-release $JAVA_VERSION -R -s \
        --module-path dependencies \
        "$JAVA_APP_JAR" \
        "$JAVA_LIB_DIR"/**/*.jar \
        > deps.txt
  else 
    $JAVA_HOME/bin/jdeps --multi-release $JAVA_VERSION -R -s \
      --module-path dependencies \
      "$JAVA_APP_JAR" \
      > deps.txt
    cat deps.txt
  fi
}