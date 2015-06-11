FROM sdt4docker/raspberry-pi-cross-compiler

RUN cd /usr/local/src \
 && curl -Ls http://www.airspayce.com/mikem/bcm2835/bcm2835-1.42.tar.gz \
        | tar -xzf - \
 && cd bcm2835-1.42 \
 && ./configure --host $HOST --prefix $RASPBIAN_ROOT/usr \
 && make install
