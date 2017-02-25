# Program Study

library("data.table")
library(Hmisc)
library(xtable)

##### Histogram includes
library(MASS)
library(RColorBrewer)
rf <- colorRampPalette(rev(brewer.pal(11,'Spectral')))
set2 <- colorRampPalette(brewer.pal(8,'Set2'))(8)
set3 <- colorRampPalette(brewer.pal(12,'Set3'))(12)
set33 <- brewer.pal(3,'Set3');
set33.ramp <- colorRampPalette(set3)(12)
library(grDevices)
#$$$$
library(lattice)
library(testit)
library(tidyr)
library(assertthat)
library(lsr)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))
source("TatsukiRcodeTplot.R") # http://biostat.mc.vanderbilt.edu/wiki/Main/TatsukiRcode#tplot_40_41


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

pilot.ids <- c(1161, 1224, 3270, 3782, 3881, 4747, 5125, 6033, 6224, 6490, 7400, 9351)

f.t <- function(a, a_total, b, b_total) fisher.test(rbind(c(a,a_total-a), c(b,b_total-b)), alternative="greater")

resultsDT <- data.table(read.csv("csv/results.csv", header = TRUE))

assert_that(!any(resultsDT$Subject %in% pilot.ids)) # "There are no pilot ID's in the results")


resultsDT.flat <- resultsDT[, .(q=q.cols, Order, output=sapply(q.cols, function(chr) as.character(get(chr)))) , by=Subject]
resultsDT.flat <- resultsDT.flat[nchar(output) > 0]
resultsDT.flat$pos <- apply(resultsDT.flat, 1, function(x) {regexpr(tolower(x[['q']]), x[['Order']])[1]})
resultsDT.flat$gave.up <- resultsDT.flat[, grepl('!',output)]
resultsDT.flat[, confusing:=tolower(q)%in%c.types]

# Give-ups by position
resultsDT.flat[gave.up==TRUE, .("IGUs" = sum(gave.up)), by=pos][order(pos)]


# ./fault_rates.rb csv/results.csv > csv/fault_rates.csv
faultDT <- data.table(read.csv("csv/fault_rates.csv", header = TRUE))
faultDT$c_checks <- mapply(max, 1, faultDT$c_checks)
faultDT$c_fault_rate  <- faultDT$c_faults / faultDT$c_checks
faultDT$nc_fault_rate <- faultDT$nc_faults/faultDT$nc_checks
#faultDT[, confusing:=question%in%c.types]

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

# participants who did better on C than NC
better.on.c <- scores.summed.subject[c.sum > nc.sum]$subject
resultsDT[resultsDT$Subject %in% better.on.c]$Order
mean(scores.summed[confusing == TRUE & subject %in% better.on.c]$rate - scores.summed[confusing == FALSE & subject %in% better.on.c]$rate)
mean(scores.summed[confusing == TRUE & !(subject %in% better.on.c)]$rate - scores.summed[confusing == FALSE & !(subject %in% better.on.c)]$rate)


# Heatmap: http://www.r-bloggers.com/5-ways-to-do-2d-histograms-in-r/
# Overlay image: http://stackoverflow.com/questions/12918367/in-r-how-to-plot-with-a-png-as-background

pdf("img/program_subject_performance_c_vs_nc_questions.pdf", width = 5, height = 5.5)
# k <- kde2d(c.sum, nc.sum, n=200, lims=c(0,1, 0,1), h=.3)
# img <- image(k, col=rf(32))
# grid()
plot(c.sum, nc.sum, xlim=c(0,1), ylim=c(0,1), xlab="", ylab="")
title(main="Subject performance on\nObfuscated vs Transformed programs", xlab = "Obfuscated correct rate", ylab = "Transformed correct rate")
points(c.sum, nc.sum, pch=16, bg="black", col=rgb(.2,.2,.2,.8))#'#404040F0')
abline(0,1,lty=3)
dev.off()

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

q.es <- function(a, b) {
  c.sum <- gradeDT[qtype==a]$rate
  nc.sum <- gradeDT[qtype==b]$rate
  
  cohensD(c.sum, nc.sum)
}

a.v.b <- q.p.value('a', 'b')$p.value
c.v.d <- q.p.value('c', 'd')$p.value
e.v.f <- q.p.value('e', 'f')$p.value
g.v.h <- q.p.value('g', 'h')$p.value

