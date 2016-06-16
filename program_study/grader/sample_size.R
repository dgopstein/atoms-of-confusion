library("data.table")
library("samplesize")

pilot.results <- data.table(read.csv("csv/pilot_results.csv", header = TRUE))
pilot.results$confusing <- pilot.results$qtype %in% c('a','c','e','g')

scores <- function(char) pilot.results[qtype == char, correct/points]

length(scores('a'))

var.test(scores('a'), scores('b'))

cs <- c('a', 'c', 'e', 'g')
ncs <- c('b', 'd', 'f', 'h')

pair.test <- function(a, b) {
  as <- scores(a)
  bs <- scores(b)
  
  wt <- wilcox.test(as, bs)

  wss <- n.wilcox.ord(power = 0.8, alpha = 0.05, t = 0.5, p = c(mean(as), 1 - mean(as)), q = c(mean(bs), 1 - mean(bs)))
  
  tt <- t.test(as, bs)
  tss <- n.ttest(power = 0.8, alpha = 0.05, mean(as) - mean(bs), sd1 = sd(as), sd2 = sd(bs))
  
  list("pair" = paste(a, b, sep=""), "t.p.value" = tt$p.value, "t.ss" = tss$`Total sample size`, "wilcox.p.value" = wt$p.value, "wilcox.ss" = wss$`total sample size`)
}

pair.data <- t(mapply(pair.test, cs, ncs))
pair.data

