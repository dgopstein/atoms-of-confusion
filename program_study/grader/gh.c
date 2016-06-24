#include <stdio.h>

#include "macros.h"

#define GO(label) \
    switch (label) { \
      case 'a': goto a; break; \
      case 'b': goto b; break; \
      case '1': goto c1; break; \
      case '2': goto c2; break; \
      case '3': goto c3; break; \
      case '4': goto c4; break; \
      default: label = 'y'; return -1; \
    }

int in_V1, in_V2, in_V3, in_V4;
char in_V6;


int F1(int V1, int V2) {
  int V3, V4;







  //printf("a: %d %d\n", V1, V2);

/* start: AAAAAAAAAAAAAAA */
{
  SCAN_LABEL('a')

  a:;

  n_scanned = scanf(" %d %d", &in_V1, &in_V2);

  int n_points = 2;

  // If the parse failed, score every input wrong
  if (n_scanned == EOF) {
    return -3;
  } else if (n_scanned != n_points) {
    if (n_scanned < 2) in_V2 = i_EOB;
    if (n_scanned < 1) in_V1 = i_EOB;
  }

  #ifdef DEBUG
  printf("a-expected: %d %d\n", V1, V2);
  printf("a-actual:   %d %d\n", in_V1, in_V2);
  #endif

  if (label_fault) {
    label_fault = 0;

    V1 = in_V1;
    V2 = in_V2;
  } else {
    i_param_fault('a', 1, &V1, &in_V1);
    i_param_fault('a', 2, &V2, &in_V2);
  }

  #ifdef DEBUG
  printf("%d/%d\n", total_correct, total_points);
  printf("\n");
  #endif
}

/* end: AAAAAAAAAAAAAAA */








  V4 = 1;
  V3 = V4;

  int V5;

  if (V3 * V3 <= V1) {
    if (V1 % V3 != 0) {
      V4 = V4;
      V5 = V4;
    } else {
      V4 = V3;
      V5 = V4;
    }
  } else {
    if (V2 + 1 != 0) {
      if (V4 < 2) {
        if (V1 != 0) {
          F1(V2, 0);
        }
      } else {
        F1(V4, V2);
      }
      if (V2 != 0) {











        //printf("1: %d\n", 10);

/* start: 111111111111111 */
{
  SCAN_LABELS('1', 'b')

  c1:;
  int in_10;

  n_scanned = scanf(" %d", &in_10);

  int n_points = 1;

  // If the parse failed, score every input wrong
  if (n_scanned == EOF) {
    return -3;
  } else if (n_scanned != n_points) {
    if (n_scanned < 1) in_10 = i_EOB;
  }

  #ifdef DEBUG
  printf("1-expected: %d\n", 10);
  printf("1-actual:   %d\n", in_10);
  #endif

  if (label_fault) {
    label_fault = 0;
  } else {
    p_fault('1', 1, 10 == in_10);
  }

  #ifdef DEBUG
  printf("%d/%d\n", total_correct, total_points);
  printf("\n");
  #endif
}

/* end: 111111111111111 */







      } else {


        //printf("2: %d\n", 32 << !V1);

/* start: 222222222222222 */
{
  SCAN_LABELS('2', 'b')

  c2:;

  int in_c2, out_c2 = 32 << !V1;
  n_scanned = scanf(" %d", &in_c2);

  int n_points = 1;

  // If the parse failed, score every input wrong
  if (n_scanned == EOF) {
    return -3;
  } else if (n_scanned != n_points) {
    if (n_scanned < 1) in_c2 = i_EOB;
  }

  #ifdef DEBUG
  printf("2-expected: %d\n", out_c2);
  printf("2-actual:   %d\n", in_c2);
  #endif

  if (label_fault) {
    label_fault = 0;
  } else {
    //params_fault('2', n_points, (int []){out_c2 == in_c2});
    in_V1 = !(in_c2 >> 6);
    i_param_fault('2', 1, &V1, &in_V1);
  }

  #ifdef DEBUG
  printf("%d/%d\n", total_correct, total_points);
  printf("\n");
  #endif
}

/* end: 222222222222222 */



      }
      V1 -= V4 * !!V1;
      V5 = V1;
    } else {
      F1(V4, V1 / V4);
      V5 = 0;
    }
  }

  for (; V5 != 0;) {








    //printf("b: %d %d\n", V1, V4);



/* start: BBBBBBBBBBBBBBB */
{
  SCAN_LABELS('b', 'c')

  b:;

  n_scanned = scanf(" %d %d", &in_V1, &in_V4);

  int n_points = 2;

  // If the parse failed, score every input wrong
  if (n_scanned == EOF) {
    return -3;
  } else if (n_scanned != n_points) {
    if (n_scanned < 2) in_V4 = i_EOB;
    if (n_scanned < 1) in_V1 = i_EOB;
  }

  #ifdef DEBUG
  printf("b-expected: %d %d\n", V1, V4);
  printf("b-actual:   %d %d\n", in_V1, in_V4);
  #endif

  if (label_fault) {
    label_fault = 0;

    V1 = in_V1;
    V4 = in_V4;
  } else {
    i_param_fault('b', 1, &V1, &in_V1);
    i_param_fault('b', 2, &V4, &in_V4);
  }

  #ifdef DEBUG
  printf("%d/%d\n", total_correct, total_points);
  printf("\n");
  #endif
}

/* end: BBBBBBBBBBBBBBB */








    V3++;

    if (V3 * V3 <= V1) {
      if (V1 % V3 != 0) {
        V4 = V4;
        V5 = V4;
      } else {
        V4 = V3;
        V5 = V4;
      }
    } else {
      if (V2 + 1 != 0) {
        if (V4 < 2) {
          if (V1 != 0) {
            F1(V2, 0);
          }
        } else {
          F1(V4, V2);
        }
        if (V2 != 0) {





          //printf("3: %d\n", 10);

/* start: 333333333333333 */
{
  SCAN_LABELS('3', 'b')

  c3:;
  int in_10;

  n_scanned = scanf(" %d", &in_10);

  int n_points = 1;

  // If the parse failed, score every input wrong
  if (n_scanned == EOF) {
    return -3;
  } else if (n_scanned != n_points) {
    if (n_scanned < 1) in_10 = i_EOB;
  }

  #ifdef DEBUG
  printf("3-expected: %d\n", 10);
  printf("3-actual:   %d\n", in_10);
  #endif

  if (label_fault) {
    label_fault = 0;
  } else {
    p_fault('3', 1, 10 == in_10);
  }

  #ifdef DEBUG
  printf("%d/%d\n", total_correct, total_points);
  printf("\n");
  #endif
}

/* end: 333333333333333 */




        } else {






          //printf("4: %d\n", 32 << !V1);

/* start: 444444444444444 */
{
  SCAN_LABELS('4', 'b')

  c4:;

  int in_c4, out_c4 = 32 << !V1;
  n_scanned = scanf(" %d", &in_c4);

  int n_points = 1;

  // If the parse failed, score every input wrong
  if (n_scanned == EOF) {
    return -3;
  } else if (n_scanned != n_points) {
    if (n_scanned < 1) in_c4 = i_EOB;
  }

  #ifdef DEBUG
  printf("4-expected: %d\n", out_c4);
  printf("4-actual:   %d\n", in_c4);
  #endif

  if (label_fault) {
    label_fault = 0;
  } else {
    in_V1 = !(in_c4 >> 6);
    i_param_fault('4', 1, &V1, &in_V1);
  }

  #ifdef DEBUG
  printf("%d/%d\n", total_correct, total_points);
  printf("\n");
  #endif
}

/* end: 444444444444444 */






        }
        V1 -= V4 * !!V1;
        V5 = V1;
      } else {
        F1(V4, V1 / V4);
        V5 = 0;
      }
    }
  }

  return 0;
}

int main() {
  F1(1, 0);
  printf("d\n");

  HALT_LABEL('d')
}
