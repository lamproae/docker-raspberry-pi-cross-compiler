#!/bin/bash

set -e

DEBIAN_PACKAGES=/rpxc/debian-packages.txt
RASPBIAN_PACKAGES=/rpxc/raspbian-packages.txt

export DEBIAN_FRONTEND=noninteractive

uncomment() {
    sed -e 's/\s*#.*$//; /^\s*$/d' "$@"
}

if [[ -e $DEBIAN_PACKAGES ]] ; then
    uncomment $DEBIAN_PACKAGES | xargs -r /rpxc/install-debian-packages
fi

if [[ -e $RASPBIAN_PACKAGES ]] ; then
    uncomment $RASPBIAN_PACKAGES | xargs -r /rpxc/install-raspbian-packages
fi
