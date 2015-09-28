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
    *v5++; // incorrect line
    //(*v5)++; // Correct line
  }

  // Print results
  for (int i = 0; i < 26; i++)  {
    printf("%c: %d\n", 'a'+i, v2[i]);
  }
}

int main() { char *v1 = "aaabbcddeeeffff"; int v2[26] = {0}; char v4; for (int v3 = 0; (v4 = v1[v3]) != 0; v3++) { int *v5 = v2+(v4-'a'); *v5++; } for (int i = 0; i < 26; i++)  { printf("%c: %d\n", 'a'+i, v2[i]); } }

//int main() {
//  //inc_iter();
//  inc_counts();
//}
