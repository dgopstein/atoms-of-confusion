#!/bin/bash

#src_a=$1
src_a=endoh2-decoded.c
src_b=endoh2-original.c

#prg_a=`basename $src_a`
#prg_b=`basename $src_b`
prg_a="bin/${src_a%.*}"
prg_b="bin/${src_b%.*}"

gcc $src_a -o $prg_a || exit 1
gcc $src_b -o $prg_b

mkdir -p test

# Encode each txt example
for f in `ls examples/*.txt`; do
  f=`basename $f`
  test_a="test/$f.a.raw"
  test_b="test/$f.b.raw"

  $prg_a < "examples/$f" > $test_a
  $prg_b < "examples/$f" > $test_b
  cmp $test_a $test_b
  echo "$f: $?"
done

# Decode each txt example
for f in `ls examples/*.raw`; do
  f=`basename $f`
  test_a="test/$f.a.txt"
  test_b="test/$f.b.txt"

  $prg_a e < "examples/$f" > $test_a
  $prg_b e < "examples/$f" > $test_b

  cmp $test_a $test_b
  echo "$f: $?"
done
