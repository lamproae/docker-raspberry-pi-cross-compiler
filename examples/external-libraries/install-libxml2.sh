#!/bin/bash

if [[ ! -d /rpxc ]]; then
    echo usage: rpxc --keep $0
    exit 1
fi

set -e

VERSION=2.9.2
LIBXML2=libxml2-$VERSION
TARBALL=$LIBXML2.tar.gz
URI=ftp://xmlsoft.org/libxml2/$TARBALL

cd /tmp
curl -L $URI | tar -xzf -
cd $LIBXML2
./configure --host=$HOST
make install
cd /build
rm -rf /tmp/$LIBXML2
