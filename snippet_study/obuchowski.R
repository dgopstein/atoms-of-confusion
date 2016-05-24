library("RSQLite")
library(DBI)
library("data.table")

# An implementation of Obuchowski 1998

# Desired syntax:
# obuchowski(cbind(TT, TF, FT, FF) ~ atomName, contingencies)

con <- dbConnect(drv=RSQLite::SQLite(), dbname="confusion.db")
alltables <- dbListTables(con)
contingencyQuery <- paste(readLines('sql/contingency.sql'), collapse = "\n")
queryRes <- dbGetQuery( con, contingencyQuery )
cnts <- data.table(data.frame(queryRes[c('atom', 'TT', 'TF', 'FT', 'FF')]))

cnts$n <- cnts$TT + cnts$TF + cnts$FT + cnts$FF

TF <- cnts$TF
FT <- cnts$FT

# m = number of subjects (73)
# n_j = number of questions per subject (2)
# j = is the index denoting which question pair
# I = number of treatments (2, confusing/non-confusing)
# x_ij = number of questions that responded to treatment (TF/FT)

m <- length(unique(cnts$atom))

# Eqn (1)
p.hat <- function(x) sum(x) / sum(cnts$n)

# Eqn (2)
var.hat <- function(x)
  m * (m-1)^-1 * sum( (x - (cnts$n * p.hat(x)))^2 ) / sum(cnts$n)^2

# Eqn (3)
cov.hat <- function(x, x1)
  m * (m-1)^-1 * sum( (x - (cnts$n * p.hat(x))) * (x1 - (cnts$n * p.hat(x1))) ) / sum(cnts$n)^2

# Eqn (4)
var.hat.diff <- function(x, x1)
  var.hat(x) + var.hat(x1) - 2 * cov.hat(x, x1)
  
obuchowski <- function (x1, x2)
  ((p.hat(x1) - p.hat(x2))^2) / var.hat.diff(x1, x2)

obuchowski(FT, TF)

cnts[, obuchowski(FT, TF), by=atom]
