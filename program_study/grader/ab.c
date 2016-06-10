#include <stdio.h>
#include <string.h>

#define GO(label) \
    switch (label) { \
      case 'a': goto a; break; \
      case 'b': goto b; break; \
      /*case 'c': goto c; break;*/ \
      /*case 'd': goto d; break;*/ \
      /*case 'e': goto e; break;*/ \
      default: return; \
    }

int in_V1, in_V3, in_V4, in_V6;
char label, in_V2[100], in_V5[100];

void F1(int V1, char *V2, int V3) {
  // printf("a: %d %s %d\n", V1, V2, V3);
  {
    scanf("%c: %d %s %d", &label, &in_V1, in_V2, &in_V3);

    printf("a-%d: V1-%d, V2-%d: V3-%d\n", 'a' == label,V1 == in_V1,  !strcmp(V2, in_V2), V3 == in_V3);

    GO(label);

    a:;
    V1 = in_V1;
    V2 = in_V2;
    V3 = in_V3;
  }
  int V4 = (V1 / V3) + V3;
  char *V5 = V2 - V1;
  V2 = V2 - 1;
  int V6 = (int)V2 / (int)V2;
  //printf("b: %d %s %d\n", V4, V5, V6);
  {
    scanf("%c: %d %s %d", &label, &in_V4, in_V5, &in_V6);

    printf("%c: %d %s %d\n", label, in_V4, in_V5, in_V6);
    printf("b-%d: V4-%d, V5-%d: V6-%d\n", 'b' == label,V4 == in_V4,  !strcmp(V5, in_V5), V6 == in_V6);

    GO(label);

    b:;
    V4 = in_V4;
    V5 = in_V5;
    V6 = in_V6;
  }
}
int V7;
int main() {
  for (; "ab"[V7] != 0;) {
    F1(97 - 97, &"zy"[V7], 122 / 122);
    V7 = V7 + 1;
  }
  printf("c\n");
}
