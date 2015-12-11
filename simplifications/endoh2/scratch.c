#include <stdio.h>

int main() {
  // This is code where comments give necessary whitespace
  int/**/x = 1;
  int    y = 2;
  printf("x y: %d %d\n", x, y);

  // This shows that macros don't make substitutions inside of strings
  #define COMMAC q=/*XYXY*/
  int COMMAC 2;
  printf(" COMMAC : %d\n", q);

  // Unnormalizable code
  #define f(a) #a
  int hello, world;
  printf("%s %s!\n", f(hello), f(world));

  return 0;
}
