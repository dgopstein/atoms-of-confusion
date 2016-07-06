#include <stdio.h>

#include "macros.h"

#define GO(label) \
    switch (label) { \
      case 'a': goto a; break; \
      case 'b': goto b; break; \
      default: label = 'y'; return -1; \
    }

int in_V1, in_V3, in_V4, in_V6;
char *in_V2, *in_V5;

int F1(int V1, char *V2, int V3) {
  // printf("a: %d %s %d\n", V1, V2, V3);





/* AAAAAAAAAAAAAAA */
{
  SCAN_LABEL('a')

  a:;

  n_scanned = scanf(" %d %s %d", &in_V1, in_V2, &in_V3);

  int n_points = 3;

  // If the parse failed, score every input wrong
  if (n_scanned == EOF) {
    return -4;
  } else if (n_scanned != n_points) {
    if (n_scanned < 3) in_V3 = i_EOB;
    if (n_scanned < 2) strcpy(in_V2, s_EOB);
    if (n_scanned < 1) in_V1 = i_EOB;
  }

  #ifdef DEBUG
  printf("a-computed: %d %s %d\n", V1, V2, V3);
  printf("a-inputted: %d %s %d\n", in_V1, in_V2, in_V3);
  #endif

  if (label_fault) {
    label_fault = 0;

    V1 = in_V1;
    V2 = in_V2;
    V3 = in_V3;
  } else {
    i_param_fault('a', 1, &V1, &in_V1);
    s_param_fault('a', 2, &V2, &in_V2);
    i_param_fault('a', 3, &V3, &in_V3);
  }

  #ifdef DEBUG
  printf("%d/%d\n\n", total_correct, total_points);
  #endif
}


/* AAAAAAAAAAAAAAA */





  int V4;
  if (V3 != 0) {
    V4 = (V1 / V3) + V3;
  } else {
    V4 = 0;
  }

  char *V5 = V2 - V1;
  V2 = V2 - 1;
  int V6 = (int)V2 / (int)V2;
  //printf("b: %d %s %d\n", V4, V5, V6);
/* BBBBBBBBBBBBBBB */
{
  SCAN_LABEL('b')

  b:;

  n_scanned = scanf(" %d %s %d", &in_V4, in_V5, &in_V6);

  int n_points = 3;

  // If the parse failed, score every input wrong
  if (n_scanned == EOF) {
    return -5;
  } else if (n_scanned != n_points) {
    if (n_scanned < 3) in_V6 = i_EOB;
    if (n_scanned < 2) strcpy(in_V5, s_EOB);
    if (n_scanned < 1) in_V4 = i_EOB;
  }

  #ifdef DEBUG
  printf("b-computed: %d %s %d\n", V4, V5, V6);
  printf("b-inputted: %d %s %d\n", in_V4, in_V5, in_V6);
  #endif

  if (label_fault) {
    label_fault = 0;

    V4 = in_V4;
    V5 = in_V5;
    V6 = in_V6;
  } else {
    i_param_fault('b', 1, &V4, &in_V4);
    s_param_fault('b', 2, &V5, &in_V5);
    i_param_fault('b', 3, &V6, &in_V6);
  }

  #ifdef DEBUG
  printf("%d/%d\n\n", total_correct, total_points);
  #endif
}

/* BBBBBBBBBBBBBBB */

  return -6;
}





int V7;
int main() {
  in_V2 = (char *)malloc(20);
  in_V5 = (char *)malloc(20);

  for (; "ab"[V7] != 0;) {
    F1(97 - 97, &"zy"[V7], 122 / 122);
    V7 = V7 + 1;
  }

  HALT_LABEL('c')
}
