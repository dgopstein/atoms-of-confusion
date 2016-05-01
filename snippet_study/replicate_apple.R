library("RSQLite")
library("fitdistrplus")
library(DBI)
library("data.table")
library('plyr')

con <- dbConnect(drv=RSQLite::SQLite(), dbname="confusion.db")
alltables <- dbListTables(con)

contingencyQuery <- paste(readLines('contingency.sql'), collapse = "\n")

contingencies <- dbGetQuery( con, contingencyQuery )

mcnemars <- function(contingencies) {
  # question <- 'add_CONDITION_question_1'
  for (question in contingencies$question) {
    questionCont <- contingencies[contingencies$question == question,]
    
    # https://stat.ethz.ch/R-manual/R-devel/library/stats/html/mcnemar.test.html
    contingency <- matrix(c(questionCont$TT, questionCont$FT, questionCont$TF, questionCont$FF),
             nrow = 2,
             dimnames = list("Confusing" = c("C T", "C F"),
                             "Non-Confusing" = c("NC T", "NC F")))
    
    res <- mcnemar.test(contingency)
    writeLines(sprintf("%-35s: %d - %f", question, res['p.value'] < 0.05, res['p.value']))
  }
}

mcnemars(contingencies)

signtest <- function(contingencies) {
  writeLines(sprintf("%-35s: %s - %s  (%s)", "atom", 'sgnfct', 'pvalue', "(TT TF FT FF)"))
  
  # There are 3 questions for each atom
  for (atom in unique(contingencies$atom)) {
    sign <- contingencies[contingencies$atom == atom,]
    
    contingency <- c(sum(sign$TT), sum(sign$TF), sum(sign$FT), sum(sign$FF))
    
    successes <- sum(sign$FT)
    total <- sum(c(sign$FT, sign$TF))
    alpha <- 0.05
    res <- binom.test(successes, total, p = 0.5, alternative = "greater", conf.level = 1 - alpha)
    
    writeLines(sprintf("%-35s: %d - %f  (%s)", atom, res['p.value'] < alpha, res['p.value'], paste(format(contingency, width=3), collapse=" ")))
  }
}

signtest(contingencies)
