#include <stdio.h>
#include <string.h>

#define i_EOB 0xDEAD
#define s_EOB "~~~~~~"
#define l_EOB 'z'

#define GO(label) \
    switch (label) { \
      case 'a': total_points += 1; goto a; break; \
      case 'b': total_points += 1; goto b; break; \
      case 'c': total_points += 1; goto c; break; \
      case 'd': total_points += 1; goto d; break; \
      default: return; \
    }

int total_points = 0, total_correct = 0;
int in_V1, in_V2, in_V3, in_V4;
char label;

void F1(int V1, int V2, int V3, int V4) {
  V1 = V1 + 1;
  V2 = V1;
  while (V2 < 4) {
    V3 = 0;

    printf("a: %d %d %d %d\n", V1, V2, V3, V4);




/* AAAAAAAAAAAAAAA */
{
  int n_points = 5;

  int n_scanned = scanf(" %c: %d %d %d %d", &label, &in_V1, &in_V2, &in_V3, &in_V4);

  // If the parse failed, score every input wrong
  if (n_scanned == EOF) {
    return;
  } else if (n_scanned != n_points) {
    label = l_EOB;
    in_V1 = i_EOB;
    in_V2 = i_EOB;
    in_V3 = i_EOB;
    in_V4 = i_EOB;
  }

  //printf("a-%d: V1-%d, V2-%d: V3-%d\n", 'a' == label,V1 == in_V1,  !strcmp(V2, in_V2), V3 == in_V3);

  int n_correct;
  if ('a' == label) {
    n_correct = 1 +
      (V1 == in_V1) +
      (V2 == in_V2) +
      (V3 == in_V3) +
      (V4 == in_V4);

    total_correct += n_correct;
    total_points += n_points;
  } else {
    n_correct = 0;
    GO(label);
  }

  //printf("a: %d/%d\n", n_correct, n_points);

  a:;
  if (n_scanned != n_points) {
    V1 = in_V1;
    V2 = in_V2;
    V3 = in_V3;
    V4 = in_V4;
  }
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
        printf("b: %d\n", V1);



/* BBBBBBBBBBBBBBBBBBBB */
{
  int n_points = 2;

  int n_scanned = scanf(" %c: %d", &label, &in_V1);

  // If the parse failed, score every input wrong
  if (n_scanned == EOF) {
    return;
  } else if (n_scanned != n_points) {
    label = l_EOB;
    in_V1 = i_EOB;
  }

  //printf("a-%d: V1-%d, V2-%d: V3-%d\n", 'a' == label,V1 == in_V1,  !strcmp(V2, in_V2), V3 == in_V3);

  int n_correct;
  if ('b' == label) {
    n_correct = 1 +
      (V1 == in_V1);

    total_correct += n_correct;
    total_points += n_points;
  } else {
    n_correct = 0;
    GO(label);
  }

  //printf("c: %d/%d\n", n_correct, n_points);

  b:;
  if (n_scanned != n_points) {
    V1 = in_V1;
  }
}
/* BBBBBBBBBBBBBBBBBBBBBBBB */






        V9 = 2 && (V1 % V4);
      }
    }

    for (; V9;) {
      printf("c: %d %d %d %d\n", V1, V2, V3, V4);

/* CCCCCCCCCCCCCCCCCCCCCCCCC */
{
  int n_points = 5;

  int n_scanned = scanf(" %c: %d %d %d %d", &label, &in_V1, &in_V2, &in_V3, &in_V4);

  // If the parse failed, score every input wrong
  if (n_scanned == EOF) {
    return;
  } else if (n_scanned != n_points) {
    label = l_EOB;
    in_V1 = i_EOB;
    in_V2 = i_EOB;
    in_V3 = i_EOB;
    in_V4 = i_EOB;
  }

  //printf("a-%d: V1-%d, V2-%d: V3-%d\n", 'a' == label,V1 == in_V1,  !strcmp(V2, in_V2), V3 == in_V3);

  int n_correct;
  if ('c' == label || 'a' == label) {
    n_correct = 1 +
      (V1 == in_V1) +
      (V2 == in_V2) +
      (V3 == in_V3) +
      (V4 == in_V4);

    total_correct += n_correct;
    total_points += n_points;
  } else {
    n_correct = 0;
    GO(label);
  }

  //printf("c: %d/%d\n", n_correct, n_points);

  c:;
  if (n_scanned != n_points) {
    V1 = in_V1;
    V2 = in_V2;
    V3 = in_V3;
    V4 = in_V4;
  }
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
          printf("d: %d\n", V1);


/* DDDDDDDDDDDDDDDDDDDDDDDD */
{
  int n_points = 2;

  int n_scanned = scanf(" %c: %d", &label, &in_V1);

  // If the parse failed, score every input wrong
  if (n_scanned == EOF) {
    return;
  } else if (n_scanned != n_points) {
    label = l_EOB;
    in_V1 = i_EOB;
  }

  //printf("a-%d: V1-%d, V2-%d: V3-%d\n", 'a' == label,V1 == in_V1,  !strcmp(V2, in_V2), V3 == in_V3);

  int n_correct;
  if ('d' == label || 'b' == label) {
    n_correct = 1 +
      (V1 == in_V1);

    total_correct += n_correct;
    total_points += n_points;
  } else {
    n_correct = 0;
    GO(label);
  }

  //printf("c: %d/%d\n", n_correct, n_points);

  d:;
  if (n_scanned != n_points) {
    V1 = in_V1;
  }
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
  printf("e\n");
{
  label = l_EOB;
  scanf(" %c", &label);

  int n_correct = 'e' == label || 'c' == label;
  total_correct += n_correct;

  int n_points = 1;
  total_points += n_points;
}

  printf("%d/%d\n", total_correct, total_points);
}
