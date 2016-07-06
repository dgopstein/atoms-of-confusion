library("data.table")

results <- data.table(read.csv("csv/fault_rates.csv", header = TRUE))

results$c_checks <- mapply(max, 1, results$c_checks)

results$c_fault_rate  <- results$c_faults / results$c_checks
results$nc_fault_rate <- results$nc_faults/results$nc_checks

outliers <- function(data, level = "mild") {
  lowerq = quantile(data)[2]
  upperq = quantile(data)[4]
  iqr = upperq - lowerq
  
  multiplier <- if (level == "mild") 1.5 else 3
  
  threshold.upper = (iqr * multiplier) + upperq
  threshold.lower = lowerq - (iqr * multiplier)
  
  #data[data < threshold.lower | data > threshold.upper]
  threshold.upper
}

# http://stats.stackexchange.com/questions/113602/test-if-two-binomial-distributions-are-statistically-different-from-each-other
f.t <- function(a, a_total, b, b_total) fisher.test(rbind(c(a,a_total-a), c(b,b_total-b)), alternative="greater")
f.t.res <- mapply(f.t, results$c_faults, results$c_checks, results$nc_faults, results$nc_checks)
results$ft.p.value <- unlist(f.t.res[1,])

# I give up's (incomplete data from 2016-07-05)
f.t(4, 31, 0, 31) # ab
f.t(2, 31, 1, 31) # cd
f.t(4, 31, 1, 31) # ef
f.t(4, 31, 2, 31) # gh
