library("RSQLite")
library("fitdistrplus")
library(DBI)
library("data.table")
library('plyr')


con <- dbConnect(drv=RSQLite::SQLite(), dbname="confusion.db")
alltables <- dbListTables(con)

contingencyQuery <- paste(readLines('contingency.sql'), collapse = "\n")

queryRes <- dbGetQuery( con, contingencyQuery )

alpha <- 0.05

phi <- function(chi2, n) {
  sqrt(chi2/n)
}

printContingency <- function(name, alpha, res, contingency) {
  sig <- is.significant(res, alpha)
  es <- phi(res$statistic, sum(contingency))
  contStr <- paste(format(contingency, width=3), collapse=" ")
  
  writeLines(sprintf("%-35s: %d - (p:%.2e, es:%0.2f)  (%s)", name, sig, res$p.value, es, contStr))
  
  NULL
}

is.significant <- function(res, alpha) {
  is.finite(res$p.value) && res$p.value < alpha
}


byQuestion <- function(queryRes) {
  # print p-value and effect size for each question
  contingencyTables <- mapply(function(a,b,c,d) matrix(c(a,b,c,d), 2, 2), queryRes$TT,  queryRes$TF, queryRes$FT,queryRes$FF, SIMPLIFY = FALSE)
  mcnemarsRes <- lapply(contingencyTables, function(x) mcnemar.test(x, correct=FALSE))
  ignore <- mapply(printContingency, queryRes$question, alpha, mcnemarsRes, contingencyTables)
  
  # how many questions were significant for each atom type
  mcnemarsFrame <- as.data.frame(matrix(unlist(mcnemarsRes), ncol=length(unlist(mcnemarsRes[1])), byrow=T))
  colnames(mcnemarsFrame) <- attributes(mcnemarsRes[[1]])$names
  
  mcnemarsFrame$questionName <- queryRes$question
  mcnemarsFrame$atomName <- queryRes$atom
  
  dt <- data.table(mcnemarsFrame)
  dt[, length(questionName[as.numeric(as.character(p.value)) < 0.005]), by = atomName]
}

processAtom <- function(atomName) {
    sign <- queryRes[queryRes$atom == atomName,]
    
    contingency <- matrix(c(sum(sign$TT), sum(sign$TF), sum(sign$FT), sum(sign$FF)), 2, 2)
    mcnemarsRes <- mcnemar.test(contingency, correct=FALSE)

    list('atomName' = atomName, 'contingency' = contingency, 'mcnemarsRes' = mcnemarsRes)
}

byAtom <- function(contingencies) {
  writeLines(sprintf("%-35s: sig. - (pvalue, effectSize)  (TT TF FT FF)", "atom"))
  
  alpha <- 0.05

  atomRes <- lapply(unique(contingencies$atom), processAtom)

  lapply(atomRes, function (r) printContingency(r$atomName, alpha, r$mcnemarsRes, r$contingency))

  NULL
}

byQuestion(queryRes)

byAtom(queryRes)
