FROM debian:jessie
MAINTAINER Stephen Thirlwall <sdt@dr.com>

WORKDIR /rpxc

RUN dpkg --add-architecture armhf \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        automake \
        bc \
        bison \
        cmake \
        curl \
        flex \
        lib32stdc++6 \
        lib32z1 \
        ncurses-dev \
        runit \
        libsqlite3-dev:armhf \
        ;

RUN curl -s -L https://github.com/raspberrypi/tools/tarball/master | \
        tar --strip-components 1 -xzf -

WORKDIR /build
ENTRYPOINT [ "/rpxc/entrypoint.sh" ]

COPY imagefiles/entrypoint.sh imagefiles/rpxc /rpxc/

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y \
        g++:armhf
