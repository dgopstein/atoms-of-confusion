#include <stdio.h>

// Confusing: Ascii -> Char
void main1() {
  char V1 = 103;

  printf("%c\n", V1);
}

// Non-Confusing: Ascii -> Char
void main2() {
  char V1 = 'g';

  printf("%c\n", V1);
}

// Confusing: Oct -> Dec
void main3() {
  int V1 = 013;

  printf("%d\n", V1);
}

// Non-Confusing: Oct -> Dec
void main4() {
  char V1 = 11;

  printf("%d\n", V1);
}

// Confusing: Bitmask
void main5() {
  int V1 = 208 & 13;

  printf("%d\n", V1);
}

// Non-Confusing: Bitmask
void main6() {
  char V1 = 0xD0 & 0x0D;

  printf("%d\n", V1);
}

int main() {
  main1();
  main2();

  main3();
  main4();

  main5();
  main6();
}
