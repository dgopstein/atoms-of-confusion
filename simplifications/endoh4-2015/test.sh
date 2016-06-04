#!/bin/bash

gcc="gcc -w"

#src_a=prog.c
#src_b=decoded/0000-original.c

src_a=confusing.c
src_b=nonconfusing.c

prg_a=`basename $src_a`
prg_b=`basename $src_b`
prg_a="bin/${prg_a%.*}"
prg_b="bin/${prg_b%.*}"

$gcc $src_a -o $prg_a || exit 1
$gcc $src_b -o $prg_b

# Encode each txt example
for f in `ls examples/*.txt`; do
  f=`basename $f`
  n=`echo $f | grep -o '[0-9]\+'`
  test_a="test/$n.a.txt"
  test_b="test/$n.b.txt"

  args=$(perl -e "print '@ ' x ($n);")

  "$prg_a" "$args" > $test_a
  "$prg_b" "$args" > $test_b
  cmp $test_a "examples/$f"
  echo "$?: $f a"
  cmp $test_b "examples/$f"
  echo "$?: $f b"
done
