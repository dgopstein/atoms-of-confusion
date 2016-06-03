library(DBI)
library("data.table")

con <- dbConnect(drv=RSQLite::SQLite(), dbname="confusion.db")
correctnessQuery <- paste(readLines('sql/correctness_by_degree.sql'), collapse = "\n")
correctnessRes <- dbGetQuery( con, correctnessQuery )

# Survey data
surveyCsv = tail(read.csv("csv/Confusing_Atoms-Clean.csv"), -1)

degrees <-list("None Listed", "Associate", "Bachelor's", "Master's", "Doctoral", "Professional")
gender <- list("Male", "Female", "Unspecified")

survey_correctness <- data.table(merge(correctnessRes, surveyCsv, by.x="Name", by.y="TestID"))
survey_correctness$correctness <- survey_correctness$n_correct / survey_correctness$n_questions
survey_correctness$EducationText <- unlist(degrees[survey_correctness$Education])

plot(x=survey_correctness$Education,
     y=survey_correctness$correctness,
     col="#00000020",pch=16, xaxt="n")
degree_counts <- cbind(unlist(degrees), c(unlist(survey_correctness[order(Education),.(n = sum(Name != '')), by=Education]$n), 0))
axis(1, at=(1:6), lab=apply(degree_counts, 1, function(x) paste("\n",x[1], "\nn =", x[2])))



as.ints <- function(vec) {
  c_months_str <- as.character(vec)
  as.numeric(regmatches(c_months_str, regexpr("\\d+|", c_months_str)))
}

c_months <- as.ints(survey_correctness$CMonth)

plot(x=log(c_months), y=survey_correctness$correctness,
     xlab="Experience in C (log scale)",
     ylab="Fraction of questions correct")

plot(x=log(as.ints(survey_correctness$ProgMonth)), y=survey_correctness$correctness,
     xlab="Programming Experience (log scale)",
     ylab="Fraction of questions correct")

