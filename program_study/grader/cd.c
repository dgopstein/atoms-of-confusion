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
      case 'c': goto c; break; \
      case 'd': goto d; break; \
      default: label = 'y'; return; \
    }

#define SCAN_LABEL(lbl1, lbl2) \
  n_scanned = scanf(" %c:?", &label); \
  if (n_scanned == EOF) { return; } \
  else if (n_scanned == 0) { \
    printf("didn't scan at %c, %c\n", lbl1, lbl2); } \
  else { \
    total_points += 1; \
    if (label == lbl1 || label == lbl2) { total_correct += 1; } \
    else {  \
      label_fault = 1; \
      printf("expected %c/%c, got %c\n", lbl1, lbl2, label); \
      GO(label); \
    } \
  }

int label_fault = 0;
int n_scanned = 0;
int total_points = 0, total_correct = 0;
int in_V1, in_V2, in_V3, in_V4;
char label;

void F1(int V1, int V2, int V3, int V4) {
  V1 = V1 + 1;
  V2 = V1;
  while (V2 < 4) {
    V3 = 0;

    //printf("a: %d %d %d %d\n", V1, V2, V3, V4);




/* AAAAAAAAAAAAAAA */
{
  int n_points = 4;

  SCAN_LABEL('a', 'c')
  
  a:;

  n_scanned = scanf(" %d %d %d %d", &in_V1, &in_V2, &in_V3, &in_V4);

  // If the parse failed, score every input wrong
  if (n_scanned == EOF) {
    return;
  } else if (n_scanned != n_points) {
    if (n_scanned < 4) in_V4 = i_EOB;
    if (n_scanned < 3) in_V3 = i_EOB;
    if (n_scanned < 2) in_V2 = i_EOB;
    if (n_scanned < 1) in_V1 = i_EOB;
  }

  #ifdef DEBUG
  printf("a-expected: %d %d %d %d\n", V1, V2, V3, V4);
  printf("a-actual:   %d %d %d %d\n", in_V1, in_V2, in_V3, in_V4);
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
      (V4 == in_V4);

    total_correct += n_correct;
    total_points += n_points;
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
  int n_points = 1;

  SCAN_LABEL('b', 'd')

  b:;

  n_scanned = scanf(" %d", &in_V1);

  if (n_scanned == EOF) {
    return;
  } else if (n_scanned != n_points) {
    if (n_scanned < 1) in_V1 = i_EOB;
  }

  #ifdef DEBUG
  printf("b-expected: %d\n", V1);
  printf("b-actual:   %d\n", in_V1);
  #endif

  if (label_fault) {
    label_fault = 0;

    V1 = in_V1;
  } else {
    int n_correct = 
      (V1 == in_V1);

    total_correct += n_correct;
    total_points += n_points;
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
  int n_points = 4;

  SCAN_LABEL('c', 'a')
  
  c:;

  n_scanned = scanf(" %d %d %d %d", &in_V1, &in_V2, &in_V3, &in_V4);

  // If the parse failed, score every input wrong
  if (n_scanned == EOF) {
    return;
  } else if (n_scanned != n_points) {
    if (n_scanned < 4) in_V4 = i_EOB;
    if (n_scanned < 3) in_V3 = i_EOB;
    if (n_scanned < 2) in_V2 = i_EOB;
    if (n_scanned < 1) in_V1 = i_EOB;
  }

  #ifdef DEBUG
  printf("c-expected: %d %d %d %d\n", V1, V2, V3, V4);
  printf("c-actual:   %d %d %d %d\n", in_V1, in_V2, in_V3, in_V4);
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
      (V4 == in_V4);

    total_correct += n_correct;
    total_points += n_points;
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
  int n_points = 1;

  SCAN_LABEL('d', 'b')

  d:;

  n_scanned = scanf(" %d", &in_V1);

  if (n_scanned == EOF) {
    return;
  } else if (n_scanned != n_points) {
    if (n_scanned < 1) in_V1 = i_EOB;
  }

  #ifdef DEBUG
  printf("d-expected: %d\n", V1);
  printf("d-actual:   %d\n", in_V1);
  #endif

  if (label_fault) {
    label_fault = 0;

    V1 = in_V1;
  } else {
    int n_correct = 
      (V1 == in_V1);

    total_correct += n_correct;
    total_points += n_points;
  }

  #ifdef DEBUG
  printf("%d/%d\n", total_correct, total_points);
  printf("\n");
  #endif
}
/* DDDDDDDDDDDDDDDDDDDDDDDD */








          V9 = 2 && (V1 % V4);
        }
      }
    }

    V1 = V1 + 1;
    V2 = V1;
  }
}

int main() {
  F1(1, 0, 0, 0);
  //printf("e\n");
{
  label = l_EOB;
  scanf(" %c", &label);

  #ifdef DEBUG
  printf("e-%c\n", label);
  #endif

  int n_correct = 'e' == label;// || 'c' == label;
  total_correct += n_correct;

  total_points += 1;
}

  printf("%d/%d\n", total_correct, total_points);
}
