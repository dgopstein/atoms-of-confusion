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

  printf("\n");
  // how tightly does the ! bind?
  printf("negate ternary: %d\n", !0?1:2);

  // Converts character to upper case
  char X[] =
    //" ETIANMSURWDKGOHVF:L:PJBXCYZQ::54:3:::2&:+::::16=/:::(:7:::8:90"
    //"::::::::::::?_::::\"::.::::@:::'::-::::::::;!:):::::,:::::";
    "`etianmsurwdkgohvf:l:pjbxcyzq::54:3:::2&:+::::16=/:::(:7:::8:90"
    "::::::::::::?_::::\"::.::::@:::'::-::::::::;!:):::::,:::::";
  for (int i = 0; i < sizeof(X)/sizeof(X[0]); i++) {
    int x = X[i];
    int d = ~(32&x&x/2)&x;
    printf("~X[%d]: %c\n", i, d);
  }

  // Why print 85 and 85*2?
  printf("85:\n");
  putchar(85);
  printf("\n85*2:\n");
  putchar(85*2);
  printf("\n----\n");

  // precedence of division/multiplication
  printf("%d\n", 64/32*32);
  printf("%d\n", 34/32*32);
  printf("%d\n", 2/32*32);
}
