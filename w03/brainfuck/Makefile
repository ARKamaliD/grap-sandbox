# Add additional compiler flags here
CFLAGS=-O2 -Wall -Wextra -Wpedantic -g -std=c11

all: brainfuck
brainfuck: brainfuck.c
	$(CC) $(CFLAGS) -o $@ $^
clean:
	rm -f brainfuck

