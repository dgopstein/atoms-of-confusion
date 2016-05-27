con <- dbConnect(drv=RSQLite::SQLite(), dbname="confusion.db")
clusteredQuery <- paste(readLines('sql/clustered_contingency.sql'), collapse = "\n")
clustRes <- dbGetQuery( con, clusteredQuery )
cnts <- data.table(clustRes)

# Eliasziw & Donner 1991
# Durkalski 2003

bk <- cnts$FT
ck <- cnts$TF

ed <- function (bk, ck) {
  # Number of discordant answers per subject
  Sk <- bk + ck
  
  # Number of subjects with discordant answer
  Kd <- sum(Sk >= 1)
  
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
}
