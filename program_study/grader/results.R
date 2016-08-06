library("data.table")
library(Hmisc)
library(xtable)

##### Histogram includes
library(MASS)
library(RColorBrewer)
rf <- colorRampPalette(rev(brewer.pal(11,'Spectral')))
set2 <- colorRampPalette(brewer.pal(8,'Set2'))(8)
set3 <- colorRampPalette(brewer.pal(12,'Set3'))(12)
library(grDevices)
#$$$$
library(lattice)
library(testit)

q.types <- c('a', 'b', 'c', 'd', 'e', 'f', 'g', 'h')
q.cols <- c('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H')
c.types <- c('a', 'c', 'e', 'g')
nc.types <- c('b', 'd', 'f', 'h')

q.checks <- as.integer(c(17, 17, 30, 30, 34, 34, 14, 14))
names(q.checks) <- q.types

q.src.linelist <- list('a'=14,'b'=17,'c'=14,'d'=52,'e'=21,'f'=34,'g'=22,'h'=84) # number of lines in each .c file
q.src.lines <- sapply(q.src.linelist, "[[", 1)
q.src.charlist <- list('a'=318,'b'=356,'c'=356,'d'=957,'e'=580,'f'=641,'g'=424,'h'=1291) # number of chars in each .c file
q.src.chars <- sapply(q.src.charlist, "[[", 1)

pilot.ids <- c(3782, 1161, 1224, 3270, 9351, 6490, 4747, 6224, 3881, 6033, 7400, 5125)

f.t <- function(a, a_total, b, b_total) fisher.test(rbind(c(a,a_total-a), c(b,b_total-b)), alternative="greater")

resultsDT <- data.table(read.csv("csv/results.csv", header = TRUE))


assert("There are no pilot ID's in the results", !any(resultsDT$Subject %in% pilot.ids))

resultsDT.flat <- resultsDT[, .(q=q.cols, Order, output=sapply(q.cols, function(chr) as.character(get(chr)))), by=Subject]
resultsDT.flat <- resultsDT.flat[nchar(output) > 0]
resultsDT.flat$pos <- apply(resultsDT.flat, 1, function(x) {regexpr(tolower(x[['q']]), x[['Order']])[1]})
resultsDT.flat$gave.up <- resultsDT.flat[, grepl('!',output)]
resultsDT.flat[gave.up==TRUE, .("IGUs" = sum(gave.up)), by=pos][order(pos)]

# ./fault_rates.rb csv/results.csv > csv/fault_rates.csv
faultDT <- data.table(read.csv("csv/fault_rates.csv", header = TRUE))
faultDT$c_checks <- mapply(max, 1, faultDT$c_checks)
faultDT$c_fault_rate  <- faultDT$c_faults / faultDT$c_checks
faultDT$nc_fault_rate <- faultDT$nc_faults/faultDT$nc_checks


# ./grade_csv.rb csv/results.csv > csv/grades.csv
gradeDT <- data.table(read.csv("csv/grades.csv", header = TRUE))
gradeDT$confusing <- gradeDT$qtype %in% c.types
gradeDT$gave.up <- resultsDT.flat$gave.up
gradeDT[gave.up == TRUE, points := q.checks[qtype]] # penalize people for giving up
gradeDT$rate <- gradeDT[, correct/points]


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
#plot(c.sum, nc.sum, type='n', xlim=c(0,1), ylim=c(0,1))

# Heatmap: http://www.r-bloggers.com/5-ways-to-do-2d-histograms-in-r/
# Overlay image: http://stackoverflow.com/questions/12918367/in-r-how-to-plot-with-a-png-as-background
k <- kde2d(c.sum, nc.sum, n=200, lims=c(0,1, 0,1), h=.3)
img <- image(k, col=rf(32))
grid()
title(main="Subject performance on C vs NC questions", xlab = "C correct rate", ylab = "NC correct rate")
points(c.sum, nc.sum, pch=16, bg="black", col=rgb(.2,.2,.2,.8))#'#404040F0')
abline(0,1)

