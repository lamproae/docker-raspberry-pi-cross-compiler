#!/bin/bash

: ${RPXC_IMAGE:=rpxc-with-boost}

docker build --no-cache -t $RPXC_IMAGE .
