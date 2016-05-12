library("RSQLite")
library("fitdistrplus")
library(DBI)
library("data.table")
library('plyr')
library('dplyr')
library('functional')


# add += operator
# http://stackoverflow.com/questions/5738831/r-plus-equals-and-plus-plus-equivalent-from-c-c-java-etc
`%+=%` = function(e1,e2) eval.parent(substitute(e1 <- e1 + e2))

con <- dbConnect(drv=RSQLite::SQLite(), dbname="confusion.db")
alltables <- dbListTables(con)

contingencyQuery <- paste(readLines('contingency.sql'), collapse = "\n")

contingencies <- dbGetQuery( con, contingencyQuery )
#contingenciesFrame <- ldply(contingencies, data.frame)
contingenciesFrame <- do.call(rbind.data.frame, contingencies)
#print(contingenciesFrame)
#print(contingencies)
#exit


alpha <- 0.05

phi <- function(chi2, n) {
  sqrt(chi2/n)
}

printContingency <- function(name, res, contingency) {

  sig <- is.significant(res, alpha)
  es <- phi(res$statistic, sum(contingency))
  contStr <- paste(format(contingency, width=3), collapse=" ")
  
  writeLines(sprintf("%-35s: %d - (p:%.2e, es:%0.2f)  (%s)", name, sig, res$p.value, es, contStr))
}

is.significant <- function(res, alpha) {
  #ret <- sapply(res['p.value'], is.finite) && res['p.value'] < alpha
  ret <- is.finite(res$p.value) && res$p.value < alpha
  #writeLines(paste(ret))
  ret
}


byQuestion <- function(contingencies) {
  sigCounts <- list()

  testQuestion <- function (questionCont) {
    writeLines(str(questionCont))
    writeLines(paste("qc$TT: ", str(questionCont$TT)))
    
    contingency <- matrix(c(questionCont$TT,  questionCont$TF, questionCont$FT,questionCont$FF), 2, 2)
    res <- mcnemar.test(contingency, correct=FALSE)

    printContingency(questionCont$question, res, contingency)

    if (!(questionCont$atom %in% names(sigCounts))) {
      sigCounts[[questionCont$atom]] <- 0
    }
    if (is.significant(res, alpha)) {
      sigCounts[[questionCont$atom]] %+=% 1
    }
  }

  #for (question in contingencies$question) {
  #  questionCont <- contingencies[contingencies$question == question,]
  ##for (questionCont in contingencies) {
  #  testQuestion(questionCont)
  #}
  #writeLines(str(contingencies))

  #apply(contingencies, 1, Compose(print, str))
  c1 <- contingencies[1]
  writeLines(colnames(c1))
  matrices <- apply(contingencies, 1, function(x) matrix(c(x['TT'], x['TF'], x['FT'], x['FF']), 2, 2))

  print(str(matrices[1]))

  lapply(contingencies, testQuestion)

  #sigCounts2 <- sigCounts %>% group_by()

  lapply(names(sigCounts), function(a) writeLines(sprintf("counts %d - %s", sigCounts[[a]], a)))

  sigCounts
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
    # printContingency(atom, res, contingency)

    list('atomName' = atomName, 'contingency' = contingency, 'mcnemarsRes' = mcnemarsRes)
}

byAtom <- function(contingencies) {
  writeLines(sprintf("%-35s: sig. - (pvalue, effectSize)  (TT TF FT FF)", "atom"))
  
  # There are 3 questions for each atom
  atomRes <- lapply(unique(contingencies$atom), processAtom)

  lapply(atomRes, function (r) printContingency(r$atomName, r$mcnemarsRes, r$contingency))

  atomRes
}

aggQuestions <- function(questionCounts) {
  
}

questionCounts <- byQuestion(contingenciesFrame)

questionAgg <- aggQuestions(questionCounts)

atomRes <- byAtom(contingencies)

