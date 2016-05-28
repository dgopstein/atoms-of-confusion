con <- dbConnect(drv=RSQLite::SQLite(), dbname="confusion.db")
clusteredQuery <- paste(readLines('sql/clustered_contingency.sql'), collapse = "\n")
clustRes <- dbGetQuery( con, clusteredQuery )
cnts <- data.table(clustRes)

# Eliasziw & Donner 1991
# Durkalski 2003

eliasziw1 <- function (bk, ck) {
  # Number of discordant answers per subject
  Sk <- bk + ck
  
  # Number of subjects with discordant answer
  Kd <- sum(Sk >= 1)
  
  # Number of subjects
  K <- nrow(Sk)
  
  p.bar <- sum(bk) / sum(Sk)
  
  S.bar <- (1/Kd) * sum(Sk)
  
  S0 <- S.bar - sum((Sk - S.bar)^2 - (K - Kd)*(S.bar^2)) / (Kd * (Kd - 1) * S.bar)
  
  BMS <- (1/Kd) * sum( ifelse(Sk >= 1, (( bk - Sk*p.bar )^2 / Sk), 0) )
  WMS <- (1/(Kd * (S.bar - 1))) * sum( ifelse(Sk >= 1, (( bk * (Sk - bk) ) / Sk), 0) )
  
  rho.hat <- (BMS - WMS) / (BMS + (S0 - 1)*WMS)
  
  nc <- S0 + Kd*(S.bar - S0)
  
  b <- sum(bk)
  c <- sum(ck)
  X2mc <- (b - c)^2/(b + c)
  
  X2di <- X2mc / (1 + (nc - 1) * rho.hat)
  
  X2di
}

test.test <- function(ps, the.test) {
  qs <- list()
  qs$q1 <- sample(x = c(1, 2, 3, 4), 73, replace = T, prob = ps)
  qs$q2 <- sample(x = c(1, 2, 3, 4), 73, replace = T, prob = ps)
  
  qt <- data.table(data.frame(qs))
  
  cnts <- data.table(qt[, .((q1==1) + (q2==1), (q1==2) + (q2==2), (q1==3) + (q2==3), (q1==4) + (q2==4))] )
  colnames(cnts) <- c("TT", "TF", "FT", "FF")
  cnts$id<-seq.int(nrow(cnts))
  
  cnts$n <- mapply(sum, cnts$TT, cnts$TF, cnts$FT, cnts$FF)
  
  the.test(cnts$TF, cnts$FT)
}

eliasziw1(cnts$TF, cnts$FT)

system.time(results <- data.table(replicate(1000, test.test(eliasziw1, c(0.3, 0.3, 0.3, 0.1)))))
nrow(results[V1 > qchisq(0.95, 1)]) / nrow(results)

chis <- cnts[, .(chisq = eliasziw1(TF, FT)), by=atom]
chis$p.value <- lapply(chis$chisq, function(x) pchisq(x, 1, lower.tail=FALSE))

