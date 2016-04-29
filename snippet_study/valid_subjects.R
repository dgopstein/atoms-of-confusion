library("RSQLite")
library("fitdistrplus")
library(DBI)
library("data.table")



con = dbConnect(drv=RSQLite::SQLite(), dbname="confusion.db")
alltables <- dbListTables(con)

#
# Test duration
#

# get the populationtable as a data.frame
users = dbGetQuery( con,'select * from user' )
posUsers = subset(users, Duration > 0)

print(posUsers)


posDuration <- posUsers$Duration
hist(posDuration, breaks=25) # !!!

logDuration <- log(posDuration)

qqnorm(posDuration)
qqnorm(logDuration)

print(fitdist(posDuration, "gamma"))
print(summary(fitdist(posDuration, "lnorm")))
print(fitdist(posDuration, "norm"))

#
# Answers correctness
#

usercode <- dbGetQuery( con,'select * from usercode;' );
correctCount <- dbGetQuery( con,'select userid, correct, count(*) from usercode group by userid, correct;' );
correctRatio <- correctCount[correctCount$Correct=='T',] / correctCount[correctCount$Correct=='F',]

# split(correctCount, correctCount[correctCount$Correct=='T',] / correctCount[correctCount$Correct=='F',])

DT <- data.table(usercode)
print(DT[, sum, by=list(usercode$Correct)])
