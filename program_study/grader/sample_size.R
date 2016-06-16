library("data.table")
library("samplesize")

pilot.results <- data.table(read.csv("csv/pilot_results.csv", header = TRUE))
pilot.results$confusing <- pilot.results$qtype %in% c('a','c','e','g')

scores <- function(char) pilot.results[qtype == char, correct/points]

length(scores('a'))

var.test(scores('a'), scores('b'))

pairs <- c(c('a', 'b'), c('c', 'd'), c('e', 'f'), c('g', 'h'))

pair.test <- function(a, b) {
  as <- scores(a)
  bs <- scores(b)
  
  wt <- wilcox.test(as, bs)

  wss <- n.wilcox.ord(power = 0.8, alpha = 0.05, t = 0.5, p = c(mean(as), 1 - mean(as)), q = c(mean(bs), 1 - mean(bs)))
  
  list("p.value" = wt$p.value, "ss" = wss$`total sample size`)
}

apply(pair.test, pairs)

pair.test('a', 'b')
pair.test('c', 'd')
pair.test('e', 'f')
pair.test('g', 'h')
