library(xtable)




lst <- function(s) paste("{\\begin{lstlisting}[style=tablec]^^J",
                         gsub("\n",  "^^J\n",
                         gsub(" ",   "\\\\ ",
                         gsub("%",   "\\\\%",
                         gsub("\\}", "\\\\}",
                         gsub("\\{", "\\\\{", s))))),
                         "^^J\\end{lstlisting}}")

identified.atoms <- data.table(read.csv("csv/identified_atoms.csv", header = TRUE))
identified.atoms[, Atom.Example := lst(Atom.Example)]
identified.atoms[, Transformation.Example := lst(Transformation.Example)]


print(xtable(identified.atoms), include.rownames=FALSE, sanitize.text.function = identity)

