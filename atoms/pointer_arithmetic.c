#include <stdio.h>

// String literal arithmetic: Confusing
void main1() {
  char *V1 = "abcdef" + 3;

  printf("%s\n", V1);
}

// String literal arithmetic: Non-Confusing
void main2() {
  char *V1 = &("abcdef"[3]);

  printf("%s\n", V1);
}

// Int array incrementation: Confusing
void main3() {
  int V1[] = {4, 2, 7, 5};

  int *V2 = V1 + 1;

  printf("%d\n", *V2);
}

// Int array incrementation: Non-Confusing
void main4() {
  int V1[] = {4, 2, 7, 5};

  int *V2 = &V1[1];

  printf("%d\n", *V2);
}

void main5() {
  char *V1 = "abcdef" + 2;
  char *V2 = V1 - 1;
  printf("%s\n", V2);
}

void main6() {
  char *V1 = &("abcdef"[2]);
  char *V2 = V1;
  printf("%s\n", V1);
}

int main() {
  main1();
  main2();

  main3();
  main4();

  main5();
  main6();
}
