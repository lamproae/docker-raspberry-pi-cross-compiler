#!/bin/bash

: ${RPXC_IMAGE:=rpxc-downstram}

docker build -t $RPXC_IMAGE .
