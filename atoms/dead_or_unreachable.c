#include <stdio.h>

// Dead
//int main() { 4 + 6; }

// Prime factors
void factors() {
    int n = 1234;
    int d = 2;
    
    while (n > 1){
        if (n % d != 0) d++;
        else {
            /*n =*/ n / d;
            printf("%d ",d);
        }
    }
}

void main1() { int n = 1236; int d = 2; while (n > 1){ if (n % d != 0) d++; else { n / d; printf("%d ",d); } } }

// sum a list
int main() {
  int v1[] = {1, 2, 3, 4, 5};

  int v2 = 0;
  int v3 = 0;
  //for (int v3 = 0; (v2 == v1[v3]) == -1;  
  for (int v4 = 0; v4 < 5; v4++) {
    //v2 = v1[v4]; // Correct line
    v2 == v1[v4];
    v3 += v2;
  }

  printf("%d\n", v3);
}
