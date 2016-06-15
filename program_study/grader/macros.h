#include <string.h>

#define DEBUG

#define i_EOB 0xDEAD
#define s_EOB "~~~~~~"
#define l_EOB 'z'
#define f_EOB INFINITY
#define c_EOB '!'

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

#define SCAN_LABELS(lbl1, lbl2) \
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



#define HALT_LABEL(lbl) \
{ \
  label = l_EOB; \
  scanf(" %c", &label); \
 \
  /*#ifdef DEBUG*/ \
  printf("%c-%c\n", lbl, label); \
  /*#endif*/ \
 \
  int n_correct = lbl == label; \
  total_correct += n_correct; \
 \
  total_points += 1; \
 \
  printf("%d/%d\n", total_correct, total_points); \
} 

int label_fault = 0;
int n_scanned = 0;
int total_points = 0, total_correct = 0;
char label;
