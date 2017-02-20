# Snippet Study

library(DBI)
library(RSQLite)
library(data.table)
library(xtable)
library(MASS)
library(gplots)
library(RColorBrewer)
library(ggplot2)

setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

source("TatsukiRcodeTplot.R") # http://biostat.mc.vanderbilt.edu/wiki/Main/TatsukiRcode#tplot_40_41

rf <- colorRampPalette(rev(brewer.pal(11,'Spectral')))
r <- rf(32)
set2 <- colorRampPalette(brewer.pal(8,'Set2'))(8)
set3 <- colorRampPalette(brewer.pal(12,'Set3'))(12)
set33 <- brewer.pal(3,'Set3')
source("stats/durkalski.R")

lattice.orange <- "#FFE5CC"
lattice.green <- "#CCFFCC"


par.orig <- par()

add.alpha <- function(col, alpha=1){
  if(missing(col))
    stop("Please provide a vector of colours.")
  apply(sapply(col, col2rgb)/255, 2, 
        function(x) 
          rgb(x[1], x[2], x[3], alpha=alpha))  
}
range01 <- function(x){(x-min(x))/(max(x)-min(x))} # http://stackoverflow.com/questions/5665599/range-standardization-0-to-1-in-r


con <- dbConnect(drv=RSQLite::SQLite(), dbname="confusion.db")
query.from.string <- function(query) data.table(dbGetQuery( con, query ))
query.from.file <- function(filename) query.from.string(paste(readLines(filename), collapse = "\n"))

clustRes <- query.from.file('sql/clustered_contingency.sql')
cnts <- data.table(clustRes)


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
  "Constant Assignment"           = "Assignment as Value",
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


# Cleaning
cnts <- cnts[cnts[,!atom %in% c("remove_INDENTATION_atom", "Indentation")]] # Remove old atom types
cnts[, atomName := unlist(name.conversion[atom])]

usercode <- query.from.string("select * from scrubbed_usercode;")
usercode[, correct:=(Correct=='T')]


modified.mcnemars <- durkalski

# Statistics
durkalski.chis <- cnts[, .(chisq = modified.mcnemars(.(TT=TT, TF=TF, FT=FT, FF=FF))), by=.(atom, atomName)]
durkalski.chis$c.rate <- cnts[, .(c.rate = sum(TT,TF)/sum(TT,TF,FT,FF)), by=.(atom, atomName)]$c.rate
durkalski.chis$nc.rate<- cnts[,.(nc.rate = sum(TT,FT)/sum(TT,TF,FT,FF)), by=.(atom, atomName)]$nc.rate
durkalski.chis$p.value <- lapply(durkalski.chis$chisq, function(x) pchisq(x, 1, lower.tail=FALSE))
durkalski.chis$effect.size <- mapply(phi, durkalski.chis$chisq, cnts[,.(n=sum(TT,TF,FT,FF)), by=.(atom,atomName)]$n)
durkalski.chis$sig <- lapply(durkalski.chis$chisq, function(x) x > qchisq(1-alpha, 1))

# plot density of effect.sizes
hist(durkalski.chis$effect.size, breaks=4, prob=TRUE, xlim=c(0, 1), ylab = "Probability of occurence", xlab="Effect Size")
lines(density(durkalski.chis$effect.size, bw=0.12), col='red', lwd=3)
lines(density(rbeta(10000, 3, 20), bw=0.2), col='blue', lwd=3)


# amount of confusion removed in most confusing atom
durkalski.chis[order(-effect.size), (nc.rate - c.rate)][1]

snippet.results <- durkalski.chis[order(-effect.size), .(
  "Atom" = atomName,
  "Effect" = sprintf("%3.2f", effect.size),
  "Rate Change" = nc.rate - c.rate,
  "p-value"= p.value
)]

p.value <- snippet.results$"p-value"
snippet.results.latex <- snippet.results
snippet.results.latex$"p-value" <- paste(ifelse(p.value < alpha, '\\textbf{', "{"), sprintf(ifelse(p.value < 0.01, "%0.2e", "%0.3f"), p.value), "}", sep='')

snippet.results.html <- snippet.results
snippet.results.html$"p-value" <- paste(ifelse(p.value < alpha, '<b>', ""), sprintf(ifelse(p.value < 0.01, "%0.2e", "%0.3f"), p.value), ifelse(p.value < alpha, '</b>', ""), sep='')

