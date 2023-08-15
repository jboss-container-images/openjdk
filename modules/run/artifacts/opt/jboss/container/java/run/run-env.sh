#!/bin/sh

# Default the application dir to the S2I deployment dir
if [ -z "$JAVA_APP_DIR" ]
then JAVA_APP_DIR=/deployments
fi
