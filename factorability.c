#include <stdio.h>

void f1() {
  int v1[] = {2, 1};
  int *v2 = v1;
  *v2++;
  printf("%d\n", *v2);
}

void f2() {
  int v1[] = {2, 1};
  int *v2 = v1;
  //*v2 += 1;
  *v2;
  v2 = v2 + 1;
  printf("%d\n", *v2);
}

void f3() {
  int v1[] = {2, 1};
  int *v2 = v1;
  //v1[0]++;
  v2++[0];
  printf("%d\n", *v2);
}

int main() {
  f1();
  f2();
  f3();
}
