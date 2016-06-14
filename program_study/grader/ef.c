#include <math.h>
#include <stdio.h>
#include <string.h>


#define DEBUG

#define f_EOB INFINITY
#define i_EOB 0xDEAD
#define s_EOB "~~~~~~"
#define l_EOB 'z'
#define c_EOB '!'

#define GO(label) \
    switch (label) { \
      case 'a': goto a; break; \
      case 'b': goto b; break; \
      case 'c': goto c; break; \
      default: label = 'y'; return -1; \
    }

#define SCAN_LABEL(lbl1) \
  n_scanned = scanf(" %c:?", &label); \
  if (n_scanned == EOF) { return -2; } \
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
int in_V1, in_V2, in_V3, in_V7;
double in_V4;
char in_V6;
char label;



double V4;

int F1(int V1, int V2, int V3) {
  int V5 = V1;
  char V6;




//  printf("a: %d %d %d %f\n", V1, V2, V3, V4);

/* AAAAAAAAAAAAAAA */
{
  int n_points = 4;

  SCAN_LABEL('a')

  a:;

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
    int n_correct = 
      (V1 == in_V1) +
      (V2 == in_V2) +
      (V3 == in_V3) +
      (fabs(V4 - in_V4) < 0.0001);

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










  V1 = V1 - 1;
  if (V5 + 1 != 0 && V5 + 4 != 0) {
    F1(V1, -1, V1);
  }

  if (V1 && V2) {
    V2 = V2 + 1;
    F1(-1, V2, V3);
    V4 = trunc((int)(V2 + 1) / (1 - ((int)V3 * 2) - ((int)V3 * (int)V3)));
    int V7 =
        ((V4 * V4) >= 1) && ((((int)trunc((2 % 3) / 4) - 2) + (V4 / 2)) < 1);







    //printf("c: %d %d %d %f %d\n", V1, V2, V3, V4, V7);
/* CCCCCCCCCCCCCCC */
{
  int n_points = 5;

  SCAN_LABEL('a')

  c:;

  n_scanned = scanf(" %d %d %d %lf %d", &in_V1, &in_V2, &in_V3, &in_V4, &in_V7);

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
    int n_correct = 
      (V1 == in_V1) +
      (V2 == in_V2) +
      (V3 == in_V3) +
      (fabs(V4 - in_V4) < 0.0001) +
      (V7 == in_V7);

    total_correct += n_correct;
    total_points += n_points;
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
  int n_points = 1;

  SCAN_LABEL('b')

  b:;

  n_scanned = scanf(" %c", &in_V6);

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
    int n_correct = 
      (V6 == in_V6);

    total_correct += n_correct;
    total_points += n_points;
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
{
  label = l_EOB;
  scanf(" %c", &label);

  #ifdef DEBUG
  printf("e-%c\n", label);
  #endif

  int n_correct = 'd' == label;// || 'c' == label;
  total_correct += n_correct;

  total_points += 1;
}
}
