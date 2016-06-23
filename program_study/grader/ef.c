#include <math.h>
#include <stdio.h>

#include "macros.h"

#define GO(label) \
    switch (label) { \
      case 'a': goto a; break; \
      case 'b': goto b; break; \
      case 'c': goto c; break; \
      default: label = 'y'; return -1; \
    }


int in_V1, in_V2, in_V3, in_V7;
double in_V4;
char in_V6;


double V4;

int F1(int V1, int V2, int V3) {
  int V5 = V1;
  char V6;




//  printf("a: %d %d %d %f\n", V1, V2, V3, V4);

/* AAAAAAAAAAAAAAA */
{
  SCAN_LABEL('a')

  a:;

  int n_points = 4; 

  n_scanned = scanf(" %d %d %d %lf", &in_V1, &in_V2, &in_V3, &in_V4);

  // If the parse failed, score every input wrong
  if (n_scanned == EOF) {
    return -3;
  } else if (n_scanned != n_points) {
    if (n_scanned < 4) in_V4 = f_EOB;
    if (n_scanned < 3) in_V3 = i_EOB;
    if (n_scanned < 2) in_V2 = i_EOB;
    if (n_scanned < 1) in_V1 = i_EOB;
  }

  #ifdef DEBUG
  printf("a-expected: %d %d %d %f\n", V1, V2, V3, V4);
  printf("a-actual:   %d %d %d %f\n", in_V1, in_V2, in_V3, in_V4);
  #endif

  if (label_fault) {
    label_fault = 0;

    V1 = in_V1;
    V2 = in_V2;
    V3 = in_V3;
    V4 = in_V4;
  } else {
    if (param_fault('a', 1, i_eq(V1, in_V1))) V1 = in_V1;
    if (param_fault('a', 2, i_eq(V2, in_V2))) V2 = in_V2;
    if (param_fault('a', 3, i_eq(V3, in_V3))) V3 = in_V3;
    if (param_fault('a', 3, f_eq(V4, in_V4))) V4 = in_V4;
  }

  //printf("a: %d/%d\n", n_correct, n_points);

  #ifdef DEBUG
  printf("%d/%d\n", total_correct, total_points);
  printf("\n");
  #endif
}

/* AAAAAAAAAAAAAAA */










  V1 = V1 - 1;
  if (V5 + 1 != 0 && V5 + 4 != 0) {
    F1(V1, -1, V1);
  }

  printf("V1,V2: (%d, %d)\n", V1, V2);

  if (V1 && V2) {
    V2 = V2 + 1;
    F1(-1, V2, V3);
    V4 = trunc((int)(V2 + 1) / (1 - ((int)V3 * 2) - ((int)V3 * (int)V3)));
    int V7 =
        ((V4 * V4) >= 1) && ((((int)trunc((2 % 3) / 4) - 2) + (V4 / 2)) < 1);







    //printf("c: %d %d %d %f %d\n", V1, V2, V3, V4, V7);
/* CCCCCCCCCCCCCCC */
{
  SCAN_LABEL('c')

  c:;

  n_scanned = scanf(" %d %d %d %lf %d", &in_V1, &in_V2, &in_V3, &in_V4, &in_V7);

  int n_points = 5;

  // If the parse failed, score every input wrong
  if (n_scanned == EOF) {
    return -3;
  } else if (n_scanned != n_points) {
    if (n_scanned < 5) in_V7 = i_EOB;
    if (n_scanned < 4) in_V4 = f_EOB;
    if (n_scanned < 3) in_V3 = i_EOB;
    if (n_scanned < 2) in_V2 = i_EOB;
    if (n_scanned < 1) in_V1 = i_EOB;
  }

  #ifdef DEBUG
  printf("c-expected: %d %d %d %f %d\n", V1, V2, V3, V4, V7);
  printf("c-actual:   %d %d %d %f %d\n", in_V1, in_V2, in_V3, in_V4, in_V7);
  #endif

  if (label_fault) {
    label_fault = 0;

    V1 = in_V1;
    V2 = in_V2;
    V3 = in_V3;
    V4 = in_V4;
    V7 = in_V7;
  } else {
    if (param_fault('c', 1, i_eq(V1, in_V1))) V1 = in_V1;
    if (param_fault('c', 2, i_eq(V2, in_V2))) V2 = in_V2;
    if (param_fault('c', 3, i_eq(V3, in_V3))) V3 = in_V3;
    if (param_fault('c', 3, f_eq(V4, in_V4))) V4 = in_V4;
    if (param_fault('c', 4, i_eq(V7, in_V7))) V7 = in_V7;
  }

  //printf("a: %d/%d\n", n_correct, n_points);

  #ifdef DEBUG
  printf("%d/%d\n", total_correct, total_points);
  printf("\n");
  #endif
}

/* CCCCCCCCCCCCCCC */





    V6 = "ab"[V7];
  } else {
    V6 = 'c';
  }





//printf("b: %c\n", V6)

/* BBBBBBBBBBBBBBB */
{
  SCAN_LABEL('b')

  b:;

  n_scanned = scanf(" %c", &in_V6);

  int n_points = 1;

  // If the parse failed, score every input wrong
  if (n_scanned == EOF) {
    return -3;
  } else if (n_scanned != n_points) {
    if (n_scanned < 1) in_V6 = c_EOB;
  }

  #ifdef DEBUG
  printf("b-expected: %c\n", V6);
  printf("b-actual:   %c\n", in_V6);
  #endif

  if (label_fault) {
    label_fault = 0;

    V6 = in_V6;
  } else {
    if (param_fault('b', 1, i_eq(V6, in_V6))) V6 = in_V6;
  }

  //printf("a: %d/%d\n", n_correct, n_points);

  #ifdef DEBUG
  printf("%d/%d\n", total_correct, total_points);
  printf("\n");
  #endif
}

/* BBBBBBBBBBBBBBB */

  return 7;
}

int main() {
  F1(-1, -2, 0);


  //printf("d\n");
  HALT_LABEL('d')
}
