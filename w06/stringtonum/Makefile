CFLAGS=-std=c11 -O3 -Wall -Wextra -Wpedantic

.PHONY: all clean
all: stringtonum
stringtonum: stringtonum.c
	$(CC) $(CFLAGS) -o $@ $^ -lm
clean:
	rm -f stringtonum
