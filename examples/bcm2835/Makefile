# build with: rpxc make
LDFLAGS=-lbcm2835

blink: blink.c
	$(CC) -o $@ $^ $(LDFLAGS)

clean:
	rm -f blink
