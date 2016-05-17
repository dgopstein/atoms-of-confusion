library("RSQLite")
library("fitdistrplus")
library(DBI)
library("data.table")
library('plyr')

is.nan.data.frame <- function(x) do.call(cbind, lapply(x, is.nan))

# Coefficient of Variability, measure of dispersion/relative variability:
# http://alstatr.blogspot.com/2013/06/measure-of-relative-variability.html
CV <- function(vec) sd(vec)/mean(vec)

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

toDF <- function (mcnemarsRes) {
  mcnemarsFrame <- as.data.frame(matrix(unlist(mcnemarsRes), ncol=length(unlist(mcnemarsRes[1])), byrow=T))
  #colnames(mcnemarsFrame) <- attributes(mcnemarsRes[[1]])$names
  mcnemarsFrame
}

#byQuestion <- function(queryRes) {
  # print p-value and effect size for each question
  contingencyTables <- mapply(function(a,b,c,d) matrix(c(a,b,c,d), 2, 2), queryRes$TT,  queryRes$TF, queryRes$FT,queryRes$FF, SIMPLIFY = FALSE)
  mcnemarsRes <- lapply(contingencyTables, function(x) mcnemar.test(x, correct=FALSE))
  ignore <- mapply(printContingency, queryRes$question, alpha, mcnemarsRes, contingencyTables)
  
  # how many questions were significant for each atom type
  mcnemarsFrame <-toDF(mcnemarsRes)
  colnames(mcnemarsFrame) <- attributes(mcnemarsRes[[1]])$names
  
  mcnemarsFrame$questionName <- queryRes$question
  mcnemarsFrame$atomName <- queryRes$atom
  mcnemarsFrame$contingencies <- contingencyTables
  mcnemarsFrame$effectSize <- apply(mcnemarsFrame, 1, function(x) phi(as.numeric(x$statistic), sum(x$contingencies)))
  mcnemarsFrame$effectSize[is.nan(mcnemarsFrame$effectSize)] <- 0
  
  dt <- data.table(mcnemarsFrame)
  print("# significant questions")
  print(dt[, length(questionName[as.numeric(as.character(p.value)) < alpha]), by = atomName])
  
  # variance of question triplets
  print("Effect size std.dev. amoung questions")
  effectSdByAtom <- dt[, sd(effectSize), by = atomName]
  effectVarByAtom <- dt[, var(effectSize), by = atomName]
  effectCoeffVarByAtom <- dt[, CV(effectSize), by = atomName]
  print(effectSdByAtom)
#}

processAtom <- function(atomName) {
    sign <- queryRes[queryRes$atom == atomName,]
    
    contingency <- matrix(c(sum(sign$TT), sum(sign$TF), sum(sign$FT), sum(sign$FF)), 2, 2)
    mcnemarsRes <- mcnemar.test(contingency, correct=FALSE)
    es <- phi(mcnemarsRes$statistic, sum(contingency))

    list('atomName' = atomName, 'contingency' = contingency, 'mcnemarsRes' = mcnemarsRes, 'effectSize' = es)
}

#byAtom <- function(queryRes) {
  writeLines(sprintf("%-35s: sig. - (pvalue, effectSize)  (TT TF FT FF)", "atom"))
  
  alpha <- 0.05

  atomRes <- lapply(unique(queryRes$atom), processAtom)

  invisible(lapply(atomRes, function (r) printContingency(r$atomName, alpha, r$mcnemarsRes, r$contingency)))

  atomFrame <- toDF(atomRes)
  
  #atomFrame
#}

#byQuestion(queryRes)

#atomFrame <- byAtom(queryRes)

#x <- atomFrame$V11
#y <- effectSdByAtom$V1
x <- effectCoeffVarByAtom$atomName
y <- effectCoeffVarByAtom$V1

l <- atomFrame$V1
#plot(x, y, xlab="effect size", ylab="sd of effect size")
#text(x,y,labels=l, srt = -25)

stripchart(y, at=-1); #text(y, 1.01, labels=l, srt=90, cex=1.5, adj=c(0,0))


