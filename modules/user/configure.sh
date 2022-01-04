#!/bin/bash
set -e

# Create a user and group used to launch processes
# We use the ID 185 for the group as well as for the user.
# This ID is registered static ID for the JBoss EAP product
# on RHEL which makes it safe to use.
groupadd -r jboss -g 185 && useradd -u 185 -r -g root -G jboss -m -d /home/jboss -s /sbin/nologin -c "JBoss user" jboss
chmod ug+rwX /home/jboss

# OPENJDK-533: Some container runtimes (Docker) will fail to start if
# the running UID cannot chdir to $HOME
chmod og+x /home/jboss
