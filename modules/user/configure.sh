#!/bin/bash
set -e

# Create a user and group used to launch processes
# We use the ID 185 for the group as well as for the user.
# This ID is registered static ID for the JBoss EAP product
# on RHEL which makes it safe to use.
groupadd -r default -g 185 && useradd -u 185 -r -g root -G default -m -d /home/default -s /sbin/nologin -c "Default user" default

# OPENJDK-533, OPENJDK-556: correct permissions for OpenShift etc
chmod 0770 /home/default
