#include <stdio.h>

// Confusing: empty if
void main1() {
  int V1 = 0;
  int V2 = 2;

  if (V1) {}
    V2 = 4;

  printf("%d\n", V2);
}

// Non-Confusing: empty if
void main2() {
  int V1 = 0;
  int V2 = 2;

  if (V1) {}
  V2 = 4;

  printf("%d\n", V2);
}

// Confusing: full if
void main3() {
  int V1 = 0;
  int V2 = 1;

  if (V1) {
    V2 = 2;
  }
    V2 = V2 * 3;

  printf("%d\n", V2);
}

// Non-Confusing: full if
void main4() {
  int V1 = 0;
  int V2 = 1;

  if (V1) {
    V2 = 2;
  }
  V2 = V2 * 3;

  printf("%d\n", V2);
}

// Confusing: while
void main5() {
  int V1 = 0;

  for (int V2 = 0; V2 < 3; V2++) {
    V1 = V1 + 2;
  }
    V1 = V1 + 1;

  printf("%d\n", V1);
}

// Non-Confusing: while
void main6() {
  int V1 = 0;

  for (int V2 = 0; V2 < 3; V2++) {
    V1 = V1 + 2;
  }
  V1 = V1 + 1;

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
