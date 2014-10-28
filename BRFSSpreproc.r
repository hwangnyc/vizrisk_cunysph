##Marcel Ramos - VizRisk Project R Code (R version 3.1.1)
## To load processed data, use load("filename.rda") ## make sure RDA file is in the working directory

#Loading raw data
require(data.table)
require(foreign)
brfss1 = fread("BRFS2011.csv")
brfss2 = fread("BRFS2012.csv")
brfss3 = read.xport("LLCP2013.xpt")
brfss3 <- data.table(brfss3)

require(survey)
options(survey.lonely.psu="remove")
setnames(brfss1, names(brfss1[,c(58,126), with=FALSE]), c("MMRACE","CHOLCHK5"))
setnames(brfss1, names(brfss1), brfss1[, gsub("_", "", names(brfss1))])
setnames(brfss2, names(brfss2[,53, with=FALSE]), "MMRACE")
setnames(brfss2, names(brfss2), brfss2[, gsub("_", "", names(brfss2))])
setnames(brfss3, names(brfss3[,c(237,252), with=FALSE]), c("CHOLCHK5","AGEG"))
setnames(brfss3, names(brfss3), brfss3[, gsub("(^x_)|(_$)", "", names(brfss3), ignore.case=TRUE)])


#Sum number of metabolic conditions
brfss1[,METCOND:=apply(cbind(ifelse(brfss1$BPHIGH4==1, 1, 0) ,ifelse(brfss1$DIABETE3==1, 1, 0) , ifelse(brfss1$RFBMI5==2, 1, 0) ,ifelse(brfss1$TOLDHI2==1, 1, 0) ), 1, FUN=sum,na.rm=TRUE)]
#No data on BPHIGH/TOLDHI in BRFSS2 ::  names(brfss2)[grep("bphigh| diabete| rfbmi| toldhi", names(brfss2), ignore.case=TRUE)]
brfss3[,METCOND:=apply(cbind(ifelse(brfss3$BPHIGH4==1, 1, 0) ,ifelse(brfss3$DIABETE3==1, 1, 0) , ifelse(brfss3$RFBMI5==2, 1, 0) ,ifelse(brfss3$TOLDHI2==1, 1, 0) ), 1, FUN=sum,na.rm=TRUE)]

#Creating Metabolic Syndrome variable
brfss1[,METSD:=factor(ifelse(METCOND>=3,1,0), levels=c(0,1), labels=c("No", "Yes"))]
brfss3[,METSD:=factor(ifelse(METCOND>=3,1,0), levels=c(0,1), labels=c("No", "Yes"))]

#Code Race as Factor
brfss1$IMPRACE <- factor(brfss1$IMPRACE, levels=seq(1,6,1), labels=c("NH White", "NH Black", "NH Asian", "NH NA/AN", "Hispanic","NH Other"))
brfss2$IMPRACE <- factor(brfss2$IMPRACE, levels=seq(1,6,1), labels=c("NH White", "NH Black", "NH Asian", "NH NA/AN", "Hispanic","NH Other"))
brfss3$IMPRACE <- factor(brfss3$IMPRACE, levels=seq(1,6,1), labels=c("NH White", "NH Black", "NH Asian", "NH NA/AN", "Hispanic","NH Other"))

#Code Gender as Factor
brfss1$SEX <- factor(brfss1$SEX, levels=c(1,2), labels=c("Male", "Female"))
brfss2$SEX <- factor(brfss2$SEX, levels=c(1,2), labels=c("Male", "Female"))
brfss3$SEX <- factor(brfss3$SEX, levels=c(1,2), labels=c("Male", "Female"))

#Age Groups
brfss1$AGEG <- factor(brfss1$AGEG, levels=seq(1,6,1), labels=c("18-24", "25-34", "35-44", "45-54", "55-64", ">65"))
brfss2$AGEG <- factor(brfss2$AGEG, levels=seq(1,6,1), labels=c("18-24", "25-34", "35-44", "45-54", "55-64", ">65"))
brfss3$AGEG <- factor(brfss3$AGEG, levels=seq(1,6,1), labels=c("18-24", "25-34", "35-44", "45-54", "55-64", ">65"))

#YEAR VARIABLE
brfss1[,YEAR:=2011]
brfss2[,YEAR:=2012]
brfss3[,YEAR:=2013]

#Coding for adults only and "subsetting out" non-US states (Guam, PR)
brfss1[,ADLT:=ifelse(brfss1$AGE65YR == 1 | brfss1$AGE65YR == 2, 1, 0)]
brfss2[,ADLT:=ifelse(brfss2$AGE65YR == 1 | brfss2$AGE65YR == 2, 1, 0)]
brfss3[,ADLT:=ifelse(brfss3$AGE65YR == 1 | brfss3$AGE65YR == 2, 1, 0)]

#Design object specification - should take a few minutes to run
dsg1 <- svydesign(id=~PSU, strata=~STSTR, weights=~LLCPWT, data=brfss1, nest=TRUE)
dsg2 <- svydesign(id=~PSU, strata=~STSTR, weights=~LLCPWT, data=brfss2, nest=TRUE)
dsg3 <- svydesign(id=~PSU, strata=~STSTR, weights=~LLCPWT, data=brfss3, nest=TRUE)

dsub1 <- subset(dsg1, brfss1$ADLT==1 & brfss1$STATE < 57)
dsub2 <- subset(dsg2, brfss2$ADLT==1 & brfss2$STATE < 57)
dsub3 <- subset(dsg3, brfss3$ADLT==1 & brfss3$STATE < 57)

a <- svyby(~AGE, ~STATE, dsub1, svymean, na.rm.by=TRUE)
a$year <- 2011
b <- svyby(~AGE, ~STATE, dsub2, svymean, na.rm.by=TRUE)
b$year <- 2012
mages <- rbind(a,b)

save(mages,file= "meanages.rda")
#use load() to read into R ::  load("meanages.rda"); str(mages)

a1 <- as.data.frame(svytable(~AGEG+STATE+SEX+IMPRACE, dsub1, Ntotal=sum(weights(dsub1, "sampling"))))
b1 <- as.data.frame(svytable(~AGEG+STATE+SEX+IMPRACE, dsub2, Ntotal=sum(weights(dsub2, "sampling"))))
c1 <- as.data.frame(svytable(~AGEG+STATE+SEX+IMPRACE, dsub3, Ntotal=sum(weights(dsub2, "sampling"))))

a1$YEAR <- 2011; b1$YEAR <- 2012; c1$YEAR <- 2013

#Long dataset without metabolic syndrome for all 3 years
longbrfss <- rbindlist(list(a1,b1,c1))

save(longbrfss, file="brfssLONG.rda") 
### load("Data/brfssLONG.rda"); str(longbrfss)

a2 <- as.data.frame(svytable(~AGEG+STATE+SEX+IMPRACE+METSD, dsub1, Ntotal=sum(weights(dsub1, "sampling"))))
c2 <- as.data.frame(svytable(~AGEG+STATE+SEX+IMPRACE+METSD, dsub3, Ntotal=sum(weights(dsub3, "sampling"))))

a2$YEAR <- 2011 ; c2$YEAR <- 2013

#Long dataset with metabolic syndrome for 2011 and 2013 (no data for 2012)
metsyn <- rbindlist(list(a2,c2))

save(metsyn, file="metsyn1113.rda") 
### load("metsyn1113.rda"); str(metsyn)

