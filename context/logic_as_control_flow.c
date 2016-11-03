#include <stdio.h>

void toplevel_C() {
  int V1 = 1;
  int V2 = 2;

  V1 || (V2 = 3);

  printf("%d %d\n", V1, V2);
}

void toplevel_NC() {
  int V1 = 1;
  int V2 = 2;

  if (V1 == 0) {
    V2 = 3;
  }

  printf("%d %d\n", V1, V2);
}

void predicate_C() {
  int V1 = 1;
  int V2 = 2;
  int V3 = 3;

  if (V1 || (V2 = 3)) {
    V3 = 4;
  }

  printf("%d %d %d\n", V1, V2, V3);
}

void predicate_NC() {
  int V1 = 1;
  int V2 = 2;
  int V3 = 3;

  if (V1 != 0) {
    V3 = 4;
  } else {
    V2 = 3;
    if (V2) {
      V3 = 4;
    }
  }

  printf("%d %d %d\n", V1, V2, V3);
}

void body_C() {
  int V1 = 1;
  int V2 = 2;
  int V3 = 3;

  if (V1 != 0) {
    V2 || (V3 = 4);
  }

  printf("%d %d %d\n", V1, V2, V3);  
}

void body_NC() {
  int V1 = 1;
  int V2 = 2;
  int V3 = 3;

  if (V1 != 0) {
    if (V2 == 0) {
      V3 = 4;
    }
  }

  printf("%d %d %d\n", V1, V2, V3);  
}

void arithmetic_C() {
  // ???
}

void arithmetic_NC() {
  // ???
}

int main() {
  toplevel_C();
  toplevel_NC();
  predicate_C();
  predicate_NC();
  body_C();
  body_NC();
  arithmetic_C();
  arithmetic_NC();
}
