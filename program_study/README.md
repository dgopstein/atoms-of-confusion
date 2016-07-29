# Program Study Data

In this study we showed 2 varations (one containing atoms, one with atoms removed) of 4 programs (IOCCC winners from various years) to participants to measure the difference in hand trace error rates.

### Programs - `[a-h].c`

The 8 files `[a-h].c` were the text of the program study. All odd-lettered programs `[a, c, e, g]` contain atoms, and all even-lettered programs `[b, d, f, h]` have had their atoms removed.

### Results - `grader/csv/results.csv`

The transcribed results from each subject. The data is stored as a CSV with the following columns:

* **Subject**: A unique, randomized, number assigned anonymouly to each subject.
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

### Grades

The score each participant received on each question they answered

* **subject**: A unique, randomized, number assigned anonymouly to each subject.
* **qtype**: Which question, `[a-h]`.
* **qpos**: Which position in the test the question appeared, `[1-4]`.
* **mins**: How long it took the participant to answer the question, in minutes.
* **correct**: The number of output elements the participant answered correctly.
* **points**: Then number of output elements the participant attempted (faults + correct).
