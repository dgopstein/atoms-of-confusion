#include <stdio.h>

// Confusing: string literal, index literal
void main1() {
  char V1 = 2["abcdef"];

  printf("%c\n", V1);
}

// Non-Confusing: string literal, index literal
void main2() {
  char V1 = "abcdef"[2];

  printf("%c\n", V1);
}

// Confusing: string literal, index variable
void main3() {
  char V1 = 3;
  char V2 = V1["abcdef"];

  printf("%c\n", V2);
}

// Non-Confusing: string literal, index variable
void main4() {
  char V1 = 3;
  char V2 = "abcdef"[V1];

  printf("%c\n", V2);
}

// Confusing: string variable, index variable
void main5() {
  char V1 = 4;
  char* V2 = "abcdef";
  char V3 = V1[V2];

  printf("%c\n", V3);
}

// Non-Confusing: string variable, index variable
void main6() {
  char V1 = 4;
  char* V2 = "abcdef";
  char V3 = V2[V1];

  printf("%c\n", V3);
}

int main() {
  main1();
  main2();

  main3();
  main4();

  main5();
  main6();
}
