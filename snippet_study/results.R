library(DBI)
library(data.table)

source("stats/durkalski.R")

con <- dbConnect(drv=RSQLite::SQLite(), dbname="confusion.db")
clusteredQuery <- paste(readLines('sql/clustered_contingency.sql'), collapse = "\n")
clustRes <- dbGetQuery( con, clusteredQuery )
cnts <- data.table(clustRes)

# Cleaning
cnts <- cnts[cnts[,!atom %in% c("remove_INDENTATION_atom", "Indentation")]] # Remove old atom types
cnts[, atomName := unlist(name.conversion[atom])]


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

alpha <- 0.05
phi <- function(chi2, n) sqrt(chi2/n)

# Statistics
durkalski.chis <- cnts[, .(chisq = durkalski(.(TT=TT, TF=TF, FT=FT, FF=FF))), by=.(atom, atomName)]
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

# Playground
atom.contingencies = cnts[, .(TT=sum(TT), TF=sum(TF), FT=sum(FT), FF=sum(FF)), by=atom]
question.contingencies = cnts[, .(TT=sum(TT), TF=sum(TF), FT=sum(FT), FF=sum(FF)), by=list(question,atomName)]



