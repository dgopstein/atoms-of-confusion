#include <string.h>
#include <stdio.h>

// Compare a number against a different number
void conditional_assignment() {
  int v1 = 7;
  if ((v1 = 8)) printf("true\n"); else printf("false\n");
}
//int main() { int v1 = 7; if (v1 = 8) printf("true\n"); else printf("false\n"); }

// Compare two identical strings
void compare_strings() {
  if (strcmp("a", "a")) printf("true\n"); else printf("false\n");
}
//int main() { if (strcmp("a", "a")) printf("true\n"); else printf("false\n"); }

//int main() {
//  //conditional_assignment();
//  //compare_strings();
//}

void main1() {
  if ("false") {
    printf("true\n");
  } else {
    printf("false\n");
  }
}

int main() {
  if (-1) {
    printf("true\n");
  } else {
    printf("false\n");
  }
}
