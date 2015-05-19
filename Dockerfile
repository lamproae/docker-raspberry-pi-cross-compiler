FROM debian:wheezy
MAINTAINER Stephen Thirlwall <sdt@dr.com>

WORKDIR /rpxc

RUN sed -i -e 's/^deb /deb [arch=amd64] /' /etc/apt/sources.list \
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
        ;

RUN curl -s -L https://github.com/raspberrypi/tools/tarball/master | \
        tar --strip-components 1 -xzf -

RUN dpkg --add-architecture armhf \
 && echo deb '[arch=armhf]' http://mirrordirector.raspbian.org/raspbian/ wheezy main \
        >> /etc/apt/sources.list \
 && curl -Ls https://archive.raspbian.org/raspbian.public.key \
        | apt-key add - \
 && apt-get update \
 ;

WORKDIR /build
ENTRYPOINT [ "/rpxc/entrypoint.sh" ]

COPY imagefiles/* /rpxc/

ENV CCROOT /rpxc/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/arm-linux-gnueabihf/libc/

RUN /rpxc/install-rpi-package \
        libc6-dev \
        libsqlite3-0 \
        libsqlite3-dev \
        linux-libc-dev \
        ;

RUN /rpxc/install-rpi-package \
    libxml2-dev \
    libxml2
    ;

RUN /rpxc/install-rpi-package \
    libsdl1.2-dev
