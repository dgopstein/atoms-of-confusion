The subdirectories in this directory each correspond to a winner of the IOCCC.
Each of those winners in turn corresponds to one question of the [Atom Impact Experiment](http://atomsofconfusion.com/2016-program-study).
The names of the files in the impact experiment correspond to the obfuscated and transformed versions of each of these winners in order of year:

 * `a.c` - `1984-anonymous/confusing.c` - obfuscated
 * `b.c` - `1984-anonymous/nonconfusing.c` - transformed
 * `c.c` - `1995-makarios/confusing.c` - obfuscated
 * `d.c` - `1995-makarios/nonconfusing.c` - transformed
 * `e.c` - `2000-natori/confusing.c` - obfuscated
 * `f.c` - `2000-natori/nonconfusing.c` - transformed
 * `g.c` - `2015-endoh4/confusing.c` - obfuscated
 * `h.c` - `2015-endoh4/nonconfusing.c` - transformed

Each directory contains some of the original files from the IOCCC submission (Makefile, hint.text, etc) and several standard files used in simplifying the program:

 * `confusing.c` - The obfuscated version of the program (a.c, c.c, e.c, g.c)
 * `nonconfusing.c` - The normalized and transformed version of the program (b.c, d.c, f.c, h.c)
 * `test.sh` - A script that compares the output of `confusing.c` and `nonconfusing.c` to make sure they are functionally equivalent
 * `notes.txt` - A description of interesting things found when simplifying the source and an index of all the simplifying transformations
 * `decoded/` - Incremental versions of the transformed file after every simplifying step. These files are named with the following convention `phase-phasename-step-transformation.c` where:
   * `phase-phasename` describes whether the transformation is for
     * `1-normalization` removing non-atom sources of confusion
     * `2-simplification` removing atoms
     * `3-(non)confusing` making changes to make the code amenable to hand-execution
   * `step` the order in which each transformation was made
   * `transformation` a short description of the transformation
