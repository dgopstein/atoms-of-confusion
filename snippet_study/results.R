library(DBI)
library(data.table)
library(xtable)

source("stats/durkalski.R")

con <- dbConnect(drv=RSQLite::SQLite(), dbname="confusion.db")
query.from.string <- function(query) data.table(dbGetQuery( con, query ))
query.from.file <- function(filename) query.from.string(paste(readLines(filename), collapse = "\n"))

clustRes <- query.from.file('sql/clustered_contingency.sql')
cnts <- data.table(clustRes)

# Cleaning
cnts <- cnts[cnts[,!atom %in% c("remove_INDENTATION_atom", "Indentation")]] # Remove old atom types
cnts[, atomName := unlist(name.conversion[atom])]

usercode <- query.from.string("select * from usercode;")

name.conversion <- list(
  "add_CONDITION_atom"            = "Implicit Predicate",
  "add_PARENTHESIS_atom"          = "Infix Operator Precedence",
  "move_POST_INC_DEC_atom"        = "Post-Increment/Decrement",
  "move_PRE_INC_DEC_atom"         = "Pre-Increment/Decrement",
  "replace_CONSTANTVARIABLE_atom" = "Constant Variables",
  "replace_MACRO_atom"            = "Macro Operator Precedence",
  "replace_Ternary_Operator"      = "Conditional Operator",
  "replace_Arithmetic_As_Logic"   = "Arithmetic as Logic",
  "replace_Comma_Operator"        = "Comma Operator",
  "Constant Assignment"           = "Side-Effecting Expression",
  "Logic as Control Flow"         = "Logic as Control Flow",
  "Re-purposed variables"         = "Repurposed Variables",
  "Swapped subscripts"            = "Reversed Subscripts",
  "Dead, unreachable, repeated"   = "Dead, Unreachable, Repeated",
  "Literal encoding"              = "Change of Literal Encoding",
  "Curly braces"                  = "Omitted Curly Braces",
  "Type conversion"               = "Type Conversion",
  "move_Preprocessor_Directives_Inside_Statements" = "Preprocessor in Expression",
  "replace_Mixed_Pointer_Integer_Arithmetic" = "Pointer Arithmetic"
  #  "Indentation",
  #  "remove_INDENTATION_atom",
)

is.truthy <- function(str) ifelse(str == "T", 1, 0)

alpha <- 0.05
phi <- function(chi2, n) sqrt(chi2/n)

modified.mcnemars <- durkalski

# Statistics
durkalski.chis <- cnts[, .(chisq = modified.mcnemars(.(TT=TT, TF=TF, FT=FT, FF=FF))), by=.(atom, atomName)]
durkalski.chis$p.value <- lapply(durkalski.chis$chisq, function(x) pchisq(x, 1, lower.tail=FALSE))
durkalski.chis$effect.size <- mapply(phi, durkalski.chis$chisq, cnts[,.(n=sum(TT,TF,FT,FF)), by=.(atom,atomName)]$n)
durkalski.chis$sig <- lapply(durkalski.chis$chisq, function(x) x > qchisq(1-alpha, 1))

snippet.results <- durkalski.chis[, .(
  "Atom" = atomName,
  "Effect" = sprintf("%3.2f", effect.size),
  "p-value"= paste(ifelse(p.value < alpha, '\\textbf{', "{"), sprintf(ifelse(p.value < 0.01, "%0.2e", "%0.3f"), p.value), "}", sep='')
  # ,"Accept"= ifelse(p.value<alpha,"T","F")
)]
setorder(snippet.results, -"Effect")
print(xtable(snippet.results), include.rownames=FALSE, sanitize.text.function=identity)
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
#   Atoms figure for paper
# ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

# All questions C vs NC
all.q.data <- cnts[cnts[,!atomName %in% c("Dead, Unreachable, Repeated",  "Arithmetic as Logic", "Pointer Arithmetic", "Constant Variables")]]
all.q.data <- all.q.data[, .(TT=sum(TT), TF=sum(TF), FT=sum(FT), FF=sum(FF)), by=userId] # Sum all questions per user
all.q.chi2 <- all.q.data[, .(chisq = modified.mcnemars(.(TT=TT, TF=TF, FT=FT, FF=FF)))]$chisq
all.q.p.value <- pchisq(all.q.chi2, 1, lower.tail=FALSE)
all.q.effect.size <- phi(all.q.chi2, cnts[,.(n=sum(TT,TF,FT,FF))]$n)
all.q.effect.size

