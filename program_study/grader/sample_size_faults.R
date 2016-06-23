library("data.table")
library("samplesize")
library(lsr)
library("Hmisc")
library("binomSampleSize")
library("binGroup")

pilot <- data.table(read.csv("csv/fault_rates.csv", header = TRUE))
pilot$c_checks <- mapply(max, 1, pilot$c_checks)

pilot$c_fault_rate  <- pilot$c_faults / pilot$c_checks
pilot$nc_fault_rate <- pilot$nc_faults/pilot$nc_checks


hist(pilot$c_fault_rate, breaks=10)
hist(pilot$nc_fault_rate, xlim=c(0,1), ylim=c(0,12), breaks=10)

t.test(pilot$c_fault_rate, pilot$nc_fault_rate)

pilot$c_faults

binoms <- mapply(binom.test, pilot$c_faults,pilot$c_checks)
# pilot$c_pvalues <- unlist(binoms[3,])

# http://stats.stackexchange.com/questions/113602/test-if-two-binomial-distributions-are-statistically-different-from-each-other
f.t <- function(a, a_total, b, b_total) fisher.test(rbind(c(a,a_total-a), c(b,b_total-b)), alternative="greater")
f.t.res <- mapply(f.t, pilot$c_faults, pilot$c_checks, pilot$nc_faults, pilot$nc_checks)
pilot$ft.p.value <- unlist(f.t.res[1,])

cloglog.sample.size(p.alt, n = NULL, p = 0.5, power = 0.8, alpha = 0.05,
                    alternative = c("two.sided", "greater", "less"), exact.n = FALSE,
                    recompute.power = FALSE, phi = 1)
pilot$prop.ss <- unlist(mapply(function(a, b) { power.prop.test(p1 = a, p2 = b, power = 0.8) }, pilot$c_fault_rate, pilot$nc_fault_rate)[1,])

mapply(function(a, b) { power.prop.test(p1 = a, p2 = b, power = 0.8) }, pilot$c_fault_rate, pilot$nc_fault_rate)

length(pilot$prop.ss[pilot$prop.ss]) / 5

# which atoms are the most confusing
hist(pilot$prop.ss, xlim=c(0, 200), breaks = 200, xlab="Sample Size Estimate", main = "Sample Sizes for Individual Variable Errors")

# which atoms still remain in the NC questions

#http://stackoverflow.com/questions/12866189/calculating-the-outliers-in-r
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

upper.quantile <- outliers(pilot$nc_fault_rate, "mild")
upper.wilson <- binconf(sum(pilot$nc_faults), sum(pilot$nc_checks))[3]

pilot[nc_fault_rate > upper.quantile]
pilot[nc_fault_rate > upper.wilson]

#ciss.binom(p0=1/2, d=0.1, alpha=0.05, method="wilson")


wilson.ss <- function (x) binDesign( nmax=100, delta=x, p.hyp=upper.wilson, alternative="greater", method="CP", power=0.8)


wilson.capped <- sapply(pilot$nc_fault_rate, function(x) 0.0001 + max(x, upper.wilson))
pilot$wilson.ss <- unlist(sapply(wilson.capped, wilson.ss)[2,])

hist(pilot$wilson.ss, breaks = 10, xlim=c(0,50), ylim=c(0,4), xlab="Sample Size Estimate", main = "Sample Sizes for latent atoms in NC programs")

  