hist(c.sum); rug(c.sum)
hist(nc.sum); rug(nc.sum)

#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


#######################################################
# P-value for C vs NC questions (a vs b, c vs d, etc)
#######################################################
q.p.value <- function(a, b) {
  c.sum <- gradeDT[,correct/points,by=qtype][qtype==a]$V1
  nc.sum <- gradeDT[,correct/points,by=qtype][qtype==b]$V1
  
  t.test(c.sum, nc.sum, alternative="less")
}


a.v.b <- q.p.value('a', 'b')$p.value
c.v.d <- q.p.value('c', 'd')$p.value
e.v.f <- q.p.value('e', 'f')$p.value
g.v.h <- q.p.value('g', 'h')$p.value

# Correctness of each question pair
gradeDT[order(qtype), mean(rate), by=qtype]

# Correctness of all C vs all NC
all.correctness <- gradeDT[, .(correctness = mean(rate)), by=confusing]

# p-value for all C vs all NC
all.q.p.value <- t.test(gradeDT[confusing==TRUE]$rate, gradeDT[confusing==FALSE]$rate, alternative="less")$p.value

q.rate <- gradeDT[order(qtype),.( correctness = mean(rate), confusing = max(confusing) ), by=qtype]
q.rate <- rbind(q.rate, list("all C", all.correctness[confusing==TRUE]$correctness, 1))
q.rate <- rbind(q.rate, list("all NC", all.correctness[confusing==FALSE]$correctness, 0))
#colnames(q.rate) <- null
#q.rate$qtype <- c("", "", "", "", "", "", "", "", "", "")

q.correctness.labels <- paste0(c("Q1\n", "Q2\n", "Q3\n", "Q4\n", "All\n"), sapply(c(a.v.b, c.v.d, e.v.f, g.v.h, all.q.p.value), function(x) sprintf("p: %0.4f", x)))

#svg("img/average_score_per_question.svg", width = 9, height = 8)
#png("img/average_score_per_question.png", width = 768, height = 768)
pdf("img/average_score_per_question.pdf", width = 9, height = 8)
#https://cran.r-project.org/web/packages/lattice/lattice.pdf
bar.colors <- set3[c(5, 6)]
barchart(correctness~qtype,data=q.rate,groups=confusing, main='Average Score by Question Type', 
         ylab = "Correctness Rate", xlab=list(label = q.correctness.labels, cex = 0.8), scales=list(x=list(draw=FALSE)), 
         par.settings=list(fontsize = list(text = 24), superpose.polygon = list(col = bar.colors), par.main.text = list(just=c(.45, 0))),
         auto.key=list(text=c("Non-Confusing", "Confusing"), height = 6, size = 1, padding.text = -2, columns = 2,
                       reverse.rows = TRUE, between=.5, between.columns=0.8, width=10, space="top", cex = 0.8))
dev.off()

#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$





#######################################################
# I give up's
#######################################################
# http://stats.stackexchange.com/questions/113602/test-if-two-binomial-distributions-are-statistically-different-from-each-other
f.t.res <- mapply(f.t, faultDT$c_faults, faultDT$c_checks, faultDT$nc_faults, faultDT$nc_checks)
faultDT$ft.p.value <- unlist(f.t.res[1,])

# Count how many X,!, or ?'s are in the user responses
count.chars <- function(char) sapply(q.cols, function(x) sum(grepl(char,resultsDT[[x]])))

# Check whether the counts of X,!, or ?'s are statistically significant
sig.counts <- function(counts) {
  mapply(function(a, b){ f.t(counts[[a]], resultsDT[, sum(get(a) != "")],
                             counts[[b]], resultsDT[, sum(get(b) != "")])$p.value},
         toupper(c.types), toupper(nc.types))
}

total.sig.counts <- function (counts) {
  f.t(sum(counts[toupper(c.types)]), resultsDT[, sum((A!="")+(C!="")+(E!="")+(G!=""))],
      sum(counts[toupper(nc.types)]),resultsDT[, sum((B!="")+(D!="")+(F!="")+(H!=""))]) 
}

