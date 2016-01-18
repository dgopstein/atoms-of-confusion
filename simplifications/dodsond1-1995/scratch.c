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

  return 0;
}
