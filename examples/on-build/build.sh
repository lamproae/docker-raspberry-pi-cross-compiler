#!/bin/bash

: ${RPXC_IMAGE:=rpxc-downstream}

docker build -t $RPXC_IMAGE .
