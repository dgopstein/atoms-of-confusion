#include <stdio.h>

// Confusing: dead code
void main1() {
  int V1 = 1;

  V1 = 3;
  V1 = 2;

  printf("%d\n", V1);
}

// Non-Confusing: dead code
void main2() {
  int V1 = 1;

  V1 = 2;

  printf("%d\n", V1);
}

// Confusing: unused code
void main3() {
  int V1 = 1;

  if (0) {
    V1 = 3;
  }

  printf("%d\n", V1);
}

// Non-Confusing: unused code
void main4() {
  int V1 = 1;

  printf("%d\n", V1);
}

// Confusing: repeated code
void main5() {
  int V1 = 0;

  V1 = V1;

  printf("%d\n", V1);
}

// Non-Confusing: repeated code
void main6() {
  int V1 = 0;

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
