#include <stdio.h>

// Self-assignment: Confusing
void main1() {
  int V1 = 0;
  V1 = V1;
  printf("%d\n", V1);
}

// Self-assignment: Non-Confusing
void main2() {
  int V1 = 0;
  printf("%d\n", V1);
}

// Identical branches: Confusing
void main3() {
  int V1, V2;

  if (V1) {
    V2 = 10000;
  } else {
    V2 = 10000;
  }

  printf("%d\n", V2);
}

// Identical branches: Non-Confusing
void main4() {
  int V1, V2;

  V2 = 10000;

  printf("%d\n", V2);
}

// Overwriting loop: Confusing
void main5() {
  int V1 = 0;
  int V2;

  while (V1 < 100) {
    V1 = V1 + 1;
    V2 = V1;
  }

  printf("%d %d\n", V1, V2);
}

// Overwriting loop: Non-Confusing
void main6() {
  int V1 = 100;
  int V2 = 100;

  printf("%d %d\n", V1, V2);
}

// Intermediate variables: Confusing
void main7() {
  int V1 = 3, V2 = 4, V3, V4, V5, V6;

  V3 = V5;
  V5 = V2;
  V2 = V1;
  V4 = V2;
  V1 = V5;
  V5 = V4;
  V3 = V1;

  printf("%d %d\n", V1, V5);
}

// Intermediate variables: Non-Confusing
void main8() {
  int V1 = 3, V2 = 4;

  printf("%d %d\n", V2, V1);
}

int main() {
  main1();
  main2();

  main3();
  main4();

  main5();
  main6();

  main7();
  main8();
}