a.b.es <- q.es('a', 'b')
c.d.es <- q.es('c', 'd')
e.f.es <- q.es('e', 'f')
g.h.es <- q.es('g', 'h')

# Correctness of each question pair
gradeDT[order(qtype), mean(rate), by=qtype]

# Correctness of all C vs all NC
all.correctness <- gradeDT[, .(correctness = mean(rate)), by=confusing]
all.difference <- (all.correctness[confusing==TRUE]-all.correctness[confusing==FALSE])$correctness

# p-value for all C vs all NC
all.q.p.value <- t.test(gradeDT[confusing==TRUE]$rate, gradeDT[confusing==FALSE]$rate, alternative="less")$p.value
all.q.effect.size <- cohensD(gradeDT[confusing==TRUE]$rate, gradeDT[confusing==FALSE]$rate)

q.rate <- gradeDT[order(qtype),.( correctness = mean(rate), confusing = max(confusing) ), by=qtype]
q.rate <- rbind(q.rate, list("all C", all.correctness[confusing==TRUE]$correctness, 1))
q.rate <- rbind(q.rate, list("all NC", all.correctness[confusing==FALSE]$correctness, 0))
#colnames(q.rate) <- null
#q.rate$qtype <- c("", "", "", "", "", "", "", "", "", "")

q.correctness.labels <- paste0(c("All\n", "Q1\n", "Q2\n", "Q3\n", "Q4\n"),
                               sapply(c(all.q.p.value, a.v.b, c.v.d, e.v.f, g.v.h),
                                      function(x) ifelse(x >= 0.0001, sprintf("p: %0.4f\n", x), sprintf("p: %0.2e\n", x))),
                               sapply(c(all.q.effect.size, a.b.es, c.d.es, e.f.es, g.h.es),
                                      function(x) ifelse(x >= 0.0001, sprintf("d: %0.4f", x), sprintf("d: %0.2e", x)))
                               )


add.alpha <- function(col, alpha=1){
  if(missing(col))
    stop("Please provide a vector of colours.")
  apply(sapply(col, col2rgb)/255, 2, 
        function(x) 
          rgb(x[1], x[2], x[3], alpha=alpha))  
}
#https://cran.r-project.org/web/packages/lattice/lattice.pdf
bar.colors <- rev(sapply(set33[c(3,2)], function(x) add.alpha(x, alpha=0.8)))

graph.gradeDT <- as.data.table(gradeDT)
graph.gradeDT[, qtype := ifelse(confusing==TRUE, 'all.C', 'all.NC')]
graph.gradeDT <- rbind(graph.gradeDT, gradeDT)

pdf("img/program_average_score_per_question.pdf", width = 6, height = 5.5)
par(mar=c(4.1,4.1,2.1,2.1), xpd=TRUE)
tplot(rate~qtype,data=graph.gradeDT,
      las=2, xaxt="n",
      bty='U', pch=20, dist=.01, jit=.07, type='db',
      col=rgb(0,0,0,alpha=0.4),
      boxcol=bar.colors, boxborder=grey(0), cex=0.85,
      boxplot.pars=list(medlwd=5, boxwex=1.2),
      at=c(0.9,1.7, 3.1,3.9, 5.1,5.9, 7.1,7.9, 9.1, 9.8)
      )
segments(2.4,-0.13,2.4,1.03)
legend(4.5, 1.18, c('Obfuscated','Clarified  '), col=bar.colors, fill=bar.colors, pt.cex=2, horiz=TRUE, bty="n", adj=1.4)
mtext("Correctness", side=2, line=2.8, cex=1.4)
axis(1, at=0.5+c(0.8,3,5,7,9), labels = q.correctness.labels, tick = FALSE, line = 1.0)#, cex.axis=1.6)
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

igu.c.count <- sum(igu.counts[toupper(c.types)])
igu.nc.count <- sum(igu.counts[toupper(nc.types)])

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

demographicDT$Languages <- as.character(demographicDT$Languages)
demographicDT$DailyLang <- as.character(demographicDT$DailyLang)
demographicDT$FavoriteLang <- as.character(demographicDT$FavoriteLang)

demographicDT$language.list <- sapply(demographicDT[, Languages], function(x) sapply(strsplit(x,", "), tolower))
demographicDT$daily.lang.list <- sapply(demographicDT[, DailyLang], function(x) sapply(strsplit(x,", "), tolower))
demographicDT$fav.lang.list <- sapply(demographicDT[, FavoriteLang], function(x) sapply(strsplit(x,", "), tolower))

