library("RSQLite")
library("fitdistrplus")
library(DBI)
library("data.table")
library('plyr')

con <- dbConnect(drv=RSQLite::SQLite(), dbname="confusion.db")
alltables <- dbListTables(con)

contingencyQuery <- paste(readLines('contingency.sql'), collapse = "\n")

contingencies <- dbGetQuery( con, contingencyQuery )

# atom <- 'add_CONDITION_atom_1'
for (atom in contingencies$atom) {
  atomCont <- contingencies[contingencies$atom == atom,]
  
  # https://stat.ethz.ch/R-manual/R-devel/library/stats/html/mcnemar.test.html
  contingency <- matrix(c(atomCont$TT, atomCont$FT, atomCont$TF, atomCont$FF),
           nrow = 2,
           dimnames = list("Confusing" = c("C T", "C F"),
                           "Non-Confusing" = c("NC T", "NC F")))
  
  res <- mcnemar.test(contingency)
  print(sprintf("%-25s: %f", atom, res['p.value']))
}
