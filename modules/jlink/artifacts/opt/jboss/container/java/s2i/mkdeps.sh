#!/bin/bash
set -euo pipefail
shopt -s globstar

project="${project-spring-boot-sample-simple}"
jarfile="${jarfile-$project/target/spring-boot-sample-simple-1.5.0.BUILD-SNAPSHOT.jar}"
libdir="${libdir-$project/target/lib}"

test -f "$jarfile"
test -d "$libdir"

# Create a temporary directory for a module path
# This works around "Module java.xml.bind not found, required by java.ws.rs"
mkdir dependencies
find $libdir -type f -name '*.jar' -print0 | xargs -r0 cp -vt dependencies

$JAVA_HOME/bin/jdeps --multi-release 11 -R -s \
    --module-path dependencies \
    "$jarfile" \
    "$libdir"/**/*.jar \
> deps.txt
