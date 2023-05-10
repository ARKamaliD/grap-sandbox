# Add additional compiler flags here
CFLAGS=-O0

all: main

# Create a new target named "main" with two dependencies "main.c", "xor.S":
main: main.c xor.S
	# "$@" copy pastes target name "main" in the command below
	# "$^"  copy pastes dependency names "main.c", "xor.S" in the command below
	$(CC) $(CFLAGS) -o $@ $^

clean:
	rm -f main