error.counts <- count.chars("X")
igu.counts <- count.chars("!")
unknown.counts <- count.chars("\\?")

sig.counts(error.counts)
sig.counts(igu.counts)
sig.counts(unknown.counts)

total.sig.counts(error.counts)$p.value
total.sig.counts(igu.counts)$p.value
total.sig.counts(unknown.counts)$p.value

unlist(q.src.charlist)[c.types]


# On which question do people give up?

#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


#######################################################
# Correctness by question order
#######################################################

# how many C/NC in each question position
gradeDT[order(qpos, confusing), .( COUNT = .N ),by=c('qpos', 'confusing')]

pos.scores <- gradeDT[, .(rate = mean(rate)),by=c('qpos','confusing')]
plot(pos.scores$qpos, pos.scores$rate)

#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$



#######################################################
# Timing per question
#######################################################

q.times <- gradeDT[order(qtype),.( time = mean(mins), confusing = max(confusing) ),by=qtype]


barchart(time~qtype,data=q.times,groups=confusing, main='Average minutes taken to answer each question')
         #scales=list(x=list(rot=90,cex=0.8)))

####
# Timing per correctness rate
###
plot(gradeDT[confusing==TRUE]$rate, gradeDT[confusing==TRUE]$mins, col=set2[1], main='Correctness vs Time for Cs', xlab='Correctness', ylab='Time')
plot(gradeDT[confusing==FALSE]$rate, gradeDT[confusing==FALSE]$mins, col=set2[2], main='Correctness vs Time for NCs', xlab='Correctness', ylab='Time')

# combine C and NC
plot(gradeDT$rate, gradeDT$mins, type='n', main='Correctness vs Time', xlab='Correctness', ylab='Time')
points(gradeDT[confusing==TRUE]$rate, gradeDT[confusing==TRUE]$mins, col=set2[1])
points(gradeDT[confusing==FALSE]$rate, gradeDT[confusing==FALSE]$mins, col=set2[2])

#$$$$$$$$$$$$$$$$$$$$$$$$$$$$$


#######################################################
# Correctness by program length
#######################################################

chars.rate <- gradeDT[,.(correctness=rate, chars=unlist(q.src.charlist[qtype]), confusing)]
boxplot(correctness~chars, data=chars.rate)

#paste(names(q.src.chars), q.src.chars, sep=": ") # get the names of each question/length
boxplot(correctness~chars, data=chars.rate[confusing==TRUE], xaxt='n', main='Correctness for C Questions', xlab="Question: number of chars in source")
axis(1, c("a: 318",'c: 356','g: 424','e: 580'), at=c(1,2,3,4))
boxplot(correctness~chars, data=chars.rate[confusing==FALSE], xaxt='n', main='Correctness for NC Questions', xlab="Question: number of chars in source")
axis(1, c("b: 356",'f: 641','d: 957','h: 1291'), at=c(1,2,3,4))


# boxplot to see the variance of individual results?
# log-scale the results to make them look linear?
# color C/NC differently
#$$$$$$$$$$$$$$$$$$$$$$$$$$$

#######################################################
# How far people got in the questions
#######################################################
library(vioplot)
vioplot(
  gradeDT[qtype=='a']$points,
  gradeDT[qtype=='b']$points,
  gradeDT[qtype=='c']$points,
  gradeDT[qtype=='d']$points,
  gradeDT[qtype=='e']$points,
  gradeDT[qtype=='f']$points,
  gradeDT[qtype=='g']$points,
  gradeDT[qtype=='h']$points
  ,col="#F2F2F2")
boxplot(points ~ qtype, gradeDT, main="How many points the subject attempted, by question")


#######################################################
# Why did some people do better on C questions
#######################################################

subj.rates <- gradeDT[, .(rate=mean(rate)), by=.(subject, confusing)]
subj.backwards <- # the subjects who did better on C questions
  (subj.rates[confusing==TRUE][subj.rates[confusing==TRUE]$rate > subj.rates[confusing==FALSE]$rate])$subject

