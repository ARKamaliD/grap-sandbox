## Disassemblieren mit objdump

```shell
objdump gauss -d -M intel | less
```

Um das `-M intel` nicht immer schreiben zu müssen, kann man auch einen Alias erstellen. Dazu folgende Befehle
ausführen
und danach neu einloggen bzw. eine neue Shell aufmachen.

``` shell
echo 'alias objdump="objdump -M intel"' >> ~/.bashrc
echo '. ~/.bashrc' >> ~/.bash_profile
```

## Optimierungsstufen

```shell
gcc -O2 -o gauss2 gauss.c
```

Weitere Informationen gibt es im [GCC-Manual](https://gcc.gnu.org/onlinedocs/gcc/Optimize-Options.html).

## Godbolt Compiler Explorer

Godbolt Compiler Explorer: [godbolt.org](https://godbolt.org/)

## Für Debugging kompilieren

[debug.c](https://gra.caps.in.tum.de/b/8f9bb44692e01a8258a475b933a2784e6b31ef2204309d9ea0f2f9bcdfacb7c9/v4-1-debug.c)
[aengelke's .gdbinit](http://home.in.tum.de/~engelke/raw/.gdbinit)

`debug.c`

``` c
#include <stdlib.h>
#include <stdio.h>
#include <string.h>

void gen_factors(int* factors, int len) {
int a = 0;
int b = 1;
for(int i = 0; i < len; i++) {
factors[i] = b;

        int c = a + b;
        a = b;
        b = c;
    }
}

int fun1(int x, int y) {
return x % y;
}

int fun2(int n, int* factors, int factors_len) {
int sum = 0;
for(int i = 0; i <= n; i++) {
sum += factors[i % factors_len] * i;
}
return sum;
}

int main(int argc, char** argv) {
int* factors = malloc(sizeof(*factors) * 8);
gen_factors(factors, 8);

    int n = (argc == 0) ? 0 : (argc - 1);
    int len = strlen(argv[n]);
    int magic_number = 42;
    int answer = fun1(len, magic_number);
    printf("The answer is: %i\n", answer);

    int m = answer * len;
    int result = fun2(m, factors, 8);
    printf("The  result is: %i\n", result);

    free(factors);

    return 0;
}
```

```shell
gcc -o debug -O0 -Wall -Wextra -g debug.c
gdb debug
```

### Programmstatus inspizieren

GDB
Dokumentation:[`print`](https://sourceware.org/gdb/current/onlinedocs/gdb.html/Data.html),[`x`](https://sourceware.org/gdb/current/onlinedocs/gdb.html/Memory.html)

### Links

- [debug.c](https://gra.caps.in.tum.de/b/8f9bb44692e01a8258a475b933a2784e6b31ef2204309d9ea0f2f9bcdfacb7c9/v4-1-debug.c)
- [aengelke's .gdbinit](http://home.in.tum.de/~engelke/raw/.gdbinit)