setorder(snippet.results, -"Effect")
print(xtable(snippet.results.latex), include.rownames=FALSE, sanitize.text.function=identity)
print(xtable(snippet.results.html), include.rownames=FALSE, sanitize.text.function=identity, type="html")

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
unique.answers[, c.rate := C_correct/C_total]
unique.answers[, nc.rate:= NC_correct/NC_total]
#unique.answers.flat <- unique.answers[, .(atom=c(atom, atom), question=c(question,question), qid=c(c_id, nc_id+1), type=.("C", "NC"), unique=c(C_unique, NC_unique), correct=c(C_correct, NC_correct), total=c(C_total, NC_total))]
unique.answers.c <-  unique.answers[, .(atom, qid=c_id,  type="C",  unique=C_unique,  correct=C_correct,  total= C_total)]
unique.answers.nc <- unique.answers[, .(atom, qid=nc_id, type="NC", unique=NC_unique, correct=NC_correct, total=NC_total)]
unique.answers.flat <- rbind(unique.answers.c, unique.answers.nc)[order(qid)]
unique.answers.flat[, incorrect          := (total - correct)       ]
unique.answers.flat[, incorrect.variance := ((unique-1) / incorrect)]
unique.answers.flat[, rate               := (correct / total)       ]
unique.answers.flat

all.qids <- unique.answers.flat$qid
c.qids   <- unique.answers.c$qid
nc.qids  <- unique.answers.nc$qid
n.questions <- nrow(unique.answers.flat)

# Graph the variance of incorrect answers
varianceDT <- unique.answers.flat[is.finite(incorrect.variance)][order(incorrect.variance)]
par(oma=c(1,8,1,1))
barplot(varianceDT$incorrect.variance, names.arg=varianceDT$question, horiz=TRUE, las=2, cex.names=0.5, xlim=c(0,1.1))
high.var.incorrect <- varianceDT[incorrect.variance < 1][order(-incorrect.variance)][1:10]
low.var.incorrect <- varianceDT[incorrect.variance < 1][order( incorrect.variance)][1:10]
mean(high.var.incorrect$rate)
mean(low.var.incorrect$rate)
high.var.incorrect[, .(question, unique, incorrect, guess.rate=incorrect.variance, correctness=rate)]
low.var.incorrect[, .(question, unique, incorrect, guess.rate=incorrect.variance, correctness=rate)]
nrow(usercode[CodeID==106&Correct=="T", .(Answer)])

# Responses with only 1 answer
unique.answers.flat[unique==1, .N, by=type] # Distribution by C/NC
usercode[CodeID==101, .N, by=.(CodeID, Correct)] # verification

usercode[CodeID==107]

# Number of unique responses on confusing/non-confusing versions of code
plot(NC_unique ~ C_unique, unique.answers, ylim=c(0,22), xlim=c(0,22), main="Number of unique responses on confusing/non-confusing")

# Unique responses vs. correctness
plot(unique ~ rate, unique.answers.flat[type=="C"], xlim=c(0, 1), ylim=c(0,22), main="Unique responses vs. correctness - Confusing")
plot(unique ~ rate, unique.answers.flat[type=="NC"], xlim=c(0, 1), ylim=c(0,22), main="Unique responses vs. correctness - Non-Confusing")


# Most common highly-diverse answer
usercode[Tag=='replace_Comma_Operator', .N, by=.(Answer, CodeID)][order(CodeID, N)]

#########################################################
#           Clustering People
#########################################################
# Cluster responses - http://www.statmethods.net/advstats/cluster.html
results.by.user.mat <- matrix(ncol = usercode[, max(CodeID)], nrow = usercode[, max(UserID)])
inp.mtx <- as.matrix(usercode[,.(UserID,CodeID,is.truthy(Correct))]) # http://stats.stackexchange.com/questions/6827/efficient-way-to-populate-matrix-in-r
results.by.user.mat[inp.mtx[,1:2] ]<- inp.mtx[,3]
results.by.user.mat <- results.by.user.mat[, all.qids]
mat.idx <- which(rowSums(is.na(results.by.user.mat))!=(dim(results.by.user.mat)[2]))
results.by.user.mat <- results.by.user.mat[rowSums(is.na(results.by.user.mat))!=(dim(results.by.user.mat)[2]), ] # Remove empty rows(users)


library(cluster)
# clustering <- clara(x=results.by.user.mat, k = 1)
# clustering$diss
# nrow(results.by.user.mat)
# for (i in 2:15) wss[i] <- sum(clara(results.by.user.mat, k=i)$withinss)

# https://rstudio-pubs-static.s3.amazonaws.com/33876_1d7794d9a86647ca90c4f182df93f0e8.html
D=daisy(results.by.user.mat, metric='gower') # Declare binary data
H.user.fit <- hclust(D, method="ward.D2")
plot(H.user.fit, main="Hierarchical clusters of users")
rect.hclust(H.user.fit, k=2, border="red")
user.groups <- cutree(H.user.fit, k=2)
#clusplot(results.by.user.mat, groups, color=TRUE, shade=TRUE, labels=2, lines=0, main= 'Customer segments')

