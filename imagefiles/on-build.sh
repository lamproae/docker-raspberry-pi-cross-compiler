#!/bin/bash

set -e

DEBIAN_PACKAGES=/rpxc/debian-packages.txt
RASPBIAN_PACKAGES=/rpxc/raspbian-packages.txt

export DEBIAN_FRONTEND=noninteractive

if [[ -e $DEBIAN_PACKAGES || -e $DEBIAN_PACKAGES ]] ; then
    apt-get update
fi

if [[ -e $DEBIAN_PACKAGES ]] ; then
    cat $DEBIAN_PACKAGES | xargs -r apt-get install -y
fi

if [[ -e $RASPBIAN_PACKAGES ]] ; then
    cat $RASPBIAN_PACKAGES | xargs -r /rpxc/install-raspbian-packages
fi
