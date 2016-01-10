#include <stdio.h>

// Without modification: Confusing
void main1() {
  int V1 = 1;
  int V2 = 2;
  int V3 = 3;

  int V4 = 5 + ((V1 - 1) * V2) - (4 * V3);

  printf("%d %d\n", V1, V4);
}

// Without modification: Non-Confusing
void main2() {
  int V1 = 1;
  int V2 = 2;
  int V3 = 3;

  int V4 = (V1 - 1) * V2;

  int V5 = 4 * V3;

  int V6 = 5 + V4 - V5;

  printf("%d %d\n", V1, V6);
}

// With modification: Confusing
void main3() {
  int V1 = 1;
  int V2 = 2;
  int V3 = 3;

  int V4 = 5 + ((V1 += 1) * V2) - (4 * V3);

  printf("%d %d\n", V1, V4);
}

// With modification: Non-Confusing
void main4() {
  int V1 = 1;
  int V2 = 2;
  int V3 = 3;

  V1 += 1;

  int V4 = V1 * V2;

  int V5 = 4 * V3;

  int V6 = 5 + V4 - V5;

  printf("%d %d\n", V1, V6);
}

int main() {
  main1();
  main2();

  main3();
  main4();
}

