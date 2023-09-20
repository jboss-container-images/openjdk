#!/bin/sh
set -euo pipefail
set -x

jarfile="/tmp/run/app.jar"
libdir="/tmp/run/lib"
outdir="/tmp/run/out"

test -e "$JAVA_HOME"

export project jarfile libdir outdir

bash -x ./mkdeps.sh
bash -x ./mkstrippeddeps.sh
bash -x ./generatejdkdeps.sh
bash -x ./mkjreimage.sh
