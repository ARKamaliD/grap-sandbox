CFLAGS=-std=c11 -O0 -Wall -Wextra -Wpedantic -g

all: outerprod
outerprod: outerprod.c outerprod_helpers.c
	$(CC) $(CFLAGS) -o $@ $^
clean:
	rm -f outerprod