subjectDT <- merge(subject.points, demographicDT, by.x='subject', by.y='Subject')
subjectDT[,n.lang:=1+str_count(Languages, ","),]

# img <- image(kde2d(subjectDT[!is.na(Age)]$Age, subjectDT[!is.na(Age)]$rate, n=200, lims=c(15,45, 0,1), h=c(10, .3)), col=rf(32))
# points(subjectDT[!is.na(Age)]$Age, subjectDT[!is.na(Age)]$rate)


#par(mfrow=c(3,3))
#par(mfrow=c(1,1))

plot(rate ~ ProgrammingYears, data=subjectDT)
plot(rate ~ CYears, data=subjectDT)
boxplot(rate ~ Gender, data=subjectDT)
boxplot(rate ~ Degree, data=subjectDT, main="Program Study\nCorrectness vs Education", xlab="Working/Completed Degree", xaxt='n'); axis(side=1, at=1:3, labels=c("bachelors", "masters", "phd"))
boxplot(rate ~ SelfEval, data=subjectDT[SelfEval < 6], main="Program Study\nCorrectness vs Self-Evaluation")
boxplot(rate ~ n.lang, data=subjectDT)
boxplot(rate ~ Age, data=subjectDT)
boxplot(rate ~ round(Age/7), data=subjectDT)


plot(ability ~ ProgrammingYears, data=subjectDT)
plot(ability ~ CYears, data=subjectDT)
plot(ability ~ Gender, data=subjectDT)
plot(ability ~ Degree, data=subjectDT)
plot(ability ~ SelfEval, data=subjectDT)
plot(ability ~ n.lang, data=subjectDT)
plot(ability ~ Age, data=subjectDT)


# Plot years experience vs correctness
dev.off()
boxplot(rate ~ SelfEval, data=subjectDT)


# Plot years experience vs correctness
dev.off()
# filteredSubjectDT<-subjectDT[!is.na(CYears) & CYears != 25,][order(CYears)] # Outlier?
filteredSubjectDT<-subjectDT[!is.na(CYears),][order(CYears)]
y<-filteredSubjectDT$rate
x<-filteredSubjectDT$CYears
plot(y ~ x, main="Impact Study\nC Experience vs. Performance", xlab="Years of C experience", ylab="Correct Rate")
#m<-nls(y~a*x/(x+b), start=list(a=1,b=1))
m<-nls(y~a*x^b, start=list(a=20,b=.2))
#m<-nls(y~a*x^2+b*x, start=list(a=1,b=2))
lines(seq(1,30,0.2),predict(m, list(x=seq(1,30,0.2))),lty=2,col="red",lwd=3)
cor(y,predict(m))
aq<-aq.plot(cbind(y, predict(m)))
plot(y ~ x, col=as.factor(aq$outliers))

library(MVN)
library(mvoutlier)
mvOutlier(subjectDT[,.(CYears, rate)])
filteredSubjectDT[c(32,42)]
aq.plot(subjectDT[,.(CYears, rate)], alpha=0.0000000969)

#######################################################
#             Combined bar chart
#######################################################

require(ggplot2); require(gridExtra); require(grid)

resultsDT.flat[!gave.up&nchar(output)==1&output!="X", .(q, output, confusing)]




library(gridExtra)

give.ups <- gradeDT[, .(val=as.integer(gave.up)/1), by=confusing]
label.faults <- melt(faultDT, measure.vars=c('c_fault_rate', 'nc_fault_rate'))[,.(val=value, confusing=variable=='c_fault_rate')]
points.answered <- gradeDT[(!gave.up), .(val=points/.N), by=confusing]
totally.correct <- gradeDT[, .(val=as.integer(rate==1)/1), by=confusing]

pvc <- function(dt, alt) sprintf("%0.4f", t.test(val ~ confusing, data=dt, alternative=alt)$p.value)
mean.dt <- function(dt, name, alt) dt[,.(val=mean(val), label=paste(name, "\np=", pvc(dt, alt), sep="")), by=confusing]
give.ups.mean     <-    mean.dt(give.ups, "\nGive Ups", "less")
label.faults.mean <-    mean.dt(label.faults, "Control Flow\nErrors", "less")
points.answered.mean <- mean.dt(points.answered, "Points\nAnswered", "greater")
totally.correct.mean <- mean.dt(totally.correct, "Totally\nCorrect", "greater")

