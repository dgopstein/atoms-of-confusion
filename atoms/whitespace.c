#include <stdio.h>

//Confusing: pointer declaration
void main1() {
  char* V1, V2;

  int V3;
  if (sizeof(V1) == sizeof(V2)) {
    V3 = 1;
  } else {
    V3 = 2;
  }

  printf("%d\n", V3);
}

//Non-Confusing: pointers declaration
void main2() {
  char *V1, V2;

  int V3;
  if (sizeof(V1) == sizeof(V2)) {
    V3 = 1;
  } else {
    V3 = 2;
  }

  printf("%d\n", V3);
}

// Confusing: Newline
void main3() {
  int V1 = 1;
  int V2 = 2;

  if (V1) { V2 = V2 + 1; } V2 = V2 + 1;

  printf("%d\n", V2);
}

// Non-Confusing: Newline
void main4() {
  int V1 = 1;
  int V2 = 2;

  if (V1) {
    V2 = V2 + 1;
  }
  V2 = V2 + 1;

  printf("%d\n", V2);
}

// Confusing: Function application
int F1(int A1) { return A1 + 2; }
void main5() {
  int V1 = F1 (3+1)*2;

  printf("%d\n", V1);
}

// Non-Confusing: Function application
int F2(int A1) { return A1 + 2; }
void main6() {
  int V1 = F2(3+1) * 2;

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