user.clus <- as.data.table(results.by.user.mat)
user.clus$group <- user.groups
user.group1 <- apply(user.clus[user.groups==1], 2, function(x) mean(x, na.rm=TRUE))
user.group2 <- apply(user.clus[user.groups==2], 2, function(x) mean(x, na.rm=TRUE))
user.groups.diff <- data.table(atom = c(unique.answers.flat[order(qid)]$atom, "Not a real question"), qid = c(all.qids, -1),  diff = t(t(user.group1 - user.group2))[,1]) # Transpose (I apply t twice, but it only ends up transposing once [idk why]) to put the data into rows
biggest.diff.idx <- which(abs(user.groups.diff$diff) > 0.7) # Find the largest differences between the groups, these are the question numbers for the most import differentiators
user.groups.diff[biggest.diff.idx]
mean(user.group1)
mean(user.group2)

user.groups.diff[diff > 0][, .(atom, diff=mean(diff))]

#########################################################
#               Clustering Answers
#########################################################

results.by.qid.mat <- t(results.by.user.mat)
D=daisy(results.by.qid.mat, metric='gower') # Declare binary data
H.qid.fit <- hclust(D, method="ward.D2")

suppressWarnings(par(par.orig)) # reset par
plot(H.qid.fit, main="Hierarchical clusters of questions")
n.qid.groups <- 3
rect.hclust(H.qid.fit, k=n.qid.groups, border="red")

qid.groups <- cutree(H.qid.fit, k=n.qid.groups)
qid.clus <- as.data.table(results.by.qid.mat)
qid.clus$group <- qid.groups
qid.clus$qid <- all.qids
qid.clus$question <- unique.answers.flat[order(qid), paste(atom, type, sep="_")]
qid.clus$rate <- unique.answers.flat[order(qid), rate]

#########################################################
#               Monotonic Users/Answer heatmap
#########################################################
rownames(results.by.qid.mat) <- all.qids
colnames(results.by.qid.mat) <- 1:73
results.ordered <- results.by.qid.mat[,order(colSums(results.by.qid.mat, na.rm=TRUE))]
results.ordered <- results.ordered[order(rowSums(results.ordered, na.rm=TRUE)),]
#results.ordered <- replace(results.ordered, which(function(x) x ==NA, results.ordered)

heatmap(results.ordered, col=c("black", "yellow"), scale="none", Rowv = NA, Colv = NA, xlab="Subjects", ylab="Questions")

#########################################################
#               2D clustering
#########################################################



novices.mat <- results.by.user.mat[which(user.groups == 1),]
rownames(novices.mat) <- which(user.groups == 1)
colnames(novices.mat) <- all.qids
experts.mat <- results.by.user.mat[which(user.groups == 2),]
rownames(experts.mat) <- which(user.groups == 2)
colnames(experts.mat) <- all.qids

# Sort question correctness
novices.mat <- novices.mat[,order(colSums(novices.mat, na.rm=TRUE))]
experts.mat <- experts.mat[,order(colSums(experts.mat, na.rm=TRUE))]

novices.rate <- rowSums(novices.mat, na.rm=TRUE) / ncol(novices.mat)
experts.rate <- rowSums(experts.mat, na.rm=TRUE) / ncol(experts.mat)

novices.rate[order(novices.rate)]
experts.rate[order(experts.rate)]

# Average correctness for novices and experts
mean(novices.rate)
mean(experts.rate)

novice.ids <- as.numeric(rownames(novices.mat))
expert.ids <- as.numeric(rownames(experts.mat))

novice.orders <- as.numeric(colnames(novices.mat))
expert.orders <- as.numeric(colnames(experts.mat))
question.orders <- cbind(novice.orders, expert.orders)
novice.c.orders  <- novice.orders[which( as.logical(novice.orders %% 2))]
expert.c.orders  <- expert.orders[which( as.logical(expert.orders %% 2))]
novice.nc.orders <- novice.orders[which(!as.logical(novice.orders %% 2))]
expert.nc.orders <- expert.orders[which(!as.logical(expert.orders %% 2))]

c.deviations  <- match(novice.c.orders, expert.c.orders)
nc.deviations <- match(novice.nc.orders, expert.nc.orders)

c.distances  <- c.qids - c.deviations
nc.distances <- nc.qids - nc.deviations

novice.c.orders[which(c.distances > 30)]
novice.nc.orders[which(nc.distances < -45)]

novice.c.orders[which(c.distances < -20)]
novice.nc.orders[which(nc.distances > 40)]

