#include <string.h>
#include <stdlib.h>

#define DEBUG

#define i_EOB 0xDEAD
#define s_EOB "~~~~~~"
#define l_EOB '_'
#define f_EOB INFINITY
#define c_EOB '#'

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
      char *fault_str = (char *)malloc(20); \
      sprintf(fault_str, "FAULT: label,%c,%c", lbl1, label); \
      faults[fault_idx++] = fault_str; \
      printf("expected %c, got %c\n", lbl1, label); \
      GO(label); \
    } \
  }

#define SCAN_LABELS(lbl1, lbl2) \
  n_scanned = scanf(" %c:?", &label); \
  if (n_scanned == EOF) { return -8; } \
  else if (n_scanned == 0) { \
    printf("didn't scan at %c, %c\n", lbl1, lbl2); } \
  else { \
    total_points += 1; \
    if (label == lbl1 || label == lbl2) { total_correct += 1; } \
    else {  \
      label_fault = 1; \
      char *fault_str = (char *)malloc(20); \
      sprintf(fault_str, "FAULT: labels,%c,%c,%c", lbl1, lbl2, label); \
      faults[fault_idx++] = fault_str; \
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
  if (!label_fault) { \
    total_points += 1; \
    \
    if (lbl == label) { \
      total_correct += 1; \
    } else { \
      char *fault_str = (char *)malloc(20); \
      sprintf(fault_str, "FAULT: halt_label,%c,%c", lbl, label); \
      faults[fault_idx++] = fault_str; \
    } \
  } \
 \
  printf("\n"); \
  for (int i = 0; i < fault_idx; i++) printf("%s\n", faults[i]); \
  printf("%d/%d\n", total_correct, total_points); \
} 

int label_fault = 0;
int n_scanned = 0;
int total_points = 0, total_correct = 0;
char label;

char* faults[100];
int fault_idx = 0;

void param_fault(char lbl, int fmt_idx, int cnd) {
  if (cnd) {
    total_correct += 1;
  } else {
    char *fault_str = (char *)malloc(20); \
    sprintf(fault_str, "FAULT: param,%c,%d", lbl, fmt_idx); \
    faults[fault_idx++] = fault_str; \
  }
}
