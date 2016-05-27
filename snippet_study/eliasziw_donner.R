con <- dbConnect(drv=RSQLite::SQLite(), dbname="confusion.db")
clusteredQuery <- paste(readLines('sql/clustered_contingency.sql'), collapse = "\n")
clustRes <- dbGetQuery( con, clusteredQuery )
cnts <- data.table(clustRes)

b <- cnts$FT
c <- cnts$TF

# Number of discordant answers per subject
S <- b + c

# Number of subjects with discordant answer
K <- sum(S >= 1)