suppressWarnings(par(par.orig))
par.orig$oma
par(oma=c(1,2,1,1))
# Confusing Parallel Coordinates Plot
slope.colors <- sapply(abs(c.distances), function(d) rgb(.2, .2, .2, alpha = (.1+d/max(abs(c.distances))) * .9))
c.orders <- cbind(c.qids, c.deviations)
colnames(c.orders) <- c("novices", "experts")
parcoord(c.orders, col=slope.colors, lwd=4, main="Difficulty ranking of\nConfusing questions by user group")
title(ylab="<-- More Difficult        Less Difficult -->")
axis(2, at=seq(0,1,length.out=length(c.qids)), labels=novice.c.orders, cex.axis=0.7, las=1)
axis(4, at=seq(0,1,length.out=length(nc.qids)), labels=expert.c.orders, cex.axis=0.7, las=1)

# Confusing Parallel Coordinates Plot
slope.colors <- sapply(abs(nc.distances), function(d) rgb(.2, .2, .2, alpha = (.1+d/max(abs(nc.distances))) * .9))
nc.orders <- cbind(nc.qids, nc.deviations)
colnames(nc.orders) <- c("novices", "experts")
parcoord(nc.orders, col=slope.colors, lwd=4, main="Difficulty ranking of\nNon-Confusing questions by user group")
title(ylab="<-- Less Difficult        More Difficult -->")
axis(2, at=seq(0,1,length.out=length(c.qids)), labels=novice.nc.orders, cex.axis=0.7, las=1)
axis(4, at=seq(0,1,length.out=length(nc.qids)), labels=expert.nc.orders, cex.axis=0.7, las=1)

# Line segment plot by correctness
usercode$confusing <- as.logical(usercode$CodeID %% 2)
# usercode$experience[usercode$UserID %in% novice.ids] <- "novice"
# usercode$experience[usercode$UserID %in% expert.ids] <- "expert"
# usercode[, by=list(experience, confusing)]

novice.rates <- (colSums(novices.mat, na.rm=TRUE))/colSums(!is.na(novices.mat))
expert.rates <- (colSums(experts.mat, na.rm=TRUE))/colSums(!is.na(experts.mat))
novice.rates <- novice.rates[order(as.numeric(names(novice.rates)))]
expert.rates <- expert.rates[order(as.numeric(names(expert.rates)))]

t.test(novice.rates, expert.rates)

novice.line.rates <- cbind(0, novice.rates)
expert.line.rates <- cbind(1, expert.rates)
experience.rates <- rbind(novice.line.rates, expert.line.rates)
experience.slopes <- expert.rates - novice.rates

exp.order <- order(experience.slopes)
experience.slopes <- experience.slopes[exp.order]
novice.rates <- novice.rates[exp.order]
expert.rates <- expert.rates[exp.order]


all.qids[which.max(experience.slopes)]
all.qids[which.min(experience.slopes)]
sum(experience.slopes < 0)

sort(unique(usercode$UserID))[novice.ids]
sort(unique(usercode$UserID))[expert.ids]


#cols <- set3
experience.slopes.magnitude <- range01(experience.slopes - mean(experience.slopes))
#bo.ramp <- colorRampPalette(c("#1181F1", "#C101F1"))
bo.ramp <- colorRampPalette(set33)
color.steps <- 20
slope.cols <- bo.ramp(color.steps)[cut(experience.slopes.magnitude, breaks=color.steps)]
slope.cols <- mapply(function(col, mag) add.alpha(col, alpha=mag), slope.cols, .2+(abs(1.0*(experience.slopes.magnitude-.2)))**1.0)
# color.pivot <- function(x) {
#   idx <- which(x == experience.slopes.magnitude)
#   len <- length(experience.slopes.magnitude)
#   n <- 5
#   ifelse(idx <= n || idx >= len - n, color3, color2)
# }
# slope.cols <- sapply(experience.slopes.magnitude, color.pivot)

len.cols <- length(experience.slopes.magnitude)
n.highlight <- 5
pdf("img/snippet_correctness_by_subject_ability.pdf", width = 4, height = 5)
par(mar=c(2.5, 4, 3, 2))
plot(experience.rates, main="Question Correctness\nby Subject Ability", ylab="Question Correctness", xaxt='n')
segments(0, (novice.rates), 1, (expert.rates), col=(slope.cols), lwd=4)
segments(0, (novice.rates)[1:n.highlight], 1, (expert.rates)[1:n.highlight], col=(slope.cols), lwd=4)
points(experience.rates)
#segments(0, (novice.rates)[len.cols - n.highlight : len.cols], 1, (expert.rates)[len.cols - n.highlight : len.cols], col=(slope.cols[len.cols - n.highlight : len.cols]), lwd=4)
axis(1, at=c(0, 1), labels=c("Low\nperforming", "High\nperforming"), tick=FALSE)
dev.off()

# novice/expert scatter plot
pdf("img/snippet_question_by_ability.pdf", width = 5, height = 5)
par(par.orig)
plot(novice.rates,expert.rates, xlim=c(0,1), ylim=c(0,1), xlab="Low-performer correctness", ylab="High-performer correctness")
abline(0,1,lty=3)
dev.off()

