#Load data.table and data table
require(data.table)
suppressPackageStartupMessages(library(googleVis))
require(reshape2)
load("data/metsyn1113.rda")
load("data/fipscd.rda") 
setkey(metsyn, YEAR)

metsyn[, ABB:=fips$Abb[match(metsyn$STATE, fips$FIPS)]]
metsyn[, SNAME:=fips$STATE[match(metsyn$STATE, fips$FIPS)]]
metsyn[, REGION:=fips$region[match(metsyn$STATE, fips$FIPS)]]

#Loading Census Population Proportions Data
ASprops <- read.csv("data/Census2010prop.csv", header=TRUE, colClasses=c("factor", "integer", "numeric"))

#Loading farmers market / fast food data

fmf <- read.csv("data/percap_fst_fm.csv")

#Creating Proportion Vector
metsyn[, AGEPR:= ASprops$Percent[match(metsyn$AGEG, ASprops$Age.Group)]]

#Standardizing by Age Groups
metsyn[, STDFQ:= Freq*AGEPR]

#Age-Standardized Proportions ##can be calculated later
metsyn[, STDPROP:=STDFQ/sum(STDFQ)*100, by=YEAR]

