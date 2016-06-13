#include <stdio.h>
#include <string.h>

#define i_EOB 0xDEAD
#define s_EOB "~~~~~~"
#define l_EOB 'z'

#define GO(label) \
    switch (label) { \
      case 'a': goto a; total_points += 1; break; \
      case 'b': goto b; total_points += 1; break; \
      default: return; \
    }

int total_points = 0, total_correct = 0;
int in_V1, in_V3, in_V4, in_V6;
char label, in_V2[100], in_V5[100];

void F1(int V1, char *V2, int V3) {
  // printf("a: %d %s %d\n", V1, V2, V3);
  {
    int n_points = 4;

    int n_scanned = scanf(" %c: %d %s %d", &label, &in_V1, in_V2, &in_V3);

    // If the parse failed, score every input wrong
    if (n_scanned == EOF) {
      return;
    } else if (n_scanned != n_points) {
      label = l_EOB;
      in_V1 = i_EOB;
      strcpy(in_V2, s_EOB);
      in_V3 = i_EOB;
    }

    //printf("a-%d: V1-%d, V2-%d: V3-%d\n", 'a' == label,V1 == in_V1,  !strcmp(V2, in_V2), V3 == in_V3);

    int n_correct;
    if ('a' == label) {
      n_correct = 1 +
        (V1 == in_V1) +
        !strcmp(V2, in_V2) +
        (V3 == in_V3);

      total_correct += n_correct;
      total_points += n_points;
    } else {
      n_correct = 0;
      GO(label);
    }

    //printf("a: %d/%d\n", n_correct, n_points);


    a:;
    if (n_scanned != n_points) {
      V1 = in_V1;
      V2 = in_V2;
      V3 = in_V3;
    }
  }
  int V4 = (V1 / V3) + V3;
  char *V5 = V2 - V1;
  V2 = V2 - 1;
  int V6 = (int)V2 / (int)V2;
  //printf("b: %d %s %d\n", V4, V5, V6);
  {
    int n_points = 4;

    int n_scanned = scanf(" %c: %d %s %d", &label, &in_V4, in_V5, &in_V6);
    
    if (n_scanned == EOF) {
      return;
    } else if (n_scanned != n_points) {
      // If the output format was wrong, score every input wrong
      label = l_EOB;
      in_V4 = i_EOB;
      strcpy(in_V5, s_EOB);
      in_V6 = i_EOB;
    }

    int n_correct;
    if ('b' == label) {
      n_correct = 1 +
        (V4 == in_V4) +
        !strcmp(V5, in_V5) +
        (V6 == in_V6);

      total_correct += n_correct;
      total_points += 4;
    } else {
      // If the wrong branch was taken all the values will be wrong, so only dock 1 point
      n_correct = 0;
      GO(label);
    }

    // printf("b: %d/%d\n", n_correct, n_points);

    b:;
    // Don't assume the bad values if the input was unparsable
    if (n_scanned != n_points) {
      V4 = in_V4;
      V5 = in_V5;
      V6 = in_V6;
    }
  }
}
int V7;
int main() {
  for (; "ab"[V7] != 0;) {
    F1(97 - 97, &"zy"[V7], 122 / 122);
    V7 = V7 + 1;
  }
  //printf("c\n");
  {
    scanf(" %c", &label);

    int n_correct = 'c' == label;
    total_correct += n_correct;

    int n_points = 1;
    total_points += n_points;

    //printf("c: %d/%d\n", n_correct, n_points);
    printf("%d/%d\n", total_correct, total_points);
  }
}
