FROM sdt4docker/raspberry-pi-cross-compiler

WORKDIR /build-libs

ADD libxml2-2.9.2.tar.gz /build-libs

RUN cd libxml2-2.9.2 && ./configure --build=armv6l
