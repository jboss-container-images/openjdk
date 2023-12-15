# OpenShift-JLink PoC

Try it out:

## Stage 1: build and analyse application with OpenShift source-to-image (S2I)

You need:

1. Access to an OpenShift instance, or, use [the s2i standalone program](https://github.com/openshift/source-to-image)
    * _([you might need to use an old version](https://github.com/openshift/source-to-image/issues/1135))_
2. The OpenJDK builder image (with the customisations from the `jlink-dev` branch).
   There's one at `quay.io/jdowland/jlink:latest`
3. A quickstart ([there's a specially-prepared Quarkus quickstart](https://github.com/jmtd/quarkus-quickstarts/tree/OPENJDK-631-fastjar-layout);
   in the future [the mainline Quarkus quickstarts will be suitable](https://github.com/quarkusio/quarkus-quickstarts/pull/1359))

Here's a recipe using local `s2i`

```
BASEIMG=quay.io/jdowland/jlink:latest
APPSRC=https://github.com/jmtd/quarkus-quickstarts.git
CONTEXTDIR=getting-started
REV=OPENJDK-631-fastjar-layout
OUTIMG=ubi9-jlinked-image

s2i build --pull-policy never --context-dir=${CONTEXTDIR} -r=${REV} \
    -e QUARKUS_PACKAGE_TYPE=uber-jar \
    -e S2I_ENABLE_JLINK=true \
    ${APPSRC} \
    ${BASEIMG} \
    ${OUTIMG}
```

## Stage 2: multi-stage build to assemble micro runtime

You need:

1. The output image from the first stage
    * _here's one we made earlier: `quay.io/jdowland/jlink:quarkus-getting-started`_
2. OpenShift, or a container runtime (e.g. Docker)
3. [this Dockerfile](Dockerfile) (In future this is an OpenShift template)

With docker, from a clone of this repository, in this directory:

```
docker build -t myapp -f .
```

## Stage 3: try it out!

Does it work?

    docker run --rm -ti -p 8080 myapp

How big is it?

    docker inspect -f '{{.Size}}' myapp
