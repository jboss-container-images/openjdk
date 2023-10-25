FROM    registry.access.redhat.com/ubi8/ubi-minimal:latest

# binutils: objcopy
RUN microdnf --setopt=install_weak_deps=0 --setopt=tsflags=nodocs install -y \
    java-17-openjdk-headless java-17-openjdk-devel java-17-openjdk-jmods \
    binutils \
    && microdnf clean all \
    && rpm -q \
    java-17-openjdk-headless java-17-openjdk-devel java-17-openjdk-jmods

ENV     JAVA_HOME=/usr/lib/jvm/jre
WORKDIR /tmp
COPY    generatejdkdeps.sh mkdeps.sh mkjreimage.sh mkstrippeddeps.sh runall.sh /tmp/

# ?
USER    1000
RUN     mkdir -p /tmp/run/lib

CMD     ./runall.sh
