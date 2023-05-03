# Add additional compiler flags here
#CFLAGS=-O0  -Wall -Wextra -Wpedantic -std=c11
#CFLAGS=-O2  -Wall -Wextra -Wpedantic -std=c11
CFLAGS=-O0 -g  -Wall -Wextra -Wpedantic -std=c11

all: gcd
gcd: gcd.c
	$(CC) $(CFLAGS) -o $@ $^
clean:
	rm -f gcd

