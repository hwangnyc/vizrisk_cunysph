# Code to read in the data set, set up survey weights, 
# and create contingency table by state

# read in file and create subset

# download 2012 BRFSS CSV file here:
# http://www.hhsvizrisk.org/alldatasets-1/

brf <- read.csv("BRFS2012.csv")
dffull <- brf[c("SEQNO", "X_STSTR", "X_LLCPWT", "X_STATE", "EXERANY2", "AGE")]
rm(brf); gc()

##Sample a "small" dataset to test with
##set.seed(1)
##df <- dffull[sort(sample(1:nrow(dffull), size=50000)), ]
df <- dffull

# format exercise variable

exerlabels <- c("Yes", "No", "Don't know", "Refused")
df$exerany <- factor(df$EXERANY2, labels = exerlabels)

# create binary yes/no exercise variable
df$exerbin <- "No"
df$exerbin[df$exerany == "Yes"] <- "Yes"
df$exerbin <- as.factor(df$exerbin)

## set up survey weights
library(survey)
##note - I changed sample to svy.sample, so we don't overwrite the
##base function sample().
svy.sample <- svydesign(id=~SEQNO, strata=~X_STSTR, weights=~X_LLCPWT,
                    data=df, nest=TRUE)

# try to create contingency table with row=state and column= exercise yes vs no

# simple table of one variable
(exertable <- prop.table(svytable(~exerbin, design = svy.sample)))
(exertable <- prop.table(svytable(~EXERANY2, design = svy.sample)))
(statetable <- svytable(~X_STATE, design = svy.sample))

# contingency table
(exertable <- svyby(~exerbin, by=df$X_STATE, svy.sample, svytotal))
(exertable2 <- svytable(~exerbin+X_STATE, svy.sample))


## working now
(exertable3 <- svyby(~exerbin, ~X_STATE, svy.sample, svytotal))
(exertable4 <- svytotal(~exerbin, byvar = df$X_STATE, svy.sample))

