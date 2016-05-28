library("RSQLite")
library(DBI)
library("data.table")

# An implementation of Obuchowski 1998

# Desired syntax:
# obuchowski(cbind(TT, TF, FT, FF) ~ atomName, contingencies)

con <- dbConnect(drv=RSQLite::SQLite(), dbname="confusion.db")
clusteredQuery <- paste(readLines('sql/clustered_contingency.sql'), collapse = "\n")
clustRes <- dbGetQuery( con, clusteredQuery )
cnts <- data.table(clustRes)

N <- cnts$TT + cnts$TF + cnts$FT + cnts$FF

TF <- cnts$TF
FT <- cnts$FT

# m = number of subjects (73)
# n_j = number of questions per subject (2)
# j = is the index denoting which question pair
# I = number of treatments (2, confusing/non-confusing)
# x_ij = number of questions that responded to treatment (TF/FT)

obuchowski.test <- function(x1, x2, N, clusters) {
  m <- length(unique(clusters))
  ((p.hat(x1, N) - p.hat(x2, N))^2) / var.hat.diff(x1, x2, N, m)
}

# Eqn (1)
p.hat <- function(x, N) sum(x) / sum(N)

# Eqn (2)
var.hat <- function(x, N, m)
  m * (m-1)^-1 * sum( (x - (N * p.hat(x, N)))^2 ) / sum(N)^2

# Eqn (3)
cov.hat <- function(x, x1, N, m)
  m * (m-1)^-1 * sum( (x - (N * p.hat(x, N))) * (x1 - (N * p.hat(x1, N))) ) / sum(N)^2

# Eqn (4)
var.hat.diff <- function(x, x1, N, m)
  var.hat(x, N, m) + var.hat(x1, N, m) - 2 * cov.hat(x, x1, N, m)

chis <- cnts[, .(chisq = obuchowski.test(TF, FT, N, userId)), by=atom]
chis$sig <- chis[, chisq > qchisq(0.95, 1)]
