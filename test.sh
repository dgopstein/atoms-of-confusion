#!/bin/bash

src_a=$1
src_b=vik-original.c

#prg_a=`basename $src_a`
#prg_b=`basename $src_b`
prg_a="bin/${src_a%.*}"
prg_b="bin/${src_b%.*}"

gcc $src_a -o $prg_a
gcc $src_b -o $prg_b

mkdir -p test
for f in `ls examples`; do
  test_a="test/$f.a"
  test_b="test/$f.b"

  # Encode and Decode each example... why not?
  $prg_a < "examples/$f" > "${test_a}.raw"
  $prg_b < "examples/$f" > "${test_b}.raw"

  $prg_a e < "examples/$f" > "${test_a}.txt"
  $prg_b e < "examples/$f" > "${test_b}.txt"

  cmp $test_a $test_b
done
