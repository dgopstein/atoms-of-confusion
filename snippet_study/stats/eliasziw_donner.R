# Eliasziw & Donner 1991

mcnemars <- function(abcd) {
  #b <- sum(bk)
  #c <- sum(ck)
  b <- sum(abcd$TF)
  c <- sum(abcd$FT)
  X2mc <- (b - c)^2/(b + c)
}

eliasziw1 <-function (abcd) {
  bk <- abcd$TF
  ck <- abcd$FT
  
  # Number of discordant answers per subject
  Sk <- bk + ck
  
  # Number of subjects with discordant answer
  Kd <- sum(Sk >= 1)
  
  # Number of subjects
  #K <- nrow(Sk)
  K <- length(Sk)
  
  p.bar <- sum(bk) / sum(Sk)
  
  S.bar <- (1/Kd) * sum(Sk)
  
  S0 <- S.bar - sum((Sk - S.bar)^2 - (K - Kd)*(S.bar^2)) / (Kd * (Kd - 1) * S.bar)
  
  BMS <- (1/Kd) * sum( ifelse(Sk >= 1, (( bk - Sk*p.bar )^2 / Sk), 0) )
  WMS <- (1/(Kd * (S.bar - 1))) * sum( ifelse(Sk >= 1, (( bk * (Sk - bk) ) / Sk), 0) )
  
  rho.hat <- (BMS - WMS) / (BMS + (S0 - 1)*WMS)
  
  nc <- S0 + Kd*(S.bar - S0)
  
  X2di <- mcnemars(abcd) / (1 + (nc - 1) * rho.hat)
  
  X2di
}

test.test <- function(the.test, ps) {
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

eliasziw2 <- function (abcd) {
  bk <- abcd$TF
  ck <- abcd$FT
  
  # Row-wise sum [2, 2, 2, ...]
  nk <- Reduce("+", abcd)

  # Number of discordant answers per subject
  Sk <- bk + ck
  
  # Number of subjects with discordant answer
  Kd <- sum(Sk >= 1)
  
  # Number of subjects
  K <- length(nk)
  
  n.bar <- (1 / K) * sum(nk)
  
  n0 <- n.bar - ( sum( (nk - n.bar)^2 ) ) / (K * (K - 1) * n.bar )
  
  # Total number of responses
  N = sum(nk)
  
  abcd.mat <- data.matrix(abcd)
  
  # Column-wise sum: TT:1678, TF:168, FT:845, FF:342
  abcd.sum <- sapply(abcd, sum)
  
  P.hat <- abcd.sum / N
  
  

  nk_X_P.hat <-t(sapply(nk, function(x) x * P.hat))
  dput(abcd.mat)
  dput(nk_X_P.hat)

  BMSpooled <- (1 / K) * sum( (abcd.mat - nk_X_P.hat)^2 / nk )
  WMSpooled <- (1 / (K * (n.bar - 1))) * sum( ( abcd.mat *  as.vector(nk - abcd.mat)) / nk )
  
  rho.tilde.star <- (BMSpooled - WMSpooled) / (BMSpooled + (n0 - 1)*WMSpooled)
  
  rho.tilde <- 1 / (1 + P.hat[['TF']]*(1 - rho.tilde.star)/rho.tilde.star
                      + P.hat[['FT']]*(1 - rho.tilde.star)/rho.tilde.star)
  
  S.bar <- (1/Kd) * sum(Sk)
  
  S0 <- S.bar - sum((Sk - S.bar)^2 - (K - Kd)*(S.bar^2)) / (Kd * (Kd - 1) * S.bar)
  
  nc <- S0 + Kd*(S.bar - S0)

  C.hat <- 1 + (nc - 1) * rho.tilde
  
  X2di <- mcnemars(abcd) / C.hat
  
  X2di
}
