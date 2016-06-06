#include <stdio.h>

int main(int argc, char **argv) {
  argv = 0;
  printf("1-argv: %d\n", (int)argv);

  argv++;
  printf("2-argv: %d\n", (int)argv);

  char *c = 0;
  printf("1-c: %d\n", (int)c);
  c++;
  printf("2-c: %d\n", (int)c);

  char **cc = 0;
  printf("1-cc: %d\n", (int)cc);
  cc++;
  printf("2-cc: %d\n", (int)cc);

  char **cc2 = 0;
  printf("1-cc2: %d\n", (int)cc2);
  cc2+=1;
  printf("2-cc2: %d\n", (int)cc2);

  char **cc3 = 0;
  printf("1-cc3: %d\n", (int)cc3);
  cc3+=2;
  printf("3-cc3: %d\n", (int)cc3);
}
