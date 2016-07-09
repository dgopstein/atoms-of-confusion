library("data.table")
library(Hmisc)

c.types <- c('a', 'c', 'e', 'g')
nc.types <- c('b', 'd', 'f', 'h')

f.t <- function(a, a_total, b, b_total) fisher.test(rbind(c(a,a_total-a), c(b,b_total-b)), alternative="greater")

# ./fault_rates.rb csv/results.csv > csv/fault_rates.csv
faultDT <- data.table(read.csv("csv/fault_rates.csv", header = TRUE))
faultDT$c_checks <- mapply(max, 1, faultDT$c_checks)
faultDT$c_fault_rate  <- faultDT$c_faults / faultDT$c_checks
faultDT$nc_fault_rate <- faultDT$nc_faults/faultDT$nc_checks


# ./grade_csv.rb csv/results.csv > csv/grades.csv
gradeDT <- data.table(read.csv("csv/grades.csv", header = TRUE))
gradeDT$confusing <- gradeDT$qtype %in% c.types
gradeDT$rate <- gradeDT[, correct/points]

#######################################################
# How many subjects answered a question totally correct
#######################################################
all.correct <- gradeDT[order(qtype), .(n.correct=sum(correct==points)), by=qtype]
n.correct.f.t <- function(a.type, b.type)
  f.t(all.correct[qtype==b.type]$n.correct, sum(gradeDT$qtype==b.type),
      all.correct[qtype==a.type]$n.correct, sum(gradeDT$qtype==a.type))

n.correct.f.t('a', 'b')$p.value
n.correct.f.t('c', 'd')$p.value
n.correct.f.t('e', 'f')$p.value
n.correct.f.t('g', 'h')$p.value


f.t(sum(all.correct[qtype %in% nc.types]$n.correct), sum(gradeDT$qtype %in% nc.types),
    sum(all.correct[qtype %in% c.types]$n.correct), sum(gradeDT$qtype %in% c.types))
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$







#######################################################
# Outlier subjects based on question correctness
#######################################################
# upper.wilson <- binconf(sum(faultDT$nc_faults), sum(faultDT$nc_checks, na.rm = TRUE))[3]
# faultDT[nc_fault_rate > upper.wilson]

subject.points <- gradeDT[,.(correct=sum(correct), points=sum(points), rate=sum(correct)/sum(points)), by=subject]
lower.wilson <- binconf(sum(subject.points$correct), sum(subject.points$points))[2]
subject.points[correct/points > lower.wilson]

hist(subject.points$rate, breaks=9, main="correctness of user responses", xlab="rate of correct answers per user")
rug(subject.points$rate)
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$





#######################################################
# C vs NC chart per subject
#######################################################
scores.summed <- gradeDT[,.(rate=sum(correct)/sum(points)),by=c("subject", "confusing")]
c.sum <- scores.summed[confusing == TRUE, rate]
nc.sum <- scores.summed[confusing == FALSE, rate]

scores.summed.subject <- scores.summed[,sum(rate)/2,by="subject"]
plot(c.sum, nc.sum, xlim=c(.3,1), ylim=c(.3,1))
abline(0,1)
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


#######################################################
# P-value for C vs NC questions (a vs b, c vs d, etc)
#######################################################
q.p.value <- function(a, b) {
  c.sum <- gradeDT[,correct/points,by=qtype][qtype==a]$V1
  nc.sum <- gradeDT[,correct/points,by=qtype][qtype==b]$V1
  
  t.test(c.sum, nc.sum, alternative="less")
}

q.p.value('a', 'b')$p.value
q.p.value('c', 'd')$p.value
q.p.value('e', 'f')$p.value
q.p.value('g', 'h')$p.value

# Correctness of each question pair
gradeDT[order(qtype), sum(correct)/sum(points), by=qtype]

# Correctness of all C vs all NC
gradeDT[, sum(correct)/sum(points), by=confusing]

# p-value for all C vs all NC
t.test(gradeDT[confusing==TRUE]$rate, gradeDT[confusing==FALSE]$rate, alternative="less")
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$





#######################################################
# I give up's (incomplete data from 2016-07-05)
#######################################################
# http://stats.stackexchange.com/questions/113602/test-if-two-binomial-distributions-are-statistically-different-from-each-other
f.t.res <- mapply(f.t, faultDT$c_faults, faultDT$c_checks, faultDT$nc_faults, faultDT$nc_checks)
faultDT$ft.p.value <- unlist(f.t.res[1,])

f.t(4, 31, 0, 31)$p.value # ab
f.t(2, 31, 1, 31)$p.value # cd
f.t(4, 31, 1, 31)$p.value # ef
f.t(4, 31, 2, 31)$p.value # gh
f.t(14, 124, 4, 124)$p.value # all
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

