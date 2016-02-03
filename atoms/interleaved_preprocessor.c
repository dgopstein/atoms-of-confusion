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

int main() {
  main1();
  main2();

  main3();
  main4();

  //main5();
  //main6();
}

// trigraphs: Confusing
//void main1() {
//  char *V1[] = {"abc", "def", "ghi"};
//
//  char *V2 = V1[1??)??(2]
//
//  printf("%d\n", V2);
//}
