library("data.table")
library(Hmisc)

f.t <- function(a, a_total, b, b_total) fisher.test(rbind(c(a,a_total-a), c(b,b_total-b)), alternative="greater")

# ./fault_rates.rb csv/results.csv > csv/fault_rates.csv
faultDT <- data.table(read.csv("csv/fault_rates.csv", header = TRUE))

# ./grade_csv.rb csv/results.csv > csv/grades.csv
gradeDT <- data.table(read.csv("csv/grades.csv", header = TRUE))

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

c.types <- c('a', 'c', 'e', 'g')
nc.types <- c('b', 'd', 'f', 'h')

f.t(sum(all.correct[qtype %in% nc.types]$n.correct), sum(gradeDT$qtype %in% nc.types),
    sum(all.correct[qtype %in% c.types]$n.correct), sum(gradeDT$qtype %in% c.types))
#######################################################




faultDT$c_checks <- mapply(max, 1, faultDT$c_checks)
faultDT$c_fault_rate  <- faultDT$c_faults / faultDT$c_checks
faultDT$nc_fault_rate <- faultDT$nc_faults/faultDT$nc_checks





#######################################################
# Outliers
#######################################################
# upper.wilson <- binconf(sum(faultDT$nc_faults), sum(faultDT$nc_checks, na.rm = TRUE))[3]
# faultDT[nc_fault_rate > upper.wilson]

subject.points <- gradeDT[,.(correct=sum(correct), points=sum(points), rate=sum(correct)/sum(points)), by=subject]
lower.wilson <- binconf(sum(subject.points$correct), sum(subject.points$points))[2]
subject.points[correct/points > lower.wilson]

hist(subject.points$rate, breaks=9, main="correctness of user responses", xlab="rate of correct answers per user")
rug(subject.points$rate)
#######################################################



# http://stats.stackexchange.com/questions/113602/test-if-two-binomial-distributions-are-statistically-different-from-each-other
f.t.res <- mapply(f.t, faultDT$c_faults, faultDT$c_checks, faultDT$nc_faults, faultDT$nc_checks)
faultDT$ft.p.value <- unlist(f.t.res[1,])

# I give up's (incomplete data from 2016-07-05)
f.t(4, 31, 0, 31)$p.value # ab
f.t(2, 31, 1, 31)$p.value # cd
f.t(4, 31, 1, 31)$p.value # ef
f.t(4, 31, 2, 31)$p.value # gh
f.t(14, 124, 4, 124)$p.value # all
