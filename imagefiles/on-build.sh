#!/bin/bash

if [[ -e /rpxc/native-packages.txt ]] ; then
    cat /rpxc/native-packages.txt | xargs -r echo Installing native:
fi

if [[ -e /rpxc/rpi-packages ]] ; then
    cat /rpxc/rpi-packages.txt | xargs -r echo Installing rpi:
fi
