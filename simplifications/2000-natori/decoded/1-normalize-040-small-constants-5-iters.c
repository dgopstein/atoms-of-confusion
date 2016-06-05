#include <stdio.h>
double l;
int main(int _, char **o, char **O) {
  //printf("%d %d %d\n", _, o, O);
  return printf("%d\n",
      (_-- + 1 && _ + 4 && main(_, -8, _), _ && o)
          ? (main(-1, ++o, O),
             ((l = (int)(o + 1) / (3 - (int)O * 2 - (int)O * (int)O),
               l * l < 4 && ((-8 % 3) / 9 -
                                  7 + (l / 2)) < 1)))//[" #"]))
          : 3);
}
