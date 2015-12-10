#include <stdio.h>

void f1() {
  int v1[] = {12345, 23451, 34512};
  void *v2 = &v1;
  //char v1[] = {'a', 'b', 'c', 'd', 'e', 'f'};
  printf("1: %d\n", v1[1]);
  printf("2: %d\n", *(v1+1));
  printf("3: %d\n", *(int *)((void*)v1+1));
  printf("4: %d\n", *(1+v1));
  printf("5: %d\n", *(int *)(v2+1));
}

void f2() {
  char *v1 = "0123456789";
  int *v2 = v1;

  printf("1: %d\n", *(v2+4));
}

int main() {
  //f1();
  f2();
}
