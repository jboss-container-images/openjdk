#!/bin/bash
set -euo pipefail

for candidate in yum dnf microdnf; do
    if command -v "$candidate"; then
        mgr="$(command -v "$candidate")"
        "$mgr" update --setopt=install_weak_deps=0 --setopt=tsflags=nodocs -y
        "$mgr" -y clean all
        exit
    fi
done

echo "cannot find a package manager" >&2
exit 1
