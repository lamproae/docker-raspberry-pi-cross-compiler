#!/bin/bash

RPXC=rpxc
LIBXML2=libxml2-2.9.2

$RPXC --keep rpxc-with-libxml2 bash -c "\
    set -e
    cd /tmp/
    tar -xzf /build/$LIBXML2.tar.gz
    cd $LIBXML2
    ./configure --host=\$HOST
    make install
    echo ok.

"

docker commit rpxc-with-libxml2 rpxc-with-libxml2

rpxc --image rpxc-with-libxml2 rpxc gcc -I /usr/local/include/libxml -L /usr/local/lib -o test test.c
