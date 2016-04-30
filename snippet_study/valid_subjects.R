library("RSQLite")
library("fitdistrplus")
library(DBI)
library("data.table")
library('plyr')



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
mean(posDuration)

hist(posDuration, breaks=20) # !!!




logDuration <- log(posDuration)

qqnorm(posDuration)
qqnorm(logDuration)

print(fitdist(posDuration, "gamma"))
print(summary(fitdist(posDuration, "lnorm")))
print(fitdist(posDuration, "norm"))
print(fitdist(posDuration, "pois"))


#
# Answers correctness
#

usercounts <- dbGetQuery( con,"select userid, sum(case when correct = 'T' then 1 end) t, sum(case when correct = 'F' then 1 end) f, count(*) as nAnswered from usercode group by userid;");

#print(length(usercounts[usercounts$nAnswered==84,]$UserID))



hist(usercounts$nAnswered)
#DT <- data.table(usercounts)
#DT[,sum, by=nAnswered]
#print(aggregate(~ nAnswered, usercounts, sum))

print(count(usercounts, "nAnswered"))

ratio <- usercounts$t / usercounts$f
hist(ratio, breaks=30)
print(sort(ratio))

