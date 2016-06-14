#include <stdio.h>
#include <string.h>

#define DEBUG

#define i_EOB 0xDEAD
#define s_EOB "~~~~~~"
#define l_EOB 'z'

#define GO(label) \
    switch (label) { \
      case 'a': total_points += 1; goto a; break; \
      case 'b': total_points += 1; goto b; break; \
      case 'c': total_points += 1; goto c; break; \
      case 'd': total_points += 1; goto d; break; \
      default: label = 'y'; return; \
    }

#define SCAN_LABEL(lbl) \
  n_scanned = scanf(" %c:?", &label); \
  if (n_scanned == EOF) { return; } \
  else if (n_scanned == 0) { printf("didn't scan at lbl\n"); } \
  else { \
    total_points += 1; \
    if (label == lbl) { total_correct += 1; } \
    else {  \
      label_fault = 1; \
      printf("expected %c, got %c\n", lbl, label); \
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

  SCAN_LABEL('a')
  
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
  printf("a-actual:   %d %d %d %d\n\n", in_V1, in_V2, in_V3, in_V4);
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

  //printf("a: %d/%d\n", n_correct, n_points);
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

  SCAN_LABEL('b')

  b:;

  n_scanned = scanf(" %d", &in_V1);

  if (n_scanned == EOF) {
    return;
  } else if (n_scanned != n_points) {
    if (n_scanned < 1) in_V1 = i_EOB;
  }

  #ifdef DEBUG
  printf("b-expected: %d\n", V1);
  printf("b-actual:   %d\n\n", in_V1);
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

  SCAN_LABEL('c')
  
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
  printf("c-actual:   %d %d %d %d\n\n", in_V1, in_V2, in_V3, in_V4);
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

  SCAN_LABEL('d')

  d:;

  n_scanned = scanf(" %d", &in_V1);

  if (n_scanned == EOF) {
    return;
  } else if (n_scanned != n_points) {
    if (n_scanned < 1) in_V1 = i_EOB;
  }

  #ifdef DEBUG
  printf("d-expected: %d\n", V1);
  printf("d-actual:   %d\n\n", in_V1);
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

  //printf("d: %d/%d\n", n_correct, n_points);
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

  int n_correct = 'c' == label;// || 'e' == label;
  total_correct += n_correct;

  int n_points = 1;
  total_points += n_points;
}

  printf("%d/%d\n", total_correct, total_points);
}