#########################################################
#               User Demographics
#########################################################

userTable  <- query.from.string('select * from user;')
userTable[, Name := as.factor(as.numeric(Name))]

userSurvey <- read.csv("confidential-Confusing_Atoms-scrubbed.csv", header = TRUE)
userSurvey <- userSurvey[-1] # Remove column labels
userSurvey <- data.table(userSurvey)
userSurvey[, TestID := as.factor(TestID)]
userSurvey[, CMonth := as.numeric(as.character(CMonth))]
userSurvey[, Gender := as.numeric(as.character(Gender))]
userSurvey[, ProgMonth := as.numeric(as.character(ProgMonth))]
userSurvey[, LastC := as.character(LastC)]
userSurvey[, PriLan := as.character(PriLan)]
userSurvey$pri.lang.list <- sapply(userSurvey[, PriLan], function(x) sapply(strsplit(x,", "), tolower))

userDT <- data.table(merge(userTable, userSurvey, all.y=TRUE, by.x="Name", by.y ="TestID"))
userDT <- userDT[!is.na(ID)]
userDT <- userDT[!is.na(Score)]
userDT$experience[which(userDT$ID %in% novice.ids)] <- "novice"
userDT$experience[which(userDT$ID %in% expert.ids)] <- "expert"

# plot experience vs performance
# https://www.r-bloggers.com/first-steps-with-non-linear-regression-in-r/
dev.off()
y<-userDT[!is.na(CMonth),][order(CMonth)]$Score / 100
x<-userDT[!is.na(CMonth),][order(CMonth)]$CMonth / 12
plot(y ~ x, main="Existence Study\nC Experience vs. Performance", xlab="Years of C experience", ylab="Correct Rate")
#m<-nls(y~a*x/(b+x), start=list(a=1, b=1))
m<-nls(y~a*x^b, start=list(a=20,b=.2))
lines(x,predict(m),lty=2,col="red",lwd=3)
cor(y,predict(m))

y<-userDT[!is.na(ProgMonth),][order(ProgMonth)]$Score
x<-userDT[!is.na(ProgMonth),][order(ProgMonth)]$ProgMonth
plot(y ~ x, main="Programming Experience vs. Performance", xlab="Months of Programming experience", ylab="% Correct Code Snippets")
m<-nls(y~a*x^b, start=list(a=20,b=.2))
lines(x,predict(m),lty=2,col="red",lwd=3)
cor(y,predict(m))

# Are mean/median experience programming and with C correlated? (nope)
userDT[,.(mean.c = mean(CMonth, na.rm=TRUE), mean.prog = mean(ProgMonth, na.rm=TRUE), med.c = median(CMonth, na.rm=TRUE), med.prog = median(ProgMonth, na.rm=TRUE)), by=experience]

t.test(userDT[experience=="novice"]$CMonth, userDT[experience=="expert"]$CMonth)

# Gender (nope)
userDT[Gender == 2, sum(Gender - 1)]
gender.exp.sig <- f.t(userDT[ID %in% novice.ids & Gender == 2, sum(Gender - 1)] ,length(novice.ids),
                      userDT[ID %in% expert.ids & Gender == 2, sum(Gender - 1)] ,length(expert.ids))
userDT[, mean(Gender - 1), by=experience]

# Education
userDT[order(c(experience, Education)), .N, by=list(Education, experience)]

# 1-Associate Degree
# 2-Bachelor's Degree
# 3-Master's Degree
# 4-Doctoral Degree
# 5-Professional Degree

# Months since C
test.year <- 2016
test.mon <- 04
userDT[, last.c.year := as.numeric(sapply(strsplit(LastC, "-"), '[[', 1))]
userDT[, last.c.mon  := as.numeric(sapply(strsplit(LastC, "-"), '[[', 2))]
userDT[, last.c.total.mon := (((test.year - last.c.year) * 12) + test.mon - last.c.mon)]
userDT$last.c.total.mon <- ifelse(userDT$last.c.total.mon < 0, 0, userDT$last.c.total.mon) # Remove future values
userDT[, .(last.c.mean = mean(last.c.total.mon), last.c.med = median(last.c.total.mon)), by=experience]


t.test(userDT[experience=="novice"]$last.c.total.mon, userDT[experience=="expert"]$last.c.total.mon)

#########################################################
#               User Performance
#########################################################

pdf("img/snippet_subject_performance_c_vs_nc_questions.pdf", width = 5, height = 5.5)
plot(unique.answers$c.rate, unique.answers$nc.rate, xlim=c(0,1), ylim=c(0,1), xlab="", ylab="")
title(main="Subject performance on\nAtom candidate vs Transformed snippets", xlab = "Atom candidate correct rate", ylab = "Transformed correct rate")
points(unique.answers$c.rate, unique.answers$nc.rate, pch=16, bg="black", col=rgb(.2,.2,.2,.8))#'#404040F0')
abline(0,1,lty=3)
dev.off()
       
