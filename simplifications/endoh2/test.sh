#!/bin/bash

gcc="gcc -Itest "

src_a=endoh2.c
src_b=orig_files/prog.c

prg_a=`basename $src_a`
prg_b=`basename $src_b`
prg_a="bin/${prg_a%.*}"
prg_b="bin/${prg_b%.*}"

$gcc $src_a -o $prg_a || exit 1
$gcc $src_b -o $prg_b

mkdir -p test

cp orig_files/prog.c test/

echo "-- Executed --"

# Encode each txt example
for f in `ls examples/*.txt`; do
  f=`basename $f`

  test_a="test/$f.a.c"
  test_b="test/$f.b.c"

  $prg_a < "examples/$f" > $test_a
  $prg_b < "examples/$f" > $test_b
  cmp $test_a $test_b
  echo "$f: $?"
done

echo "-- Included --"

# Decode each txt example
for f in `ls examples/*.c`; do
  f=`basename $f`

  base="${f%.c}"
  prg_a="test/$base.a"
  prg_b="test/$base.b"

  test_include=test/prog.c
  cp $src_a $test_include; $gcc $test_a -o $prg_a || exit 1
  cp $src_b $test_include; $gcc $test_b -o $prg_b

  out_a="test/$base.a.out"
  out_b="test/$base.b.out"

  $prg_a > $out_a
  $prg_b > $out_b

  cmp $out_a $out_b
  echo "$f: $?"
done
