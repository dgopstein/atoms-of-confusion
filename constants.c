#include <stdio.h>

// Calculate distance travelled of a falling body
double f1(double p1, double p2, double p3) {
  return p1 * p2 * p3 * p3;
}

void main1() {
  printf("%f\n", f1(0.5, 9.8, 3)); 
}


// Multiply by zero
int main() {
  int v1 = 1;
  int v2 = 2;
  int v3 = 3;
  int v4 = 0;

  printf("%d\n", v1*v2*v3*v4*v3*v2*v1);
}