#########################################################
#              Question correlation matrix
#########################################################

results.correct.mat <- results.by.user.mat
results.correct.mat[is.na(results.correct.mat)] <- 0
correct.mat <- t(results.correct.mat) %*% results.correct.mat

cor(results.by.user.mat, results.by.user.mat, use="pairwise.complete.obs")[1:10, 1:10]
cor(results.by.user.mat[1,], results.by.user.mat[2,], use="pairwise.complete.obs")
cor(results.by.user.mat[1,], results.by.user.mat[2,], use="pairwise.complete.obs")

unique.answers[nc_id==2]

cor(results.by.user.mat[,2], results.by.user.mat[,3], use="pairwise.complete.obs")
cor.mat <- apply(results.by.user.mat, 2, function(x)
             apply(results.by.user.mat, 2, function(y)
               cor(x, y, use="pairwise.complete.obs")))
cor.mat[1:10, 1:10]
cor.mat[is.na(cor.mat)] <- 0
colnames(cor.mat) <- all.qids
rownames(cor.mat) <- all.qids
heatmap(cor.mat, scale="none")

results.by.user.mat[1:10, 1:10]

#answered.mat <- sqrt(crossprod(t(colSums(results.correct.mat)), t(colSums(results.correct.mat))))
answered.mat <- colSums(results.correct.mat)
answered.mat[1:10, 1:10]
cond.prob.mat <- (correct.mat / answered.mat)
cond.prob.mat[1:10, 1:10]

colnames(cond.prob.mat) <- all.qids
rownames(cond.prob.mat) <- all.qids
heatmap(cond.prob.mat, scale="none")
which(cond.prob.mat > 0.98 & cond.prob.mat < 1)
cond.prob.mat[137]

###############################################################################
#       How many errors is the top quartile of atoms responsible for
###############################################################################

lower.usercode <- usercode[!(Tag %in% durkalski.chis[order(-effect.size)][1:5]$atom)]
all.n.incorrect   <- sum(      usercode[confusing == TRUE]$Correct == 'F')
lower.n.incorrect <- sum(lower.usercode[confusing == TRUE]$Correct == 'F')
1 - (lower.n.incorrect / all.n.incorrect)

# Were while-loops with assignment in the condition confusing?
q.cont <- question.contingencies <- data.table(query.from.file('sql/question_contingency.sql'))
q.cont.mats <- mapply(function(a,b,c,d) matrix(c(a,b,c,d), 2, 2), q.cont$TT,  q.cont$TF, q.cont$FT,q.cont$FF, SIMPLIFY = FALSE)
mcnemarsRes <- lapply(q.cont.mats, function(x) mcnemar.test(x, correct=FALSE))
rm(q.cont)
question.contingencies$chisq <- sapply(mcnemarsRes, function(row) row[['statistic']])
question.contingencies$p.value <- sapply(mcnemarsRes, function(row) row[['p.value']])
question.contingencies[, sample := TT+TF+FT+FF]
question.contingencies[, effect.size := phi(chisq, sample)]
question.contingencies[, c.rate := (TT+TF)/sample]
question.contingencies[, nc.rate := (TT+FT)/sample]
question.contingencies

###############################################################################
#       Demographics again
###############################################################################
colnames(userDT)

# Duration vs Score
plot(Score ~ Duration, userDT)
y <- userDT$Score
x <- userDT$Duration
#m<-nls(y~(a*x^b), start=list(a=2000,b=.7))
m<-nls(y~a*x/(x+b), start=list(a=1,b=1))
lines(seq(1000000,4000000,100000),predict(m, list(x=seq(1000000,4000000,100000))),lty=2,col="red",lwd=3)
cor(y,predict(m))

# Browser
boxplot(Score ~ Browser, userDT)

# Gender
boxplot(Score ~ Gender, userDT)
boxplot(Duration ~ Gender, userDT)
t.test(Score ~ Gender, userDT) # Not staistically significant

boxplot(Score ~ Education, userDT[Education > 1], main="Snippet Study\nCorrectness vs Education", xlab="Working/Completed Degree", xaxt='n'); axis(side=1, at=1:3, labels=c("bachelors", "masters", "phd"))
plot(Score ~ FirstC, userDT, main="Score by FirstC") # XXX needs to be processed
plot(Score ~ LastC, userDT, main="Score by LastC") # XXX needs to be processed
plot(Score ~ CMonth, userDT, main="Score by CMonths")
plot(Score ~ ProgMonth, userDT, main="Score by ProgMonths")
userDT$Education
# CMonth vs ProgMonth
m<-nls(Score~(a*CMonth^b), data=userDT, start=list(a=1,b=1)) # cor=0.48
m<-nls(Score~(a*ProgMonth^b), data=userDT, start=list(a=1,b=1)) # cor=0.44
m<-nls(Score~(CMonth^a + b*ProgMonth^c), data=cmos, start=list(a=1,b=1,c=1)) # cor=0.51
cor(cmos$Score,predict(m))


