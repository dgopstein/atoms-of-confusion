#include <string.h>
#include <stdlib.h>
#include <math.h>

#define MIN(a,b) (((a)<(b))?(a):(b))

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
    check_label(lbl1); \
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
    char unified_label = MIN(lbl1, lbl2); \
    check_label(unified_label); \
    if (label == lbl1 || label == lbl2) { total_correct += 1; } \
    else {  \
      label_fault = 1; \
      char *fault_str = (char *)malloc(20); \
      sprintf(fault_str, "FAULT: label,%c,%c", unified_label, label); \
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
  check_halt(); \
  /*#ifdef DEBUG*/ \
  printf("%c-%c\n", lbl, label); \
  /*#endif*/ \
 \
  if (!label_fault) { \
    total_points += 1; \
    check_halt();\
    \
    if (lbl == label) { \
      total_correct += 1; \
    } else { \
      char *fault_str = (char *)malloc(20); \
      sprintf(fault_str, "FAULT: halt,%c,%c", lbl, label); \
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

void check_label(char lbl) {
  char *fault_str = (char *)malloc(20);
  sprintf(fault_str, "CHECK: label,%c", lbl);
  faults[fault_idx++] = fault_str;
}

void check_param(char lbl, int count) {
  char *fault_str = (char *)malloc(20);
  sprintf(fault_str, "CHECK: param,%c,%d", lbl, count);
  faults[fault_idx++] = fault_str;
}

void check_halt() {
  faults[fault_idx++] = "CHECK: halt";
}

int p_fault(char lbl, int fmt_idx, int cnd) {
  check_param(lbl, fmt_idx);
  total_points += 1;

  int was_fault;
  if (cnd) {
    was_fault = 0;
  } else {
    char *fault_str = (char *)malloc(20);
    sprintf(fault_str, "FAULT: param,%c,%d", lbl, fmt_idx);
    faults[fault_idx++] = fault_str;

    was_fault = 1;
  }

  total_correct += 1 - was_fault;

  return was_fault;
}


//void params_fault(char lbl, int count, int *arr) {
//  for (int i = 0; i < count; i++) {
//    p_fault(lbl, i, arr[i]);
//  }
//
//  total_points += count;
//}

int c_eq(char a,     char b) { return a == b; }
int i_eq(int a,       int b) { return a == b; }
int f_eq(float a,   float b) { return fabs(a - b) < 0.0001; }
int d_eq(double a, double b) { return fabs(a - b) < 0.0001; }
int s_eq(char *a,   char *b) { return !strcmp(a, b); };

void c_ass(char *a,     char *b) { *a = *b; }
void i_ass(int *a,       int *b) { *a = *b; }
void f_ass(float *a,   float *b) { *a = *b; }
void d_ass(double *a, double *b) { *a = *b; }
void s_ass(char **a,     char **b) { 
  *a = (char *)malloc(20); 
  strcpy(*a, *b);
}

// Check value, increment total_points, and assign the users value to in-memory model

void c_param_fault(char lbl, int idx, char *a, char *b) {
  if (p_fault(lbl, idx, c_eq(*a, *b))) c_ass(a, b); }

void i_param_fault(char lbl, int idx, int *a, int *b) {
  if (p_fault(lbl, idx, i_eq(*a, *b))) i_ass(a, b); }

void f_param_fault(char lbl, int idx, float *a, float *b) {
  if (p_fault(lbl, idx, f_eq(*a, *b))) f_ass(a, b); }

void d_param_fault(char lbl, int idx, double *a, double *b) {
  if (p_fault(lbl, idx, d_eq(*a, *b))) d_ass(a, b); }

void s_param_fault(char lbl, int idx, char **a, char **b) {
  if (p_fault(lbl, idx, s_eq(*a, *b))) s_ass(a, b); }

