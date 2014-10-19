#Load data.table and data table
require(data.table)
suppressPackageStartupMessages(library(googleVis))
require(reshape2)
load("data/metsyn1113.rda")
load("data/fipscd.rda") 

#Removing US territories
fips <- fips[!fips$FIPS>56,]

#Loading Census Population Proportions Data
ASprops <- read.csv("data/Census2010prop.csv", header=TRUE, colClasses=c("factor", "integer", "numeric"))

#Loading farmers market / fast food data
fmf <- read.csv("data/percap_fst_fm.csv")

#Creating Proportion Vector
metsyn[, AGEPR:= ASprops$Percent[match(metsyn$AGEG, ASprops$Age.Group)]]

#Standardizing by Age Groups
metsyn[, STDFQ:= Freq*AGEPR]



