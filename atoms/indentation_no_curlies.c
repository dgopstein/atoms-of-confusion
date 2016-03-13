#include <stdio.h>

// Confusing: empty if
void main1() {
  int V1 = 0;
  int V2 = 2;

  if (V1);
    V2 = 4;

  printf("%d\n", V2);
}

// Non-Confusing: empty if
void main2() {
  int V1 = 0;
  int V2 = 2;

  if (V1);
  V2 = 4;

  printf("%d\n", V2);
}

// Confusing: full if
void main3() {
  int V1 = 0;
  int V2 = 1;

  if (V1)
    V2 = 2;
    V2 = V2 * 3;

  printf("%d\n", V2);
}

// Non-Confusing: full if
void main4() {
  int V1 = 0;
  int V2 = 1;

  if (V1)
    V2 = 2;
  V2 = V2 * 3;

  printf("%d\n", V2);
}

//Confusing: Dangling Else
void main5() {
  int V1 = 2;
  int V2 = 0;
  int V3 = 3;

  if (V1)
    if (V2)
      V3 = V3 + 2;
  else
    V3 = V3 + 4;

  printf("%d\n", V3);
}

// Non-Confusing: Dangling Else
void main6() {
  int V1 = 2;
  int V2 = 0;
  int V3 = 3;

  if (V1)
    if (V2)
      V3 = V3 + 2;
    else
      V3 = V3 + 4;

  printf("%d\n", V3);
}

int main() {
  main1();
  main2();

  main3();
  main4();

  main5();
  main6();
}