# Playground
atom.contingencies = cnts[, .(TT=sum(TT), TF=sum(TF), FT=sum(FT), FF=sum(FF)), by=atom]

##########################################################
#  Anecdote: How many different answer per question
##########################################################
unique.answers <- query.from.file('sql/unique_answers.sql')
unique.answers.flat <- unique.answers[, .(atom=c(atom, atom), question=c(question,question), qid=c(c_id, nc_id), type=c("C", "NC"), unique=c(C_unique, NC_unique), correct=c(C_correct, NC_correct), total=c(C_total, NC_total))]
unique.answers.flat[, rate:=(correct / total)]

# Responses with only 1 answer
unique.answers.flat[unique==1, .N, by=type] # Distribution by C/NC
usercode[CodeID==101, .N, by=.(CodeID, Correct)] # verification



# Number of unique responses on confusing/non-confusing versions of code
plot(NC_unique ~ C_unique, unique.answers, ylim=c(0,22), xlim=c(0,22), main="Number of unique responses on confusing/non-confusing")

# Unique responses vs. correctness
plot(unique ~ rate, unique.answers.flat[type=="C"], xlim=c(0, 1), ylim=c(0,22), main="Unique responses vs. correctness - Confusing")
plot(unique ~ rate, unique.answers.flat[type=="NC"], xlim=c(0, 1), ylim=c(0,22), main="Unique responses vs. correctness - Non-Confusing")

#########################################################
#                  Clustering
#########################################################
# Cluster responses - http://www.statmethods.net/advstats/cluster.html
results.by.user.mat <- matrix(ncol = usercode[, max(CodeID)], nrow = usercode[, max(UserID)])
inp.mtx <- as.matrix(usercode[,.(UserID,CodeID,is.truthy(Correct))]) # http://stats.stackexchange.com/questions/6827/efficient-way-to-populate-matrix-in-r
results.by.user.mat[inp.mtx[,1:2] ]<- inp.mtx[,3]
mat.idx <- which(rowSums(is.na(results.by.user.mat))!=(dim(results.by.user.mat)[2]))
results.by.user.mat <- results.by.user.mat[rowSums(is.na(results.by.user.mat))!=(dim(results.by.user.mat)[2]), ] # Remove empty rows(users)


library(cluster)
# clustering <- clara(x=results.by.user.mat, k = 1)
# clustering$diss
# nrow(results.by.user.mat)
# for (i in 2:15) wss[i] <- sum(clara(results.by.user.mat, k=i)$withinss)

# https://rstudio-pubs-static.s3.amazonaws.com/33876_1d7794d9a86647ca90c4f182df93f0e8.html
D=daisy(results.by.user.mat, metric='gower') # Declare binary data
H.fit <- hclust(D, method="ward.D2")
plot(H.fit, main="Hierarchical clusters of users")
rect.hclust(H.fit, k=2, border="red")
groups <- cutree(H.fit, k=2)
#clusplot(results.by.user.mat, groups, color=TRUE, shade=TRUE, labels=2, lines=0, main= 'Customer segments')

user.clus <- as.data.table(results.by.user.mat)
user.clus$group <- groups
group1 <- apply(user.clus[groups==1], 2, function(x) mean(x, na.rm=TRUE))
group2 <- apply(user.clus[groups==2], 2, function(x) mean(x, na.rm=TRUE))
groups.diff <- data.table(atom = c(unique.answers.flat[order(qid)]$atom, "Not a real question"), qid = c(1:126, -1),  diff = t(t(group1 - group2))[,1]) # Transpose (I apply t twice, but it only ends up transposing once [idk why]) to put the data into rows
biggest.diff.idx <- which(abs(groups.diff) > 0.7) # Find the largest differences between the groups, these are the question numbers for the most import differentiators
groups.diff[biggest.diff.idx]
mean(group1)
mean(group2)

groups.diff[diff > 0][, .(.N, mean(diff)), by=atom]


