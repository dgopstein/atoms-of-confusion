main(int n, char** i, char** a, char** m) {
  F1(n, i, a, m);
}

F1(n, i, a, m) {
  while (i = ++n)
    for (a = 0; a < i ? a = a * 8 + i % 8, i /= 8, m = a == i | a / 8 == i,
        1 : (n - ++m || printf("%o\n", n)) && n % m;)
      ;
}
