#define NOBODY
#include <stdio.h>

int f(int i) {
  if (i % 2) {
    return i * 3;
  } else {
    return i * 2;
  }
}

  /*
  int h(int a, int b) {
    return a + b;
  }
  h(f = 2, f = 3) // unsequenced
  */

int F1(int A1) {
  return A1;
}

int F2(int* A1) {
  *A1 += 1;
  return *A1-1;
}

int main() {
  int a = 1, b = 2;
  printf("%d, %d\n", a, b);

  a = + +b;
  printf("%d, %d\n", a, b);

  // blank macro is interpreted as whitespace
  a = +NOBODY+b;
  printf("%d, %d\n", a, b);

  a = ++b;
  printf("%d, %d\n", a, b);

  //char *c = "cvz";
  //printf("%c, %c, %c\n", *c, *c++, *c); // unsequenced

  char *d = "cvz\n";
  for (int i = 0; *d; putchar(*d++)) ;

  char *e = "cvz\n";
  for (int i = 0; *e; putchar(*e)) e+=1;

  printf("\n--------------\n");
  for (int i = 0; (i % 2 ? i * 3 : i * 2) < 10; i++) printf("%d\n", i);
  for (int i = 0; f(i) < 10; i++) printf("%d\n", i);
  printf("--------------\n\n");

  int f = 1;
  //int g = f++ + f++; // unsequenced
  int g = 0;
  printf("%d %d\n", g, f);

  f = 1;
  g = f + f + 1;
  f += 2;
  printf("%d %d\n", g, f);

  printf("\n--------------\n\n");

  f = 0;
  g = f++ && f++;
  printf("%d %d\n", g, f);

  f = 0;
  g = f && f + 1;
  f += 2;
  printf("%d %d\n", g, f);

  printf("\n--------------\n\n");

  f = 0;
  printf("%d\n", 0 || (f = 0));
  printf("%d\n", 0 || (f = 1));
  printf("%d\n", 0 || (f = 2));
  printf("%d\n", 1 || (f = 0));
  printf("%d\n", 1 || (f = 1));
  printf("%d\n", 1 || (f = 2));

  printf("\n--------------\n\n");

  //printf("%d %d\n", f = 2, f, f = 3, f); unsequenced

  int V1 = 0;
//  V1 = F1(F2(&V1));
  V1 = F1(V1++);
  printf("%d\n", V1);

  //V1 = {2, 5, 6, 3};
  //V2 = V1;
  //while ( condition && ((V2 == V1) && !(*(V2++) = 8)) || !(*(V2++) = 1)) { stuff }

  return 0;
}
