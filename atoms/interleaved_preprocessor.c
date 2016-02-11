#include <stdio.h>

// Macro in assignment: Confusing
void main1() {
    char *V1 = "qwertyuiop"
    #define M1
    "zxcvbnm,.";

    printf("%s\n", V1);
}

// Macro in assignment: Non-Confusing
void main2() {
    char *V1 = "qwertyuiop"
    "zxcvbnm,.";

    #define M1

    printf("%s\n", V1);
}

// Macro in expression: Confusing
void main3() {
  int V1;
  V1 = 4;

  int V2 = 1
  #define M2 2
  +
  #define M3 3
  V1;

  printf("%d %d\n", V1, V2);
}

// Macro in expression: Non-Confusing
void main4() {
  #define M2 2
  #define M3 3

  int V1;
  V1 = 4;

  int V2 = 1 + V1;

  printf("%d %d\n", V1, V2);
}

// Macro conditional assignment: Confusing
void main5() {
  int V1 = 1, V2 = 2;

  if (V1 < V2) {
    #define M1 1
    #define M2 2
  } else {
    #define M1 2
    #define M2 1
  }
  
  printf("%d %d\n", M1, M2);
}

// Macro conditional assignment: Non-Confusing
void main6() {
  #define M1 2
  #define M2 1

  printf("%d %d\n", M1, M2);
}

// Macro reassignment: Confusing
void main7() {
  int V1 = 0;

  for (int V2 = 0; V2 < 2; V2++) {
    #define M1(x) x+1
    V1 = M1(0);
  }

  printf("%d\n", V1);
}

// Macro reassignment: Non-Confusing
void main8() {
  int V1 = 0;

  #define M1(x) x+1

  for (int V2 = 0; V2 < 3; V2++) {
    V1 = M1(0);
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

  main7();
  main8();
}

// trigraphs: Confusing
//void main1() {
//  char *V1[] = {"abc", "def", "ghi"};
//
//  char *V2 = V1[1??)??(2]
//
//  printf("%d\n", V2);
//}
