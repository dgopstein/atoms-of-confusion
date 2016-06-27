#include <stdio.h>


#include "macros.h"

#define GO(label) \
    switch (label) { \
      case 'a': goto a; break; \
      case 'b': goto b; break; \
      case 'c': goto c; break; \
      case 'd': goto d; break; \
      default: label = 'y'; return -1; \
    }

int in_V1, in_V2, in_V3, in_V4;

int F1(int V1, int V2, int V3, int V4) {
  V1 = V1 + 1;
  V2 = V1;
  while (V2 < 4) {
    V3 = 0;

    //printf("a: %d %d %d %d\n", V1, V2, V3, V4);




/* AAAAAAAAAAAAAAA */
{
  SCAN_LABELS('a', 'c')
  
  a:;

  n_scanned = scanf(" %d %d %d %d", &in_V1, &in_V2, &in_V3, &in_V4);

  int n_points = 4;

  // If the parse failed, score every input wrong
  if (n_scanned == EOF) {
    return -9;
  } else if (n_scanned != n_points) {
    if (n_scanned < 4) in_V4 = i_EOB;
    if (n_scanned < 3) in_V3 = i_EOB;
    if (n_scanned < 2) in_V2 = i_EOB;
    if (n_scanned < 1) in_V1 = i_EOB;
  }

  #ifdef DEBUG
  printf("a-computed: %d %d %d %d\n", V1, V2, V3, V4);
  printf("a-inputted:   %d %d %d %d\n", in_V1, in_V2, in_V3, in_V4);
  #endif

  if (label_fault) {
    label_fault = 0;

    V1 = in_V1;
    V2 = in_V2;
    V3 = in_V3;
    V4 = in_V4;
  } else {
    i_param_fault('a', 1, &V1, &in_V1);
    i_param_fault('a', 2, &V2, &in_V2);
    i_param_fault('a', 3, &V3, &in_V3);
    i_param_fault('a', 4, &V4, &in_V4);
  }

  #ifdef DEBUG
  printf("%d/%d\n", total_correct, total_points);
  printf("\n");
  #endif
}
/* AAAAAAAAAAAAAAA */







    int V9;
    if (V3 < V2) {
      V3 = (V3 * 8) + (V2 % 8);
      V2 /= 8;
      V4 = (V3 == V2) | ((V3 / 8) == V2);
      V9 = 1;
    } else {
      V4 = V4 + 1;
      if ((V1 - V4) != 0) {
        V9 = V1 % V4;
      } else {
        //printf("b: %d\n", V1);



/* BBBBBBBBBBBBBBBBBBBB */
{
  SCAN_LABELS('b', 'd')

  b:;

  n_scanned = scanf(" %d", &in_V1);

  int n_points = 1;

  if (n_scanned == EOF) {
    return -9;
  } else if (n_scanned != n_points) {
    if (n_scanned < 1) in_V1 = i_EOB;
  }

  check_label('b');
  #ifdef DEBUG
  printf("b-computed: %d\n", V1);
  printf("b-inputted:   %d\n", in_V1);
  #endif

  if (label_fault) {
    label_fault = 0;

    V1 = in_V1;
  } else {
    i_param_fault('b', 1, &V1, &in_V1);
  }

  //printf("b: %d/%d\n", n_correct, n_points);
  #ifdef DEBUG
  printf("%d/%d\n", total_correct, total_points);
  printf("\n");
  #endif
}
/* BBBBBBBBBBBBBBBBBBBBBBBB */






        V9 = 2 && (V1 % V4);
      }
    }

    for (; V9;) {
      //printf("c: %d %d %d %d\n", V1, V2, V3, V4);

/* CCCCCCCCCCCCCCCCCCCCCCCCC */
{
  SCAN_LABELS('c', 'a')
  
  c:;

  n_scanned = scanf(" %d %d %d %d", &in_V1, &in_V2, &in_V3, &in_V4);

  int n_points = 4;

  // If the parse failed, score every input wrong
  if (n_scanned == EOF) {
    return -9;
  } else if (n_scanned != n_points) {
    if (n_scanned < 4) in_V4 = i_EOB;
    if (n_scanned < 3) in_V3 = i_EOB;
    if (n_scanned < 2) in_V2 = i_EOB;
    if (n_scanned < 1) in_V1 = i_EOB;
  }

  check_label('a');
  #ifdef DEBUG
  printf("c-computed: %d %d %d %d\n", V1, V2, V3, V4);
  printf("c-inputted:   %d %d %d %d\n", in_V1, in_V2, in_V3, in_V4);
  #endif

  if (label_fault) {
    label_fault = 0;

    V1 = in_V1;
    V2 = in_V2;
    V3 = in_V3;
    V4 = in_V4;
  } else {
    i_param_fault('a', 1, &V1, &in_V1);
    i_param_fault('a', 2, &V2, &in_V2);
    i_param_fault('a', 3, &V3, &in_V3);
    i_param_fault('a', 4, &V4, &in_V4);
  }

  //printf("c: %d/%d\n", n_correct, n_points);
  #ifdef DEBUG
  printf("%d/%d\n", total_correct, total_points);
  printf("\n");
  #endif
}
/* CCCCCCCCCCCCCCCCCCCCCCCCC */


      if (V3 < V2) {
        V3 = (V3 * 8) + (V2 % 8);
        V2 /= 8;
        V4 = (V3 == V2) | ((V3 / 8) == V2);
        V9 = 1;
      } else {
        V4 = V4 + 1;
        if ((V1 - V4) != 0) {
          V9 = V1 % V4;
        } else {
          //printf("d: %d\n", V1);


/* DDDDDDDDDDDDDDDDDDDDDDDD */
{
  SCAN_LABELS('d', 'b')

  d:;

  n_scanned = scanf(" %d", &in_V1);

  int n_points = 1;

  if (n_scanned == EOF) {
    return -9;
  } else if (n_scanned != n_points) {
    if (n_scanned < 1) in_V1 = i_EOB;
  }

  check_label('b');
  #ifdef DEBUG
  printf("d-computed: %d\n", V1);
  printf("d-inputted:   %d\n", in_V1);
  #endif

  if (label_fault) {
    label_fault = 0;

    V1 = in_V1;
  } else {
    i_param_fault('b', 1, &V1, &in_V1);
  }

  #ifdef DEBUG
  printf("%d/%d\n", total_correct, total_points);
  printf("\n");
  #endif
}
/* DDDDDDDDDDDDDDDDDDDDDDDD */








          // Prevent floating point exception
          if (V4 == 0) {
            V9 = 1;
          } else {
            V9 = 2 && (V1 % V4);
          }
        }
      }
    }

    V1 = V1 + 1;
    V2 = V1;
  }

  return 0;
}

int main() {
  F1(1, 0, 0, 0);
  //printf("e\n");

  HALT_LABEL('e')
}