# subjects who only tried one print statement
one.and.done <- gradeDT[points==1&confusing==FALSE]$subject

not.one.and.done <- setdiff(subj.backwards, one.and.done)

gradeDT[subject %in% not.one.and.done]

#######################################################
#              100% correct questions
#######################################################

gradeDT[rate == 1, .N, by=qtype][order(qtype)]
gradeDT[rate == 1, .N, by=confusing]

gradeDT[, mean(rate), by=qtype]
boxplot(rate ~ qtype, gradeDT[order(qtype), .(rate), by=qtype], main="Correctness by Question", xlab="Question", ylab="Correctness")
vioplot()

#######################################################
#             Cluster the subjects
#######################################################

library(cluster)

# results.mat <- matrix(ncol = length(q.types), nrow = nrow(resultsDT))
# colnames(results.mat) <- q.types
# rownames(results.mat) <- resultsDT$Subject
# inp.mtx <- as.matrix(gradeDT[,.(subject,qtype,as.numeric(rate))]) # http://stats.stackexchange.com/questions/6827/efficient-way-to-populate-matrix-in-r
# results.mat[inp.mtx[,1:2] ]<- inp.mtx[,3]
# results.mat <- matrix(data = as.numeric(results.mat), ncol = length(q.types), nrow = nrow(resultsDT))
# 
# # https://rstudio-pubs-static.s3.amazonaws.com/33876_1d7794d9a86647ca90c4f182df93f0e8.html
# D=daisy(results.mat, metric='gower') # Declare binary data
# H.fit <- hclust(D, method="ward.D2")
# plot(H.fit, main="Hierarchical clusters of users")
# rect.hclust(H.user.fit, k=2, border="red")
# user.groups <- cutree(H.user.fit, k=2)


D=daisy(subject.points[order(subject),.(subject, rate)], metric="gower")
H.fit <- hclust(D, method="ward.D2")
plot(H.fit, main="Hierarchical clusters of users")
rect.hclust(H.fit, k=2, border="red")
user.groups <- cutree(H.fit, k=2)

library("ks")
hist(subject.points$rate, freq = F)
lines(density(subject.points$rate))
segments(mean(subject.points$rate),0,mean(subject.points$rate),2.5, lwd=2, col="red") # visualize partitioning the subjects at the mean

library(stringr)
subject.points[, ability := ifelse(rate > mean(rate), "high", "low")] # partition the subjects at the mean
subject.points$ability <- as.factor(subject.points$ability)
demographicDT <- data.table(read.csv("csv/confidential_demographics.csv", header = TRUE))
subjectDT <- merge(subject.points, demographicDT, by.x='subject', by.y='Subject')
subjectDT[,n.lang:=1+str_count(Languages, ","),]

# img <- image(kde2d(subjectDT[!is.na(Age)]$Age, subjectDT[!is.na(Age)]$rate, n=200, lims=c(15,45, 0,1), h=c(10, .3)), col=rf(32))
# points(subjectDT[!is.na(Age)]$Age, subjectDT[!is.na(Age)]$rate)


par(mfrow=c(2,7))

plot(rate ~ ProgrammingYears, data=subjectDT)
plot(rate ~ CYears, data=subjectDT)
boxplot(rate ~ Gender, data=subjectDT)
boxplot(rate ~ Degree, data=subjectDT)
boxplot(rate ~ SelfEval, data=subjectDT)
boxplot(rate ~ n.lang, data=subjectDT)
boxplot(rate ~ round(Age/5), data=subjectDT)


plot(ability ~ ProgrammingYears, data=subjectDT)
plot(ability ~ CYears, data=subjectDT)
plot(ability ~ Gender, data=subjectDT)
plot(ability ~ Degree, data=subjectDT)
plot(ability ~ SelfEval, data=subjectDT)
plot(ability ~ n.lang, data=subjectDT)
plot(ability ~ Age, data=subjectDT)


