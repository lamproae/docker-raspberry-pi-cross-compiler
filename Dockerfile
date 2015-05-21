FROM debian:wheezy
MAINTAINER Stephen Thirlwall <sdt@dr.com>

# Here is where we hardcode the toolchain decision.
ENV HOST=arm-linux-gnueabihf \
    TOOLCHAIN=gcc-linaro-arm-linux-gnueabihf-raspbian

# I'd put all these into the same ENV command, but you cannot define and use
# a var in the same command.
ENV ARCH=arm \
    RASPBIAN_ROOT=/rpxc/$TOOLCHAIN/$HOST/libc \
    CROSS_COMPILE=/rpxc/$TOOLCHAIN/bin/$HOST-
ENV AS=${CROSS_COMPILE}as \
    AR=${CROSS_COMPILE}ar \
    CC=${CROSS_COMPILE}gcc \
    CPP=${CROSS_COMPILE}cpp \
    CXX=${CROSS_COMPILE}g++ \
    LD=${CROSS_COMPILE}ld

# 1. Modify our existing apt sources to be amd64-only.
# 2. Install debian packages.
# 2. Fetch the raspberrypi/tools tarball from github.
# 3. Extract only the toolchain we will be using.
# 4. Create rpxc- prefixed symlinks in /usr/local/bin (eg. rpxc-gcc, rpxc-ld).
# 5. Add the raspbian repo for armhf packages.
# 6. Let automake know where our cross-compile aclocal dir is.
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
 &&  curl -s -L https://github.com/raspberrypi/tools/tarball/master \
     | tar --wildcards --strip-components 2 -xzf - "*/arm-bcm2708/$TOOLCHAIN/" \
 && mkdir -p /usr/local/bin \
 && for i in ${CROSS_COMPILE}*; do \
        ln -sf $i /usr/local/bin/rpxc-${i#$CROSS_COMPILE}; \
    done \
 && dpkg --add-architecture armhf \
 && echo deb '[arch=armhf]' http://mirrordirector.raspbian.org/raspbian/ \
        wheezy main >> /etc/apt/sources.list \
 && curl -Ls https://archive.raspbian.org/raspbian.public.key | apt-key add - \
 && echo "$RASPBIAN_ROOT/usr/share/aclocal" >> /usr/share/aclocal/dirlist \
 ;

WORKDIR /build
ENTRYPOINT ["/rpxc/entrypoint.sh"]

COPY imagefiles/* /rpxc/

# In downstream images, automatically install requested packages.
ONBUILD COPY *-packages.txt /rpxc/
ONBUILD RUN /rpxc/on-build.sh
