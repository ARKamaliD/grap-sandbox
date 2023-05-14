#include <stddef.h>

void *memmem(const void *haystack, size_t haystacklen,
             const void *needle, size_t needlelen) {
    if (needlelen == 0) { // needle ist leerer String → gültiges Präfix jedes anderen Strings
        return (void *) haystack;
    } else if (needlelen > haystacklen) {
        return NULL;
    } else {
        const char *haystack_char = (const char *) haystack;
        const char *needle_char = (const char *) needle;

        if (needlelen <= 2) {
            for (size_t i = 0; i <= haystacklen - needlelen; i++) {
                if (needle_char[0] == haystack_char[i] &&
                    (needlelen == 1 || needle_char[1] == haystack_char[i + 1])) {
                    return (void *) &haystack_char[i];
                }
            }
            return NULL;
        } else {
            for (size_t i = 0; i <= haystacklen - needlelen; i++) {
                size_t j;
                for (j = 0; j < needlelen; j++) {
                    if (haystack_char[i + j] != needle_char[j]) {
                        break;
                    }
                }
                if (j == needlelen) {
                    return (void *) &haystack_char[i];
                }
            }
            return NULL;
        }
    }
}

/*
void *memmem(const void *haystack, size_t haystacklen,
             const void *needle, size_t needlelen) {
    if (needlelen == 0) { // needle ist leerer String → gültiges Präfix jedes anderen Strings
        return (void *) haystack;
    } else if (needlelen > haystacklen) {
        return NULL;
    } else {
        const char *haystack_char = (const char *) haystack;
        const char *needle_char = (const char *) needle;
        unsigned long long needle_hash = 0;
        unsigned long long haystack_hash = 0;
        unsigned long long prime = 257; // prime number used for hashing
        unsigned long long power = 1; // power of prime used for hashing

        // Compute hash value for needle
        for (size_t i = 0; i < needlelen; i++) {
            needle_hash = needle_hash * prime + needle_char[i];
            haystack_hash = haystack_hash * prime + haystack_char[i];
            power *= prime;
        }

        // Compare hash values of needle and substrings
        for (size_t i = 0; i <= haystacklen - needlelen; i++) {
            if (needle_hash == haystack_hash) {
                // Found potential match; confirm with full comparison
                size_t j;
                for (j = 0; j < needlelen; j++) {
                    if (haystack_char[i + j] != needle_char[j]) {
                        break;
                    }
                }
                if (j == needlelen) {
                    // Match found
                    return (void *) &haystack_char[i];
                }
            }

            // Update haystack hash value for next substring
            if (i < haystacklen - needlelen) {
                haystack_hash = haystack_hash * prime - haystack_char[i] * power
                                + haystack_char[i + needlelen];
            }
        }

        return NULL;
    }
}
*/
