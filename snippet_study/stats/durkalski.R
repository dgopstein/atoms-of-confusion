# Durkalski 2003

durkalski <- function(abcd) {
  nk <- Reduce("+", abcd)

  bk <- abcd$TF
  ck <- abcd$FT

  X2v <- sum( (1/nk)*(bk-ck) )^2/sum(((bk - ck) / nk)^2)

  X2v
}
