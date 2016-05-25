source("obuchowski.R")


test.obuchowski <- function(ps) {
  qs <- list()
  qs$q1 <- sample(x = c(1, 2, 3, 4), 73, replace = T, prob = ps)
  qs$q2 <- sample(x = c(1, 2, 3, 4), 73, replace = T, prob = ps)
  
  qt <- data.table(data.frame(qs))
  
  cnts <- data.table(qt[, .((q1==1) + (q2==1), (q1==2) + (q2==2), (q1==3) + (q2==3), (q1==4) + (q2==4))] )
  colnames(cnts) <- c("TT", "TF", "FT", "FF")
  cnts$id<-seq.int(nrow(cnts))
  
  cnts$n <- mapply(sum, cnts$TT, cnts$TF, cnts$FT, cnts$FF)
  
  obuchowski.test(cnts$TF, cnts$FT, cnts$n, cnts$id)
}



system.time(results <- replicate(1000, test.obuchowski(c(0.3, 0.3, 0.3, 0.1))))

hist(results, breaks=100)#, xlim=c(0,3))
