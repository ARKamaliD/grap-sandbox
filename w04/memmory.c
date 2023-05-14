#include <stdlib.h>
#include <string.h>
#include <stdio.h>
int main() {
    size_t bufsize = 40;
    char* buf = malloc(bufsize * sizeof(char));
    if (!buf) { // Ueberpruefung von malloc
        printf("Malloc failed. Exiting.\n");
        exit(1);
    }
    printf("Please enter your name:\n");
    fgets(buf, bufsize, stdin); // fgets statt scanf (never use scanf)
    printf("Hello %s!\n", buf); // Keine Formatstringluecke
    if (!strlen(buf)) {
        printf("You didn't enter your name!\n");
        free(buf); // kein Memory Leak
        return 1;
    } else if (strlen(buf) > 20) {
        printf("You have a really long name, %s!\n", buf);
    }
    printf("Thank you for introducing yourself, %s!\n", buf); // kein UAF
    free(buf); // kein Double Free
    return 0;
}