# Does LastC help clarify CMonths? Not really...
userDT$last.c.int <- as.numeric(as.Date(paste(userDT$LastC, "01", sep="-")))
cmos <- userDT[!is.na(CMonth)]
m<-nls(Score~(a*CMonth + b*last.c.int*CMonth), data=cmos, start=list(a=1,b=1))
cor(cmos$Score,predict(m))

# Primary Language as predictor of Score
pri.lang.rates <- userDT[,.(language = unlist(pri.lang.list)), by=Score]
pri.lang.rates$rate <- pri.lang.rates$Score / 100
pri.lang.rates.agg <- pri.lang.rates[, .(n = .N, rate = mean(rate), sd = sd(rate)), by=language]
pri.lang.rates <- merge(pri.lang.rates, pri.lang.rates.agg, by="language", suffixes = c("", ".mean"))
multi.pri.lang.rates <- pri.lang.rates[n > 1]
multi.pri.lang.rates$language <- factor(multi.pri.lang.rates$language, multi.pri.lang.rates[,.(med=median(rate)), by=language][order(med)]$language) # order the languages by correctness
boxplot2(rate ~ language, multi.pri.lang.rates,  las=2, medlwd=2, medcol="#444444" , main="Snippet Study\nAverage Correctness\nby primary language")
points(1:nrow(pri.lang.rates.agg[n>1]), pri.lang.rates.agg[n>1][order(rate)]$rate, pch=16)

pdf("img/snippet_correctness_by_primary_language.pdf", width = 3.8, height = 4.5)
par(mar=c(5,4,7,1))
tplot(rate ~ language, multi.pri.lang.rates,  las=2, medlwd=2, medcol="#444444",
      show.n = TRUE, bty='U', pch=20, dist=.5, jit=.03, type='db')
title("Existence Experiment\nCorrectness by Daily Language", line = 3)
dev.off()

# Primary Languages as predictor of score including experience as confounder
pri.lang.levels <- factor(sort(unique(unlist(userDT$pri.lang.list))))
userDT$pri.lang.factor <- sapply(userDT$pri.lang.list, function(x) { factor(x, levels=pri.lang.levels) })
pri.lang.indicators <- t(sapply(userDT$pri.lang.factor, table))
raw.exp.lang.predictors <- cbind(c.months = userDT$CMonth, pri.lang.indicators)
pri.lang.indicators <- t(scale(t(pri.lang.indicators))) # Scale each subject (so adding more languages doesn't increase the mean)
exp.lang.predictors <- cbind(c.months = scale(userDT$CMonth), pri.lang.indicators) # Scale C months to have same mean/sd as languages
colnames(exp.lang.predictors)[1] <- "c.months"
pri.lang.counts <- colSums(raw.exp.lang.predictors, na.rm = TRUE)

m <- lm(userDT$Score ~ exp.lang.predictors)
pri.coeffs <- data.table(name = names(m$coefficients), coeffs = m$coefficients, counts = c(nrow(userDT), pri.lang.counts))
pri.coeffs[2:nrow(pri.coeffs),  lang := substr(name, nchar("exp.lang.predictors."), 100)]
pri.coeffs[, display := c("(Intercept)", paste(tail(lang, -1), "  ", format(pri.lang.counts, digits=2), sep=''))]
pri.coeffs <- tail(pri.coeffs, -1) # drop the intercept
par.orig<-par(mar=c(4,8,4,1), mfrow=c(1,1));
barplot(pri.coeffs[!is.na(coeffs)&counts>1][order(coeffs)]$coeffs, names.arg=pri.coeffs[!is.na(coeffs)&counts>1][order(coeffs)]$display, horiz=TRUE, las=2)
mtext("Predictive power of primary language\n to snippet study performance\nwith experience",side = 3, at = -4) 
par(par.orig)

############################################################################
#     Performance over time (first question through last )
############################################################################

# Subjects do better on questions as the test continues
usercode$normed.correct <- usercode$correct - ave(usercode$correct, usercode$CodeID) # normalize results by codeid-specific averages, so that getting a hard question wrong isn't as bad as getting an easy question wrong
over.time <- usercode[, .(normed.correct = mean(normed.correct), correct = mean(correct)), by=list(rank)]
plot(over.time$normed.correct, main="Question Position vs Correctness", ylab="Relative Correctness of Question at this Index", xlab="Position of Question in Test")
fit2 <- lm(normed.correct~rank, data=over.time)
abline(fit2, col="blue")
summary(fit2)

