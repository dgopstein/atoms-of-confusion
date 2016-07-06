library("data.table")
library("samplesize")
library(lsr)

# ./grade_csv.rb csv/pilot_results.csv > csv/pilot_grades.csv
pilot.results <- data.table(read.csv("csv/pilot_grades.csv", header = TRUE))
pilot.results <- pilot.results[subject != 1161]
pilot.results$confusing <- pilot.results$qtype %in% c('a','c','e','g')

scores.summed <- pilot.results[,.(rate=sum(correct)/sum(points)),by=c("subject", "confusing")]
c.sum <- scores.summed[confusing == TRUE, rate]
nc.sum <- scores.summed[confusing == FALSE, rate]

scores.summed.subject <- scores.summed[,sum(rate)/2,by="subject"]

plot(c.sum, nc.sum, xlim=c(.3,1), ylim=c(.3,1))
abline(lm(nc.sum ~ c.sum))
abline(0,1)

# sum.tt <- t.test(c.sum, nc.sum)
# sum.tss <- n.ttest(power = 0.8, alpha = 0.05, mean.diff = mean(c.sum) - mean(nc.sum), sd1 = sd(c.sum), sd2 = sd(nc.sum))
# sum.wt <- wilcox.test

cs <- c('a', 'c', 'e', 'g')
ncs <- c('b', 'd', 'f', 'h')

w.vs.t <- function (acounts, bcounts, name = "") {
  as = acounts$correct / acounts$points
  bs = bcounts$correct / bcounts$points
  
  # Wilcoxon
  wt <- wilcox.test(as, bs, conf.int = TRUE)
  wss <- n.wilcox.ord(power = 0.8, alpha = 0.05, t = 0.5, p = c(mean(as), 1 - mean(as)), q = c(mean(bs), 1 - mean(bs)))
  
  # T.test
  tt <- t.test(as, bs)
  tss <- n.ttest(power = 0.8, alpha = 0.05, mean.diff = mean(as) - mean(bs), sd1 = sd(as), sd2 = sd(bs))
  cohens.d <- cohensD(as,bs)
  
  # Chi-Sq
  # Chi-Sq is invalid because the data are independent
  # cnt.table <- cbind(c = colSums(acounts), nc = colSums(bcounts))
  # x2 <- chisq.test(cnt.table)

  # Results
  res <- c(name, tt$p.value, tss$`Total sample size`, cohens.d, wt$p.value, wss$`total sample size`, wt$estimate)
  names(res) <- c("pair", "t.p.value", "t.ss", "cohens.d", "wilcox.p.value", "wilcox.ss", "wilcox.estimate")
  res
}


pair.test <- function(a, b) {
  as <- pilot.results[qtype == a, .(correct, points)]
  bs <- pilot.results[qtype == b, .(correct, points)]
  
  w.vs.t(as, bs, name =  paste(a, b, sep=""))
}

# Overall Sample Size
n.ttest(power = 0.8, alpha = 0.05, mean.diff = mean(c.sum) - mean(nc.sum), sd1 = sd(c.sum), sd2 = sd(nc.sum))

# Question Sample Size
q.ss <- function(a, b) {
    c.sum <- pilot.results[,correct/points,by=qtype][qtype==a]$V1
    nc.sum <- pilot.results[,correct/points,by=qtype][qtype==b]$V1
    
    n.ttest(power = 0.8, alpha = 0.05, mean.diff = mean(c.sum) - mean(nc.sum), sd1 = sd(c.sum), sd2 = sd(nc.sum))
}

q.ss('a', 'b')[1]
q.ss('c', 'd')[1]
q.ss('e', 'f')[1]
q.ss('g', 'h')[1]

#pair.data <- t(mapply(pair.test, cs, ncs))

#print(pair.data)
#print(w.vs.t(c.sum, nc.sum))

# hist(c.sum, breaks = 10)
# hist(nc.sum, breaks = 10)
# 
# qqnorm(c.sum)
# qqnorm(nc.sum)
# 
# t.test(c.sum, nc.sum)

# diff.table <- t(cbind(cnt.table[1,], cnt.table[2,] - cnt.table[1,]))
# 
# chisq.test(cnt.table)
# chisq.test(diff.table)
