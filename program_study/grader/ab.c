#include <stdio.h>
#include <string.h>

#define DEBUG

#define i_EOB 0xDEAD
#define s_EOB "~~~~~~"
#define l_EOB 'z'

#define GO(label) \
    switch (label) { \
      case 'a': goto a; break; \
      case 'b': goto b; break; \
      default: label = 'y'; return; \
    }

#define SCAN_LABEL(lbl1) \
  n_scanned = scanf(" %c:?", &label); \
  if (n_scanned == EOF) { return; } \
  else if (n_scanned == 0) { \
    printf("didn't scan at %c\n", lbl1); } \
  else { \
    total_points += 1; \
    if (label == lbl1) { total_correct += 1; } \
    else {  \
      label_fault = 1; \
      printf("expected %c, got %c\n", lbl1, label); \
      GO(label); \
    } \
  }

int label_fault = 0;
int n_scanned = 0;
int total_points = 0, total_correct = 0;
int in_V1, in_V3, in_V4, in_V6;
char label, in_V2[100], in_V5[100];

void F1(int V1, char *V2, int V3) {
  // printf("a: %d %s %d\n", V1, V2, V3);





/* AAAAAAAAAAAAAAA */
{
  int n_points = 3;

  SCAN_LABEL('a')

  a:;

  n_scanned = scanf(" %d %s %d", &in_V1, in_V2, &in_V3);

  // If the parse failed, score every input wrong
  if (n_scanned == EOF) {
    return;
  } else if (n_scanned != n_points) {
    if (n_scanned < 3) in_V3 = i_EOB;
    if (n_scanned < 2) strcpy(in_V2, s_EOB);
    if (n_scanned < 1) in_V1 = i_EOB;
  }

  #ifdef DEBUG
  printf("a-expected: %d %s %d\n", V1, V2, V3);
  printf("a-actual:   %d %s %d\n", in_V1, in_V2, in_V3);
  #endif

  if (label_fault) {
    label_fault = 0;

    V1 = in_V1;
    V2 = in_V2;
    V3 = in_V3;
  } else {
    int n_correct = 
      (V1 == in_V1) +
      !strcmp(V2, in_V2) +
      (V3 == in_V3);

    total_correct += n_correct;
    total_points += n_points;
  }

  //printf("a: %d/%d\n", n_correct, n_points);

  #ifdef DEBUG
  printf("%d/%d\n", total_correct, total_points);
  printf("\n");
  #endif
}

/* AAAAAAAAAAAAAAA */






  int V4 = (V1 / V3) + V3;
  char *V5 = V2 - V1;
  V2 = V2 - 1;
  int V6 = (int)V2 / (int)V2;
  //printf("b: %d %s %d\n", V4, V5, V6);
/* BBBBBBBBBBBBBBB */
{
  int n_points = 3;

  SCAN_LABEL('b')

  b:;

  n_scanned = scanf(" %d %s %d", &in_V4, in_V5, &in_V6);

  // If the parse failed, score every input wrong
  if (n_scanned == EOF) {
    return;
  } else if (n_scanned != n_points) {
    if (n_scanned < 3) in_V6 = i_EOB;
    if (n_scanned < 2) strcpy(in_V5, s_EOB);
    if (n_scanned < 1) in_V4 = i_EOB;
  }

  #ifdef DEBUG
  printf("b-expected: %d %s %d\n", V4, V5, V6);
  printf("b-actual:   %d %s %d\n", in_V4, in_V5, in_V6);
  #endif

  if (label_fault) {
    label_fault = 0;

    V4 = in_V4;
    V5 = in_V5;
    V6 = in_V6;
  } else {
    int n_correct = 
      (V4 == in_V4) +
      !strcmp(V5, in_V5) +
      (V6 == in_V6);

    total_correct += n_correct;
    total_points += n_points;
  }

  #ifdef DEBUG
  printf("%d/%d\n", total_correct, total_points);
  printf("\n");
  #endif
}

/* BBBBBBBBBBBBBBB */

}





int V7;
int main() {
  for (; "ab"[V7] != 0;) {
    F1(97 - 97, &"zy"[V7], 122 / 122);
    V7 = V7 + 1;
  }

  {
    label = l_EOB;
    scanf(" %c", &label);

    #ifdef DEBUG
    printf("c-%c\n", label);
    #endif

    int n_correct = 'c' == label;
    total_correct += n_correct;

    total_points += 1;

    printf("%d/%d\n", total_correct, total_points);
  }
}
