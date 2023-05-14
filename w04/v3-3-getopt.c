// basiert auf http://man7.org/linux/man-pages/man3/getopt.3.html

#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>

int main(int argc, char *argv[])
{
   long anzahl = 5;
   int t_flag = 0;
   char* strtol_err;
   
   char opt;
   while ((opt = getopt(argc, argv, "tn:")) != -1) {
       switch (opt) {
       case 't':
           t_flag = 1;
           break;
       case 'n':
           anzahl = strtol(optarg, &strtol_err, 10);
           break;
       default: /* '?' oder 'h' */
           fprintf(stderr, "Verwendung: %s [-t] [-n anzahl]\n",
                   argv[0]);
           exit(EXIT_FAILURE);
       }
   }

   printf("n: %ld, t: %d\n", anzahl, t_flag);
   
   /* Code */

   exit(EXIT_SUCCESS);
}
