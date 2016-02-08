#define NOBODY
#include <stdio.h>

int main() {
  int a = 1, b = 2;
  printf("%d, %d\n", a, b);

  a = + +b;
  printf("%d, %d\n", a, b);

  // blank macro is interpreted as whitespace
  a = +NOBODY+b;
  printf("%d, %d\n", a, b);

  a = ++b;
  printf("%d, %d\n", a, b);

  char *c = "cvz";
  printf("%c, %c, %c\n", *c, *c++, *c);

  char *d = "cvz\n";
  for (int i = 0; *d; putchar(*d++)) ;

  char *e = "cvz\n";
  for (int i = 0; *e; putchar(*e)) e+=1;


  return 0;
}
