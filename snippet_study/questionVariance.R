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
  #ret <- sapply(res['p.value'], is.finite) && res['p.value'] < alpha
  ret <- is.finite(res$p.value) && res$p.value < alpha
  #writeLines(paste(ret))
  ret
}


byQuestion <- function(contingencies) {
  sigCounts <- list()
  for (question in contingencies$question) {
    questionCont <- contingencies[contingencies$question == question,]
    
    contingency <- matrix(c(questionCont$TT,  questionCont$TF, questionCont$FT,questionCont$FF), 2, 2)
    res <- mcnemar.test(contingency, correct=FALSE)

    #es <- assocstats(contingency)

    alpha <- 0.05

    printContingency(question, alpha, res, contingency)

    if (!(questionCont$atom %in% names(sigCounts))) {
      sigCounts[[questionCont$atom]] <- 0
    }
    if (is.significant(res, alpha)) {
      sigCounts[[questionCont$atom]] %+=% 1
    }
  }

  for (atom in names(sigCounts)) {
    writeLines(sprintf("counts %d - %s", sigCounts[[atom]], atom))
  }
}

processAtom <- function(atomName) {
    sign <- contingencies[contingencies$atom == atomName,]
    
    contingency <- matrix(c(sum(sign$TT), sum(sign$TF), sum(sign$FT), sum(sign$FF)), 2, 2)
    mcnemarsRes <- mcnemar.test(contingency, correct=FALSE)
    
    # zeros <- floor(sum(sign$TT, sign$FF) / 2)
    # successes <- sum(sign$FT)#, zeros)
    # failures <- sum(sign$TF)#, zeros)
    #total <- sum(successes, failures)
    # res <- binom.test(successes, total, p = 0.5, alternative = "greater", conf.level = 1 - alpha)
    
    # cat("mcnemars: ")
    
    # effectSize <- assocstats(contingency)
    
    # cat("signtest: ")
    # printContingency(atom, alpha, res, contingency)

    list('atomName' = atomName, 'contingency' = contingency, 'mcnemarsRes' = mcnemarsRes)
}

byAtom <- function(contingencies) {
  writeLines(sprintf("%-35s: sig. - (pvalue, effectSize)  (TT TF FT FF)", "atom"))
  
  # There are 3 questions for each atom
  alpha <- 0.05
  # for (atom in unique(contingencies$atom)) {
  #   processRes <- processAtom(atom)

  atomRes <- lapply(unique(contingencies$atom), processAtom)

  lapply(atomRes, function (r) printContingency(r$atomName, alpha, r$mcnemarsRes, r$contingency))

  NULL
}

#contingencyTables <- matrix(c(queryRes$TT,  queryRes$TF, queryRes$FT,queryRes$FF), 2, 2)
#contingencyTables <- mapply(queryRes, function(a) matrix(c(a$TT,  a$TF, a$FT,a$FF), 2, 2))
contingencyTables <- mapply(function(a,b,c,d) matrix(c(a,b,c,d), 2, 2), queryRes$TT,  queryRes$TF, queryRes$FT,queryRes$FF, SIMPLIFY = FALSE)
mcnemarsRes <- lapply(contingencyTables, function(x) mcnemar.test(x, correct=FALSE))
nulls <- mapply(printContingency, queryRes$question, alpha, mcnemarsRes, contingencyTables)

#qNameFrame <- data.frame(queryRes$question)
#mcnemarsFrame <- data.frame(unlist(mcnemarsRes))
#merge(mcnemarsFrame, qNameFrame)
#dt <- data.table(mcnemarsRes)
#dt <- do.call(rbind, lapply(mcnemarsRes, data.frame, stringsAsFactors=FALSE))
#dt$id  <- 1:nrow(dt)
#d2 <- data.table(queryRes$atom)
#d2$id  <- 1:nrow(d2)
#d3 <- merge(dt, d2, by="id")
#colnames(d3)<-c("id","mcnemars", "atom")
#d3[, length(atom[mcnemarsRes$p.value < mcnemars$alpha]), by = atom]
#d3[, length(mcnemars[mcnemars$p.value < 1]), by=atom]

#dt$mcnemarsRes[mcnemarsRes$p.value < 0.05]
mcnemarsFrame <- as.data.frame(matrix(unlist(mcnemarsRes), ncol=length(unlist(mcnemarsRes[1])), byrow=T))
colnames(mcnemarsFrame) <- attributes(mcnemarsRes[[1]])$names

mcnemarsFrame$questionName <- queryRes$question
mcnemarsFrame$atomName <- queryRes$atom

dt <- data.table(mcnemarsFrame)
dt[, length(atomName[p.value < alpha]), by = atomName]
dt[, length(questionName[as.numeric(as.character(p.value)) < 0.005]), by = atomName]



byQuestion(contingencies)

byAtom(contingencies)
