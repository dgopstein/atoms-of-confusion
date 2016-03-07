#include <stdio.h>

//Confusing: float to int
void main1() {
  float V1 = 1.99;

  int V2 = V1;

  printf("%d\n", V2);
}

//Non-Confusing: float to int
#include <math.h>
void main2() {
  float V1 = 1.99;

  int V2 = trunc(1.99);

  printf("%d\n", V2);
}

// Confusing: signed to unsigned
void main3() {
  int V1 = -1;

  unsigned int V2 = V1;

  int V3;
  if (V2 > 0) {
    V3 = 4;
  } else {
    V3 = 5;
  }

  printf("%d\n", V3);
}

// Non-Confusing: signed to unsigned
#include <limits.h>
void main4() {
  int V1 = -1;

  unsigned int V2;
  if (V1 >= 0) {
    V2 = V1;
  } else {
    V2 = UINT_MAX + (V1 + 1);
  }

  int V3;
  if (V2 >= 0) {
    V3 = 4;
  } else {
    V3 = 5;
  }

  printf("%d\n", V3);
}

// Confusing: int to char
void main5() {
  int V1 = 261;

  char V2 = V1;

  printf("%d\n", V2);
}

// Confusing: int to char
void main6() {
  int V1 = 261;

  char V2 = V1 % 256;

  printf("%d\n", V2);
}

int main() {
  main1();
  main2();

  main3();
  main4();

  main5();
  main6();
}
