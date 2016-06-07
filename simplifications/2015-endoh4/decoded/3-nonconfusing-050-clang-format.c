#include <stdio.h>

int F1(int V1, int V2) {
  int V3, V4;

  printf("a: %d %d\n", V1, V2);

  V4 = 1;
  V3 = V4;

  int V5;

  if (V3 * V3 <= V1) {
    if (V1 % V3 != 0) {
      V4 = V4;
      V5 = V4;
    } else {
      V4 = V3;
      V5 = V4;
    }
  } else {
    if (V2 + 1 != 0) {
      if (V4 < 2) {
        if (V1 != 0) {
          F1(V2, 0);
        }
      } else {
        F1(V4, V2);
      }
      if (V2 != 0) {
        printf("1: %d\n", 10);
      } else {
        printf("2: %d\n", 32 << !V1);
      }
      V1 -= V4 * !!V1;
      V5 = V1;
    } else {
      F1(V4, V1 / V4);
      V5 = 0;
    }
  }

  for (; V5 != 0;) {
    printf("b: %d %d\n", V1, V4);
    V3++;

    if (V3 * V3 <= V1) {
      if (V1 % V3 != 0) {
        V4 = V4;
        V5 = V4;
      } else {
        V4 = V3;
        V5 = V4;
      }
    } else {
      if (V2 + 1 != 0) {
        if (V4 < 2) {
          if (V1 != 0) {
            F1(V2, 0);
          }
        } else {
          F1(V4, V2);
        }
        if (V2 != 0) {
          printf("3: %d\n", 10);
        } else {
          printf("4: %d\n", 32 << !V1);
        }
        V1 -= V4 * !!V1;
        V5 = V1;
      } else {
        F1(V4, V1 / V4);
        V5 = 0;
      }
    }
  }

  return 0;
}

int main() { F1(2, -1); }