combined.bar.data.bad <- rbind(give.ups.mean, label.faults.mean)
combined.bar.data.good <- rbind(points.answered.mean, totally.correct.mean)  

plot.bad  <- barchart(val ~ label, data=combined.bar.data.bad,  groups=rev(confusing), main="Failures",  ylab="Rate", col=set33[c(2,3)])
plot.good <- barchart(val ~ label, data=combined.bar.data.good, groups=rev(confusing), main="Successes", ylab="Rate", col=set33[c(2,3)])


plot.bad
plot.good

pdf("img/program_study_good_bad.pdf", width = 6, height = 5)
lgnd <- legend(1, 2, legend=c("a", "b"), fill=attr(set33, "palette"), cex=0.6, bty="n")
grid.arrange(plot.bad, plot.good, ncol=2, heights=c(10, 1))
dev.off()



t.test(rate ~ Gender, subjectDT) # Gender is not statistical correlated with performance
cor.test(subjectDT$SelfEval, subjectDT$rate, method="spearman") # SelfEval is statistically significantly correlated with performance
summary(subjectDT$Languages)
subjectDT[,.(rate, unlist(language.list))]

unnest(subjectDT, language.list)
unstack(subjectDT, rate~language.list)

# Known languages as a predictor of performance
language.rates <- subjectDT[,.(language = unlist(language.list)), by=rate]
language.rates.agg <- language.rates[, .(n = .N, rate = mean(rate), sd = sd(rate)), by=language]
language.rates <- merge(language.rates, language.rates.agg, by="language", suffixes = c("", ".mean"))
multi.language.rates <- language.rates[n > 1]
multi.language.rates$language <- factor(multi.language.rates$language, language.rates.agg[n>1][order(rate)]$language) # order the languages by correctness
boxplot(rate ~ language, multi.language.rates,  las=2, mar=c(8, 4, 20, 2), main="Average Correctness by known language")

# Daily languages as a predictor of performance
daily.lang.rates <- subjectDT[,.(language = unlist(daily.lang.list)), by=rate]
daily.lang.rates.agg <- daily.lang.rates[, .(n = .N, rate = mean(rate), sd = sd(rate)), by=language]
daily.lang.rates <- merge(daily.lang.rates, daily.lang.rates.agg, by="language", suffixes = c("", ".mean"))
multi.daily.lang.rates <- daily.lang.rates[n > 1]
multi.daily.lang.rates$language <- factor(multi.daily.lang.rates$language, multi.daily.lang.rates[,.(med=median(rate)), by=language][order(med)]$language) # order the languages by correctness
boxplot2(rate ~ language, multi.daily.lang.rates,  las=2, medlwd=2, medcol="#444444" , main="Program Study\nAverage Correctness\nby daily language")

pdf("img/program_correctness_by_daily_language.pdf", width = 3.8, height = 4.5)
par(mar=c(5,4,7,1))
tplot(rate ~ language, multi.daily.lang.rates,  las=2, medlwd=2, medcol="#444444",
      show.n = TRUE, bty='U', pch=20, dist=.5, jit=.03, type='db')
title("Impact Experiment\nCorrectness by Daily Language", line = 3)
dev.off()


#points(1:nrow(daily.lang.rates.agg[n>1]), daily.lang.rates.agg[n>1][order(rate)]$rate, pch=16)
# library(vioplot)
# vioplot(multi.daily.lang.rates[language=="javascript"]$rate, multi.daily.lang.rates[language=="python"]$rate,
#         multi.daily.lang.rates[language=="java"]$rate, multi.daily.lang.rates[language=="c#"]$rate,
#         multi.daily.lang.rates[language=="c++"]$rate, multi.daily.lang.rates[language=="c"]$rate, names = daily.lang.rates.agg[n>1]$language)
# multi.daily.lang.rates[, .(n = .N, rate = median(rate), sd = sd(rate)), by=language]

# Favorite languages as a predictor of performance
fav.lang.rates <- subjectDT[,.(language = unlist(fav.lang.list)), by=rate]
fav.lang.rates.agg <- fav.lang.rates[, .(n = .N, rate = mean(rate), sd = sd(rate)), by=language]
fav.lang.rates <- merge(fav.lang.rates, fav.lang.rates.agg, by="language", suffixes = c("", ".mean"))
multi.fav.lang.rates <- fav.lang.rates[n > 1]
multi.fav.lang.rates$language <- factor(multi.fav.lang.rates$language, fav.lang.rates.agg[n>1][order(rate)]$language) # order the languages by correctness
boxplot(rate ~ language, multi.fav.lang.rates,  las=2, medlwd=2, medcol="#444444" , main="Average Correctness\nby favorite language")
points(1:nrow(fav.lang.rates.agg[n>1]), fav.lang.rates.agg[n>1][order(rate)]$rate, pch=16)

