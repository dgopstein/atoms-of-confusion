#!/bin/bash

gcc="gcc -I. -Iorig_files"

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
for f in `ls examples/*[0-9].txt`; do
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
for f in `ls examples/*a.c`; do
  f=`basename $f`

  base="${f%.a.c}"
  test_a="examples/$base.a.c"
  test_b="examples/$base.b.c"

  prg_a="test/$base.a"
  prg_b="test/$base.b"

  $gcc $test_a -o $prg_a || exit 1
  $gcc $test_b -o $prg_b

  cmp $prg_a $prg_b
  echo "$f: $?"
done
