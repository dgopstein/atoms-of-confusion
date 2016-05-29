library(DBI)
library(data.table)

con <- dbConnect(drv=RSQLite::SQLite(), dbname="confusion.db")
clusteredQuery <- paste(readLines('sql/clustered_contingency.sql'), collapse = "\n")
clustRes <- dbGetQuery( con, clusteredQuery )
cnts <- data.table(clustRes)

abcd <- cnts[,.(TT, TF, FT, FF)]

durkalski <- function(abcd) {
  dput(abcd)
  
  nk <- Reduce("+", abcd)

  bk <- abcd$TF
  ck <- abcd$FT

  X2v <- sum( (1/nk)*(bk-ck) )^2/sum(((bk - ck) / nk)^2)

  X2v
}

durkalski(abcd)

chis <- cnts[, .(chisq = durkalski(.(TT=TT, TF=TF, FT=FT, FF=FF))), by=atom]
chis$p.value <- lapply(chis$chisq, function(x) pchisq(x, 1, lower.tail=FALSE))
chis$sig <- lapply(chis$p.value, function(x) x < 0.05)
