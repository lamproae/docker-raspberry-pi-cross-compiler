FROM debian:jessie
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

RUN dpkg --add-architecture armhf \
 && echo deb '[arch=armhf]' http://mirrordirector.raspbian.org/raspbian/ jessie main \
        >> /etc/apt/sources.list \
 && curl -Ls https://archive.raspbian.org/raspbian.public.key \
        | apt-key add - \
 && apt-get update \
 ;

RUN curl -s -L https://github.com/raspberrypi/tools/tarball/master | \
        tar --strip-components 1 -xzf -

RUN DEBIAN_FRONTEND=noninteractive apt-get download \
        libc6-dev:armhf \
        libsqlite3-dev:armhf \
        linux-libc-dev:armhf \
        ;

# These need to get installed in a chroot environment. Use debootstrap?
RUN for i in *.deb; do dpkg-deb -x $i /rpxc/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/arm-linux-gnueabihf/libc/; done

WORKDIR /build
ENTRYPOINT [ "/rpxc/entrypoint.sh" ]

COPY imagefiles/entrypoint.sh imagefiles/rpxc /rpxc/
