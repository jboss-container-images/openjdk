# script to measure the sizes (and size savings)

S2I=${S2I-s2i}
ENGINE=${ENGINE-docker} # or e.g. podman
BASEIMG=registry.access.redhat.com/ubi9/openjdk-17:latest
APPSRC=https://github.com/quarkusio/quarkus-quickstarts
CONTEXTDIR=getting-started
rev=3.6.6
OUTIMG=out-s2i-image

# first build the image using shipped builder images
$S2I build --pull-policy never \
    -e MAVEN_S2I_ARTIFACT_DIRS=target \
    -e S2I_SOURCE_DEPLOYMENTS_FILTER="*.jar quarkus-app" \
    -e QUARKUS_PACKAGE_TYPE=uber-jar \
    -e JAVA_APP_JAR=getting-started-1.0.0-SNAPSHOT-runner.jar \
    --context-dir=$CONTEXTDIR -r=${rev} \
    $APPSRC \
    $BASEIMG \
    $OUTIMG

echo "baseline (simple S2I output):"
${ENGINE} inspect -f '{{.Size}}' $OUTIMG

# second, do a build with the image from jlink-dev branch
# make sure it's been built!
# NOTE: we override most variables from .s2i/environment in the quickstart
# sources below, in order to an uber-jar.
BASEIMG=ubi9/openjdk-17:latest
OUTIMG=out-s2i-image2

$S2I build --pull-policy never \
    -e S2I_ENABLE_JLINK=true \
    -e MAVEN_S2I_ARTIFACT_DIRS=target \
    -e S2I_SOURCE_DEPLOYMENTS_FILTER="*.jar quarkus-app" \
    -e QUARKUS_PACKAGE_TYPE=uber-jar \
    -e JAVA_APP_JAR=getting-started-1.0.0-SNAPSHOT-runner.jar \
    --context-dir=$CONTEXTDIR -r=${rev} \
    $APPSRC \
    $BASEIMG \
    $OUTIMG

echo "intermediate jlink image size:"
docker inspect -f '{{.Size}}' $OUTIMG

# third, run the above thru the second-stage process
OUTIMG=jlink-final
${ENGINE} build -t "$OUTIMG" templates/jlink
echo "final jlinked image size:"
docker inspect -f '{{.Size}}' "$OUTIMG"