# Major as a predictor of performance
major.rates <- subjectDT[, .(major = Major, rate)]
major.rates.agg <- subjectDT[, .(major=Major, rate=mean(rate), n=.N), by=Major]
major.rates <- merge(major.rates, major.rates.agg, by="major", suffixes = c("", ".mean"))
multi.major.rates <- major.rates[n > 1]
multi.major.rates$major <- factor(multi.major.rates$major, major.rates.agg[n>1][order(rate)]$major) # order the languages by correctness
boxplot(rate ~ major, multi.major.rates, las=2, medlwd=2, medcol="#444444", main="Correctness\nby Major", names=paste(major.rates.agg[n>1][order(rate)]$major, " [", major.rates.agg[n>1][order(rate)]$n, "]", sep=''))
points(1:nrow(major.rates.agg[n>1]), major.rates.agg[n>1][order(rate)]$rate, pch=16)

# Duration as a predictor of correctness
subjectDT <- merge(subjectDT, gradeDT[, .(duration = sum(mins)), by=subject], by="subject")
subjectDT[order(duration), .(subject, duration, rate)]
plot(rate ~ duration, subjectDT) # no correlation

# Education as a predictor of correctness
plot(rate ~ Degree, subjectDT)
subjectDT$Degree

# library(plot3D)
# library(rgl)
# library(scatterplot3d)
# library(car)
# scatter3d(x=subjectDT$SelfEval,y=subjectDT$ProgrammingYears,z=subjectDT$rate, colkey=F)

# Encode known languages with the factor levels of every language mentioned in the results
# https://stackoverflow.com/questions/41670305/indicator-matrix-for-non-exclusive-factors
known.lang.factor <- factor(sort(unique(unlist(subjectDT$language.list))))
subjectDT$language.list.factor <- sapply(subjectDT$language.list, function(x) { factor(x, levels=known.lang.factor) })
known.lang.indicator.matrix <- t(sapply(subjectDT$language.list.factor, table))
known.lang.counts <- colSums(known.lang.indicator.matrix)


# Multiple Linear Regression - Known Languages as predictor of score
m <- lm(subjectDT$rate ~ known.lang.indicator.matrix)
known.coeffs <- data.table(name = names(m$coefficients), coeffs = m$coefficients, counts = c(nrow(subjectDT), known.lang.counts))
known.coeffs[2:nrow(known.coeffs),  lang := substr(name, nchar("known.lang.indicator.matrix."), 100)]
known.coeffs[, display := c("(Intercept)", paste(tail(lang, -1), "  ", format(known.lang.counts, digits=2), sep=''))]

par.orig<-par(mar=c(4,8,4,1));
#barplot(known.coeffs[!is.na(coeffs)&counts>1][order(coeffs)]$coeffs, names.arg=known.coeffs[!is.na(coeffs)&counts>1][order(coeffs)]$display, horiz=TRUE, las=2, main="Predictive power of language            \n to program study performance            ");
barplot(known.coeffs[!is.na(coeffs)&counts>5][order(coeffs)]$coeffs, names.arg=known.coeffs[!is.na(coeffs)&counts>5][order(coeffs)]$display, horiz=TRUE, las=2, main="Predictive power of language (n>5)                 \n to program study performance            ");
par(par.orig)

# Daily Languages as predictor of score including experience as confounder
daily.lang.levels <- factor(sort(unique(unlist(subjectDT$daily.lang.list))))
subjectDT$daily.lang.factor <- sapply(subjectDT$daily.lang.list, function(x) { factor(x, levels=daily.lang.levels) })
daily.lang.indicators <- t(sapply(subjectDT$daily.lang.factor, table))
raw.exp.lang.predictors <- cbind(c.years = subjectDT$CYears, daily.lang.indicators)
daily.lang.indicators <- t(scale(t(daily.lang.indicators))) # Scale each subject (so adding more languages doesn't increase the mean)
exp.lang.predictors <- cbind(c.years = scale(subjectDT$CYears), daily.lang.indicators) # Scale C months to have same mean/sd as languages
colnames(exp.lang.predictors)[1] <- "c.years"
daily.lang.counts <- colSums(raw.exp.lang.predictors)


