#define NOBODY
#include <stdio.h>

int f(int i) {
  if (i % 2) {
    return i * 3;
  } else {
    return i * 2;
  }
}

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

  for (int i = 0; (i % 2 ? i * 3 : i * 2) < 10; i++) printf("%d\n", i);

  for (int i = 0; f(i) < 10; i++) printf("%d\n", i);

  return 0;
}
