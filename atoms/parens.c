#include <stdio.h>

void m1() {
  if (! 0 && 1) {
    printf("true\n");
  } else {
    printf("false\n");
  }
}

void m2() {
  if ((!0) && 1) {
    printf("true\n");
  } else {
    printf("false\n");
  }
}

void m_1() {
  int a = 3;
  int b = 1 -(-a);

  printf("%d\n", b);
}

void m3() {
  if (0 && 1 || 1) {
    printf("true\n");
  } else {
    printf("false\n");
  }
}

void m4() {
  if ((0 && 1) || 1) {
    printf("true\n");
  } else {
    printf("false\n");
  }
}

void m5() {
  int a;
  a = 4, 5;
  printf("%d\n", a);
}

void m6() {
  int a;
  (a = 4), 5;
  printf("%d\n", a);
}

// https://www-01.ibm.com/support/knowledgecenter/SSB23S_1.1.0.10/com.ibm.ztpf-ztpfdf.doc_put.10/common/m1rhparn.html
void m7() {
  if (1 & 3 == 1) {
    printf("true\n");
  } else {
    printf("false\n");
  }
}

void m8() {
  if ((1 & 3) == 1) {
    printf("true\n");
  } else {
    printf("false\n");
  }
}

int main() {
  m9();
}