m <- lm(subjectDT$rate ~ exp.lang.predictors)
daily.coeffs <- data.table(name = names(m$coefficients), coeffs = m$coefficients, counts = c(nrow(subjectDT), daily.lang.counts))
daily.coeffs[2:nrow(daily.coeffs),  lang := substr(name, nchar("exp.lang.predictors."), 100)]
daily.coeffs[, display := c("(Intercept)", paste(tail(lang, -1), "  ", format(daily.lang.counts, digits=2), sep=''))]
daily.coeffs <- tail(daily.coeffs, -1) # drop the intercept
dev.off()
par.orig<-par(mar=c(4,8,4,1));
barplot(daily.coeffs[!is.na(coeffs)&counts>1][order(coeffs)]$coeffs, names.arg=daily.coeffs[!is.na(coeffs)&counts>1][order(coeffs)]$display, horiz=TRUE, las=2)
mtext("Predictive power of daily language\n to program study performance\nwith experience",side = 3, at = c(-0.15,4), line = -0) 
par(par.orig)

# Compare python vs java from snippet to program studies
# pri.lan.rates is from snippet_study/results.R
java.py <- rbind(
  daily.lang.rates[language %in% c("java", "python"), .(study = "prog", lang=language, rate)],
  pri.lang.rates[language %in% c("java", "python"), .(study = "snip", lang=language, rate)])

m <- lm(rate ~ study + lang, java.py)
#m <- lm(rate ~ lang, java.py[study == "snip"])
summary(m)


pdf("img/program_correctness_vs_selfeval.pdf", width = 3, height = 3.5)
par(mar=c(4,4,6,1))
tplot(rate ~ SelfEval, data=subjectDT, las=2, xaxt='n',
      show.n = TRUE, bty='U', pch=20, dist=.01, jit=.2, type='db',
      boxcol=grey(1), boxborder=grey(.6), boxplot.pars=list(medlwd=2), cex=0.85)
axis(1:6, at=1:6)
title("Program Study\nCorrectness vs Self-Evaluation", line = -3, outer=TRUE)
title(x=" (novice)               (expert)", line = 2.1)
title(y="Correctness Rate", line = 2.7)
dev.off()


############################################################################
#     Performance over time (first question through last )
############################################################################

plot(rate ~ mins, gradeDT)
plot(mins ~ qtype, gradeDT)

plot(density(gradeDT[confusing==0]$mins, adj=1), col="blue")
lines(density(gradeDT[confusing==1]$mins, adj=1), col="red")

# There's no obvious learning effect
gradeDT[, .(correctness=mean(rate)), by=qpos]
plot(rate ~ qpos, gradeDT)

# The variance increases significantly for the 3rd question
# which appears to be bimodal, but not the 4th
tplot(rate ~ qpos, gradeDT,  las=2, medlwd=2, medcol="#444444",
      show.n = TRUE, bty='U', pch=20, dist=.03, jit=.03, type='db')
gradeDT[, var(rate), by=qpos]

# Questions are answered more correctly when people spend more time on them
gradeDT$normed.rate <- gradeDT$rate - ave(gradeDT$rate, gradeDT$subject)
plot(normed.rate ~ mins, gradeDT[gave.up==FALSE], main="Response Duration vs Relative Correctness of Questions", xlab="Response Duration in Minutes", ylab="Relative Correctness Rate")
fit <- lm(normed.rate ~ mins, gradeDT[gave.up==FALSE])
abline(fit)
cor(gradeDT[gave.up==FALSE]$normed.rate, predict(fit))

# Subjects do better on questions when they spend longer on their answer (give-ups omitted)
#subjectDT$mins 
plot(rate ~ mins, subjectDT)
fit <- lm(rate ~ mins, subjectDT[mins < 120])
abline(fit)
cor(subjectDT[mins < 120]$rate, predict(fit))


# An exponential fit is actually less correlated then linear
# y <- 1+gradeDT[order(mins)]$normed.rate
# x <- gradeDT[order(mins)]$mins
# m <- nls(y ~ a*x^b)#=list(a=1,b=1))
# plot(x, y)
# lines(x,predict(m),lty=2,col="red",lwd=3)




