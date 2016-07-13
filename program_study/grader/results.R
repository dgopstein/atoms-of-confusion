library("data.table")
library(Hmisc)

##### Histogram includes
library(MASS)
library(RColorBrewer)
rf <- colorRampPalette(rev(brewer.pal(11,'Spectral')))
r <- rf(32)
library(grDevices)
#$$$$
library(lattice)

c.types <- c('a', 'c', 'e', 'g')
nc.types <- c('b', 'd', 'f', 'h')

pilot.ids <- c(3782, 1161, 1224, 3270, 9351, 6490, 4747, 6224, 3881, 6033)


f.t <- function(a, a_total, b, b_total) fisher.test(rbind(c(a,a_total-a), c(b,b_total-b)), alternative="greater")

# ./fault_rates.rb csv/results.csv > csv/fault_rates.csv
faultDT <- data.table(read.csv("csv/fault_rates.csv", header = TRUE))#[! subject %in% pilot.ids]
nrow(faultDT)
faultDT$c_checks <- mapply(max, 1, faultDT$c_checks)
faultDT$c_fault_rate  <- faultDT$c_faults / faultDT$c_checks
faultDT$nc_fault_rate <- faultDT$nc_faults/faultDT$nc_checks


# ./grade_csv.rb csv/results.csv > csv/grades.csv
gradeDT <- data.table(read.csv("csv/grades.csv", header = TRUE))#[! subject %in% pilot.ids]
gradeDT$confusing <- gradeDT$qtype %in% c.types
gradeDT$rate <- gradeDT[, correct/points]


resultsDT <- data.table(read.csv("csv/results.csv", header = TRUE))#[! Subject %in% pilot.ids]


#######################################################
# How many subjects answered a question totally correct
#######################################################
all.correct <- gradeDT[order(qtype), .(n.correct=sum(correct==points)), by=qtype]
n.correct.f.t <- function(a.type, b.type)
  f.t(all.correct[qtype==b.type]$n.correct, sum(gradeDT$qtype==b.type),
      all.correct[qtype==a.type]$n.correct, sum(gradeDT$qtype==a.type))

# Per-question
n.correct.f.t('a', 'b')$p.value
n.correct.f.t('c', 'd')$p.value
n.correct.f.t('e', 'f')$p.value
n.correct.f.t('g', 'h')$p.value

# All questions pooled
f.t(sum(all.correct[qtype %in% nc.types]$n.correct), sum(gradeDT$qtype %in% nc.types),
    sum(all.correct[qtype %in% c.types]$n.correct), sum(gradeDT$qtype %in% c.types))
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$







#######################################################
# Outlier subjects based on question correctness
# n.b. Christoffer suggested that people who "I Give Up'd" many questions (the supposed outliers)
# might just have a different working style than those who didn't "I Give Up" and therefore the data is valid
#######################################################
# upper.wilson <- binconf(sum(faultDT$nc_faults), sum(faultDT$nc_checks, na.rm = TRUE))[3]
# faultDT[nc_fault_rate > upper.wilson]

subject.points <- gradeDT[,.(correct=sum(correct), points=sum(points), rate=sum(correct)/sum(points)), by=subject]
lower.wilson <-
  binconf(sum(subject.points$correct), sum(subject.points$points), alpha=0.05)
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
plot(c.sum, nc.sum, type='n', xlim=c(0,1), ylim=c(0,1))

# Heatmap: http://www.r-bloggers.com/5-ways-to-do-2d-histograms-in-r/
# Overlay image: http://stackoverflow.com/questions/12918367/in-r-how-to-plot-with-a-png-as-background
k <- kde2d(c.sum, nc.sum, n=200, lims=c(0,1, 0,1))
lim <- par()
img <- image(k, col=r)
#rasterImage(img, lim$usr[1], lim$usr[3], lim$usr[2], lim$usr[4])

grid()
title(main="Subject performance on C vs NC questions", xlab = "C correct rate", ylab = "NC correct rate")
points(c.sum, nc.sum, pch=16, bg="black", col=rgb(.2,.2,.2,.8))#'#404040F0')
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

resultsDT[, sum(grepl("X",A))]
resultsDT[, sum(grepl("X",B))]
resultsDT[, sum(grepl("X",C))]
resultsDT[, sum(grepl("X",D))]
resultsDT[, sum(grepl("X",E))]
resultsDT[, sum(grepl("X",F))]
resultsDT[, sum(grepl("X",G))]
resultsDT[, sum(grepl("X",H))]
f.t(4, 31, 0, 31)$p.value # ab
f.t(2, 31, 1, 31)$p.value # cd
f.t(4, 31, 1, 31)$p.value # ef
f.t(4, 31, 2, 31)$p.value # gh
f.t(14, 124, 4, 124)$p.value # all
#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


#######################################################
# Correctness by question order
#######################################################

# how many C/NC in each question position
gradeDT[order(qpos, confusing), .( COUNT = .N ),by=c('qpos', 'confusing')]

pos.scores <- gradeDT[, .(rate = mean(rate)),by=c('qpos','confusing')]
plot(pos.scores$qpos, pos.scores$rate)

#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


#######################################################
# Timing per question
#######################################################


q.times <- gradeDT[order(qtype),.( time = mean(mins), confusing = max(confusing) ),by=qtype]


barchart(time~qtype,data=q.times,groups=confusing, main='Average minutes taken to answer each question')
         #scales=list(x=list(rot=90,cex=0.8)))

#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

