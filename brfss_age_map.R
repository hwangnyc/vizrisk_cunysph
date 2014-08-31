# read in csv file

brf <- read.csv("BRFS2012.csv")

# create subset

df <- brf[c("SEQNO", "X_STSTR", "X_LLCPWT", "X_STATE", "EXERANY2", "AGE")]
df <- as.data.frame(df)

rm(list = "brf")

# adjust for sampling method

library(survey)
sample <- svydesign(id=~df$SEQNO,
                    strata=~df$X_STSTR, weights=~df$X_LLCPWT, data=df, nest=T) 

# CREATE AGE MAP

# table of weighted ages by state
age_state <- svyby(~AGE, ~X_STATE, sample, svymean)
df <- as.data.frame(age_state)

# create map
# modeled on code here: http://bcb.dfci.harvard.edu/~aedin/courses/R/CDC/maps.html
library(maps)
colors = c("#F1EEF6", "#D4B9DA", "#C994C7", "#DF65B0", "#DD1C77", 
           "#980043")

age_state$colorBuckets <- as.numeric(cut(age_state$AGE, c(43, 44, 45, 46, 47, 48, 49)))
colorsmatched <- age_state$colorBuckets[match(state.fips$fips, age_state$X_STATE)]

map("state", col = colors[colorsmatched], fill = TRUE, resolution = 0, 
    lty = 0, projection = "polyconic")

# add title, legend, and border

map("state", col = "white", fill = FALSE, add = TRUE, lty = 1, lwd = 0.2, 
    projection = "polyconic")

title("Mean age of BRFSS 2012 respondents, by state")
leg.txt <- c("under 43", "43", "44", "45", "46", "47", "48+")
legend("bottomright", leg.txt, horiz = TRUE, fill = colors)

# WORK ON EXERCISE VARIABLE

# format variable
# exercise
exerlabels <- c("Yes", "No", "Don't know", "Refused")
df$exerany <- factor(df$EXERANY2, labels = exerlabels)

# create binary yes/no exercise variable
df$exerbin <- "No"
df$exerbin[df$exerany == "Yes"] <- "Yes"
df$exerbin <- as.factor(df$exerbin)

# trying to create table showing proportion who exercised by state
# all of the below do not work:

exertable <- svytable(df$X_STATE, df$exerbin, sample)

exertable <- svyby(~df$exerbin, ~df$X_STATE, sample, svytotal)

exertable <- svytable(~df$exerbin+df$X_STATE, sample)

exertable <- svyratio(~df$exerbin, ~df$X_STATE, sample)
