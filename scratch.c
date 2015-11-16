#include <stdio.h>
#include <string.h>

int main(int v, char** b) {
  // v starts at one, even when no args are passed
  printf("v: %d, b[0]: %s\n", v, b[0]);

  printf("\n");
  // 0,5,5 -> 5,5,5    # f is uninitialized the first round, because d was
  int f,d,u;
  u=5;
  f=d,d=u; printf("f: %d, d: %d, u: %d\n", f, d, u);
  f=d,d=u; printf("f: %d, d: %d, u: %d\n", f, d, u);


  printf("\n");
  // the ternary colon (:) doesn't catch the assignment (c=5) at the end, the value here is 3.
  int a,c;
  int ternary;
  ternary = 1 ?a=2,3:4,c=5;
  printf("ternary: %d\n", ternary);
}
