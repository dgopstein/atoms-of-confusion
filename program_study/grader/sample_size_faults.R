library("data.table")
library("samplesize")
library(lsr)

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

n.ttest(power = 0.8, alpha = 0.05, mean.diff = mean(as) - mean(bs), sd1 = sd(as), sd2 = sd(bs))

# which atoms are the most confusing
# which atoms still remain in the NC questions