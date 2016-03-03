#include <stdio.h>

//Confusing: Conditional
void main1() {
  int V1 = 2;

  if (0) V1++; V1++;

  printf("%d\n", V1);
}

//Non-Confusing: Conditional
void main2() {
  int V1 = 2;

  if (0) { V1++; } V1++;

  printf("%d\n", V1);
}

//Confusing: While Loop
void main3() {
  int V1 = 4;

  int V2 = 0;
  while (V2 < 3) V2++; V1++;

  printf("%d %d\n", V1, V2);
}

//Non-Confusing: While Loop
void main4() {
  int V1 = 4;

  int V2 = 0;
  while (V2 < 3) { V2++; } V1++;

  printf("%d %d\n", V1, V2);
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

//Non-Confusing: Dangling Else
void main6() {
  int V1 = 2;
  int V2 = 0;
  int V3 = 3;

  if (V1) {
    if (V2) {
      V3 = V3 + 2;
    } else {
      V3 = V3 + 4;
    }
  }

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
