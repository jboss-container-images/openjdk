#!/bin/bash
set -euo pipefail

outdir="${outdir-spring-boot-jre}"
depsfile="module-deps.txt"

test -f $depsfile
modules="$(cat $depsfile)"

$JAVA_HOME/bin/jlink --output "${outdir}/jre" \
       	--add-modules "$modules" \
	--strip-debug --no-header-files --no-man-pages \
	--compress=2
