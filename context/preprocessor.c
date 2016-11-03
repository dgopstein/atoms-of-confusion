#include <stdio.h>

void toplevel_C() {
  int V1 = 0
#define M1 1
    ;

  printf("%d\n", M1);
}

void toplevel_NC() {
#define M1 1

  int V1 = 0
    ;
    
  printf("%d\n", M1);
}

void predicate_C() {
  int V1 = 0;
  int V2 = 1;
  if (V1
#define M1 1
      ) {
    V2 = 2;
    }
  printf("%d %d\n", M1, V2);
}

void predicate_NC() {
#define M1 1
  int V1 = 0;
  int V2 = 1;
  if (V1) {
    V2 = 2;
  }
  printf("%d %d\n", M1, V2);
}

void body_C() {
  int V1 = 1;
  int V2 = 1;
  if (V1) {
#define M1 1
    V2 = 2;
  } else {
#define M1 2
    V2 = 3;
  }
  printf("%d %d\n", M1, V2);
}

void body_NC() {
  int V1 = 1;
  int V2 = 1;
  if (V1) {
#define M1 1
    V2 = 2;
  } else {
#define M1 2
    V2 = 3;
  }
  printf("%d %d\n", M1, V2);
}

void arithmetic_C() {
  int V1 = 1
#define M1 1
    +2;

  printf("%d\n", M1);
}

void arithmetic_NC() {
#define M1 1

  int V1 = 1
    +2;
    
  printf("%d\n", M1);
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
