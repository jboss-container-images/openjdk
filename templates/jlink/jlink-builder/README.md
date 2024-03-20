# OpenShift-JLink PoC

Try it out:

## Stage 1: create ubi9 jlink imagestream and push a ubi9 image with jmods installed to it.

You need:

1. Access to an OpenShift instance, such as crc

Steps to produce the imagestream and image:

1. Switch to the openshift project and install the template

    oc project openshift
    oc create -f templates/jlink/jlink-builder/jlink-builder-template.yaml

This will create a Template called jlink-builder-template, you should see

    template.template.openshift.io/jlink-builder-template created

and after running oc get template, it should be in the list as

    jlink-builder-template                        Template to produce an imagestream and buildconfig for a Jlink builder image       1 (all set)       2

2. Set the parameters and create the imagestream and buildconfig from the template.

The template for now defines a single parameter, JDK_VERSION. Setting this will set the version of the builder image used in the BuildConfig. Currently suppoted values are 11, 17, and 21. By default this will be 11.

    oc process --parameters jlink-builder-template
    
    NAME                DESCRIPTION                                GENERATOR           VALUE
    JDK_VERSION         JDK version to produce a jmods image for                       11

In order to set the JDK version, you will need to use the -p flag of oc process. To process the template and create the imagestreams, simply run 

    oc process -n openshift jlink-builder-template -p JDK_VERSION=11 | oc create -f -
    
    imagestream.image.openshift.io/ubi9-openjdk-11-jlink created
    buildconfig.build.openshift.io/jlink-builder-jdk-11 created

3. Start and observe the build

Start the build using

    oc start-build jlink-builder-jdk-11
    
    build.build.openshift.io/jlink-builder-jdk-11-1 started

Then observe it by using

    oc logs -f bc/jlink-builder-jdk-11

## Stage 2: build and analyse application with OpenShift source-to-image (S2I)

TODO
