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

int main() { int n = 1236; int d = 2; while (n > 1){ if (n % d != 0) d++; else { n / d; printf("%d ",d); } } }
