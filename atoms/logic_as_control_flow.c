#include <stdio.h>

// Confusing: short if
void main1() {
  int V1 = 1;
  int V2 = 5;

  if (++V1 || ++V2) {
    V1 = V1 * 2;
    V2 = V2 * 2;
  }

  printf("%d %d\n", V1, V2);
}

// Non-Confusing: short if
void main2() {
  int V1 = 1;
  int V2 = 5;

  if (++V1) {
      V1 = V1 * 2;
      V2 = V2 * 2;
  } else if (++V2) {
      V1 = V1 * 2;
      V2 = V2 * 2;
  }

  printf("%d %d\n", V1, V2);
}

// Confusing: and/or ternary
void main3() {
  int V1 = 1;
  int V2 = 5;

  V1 == V2 && ++V1 || ++V2;

  printf("%d %d\n", V1, V2);
}

// Non-Confusing: and/or ternary
void main4() {
  int V1 = 1;
  int V2 = 5;

  if (V1 == V2) {
    ++V1;
  } else {
    ++V2;
  }

  printf("%d %d\n", V1, V2);
}

// Confusing:
void main5() {
  int V1 = 3;
  int V2 = 5;
  int V3 = 0;

  while (V1 != V2 && ++V1) {
    V3++;
  }

  printf("%d %d %d\n", V1, V2, V3);
}

// Non-Confusing:
void main6() {
  int V1 = 3;
  int V2 = 5;
  int V3 = 0;

  while (V1 != V2) {
    ++V1;
    if (!V1) break;

    V3++;
  }

  printf("%d %d %d\n", V1, V2, V3);
}

int main() {
  main1();
  main2();

  main3();
  main4();

  main5();
  main6();
}
