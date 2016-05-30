library(DBI)
library(data.table)

source("stats/durkalski.R")
source("stats/obuchowski.R")
source("stats/eliasziw_donner.R")

con <- dbConnect(drv=RSQLite::SQLite(), dbname="confusion.db")
clusteredQuery <- paste(readLines('sql/clustered_contingency.sql'), collapse = "\n")
clustRes <- dbGetQuery( con, clusteredQuery )
cnts <- data.table(clustRes)

#abcd <- cnts[,.(TT, TF, FT, FF)]

test_by_atom <- function(test) {
  chis <- cnts[, .(chisq = test(.(TT=TT, TF=TF, FT=FT, FF=FF))), by=atom]
  #chis$p.value <- lapply(chis$chisq, function(x) pchisq(x, 1, lower.tail=FALSE))
  #chis$sig <- lapply(chis$p.value, function(x) x < 0.05)
  chis$sig <- lapply(chis$chisq, function(x) x > qchisq(0.95, 1))
  
  chis
}

test_all <- function(test) test(abcd)




mcnemars.chis   <- test_by_atom(mcnemars)
dukalski.chis   <- test_by_atom(durkalski)
obuchowski.chis <- test_by_atom(obuchowski)
eliasziw1.chis  <- test_by_atom(eliasziw1)
# test_by_atom(eliasziw2)

all.chis <- Reduce(function(...) merge(..., all=T, by="atom"), list(mcnemars.chis, dukalski.chis, obuchowski.chis, eliasziw1.chis))

