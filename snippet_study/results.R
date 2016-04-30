library("RSQLite")
library("fitdistrplus")
library(DBI)
library("data.table")
library('plyr')

con <- dbConnect(drv=RSQLite::SQLite(), dbname="confusion.db")
alltables <- dbListTables(con)

