# Add additional compiler flags here
CFLAGS=-O0

all: main
main: main.c xor.S
	$(CC) $(CFLAGS) -o $@ $^
clean:
	rm -f main

