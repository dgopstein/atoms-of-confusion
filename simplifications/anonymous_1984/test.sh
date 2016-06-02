#!/bin/bash

gcc="gcc -w"

src_a=anonymous.c
src_b=decoded/0007-*.c

prg_a=`basename $src_a`
prg_b=`basename $src_b`
prg_a="bin/${prg_a%.*}"
prg_b="bin/${prg_b%.*}"

$gcc $src_a -o $prg_a || exit 1
$gcc $src_b -o $prg_b || exit 2

cmp  <($prg_a) <($prg_b)
if [[ 0 -ne $? ]]; then
  echo "Failure"
else
  echo "Success"
fi
