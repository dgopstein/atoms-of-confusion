library("data.table")
library("samplesize")
library(lsr)

pilot.results <- data.table(read.csv("csv/pilot_results.csv", header = TRUE))
pilot.results <- pilot.results[subject != 1161]
pilot.results$confusing <- pilot.results$qtype %in% c('a','c','e','g')

scores.summed <- pilot.results[,.(rate=sum(correct)/sum(points)),by=c("subject", "confusing")]
c.sum <- scores.summed[confusing == TRUE, rate]
nc.sum <- scores.summed[confusing == FALSE, rate]

scores.summed.subject <- scores.summed[,sum(rate)/2,by="subject"]

plot(c.sum, nc.sum, xlim=c(.3,1), ylim=c(.3,1))
abline(0,1)

# sum.tt <- t.test(c.sum, nc.sum)
# sum.tss <- n.ttest(power = 0.8, alpha = 0.05, mean.diff = mean(c.sum) - mean(nc.sum), sd1 = sd(c.sum), sd2 = sd(nc.sum))
# sum.wt <- wilcox.test


scores <- function(char) pilot.results[qtype == char, correct/points]

cs <- c('a', 'c', 'e', 'g')
ncs <- c('b', 'd', 'f', 'h')

w.vs.t <- function (as, bs, name = "") {
  wt <- wilcox.test(as, bs, conf.int = TRUE)
  
  wss <- n.wilcox.ord(power = 0.8, alpha = 0.05, t = 0.5, p = c(mean(as), 1 - mean(as)), q = c(mean(bs), 1 - mean(bs)))
  
  tt <- t.test(as, bs)
  tss <- n.ttest(power = 0.8, alpha = 0.05, mean.diff = mean(as) - mean(bs), sd1 = sd(as), sd2 = sd(bs))
  cohens.d <- cohensD(as,bs)
  
  #list("pair" =name, "t.p.value" = tt$p.value, "t.ss" = tss$`Total sample size`, "wilcox.p.value" = wt$p.value, "wilcox.ss" = wss$`total sample size`)
  res <- c(name, tt$p.value, tss$`Total sample size`, cohens.d, wt$p.value, wss$`total sample size`, wt$estimate)
  names(res) <- c("pair", "t.p.value", "t.ss", "cohens.d", "wilcox.p.value", "wilcox.ss", "wilcox.estimate")
  
  res
}

pair.test <- function(a, b) {
  as <- scores(a)
  bs <- scores(b)
  
  w.vs.t(as, bs, name =  paste(a, b, sep=""))
}

pair.data <- t(mapply(pair.test, cs, ncs))

print(pair.data)
print(w.vs.t(c.sum, nc.sum))

hist(c.sum, breaks = 10)
hist(nc.sum, breaks = 10)

qqnorm(c.sum)
qqnorm(nc.sum)

t.test(c.sum, nc.sum)
