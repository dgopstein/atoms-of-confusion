#include <stdio.h>

// Increment and print all elements of an array
void inc_deref() {
  int v1[] = {0, 1, 2, 3};

  int *v2 = v1;
  for (int v3 = 0; v3 < 4; v3++) {
    printf("%d\n", *v2++);
    v2++;
  }
}

//int main() { int v1[] = {0, 1, 2, 3}; int *v2 = v1; for (int v3 = 0; v3 < 4; v3++) { printf("%d\n", *v2++); v2++; } } // Incrememnt
//int main() { int v1[] = {0, 1, 2, 3}; int *v2 = v1; for (int v3 = 0; v3 < 4; v3++) { printf("%d\n", *v2--); v2++; } } // Decrement

// This actually does what you'd expect :/, print every character in a string
void inc_iter() {
  char *v1 = "abcd\n";

  char v2 = -1;
  while (v2 != 0) {
    v2 = *v1++;
    putchar(v2);
  }
}

// update counts, count the occurences of letters in string
void inc_counts() {
  char *v1 = "aaabbcddeeeffff";
  int v2[26] = {0};

  char v4;
  for (int v3 = 0; (v4 = v1[v3]) != 0; v3++) {
    int *v5 = v2+(v4-'a');
    //*v5++; // incorrect line
    (*v5)++; // Correct line
  }

  // Print results
  for (int i = 0; i < 26; i++)  {
    printf("%c: %d\n", 'a'+i, v2[i]);
  }
}

//int main() { char *v1 = "aaabbcddeeeffff"; int v2[26] = {0}; char v4; for (int v3 = 0; (v4 = v1[v3]) != 0; v3++) { int *v5 = v2+(v4-'a'); *v5++; } for (int i = 0; i < 26; i++)  { printf("%c: %d\n", 'a'+i, v2[i]); } }

// generate a string by iteratively sampling an array of letter counts
void dec_counts() {
  int v1[] = {2,3,1,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0};
  char v2[11] = {0};

  int v3 = 1;
  int v6 = 0;
  while (v3) {
    v3 = 0;
    for (int v4 = 0; v4 < 26; v4++) {
      int *v5 = v1+v4;

      if (*v5 > 0) {
        //*v5--; // incorrect line
        (*v5)--; // Correct line
        v2[v6++] = 'a' + v4;
        v3 = 1;
      }
    }
  }

  // Print results
  printf("%s\n", v2);
}

int main() { int v1[] = {2,3,1,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0}; char v2[11] = {0}; int v3 = 1; int v6 = 0; while (v3) { v3 = 0; for (int v4 = 0; v4 < 26; v4++) { int *v5 = v1+v4; if (*v5 > 0) { *v5--; v2[v6++] = 'a' + v4; v3 = 1; } } } printf("%s\n", v2); }

//int main() {
//  //inc_iter();
//  dec_counts();
//}
