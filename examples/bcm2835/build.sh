#!/bin/bash

: ${RPXC_IMAGE:=rpxc-with-bcm2835}

docker build --no-cache -t $RPXC_IMAGE .
