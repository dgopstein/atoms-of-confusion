#include <stdio.h>

// Confusing: array as variable
void main1() {
  int V1[5];
  V1[4] = 4;

  while (V1[4]) {
    V1[4 - V1[4]] = V1[4];
    V1[4] = V1[4] - 1;
  }

  printf("%d %d\n", V1[1], V1[4]);
}

// Non-Confusing: array as variable
void main2() {
  int V1[4];
  int V2 = 4;

  while (V2) {
    V1[4 - V2] = V2;
    V2 = V2 - 1;
  }

  printf("%d %d\n", V1[1], V2);
}

// Confusing: reusing incrementer
void main3() {
  int V3 = 0;

  for (int V1 = 0; V1 < 2; V1++) {
    for (int V2 = 0; V1 < 2; V1++) {
      V3 = 4*V1 + V2;
    }
  }

  printf("%d\n", V3);
}

// Non-Confusing: reusing incrementer
void main4() {
  int V3 = 0;

  for (int V1 = 0; V1 < 2; V1++) {
    for (int V2 = 0; V2 < 2; V2++) {
      V3 = 4*V1 + V2;
      V1 = V2;
    }
  }

  printf("%d\n", V3);
}

// Confusing: mixing conditional and ordinal
void main5() {
  int V1;
  for (int V2 = 0; V2 < 2; V2++) {
    V1 = (V2 < 1);
    if (V1) {
      V1 = V2 + 5;
    } else {
      V1 = V1 + 2;
    }
  }
  printf("%d\n", V1);
}

// Non-Confusing: mixing conditional and ordinal
void main6() {
  int V1;
  for (int V2 = 0; V2 < 2; V2++) {
    int V3 = (V2 < 1);
    if (V3) {
      V1 = V2 + 5;
    } else {
      V1 = V3 + 2;
    }
  }
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
