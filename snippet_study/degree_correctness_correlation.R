library(DBI)
library("data.table")

con <- dbConnect(drv=RSQLite::SQLite(), dbname="confusion.db")
correctnessQuery <- paste(readLines('sql/correctness_by_degree.sql'), collapse = "\n")
correctnessRes <- dbGetQuery( con, correctnessQuery )

# Survey data
surveyCsv = tail(read.csv("csv/Confusing_Atoms-Clean.csv"), -1)

degrees <-list("Associate", "Bachelor's", "Master's", "Doctoral", "Professional")
gender <- list("Male", "Female", "Unspecified")

survey_correctness <- merge(correctnessRes, surveyCsv, by.x="Name", by.y="TestID")
survey_correctness$correctness <- survey_correctness$n_correct / survey_correctness$n_questions
survey_correctness$EducationText <- unlist(degrees[survey_correctness$Education])


x <- survey_correctness$Education
y <- survey_correctness$correctness
lbls <- unlist(degrees) #survey_correctness$EducationText

lbls

plot(x,y,col="#00000020",pch=16, xaxt="n")
axis(1, at=(1:5), lab=lbls)
