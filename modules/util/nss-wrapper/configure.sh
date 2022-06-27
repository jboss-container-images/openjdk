#!/bin/bash
set -euo pipefail

# set up a copy of the passwd file which nss_wrapper will use.
cp /etc/passwd /home/default/passwd
chmod ug+rwX /home/default/passwd
