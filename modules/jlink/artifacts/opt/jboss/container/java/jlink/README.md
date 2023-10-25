# jlink-openshift App builder

This container bundles together scripts to analyse a Java application
with `jdeps` and generate a stripped `jre` with only the required Java
modules to run that application.

## Usage

### building

    podman build -t jlink ./

### running

Assuming you have the following defined locally:

 * `$jarfile`, a local web application JAR
 * `$libdir`, directory containing auxillary Java libraries (JARs) for the above
 * `$outputjre`, where to write the stripped JRE

Invoke as follows

    podman run --rm -ti \
        -v "$jarfile":/tmp/run/app.jar \
        -v "$libdir":/tmp/run/lib \
        -v "$outputjre":/tmp/run/out \
        jlink

## Script details

Most of the scripts require `$JAVA_HOME` to be defined.

 * `mkdeps.sh`:          application       → jdeps     → deps.txt
 * `mkstrippeddeps.sh`:  deps.txt          → filtering → stripped-deps.txt
 * `generatejdkdeps.sh`: stripped-deps.txt → filtering → module-deps.txt
 * `mkjreimage.sh`:      module-deps.txt   → jlink     → custom JDK
 * `runall.sh`: runs all of the above
