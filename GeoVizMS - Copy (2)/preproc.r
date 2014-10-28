#Load data.table and data table
require(data.table)
suppressPackageStartupMessages(require(googleVis))
require(reshape2)
load("data/metsyn1113.rda")
load("data/fipscd.rda") 

#Removing US territories
fips <- fips[!fips$FIPS>56,]

##Data taken from https://www.census.gov/geo/maps-data/maps/pdfs/reference/us_regdiv.pdf
NE <- c(9,23,25,33,44,50,34,36,42)
MW <- c(18,17,26,39,55,19,20,27,31,38,46,29)
SO <- c(10,11,12,13,24,37,45,51,54,01,21,28,47,05,22,40,48)
WE <- c(04,08,16,35,30,49,32,56,02,06,15,41,53)
subreg <- list(NE,MW,SO,WE)
subreg <- melt(subreg)
colnames(subreg) <- c("fipscode", "subregion")
subreg$subregion <- factor(subreg$subregion, levels=1:4, labels=c("North East", "MidWest", "South", "West"))

fips$subregion <- subreg$subregion[match(fips$FIPS, subreg$fipscode)]


#Adding State Names
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



