library("RSQLite")
#library("fitdistrplus")
library(DBI)
library("data.table")
#library('plyr')
library('manipulate')
library('animation')
#library(gridExtra)
#library(grid)
library(operators)

pis.nan.data.frame <- function(x) do.call(cbind, lapply(x, is.nan))

# Coefficient of Variability, measure of dispersion/relative variability:
# http://alstatr.blogspot.com/2013/06/measure-of-relative-variability.html
CV <- function(vec) sd(vec)/mean(vec)

con <- dbConnect(drv=RSQLite::SQLite(), dbname="confusion.db")
alltables <- dbListTables(con)

contingencyQuery <- paste(readLines('sql/contingency.sql'), collapse = "\n")

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

runMcnemars <- function(contingency) {
  mcnemarsRes <- mcnemar.test(contingency, correct=FALSE)
  es <- phi(mcnemarsRes$statistic, sum(contingency))
  list('contingency' = contingency, 'mcnemarsRes' = mcnemarsRes, 'effectSize' = es)
}

processAtom <- function(atomName) {
    sign <- queryRes[queryRes$atom == atomName,]
    
    contingency <- matrix(c(sum(sign$TT), sum(sign$TF), sum(sign$FT), sum(sign$FF)), 2, 2)
    mcRes <- runMcnemars(atomName, contingency)
    mcRes$atomName <- atomName
    mcRes
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
#x <- effectCoeffVarByAtom$atomName
#y <- effectCoeffVarByAtom$V1

#l <- atomFrame$V1
#plot(x, y, xlab="effect size", ylab="sd of effect size")
#text(x,y,labels=l, srt = -25)

#stripchart(y, at=0.7); text(y, 0.72, labels=l, srt=90, cex=1.5, adj=c(0,0))

triplet <- dt[atomName=='move_POST_INC_DEC_atom', ]
#lapply(triplet$questionName, function(a) triplet[questionName != a, questionName])
#apply(triplet, 1, function(a) triplet[questionName != a$questionName, questionName])

#apply(triplet, 1, function(a) {
#  m <- mean(triplet$effectSize)
#  triplet[questionName != a$questionName &
#          abs(effectSize - a$effectSize)/m < .2, questionName]
#})

neighbors <- function(thresh) {
  nbrsRes <- apply(dt, 1, function(a) {
    triplet <- dt[atomName==a$atomName, ]
    m <- mean(triplet$effectSize)
    aqn <- a$questionName
    nbrs <- triplet[questionName != aqn &
                abs(effectSize - a$effectSize) < thresh, questionName] # could (and should) be implemented in terms of the dist column below
    
    dist <- min(triplet[questionName != aqn, abs(effectSize - a$effectSize)])
    
    list(aqn, nbrs, dist)
  })
  
  
  nbrsList <- list(lapply(nbrsRes, '[[', 1), lapply(nbrsRes, '[[', 2), lapply(nbrsRes, '[[', 3))
  nbrsDT <- data.table(questionName=unlist(nbrsList[1]), neighbors=nbrsList[[2]], dist=nbrsList[[3]])
  nbrsDT$len <- lapply(nbrsDT$neighbors, length)
  nbrsDT
}


# mcTable <- nonOrphanContingencies
# mcRes <- null
applyMcnemars <- function(mcTable) {
  #mcTable[, runMcnemars(Reduce("+", contingencies)), by='atomName']
  # mcTable[, .SD[, Reduce("+", contingencies)], by='atomName']

  mcTable$TT <- lapply(mcTable$contingencies, '[[', 1)
  mcTable$TF <- lapply(mcTable$contingencies, '[[', 2)
  mcTable$FT <- lapply(mcTable$contingencies, '[[', 3)
  mcTable$FF <- lapply(mcTable$contingencies, '[[', 4)
  
  contingencies <- mcTable[, .("TT" = Reduce('+', TT), "TF" = Reduce('+', TF), "FT" = Reduce('+', FT), "FF" = Reduce('+', FF)), by='atomName']
  contingencyTables <- mapply(function(a,b,c,d) matrix(c(a,b,c,d), 2, 2), contingencies$TT,  contingencies$TF, contingencies$FT,contingencies$FF, SIMPLIFY = FALSE)
  # View(contingencyTables)
  
  mcRes <- lapply(contingencyTables, runMcnemars)

  contingencies$statistic <- lapply(lapply(mcRes, '[[', 'mcnemarsRes'), '[[', 'statistic')
  contingencies$p.value <- lapply(lapply(mcRes, '[[', 'mcnemarsRes'), '[[', 'p.value')
  contingencies$effectSize <- lapply(mcRes, '[[', 'effectSize')

  contingencies
}

csvView <- function(odt) {
  odtView <- odt[,c(attributes(odt)$names[[1]], "p.value", "effectSize","TT", "TF", "FT", "FF"), with=FALSE]
  data.frame(lapply(odtView, as.character), stringsAsFactors=FALSE)
}



orphans <- (nbrsDT <- neighbors(0.2))[len==0]

orphanContingencies <- dt[questionName %in% orphans$questionName]
nonOrphanContingencies <- dt[questionName %!in% orphans$questionName]

orphanDT <- applyMcnemars(orphanContingencies)
nonOrphanDT <- applyMcnemars(nonOrphanContingencies)

write.csv(csvView(orphanDT), file = "csv/orphans-0.2.csv")
write.csv(csvView(nonOrphanDT), file = "csv/nonOrphans-0.2.csv")
# write.csv(atomFrame, file = "atoms.csv")

#neighborLength <- function(thresh) apply(neighbors, 1, length)


histNeighbors <- function(thresh) {
  nbrs <- neighborLength(thresh)
  hist(nbrs, breaks=seq(-0.5, 2.5, 0.5),
       main = sprintf("Cluster sizes @ window = %1.2f", thresh),
       xaxt='n', #xlim=c(-1, 3),
       ylim = c(0, 70),
       xlab="# of neighbors", thresh)
  axis(side=1,at=c(0, 1, 2)-0.25,labels=c(0,1,2))
}

# histNeighbors(2)

# minThresh <- 0.01
# maxThresh <- 2.5
# manipulate(histNeighbors(x), x = slider(minThresh, maxThresh))
# 
# 
# saveGIF({
#   iters <- 50
#   for(i in 1:iters){
#     histNeighbors(i * maxThresh / iters)
#   }
# }, interval = 0.1, ani.width = 550, ani.height = 350)
