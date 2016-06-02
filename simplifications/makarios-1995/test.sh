#!/bin/bash

gcc="gcc -w"

src_a=makarios.c
src_b=decoded/0000-normalized-confusing.c

prg_a=`basename $src_a`
prg_b=`basename $src_b`
prg_a="bin/${prg_a%.*}"
prg_b="bin/${prg_b%.*}"

$gcc $src_a -o $prg_a || exit 1
$gcc $src_b -o $prg_b || exit 2

cmp  <(gstdbuf -oL $prg_a | head -100) <(gstdbuf -oL $prg_b | head -100)
if [[ 0 -ne $? ]]; then
  echo "Failure"
else
  echo "Success"
fi
