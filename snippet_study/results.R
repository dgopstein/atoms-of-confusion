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
    
    total <- sum(contingency)
    
    # Probability of success is conditional on getting the Confusing question wrong
    probabilityOfSuccess <- (sum(contingency[3:4]) / total) * 0.5
    
    # There are 3 questions per atom which must be summed together
    # The successes are the questions whose confusing version was answered incorrectly
    # But then the non-confusing version was answered correctly
    successes <- sum(sign$FT)
    res <- binom.test(successes, total, p = probabilityOfSuccess, alternative = "greater", conf.level = 0.95)
    
    writeLines(sprintf("%-35s: %d - %f  (%s)", atom, res['p.value'] < 0.05, res['p.value'], paste(format(contingency, width=3), collapse=" ")))
  }
}

signtest(contingencies)