# Subjects answer faster as the test continues
usercode$normed.duration <- usercode$Duration - ave(usercode$Duration, usercode$CodeID) # normalize duration by codeid-specific averages
over.time$normed.duration <- usercode[, .(normed.duration = mean(normed.duration), duration = mean(Duration)), by=list(rank)]$normed.duration
plot(over.time$normed.duration, main="Question Position vs Duration", ylab="Relative Duration of Question at this Index", xlab="Position of Question in Test")
fit2 <- lm(normed.duration~rank, data=over.time)
abline(fit2, col="blue")
summary(fit2)

# Subjects answer faster as the test continues
dev.off()
fit2 <- lm(correct~Duration, data=usercode)
durationcode <- usercode[Duration > 0]
duration.correct <-  durationcode[correct == TRUE]$Duration / 1000
duration.incorrect <- durationcode[correct == FALSE]$Duration / 1000
med.c <- median(duration.correct)
med.ic <- median(duration.incorrect)
density.correct <- density(duration.correct, adjust = 3)
density.incorrect <- density(duration.incorrect, adjust = 3)
plot(density.correct, xlim = c(0, 100), ylim=c(0, 0.032), col="blue", xlab="Seconds taken to respond", ylab="Probability", main=c("Probability density of response duration", "by correct/incorrect responses"))
segments(med.c, 0, med.c, density.correct$y[which(abs(density.correct$x-med.c)==min(abs(density.correct$x-med.c)))]) # draw median up to height of probability
lines(density.incorrect, col="red", lty=5)
segments(med.ic, 0, med.ic, lty=5, y1 = density.incorrect$y[which(abs(density.incorrect$x-med.c)==min(abs(density.incorrect$x-med.c)))]) # draw median up to height of probability)
legend(65, 0.03, legend=c("Correct", "Incorrect"), col=c("blue", "red"), lty=c(1,5), cex=1.2)
duration.u <- wilcox.test(duration.correct, duration.incorrect, paired=FALSE, conf.int = TRUE)
text(56, 0.013, paste("P-value:", format(duration.u$p.value, digits=3)), adj = c(0,0))
text(56, 0.010, paste("Difference in medians:", format(abs(duration.u$estimate), digits=3)), adj = c(0,0))


durationcode[, duration.user := mean(Duration), by=UserID]
durationcode[, duration.code := mean(Duration), by=CodeID]

colnames(durationcode)
#fit <- glm(Duration ~ rank + duration.user + duration.code, data=durationcode)
fit <- glm(Duration ~ rank + factor(UserID) + factor(CodeID), data=durationcode)
cor(durationcode$Duration,predict(fit))
plot(predict(fit),durationcode$Duration)

fit <- glm(correct ~ rank + factor(UserID) + factor(CodeID), data=durationcode, family=binomial(link="logit"))
cor(durationcode$correct,predict(fit))
plot(predict(fit),durationcode$correct)

# Correctness and duration covary
#durationcode$code.order <- factor(durationcode$CodeID, durationcode[, .(mcid = median(Duration)), by=CodeID][order(mcid)]$CodeID)
durationcode$code.order <- factor(durationcode$CodeID, durationcode[, .(mcid = mean(correct)), by=CodeID][order(mcid)]$CodeID)
#durationcode$code.order <- factor(durationcode$CodeID[order(as.integer(as.character(durationcode$CodeID)))])


dc <- data.table(correctness = durationcode[, mean(correct),    by=code.order][[2]],
                 duration    = durationcode[, median(Duration), by=code.order][[2]]/1000,
                 code.order  = durationcode[, code.order, by=code.order][[1]])
dc$dur <- dc$duration*2
par(mar=c(3.1,4.1,4.1,4.1))
plot(1, type="n", xaxt="n", yaxt="n", xlab="", ylab="", xlim=c(1,max(durationcode$CodeID)), ylim=c(0,100), main = "Correctness and Duration for Questions")
mtext(side=2,text="Mean Correctness",line=2.5)
axis(side=2, at=seq(0,100,length.out=5), labels=seq(0,1,length.out=5))
mtext(side=4,text="Median Duration in Seconds",line=2.5)
axis(side=4, at=seq(min(dc$dur),max(dc$dur), length.out=5), labels=round(seq(min(dc$duration),max(dc$duration),length.out=5)))
mtext(side=1,text="Question",line=1)
points(correctness*100 ~ code.order, pch=1, data = dc)#, col='blue')
points(   dur ~ as.integer(code.order), pch=20, data = dc)#, col='red')
abline(lm(dur ~ as.integer(code.order), data = dc))
legend(85, 85, legend=c("Correctness", "Duration"), pch=c(1,20), cex=1.2)
dev.off()



