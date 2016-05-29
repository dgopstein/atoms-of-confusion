library('survival')
library('aod')

View(rats)

dput(rats)
raoscott(cbind(y, n - y) ~ group, data = rats)
