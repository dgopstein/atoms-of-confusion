# Program Study Data

In this study we showed 2 variations (one containing atoms, one with atoms removed) of 4 programs (IOCCC winners from various years) to participants to measure the difference in hand trace error rates.

### Programs - `[a-h].c`

The 8 files `[a-h].c` were the text of the program study. All odd-lettered programs `[a, c, e, g]` contain atoms, and all even-lettered programs `[b, d, f, h]` have had their atoms removed.

### Graders - `grader/[ab, cd, ef, gh].c`

Since each pair of C/NC (confusing/nonconfusing) program has (mostly) the same output, each pair was graded using a single combined grader.
Each grader takes as input the subject-generated output of the program. The grader then compares what the subject thought the output should be against what is actually calculated by the computer. At each print statement the program outputs two lines showing each result, first the real output, then what the subject thought in a format like this:

    a-computed: 0 zy 1
    a-inputted: 1234 zy 1
    3/4

The first line shows what the program says should happen the second line shows what the programmer believes should happen. The next line scores the programmer on how many of the parameters (including the line label) were answered correctly. Note the error in the first parameter, the computer said the output should be `0`, the subject said `1234`, so the score is docked one point to 3 out of 4.

The grader propogates all wrong values so the subject isn't docked repeatedly for a single mistake. In this example the value of `1234` will be used by the grader in all subsequent calculations involving that variable.

When the grader is finished, it omits a summary of every parameter check and fault (error). It outputs results formatted as `OUTCOME: attribute,line-label[,parameter-position]` For the above example, it looks like this:

    CHECK: label,a
    CHECK: param,a,1
    FAULT: param,a,1
    CHECK: param,a,2
    CHECK: param,a,3

It is often useful to grade every response, all at once. This can be down as follows:

    grader/run_all.rb grader/csv/results.csv


### Results - `grader/csv/results.csv`

The transcribed results from each subject. The data is stored as a CSV with the following columns:

* **Subject**: A unique, randomized, number assigned anonymously to each subject.
* **Date**: The date the test was administered in the subject's local time.
* **Order**: Lists the selection of questions on the test, in the order they were written.
* **(start/end)[1-4]**: The time at which each question was started/finished. The order of these columns corresponds to the letters in the `Order` column.
* **[A-H]**: The output, as written by the participant, of the questions they answered. Only 4 of these columns will have values (the 4 listed in `Order`), the rest will be blank.

### Fault Rates `grader/csv/fault_rates.csv`

Each element of each line of output from each trace was scored, counted, and grouped into this file.

* **question**: Which question `[a-h]` the participant was tracing
* **fault**: Which type of element was scored. The three possible values are `[label, param, halt]`
  * `label`: The first element in a printf output that indicates what location in the source the participant thought they were executing
  * `param`: One of the later values in the print statement that represents a variable in scope in the program.
  * `halt`: A point where either the program or the participant believes the program should terminate.
* **label**: Which label (position in source file) this line applies to.
* **arg**: This value differs depending on whether the line is `param`/`label`/`halt`/
  * `label`: The user-supplied label, regardless of whether it agrees with the machine-expected label
  * `param`: Which position in the print statement the parameter was in. For example the values would follow the following number system: `label: param1, param2, param3, ...`
  * `halt`: The user-supplied label, whether or not it indicates a halt value.
* **c_faults**: The number of errors on this element in programs with atoms.
* **c_checks**: How many times this element was graded (faults + correct) in programs with atoms.
* **nc_faults**: The number of errors on this element in programs without atoms.
* **nc_checks**: How many times this element was graded (faults + correct) in programs without atoms.

### Grades - `grader/csv/grades.csv`

The score each participant received on each question they answered

* **subject**: A unique, randomized, number assigned anonymously to each subject.
* **qtype**: Which question, `[a-h]`.
* **qpos**: Which position in the test the question appeared, `[1-4]`.
* **mins**: How long it took the participant to answer the question, in minutes.
* **correct**: The number of output elements the participant answered correctly.
* **points**: Then number of output elements the participant attempted (faults + correct).
