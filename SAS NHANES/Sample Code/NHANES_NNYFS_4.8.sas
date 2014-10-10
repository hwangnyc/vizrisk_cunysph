
/****************************************************************************/
/*																			*/
/* Data Management Project				  								    */
/* Last updated 4/8/2014 by Henry Wang										*/
/* 																			*/
/****************************************************************************/
/*Create Libname*/
libname epi752 "C:\Users\hwang1\Dropbox\School\Hunter\Spring 2014\EPI 752\Project\Data"; run; 
libname epi752 "C:\Users\hwang1\Dropbox\School-original\Hunter\Spring 2014\EPI 752\Project\4-14\EPI 752 Project\Project\Data"; run;
/****************************************************************************/
/* Data Cleaning				  								  		    */
/****************************************************************************/
/*Look at data*/
proc print data=Y_mgx; run;
/*Look at physical activity questionaire data*/
proc print data=Y_paq; run;
/*Look at sample weights and demographics data*/
proc print data=Y_demo; run;
/*Look at sample weights and demographics data*/
proc print data=Y_bmx; run;
proc freq data=epi752.demo_paq_mgxA_Males; tables RIAGENDR ; run;
/*Create a Subset Females Only*/
DATA epi752.demo_paq_mgxA_Females;
  SET epi752.demo_paq_mgxA;
 IF RIAGENDR = 1 THEN DELETE ;
run;
proc freq data=epi752.demo_paq_mgxA_females; tables RIAGENDR ; run;
/* Freqs*/
proc freq data=epi752.demo_paq_mgx; tables grip_combined ; run; 
proc freq data=epi752.demo_paq_mgx; tables bmi_cat ; run; 
proc freq data=epi752.demo_paq_mgx; tables height_cm ; run;
proc freq data=epi752.demo_paq_mgx; tables bmi ; run;
proc freq data=epi752.demo_paq_mgx; tables weight_kg ; run;
proc freq data=epi752.demo_paq_mgxA; tables gripmean_h1 ; run; 
proc freq data=epi752.demo_paq_mgxA; tables gripmean_h2 ; run;
proc freq data=epi752.demo_paq_mgxA; tables MGXH1T1 MGXH1T2 MGXH1T3 ; run;
proc freq data=epi752.demo_paq_mgxA; tables RIAGENDR ; run;
proc surveyfreq data=epi752.demo_paq_mgxA; tables riagendr; strata wtint ; weight WTMEC ; run; 

/*http://www.ats.ucla.edu/stat/sas/webbooks/reg/chapter1/sasreg1.htm*/
/*Histogram - Checking to see if the Gripmax_Both Variable is normally distrubuted*/
proc univariate data=epi752.demo_paq_mgxA;
 histogram gripmax_both;
run;
proc univariate data=epi752.demo_paq_mgxA1;
var gripmax_both; histogram / cfill=Red normal midpoints=7.5 to 55.5 by 5; run; 
proc univariate data=epi752.demo_paq_mgxA1;
var gripmax_both; histogram /  cfill=gray normal midpoints=7.5 to 55.5 by 5 kernel; run; 
/*Q-Q Plot */
proc univariate data=epi752.demo_paq_mgxA1;
  var gripmax_both ;
  qqplot / normal;
run;  
proc capability data=epi752.demo_paq_mgxA1 noprint;
  ppplot gripmax_both ;
run;

/*Check Recodes*/
proc freq data=epi752.demo_paq_mgxA2; 
tables paq60_min log_bmi log_gripmax_both ; run; 

/*******************Histograms*****************/
proc univariate data=epi752.demo_paq_mgxA2 noprint;
  var log_gripmax_both ;/*Histogram for Log Gripmax*/
  histogram / cfill=grayd0  normal kernel (color = red);
run;
proc univariate data=epi752.demo_paq_mgxA;
 histogram gripmax_h1; /* is this as normall distrubuted as you would like? - May Consider transformation*/ 
run;
proc univariate data=epi752.demo_paq_mgxA2 noprint;
  var bmi ;/*Histogram for BMI*/
  histogram / cfill=grayd0  normal kernel (color = red);
run;
proc univariate data=epi752.demo_paq_mgxA2 noprint;
  var log_bmi ;/*Histogram for Log BMI*/
  histogram / cfill=grayd0  normal kernel (color = red);
run;

/*Boxplots*/
proc sort data=epi752.demo_paq_mgxA; by RIDAGEYR; run;
proc boxplot data=epi752.demo_paq_mgxA;
plot (gripmax_h1)*RIDAGEYR ; 
run; 
/*Scatter Plots*/
proc sgplot data=epi752.demo_paq_mgxA2;
  scatter x=RIDAGEYR y=gripmax_both ;
run;
proc sgplot data=epi752.demo_paq_mgxA2;
  scatter x=bmi y=gripmax_both ; /*Gripstrength as a predictor for BMI*/
run;
/*Linear Regression with sample weights.*/
proc surveyreg  data= epi752.demo_paq_mgxA2; 
strata SDMVSTRA;  /* Use the strata statement to specify the strata (SDMVSTRA) and account for design effects of stratification.*/
cluster SDMVPSU;  /*Use the cluster statement to specify PSU (sdmvpsu) to account for design effects of clustering.*/
weight WTMEC; /*Use the weight statement to account for the unequal probability of sampling and non-response.  In this example, the MEC weight (WTMEC) is used.*/
model log_gripmax_both= RIDAGEYR /solution clparm; /*Log Gripstrength and Age*/
run;
proc surveyreg  data= epi752.demo_paq_mgxA2; 
strata SDMVSTRA;  /* Use the strata statement to specify the strata (SDMVSTRA) and account for design effects of stratification.*/
cluster SDMVPSU;  /*Use the cluster statement to specify PSU (sdmvpsu) to account for design effects of clustering.*/
weight WTMEC; /*Use the weight statement to account for the unequal probability of sampling and non-response.  In this example, the MEC weight (WTMEC) is used.*/
model log_gripmax_both= BMI /solution clparm;/*Log Gripstrength and BMI*/
run;
proc surveyreg  data= epi752.demo_paq_mgxA2; 
strata SDMVSTRA;  /* Use the strata statement to specify the strata (SDMVSTRA) and account for design effects of stratification.*/
cluster SDMVPSU;  /*Use the cluster statement to specify PSU (sdmvpsu) to account for design effects of clustering.*/
weight WTMEC; /*Use the weight statement to account for the unequal probability of sampling and non-response.  In this example, the MEC weight (WTMEC) is used.*/
model log_gripmax_both= PAQ60_min /solution clparm;/*Log Gripstrength and PA*/
run;
proc surveyreg  data= epi752.demo_paq_mgxA2; 
strata SDMVSTRA;  /* Use the strata statement to specify the strata (SDMVSTRA) and account for design effects of stratification.*/
cluster SDMVPSU;  /*Use the cluster statement to specify PSU (sdmvpsu) to account for design effects of clustering.*/
weight WTMEC; /*Use the weight statement to account for the unequal probability of sampling and non-response.  In this example, the MEC weight (WTMEC) is used.*/
model log_gripmax_both= RIDAGEYR /solution clparm;/*Log Gripstrength and Age*/
run;
/**Means**/
PROC SURVEYMEANS 
data= epi752.demo_paq_mgxA_Males; 
strata SDMVSTRA; 
cluster SDMVPSU;  
weight WTMEC;
domain  RIDAGEYR ; 
var gripmean_h1 gripmean_h2 gripmax_h1 gripmax_h2; /*grip means*/
run;
PROC SURVEYMEANS 
data= epi752.demo_paq_mgxA_females; 
strata SDMVSTRA; 
cluster SDMVPSU;  
weight WTMEC;
domain  RIDAGEYR ; 
var gripmean_h1 gripmean_h2 gripmax_h1 gripmax_h2; /**Means - Females By Age*/
run;
/*Check Means without sample weights - Just to see the numbers you get*/
/*ANOVA*/
PROC ANOVA DATA = epi752.demo_paq_mgxA;
	class RIDAGEYR;
	model gripmax_h1 = RIDAGEYR;
	means RIDAGEYR / TUKEY; /*Requesting TUKEY Method*/ 
	where RIAGENDR = 1; 
RUN;
QUIT;

proc surveyreg
data= epi752.demo_paq_mgxA;
strata SDMVSTRA; 
cluster SDMVPSU;  
weight WTMEC;
model gripmax_h1 = RIDAGEYR /anova;
run;
proc sort data=epi752.Demo_paq_mgxa2; by SEQN; run;
proc sort data=epi752.Y_paq; by SEQN; run;
data epi752.datafinal;
merge epi752.Demo_paq_mgxa2 epi752.Y_paq;
by SEQN;
run; 
proc freq data=epi752.datafinal; tables PAQ706  ; run;
proc freq data=epi752.datafinal1; tables physicallyactive  ; run;
proc freq data=epi752.datafinal1; tables gripstrength  ; run;
proc surveyreg  data= epi752.datafinal1;
strata SDMVSTRA;  
cluster SDMVPSU;  
weight WTMEC; 
model gripmax_both = PAQ706 /solution clparm; 
run;
proc surveyreg  data= epi752.datafinal1;
strata SDMVSTRA;  
cluster SDMVPSU;  
weight WTMEC; 
model PAQ706= physicallyactive /solution clparm; 
run;
proc surveyreg  data= epi752.datafinal1;
strata SDMVSTRA;  
cluster SDMVPSU;  
weight WTMEC; 
model bmi= PAQ706/solution clparm; 
run;

/*Histrogram*/
proc univariate data=epi752.datafinal1;
 histogram paq706;
run;
/*Scatter plots*/
proc sgplot data=epi752.datafinal1;
  scatter x=PAQ706_nomiss y=bmi / group=RIAGENDR; 
run;

proc sgplot data=epi752.datafinal1;
  scatter x=PAQ706_nomiss y=gripmax_both / group=RIAGENDR; 
run;

proc sgplot data=epi752.datafinal1;
  scatter x=physicallyactive y=bmi / group=RIAGENDR; 
run;

/*Model BMI vs physically active yes no*/

proc surveyreg  data= epi752.datafinal1;
strata SDMVSTRA;  
cluster SDMVPSU;  
weight WTMEC; 
model bmi= physicallyactive/solution clparm; 
run;

proc surveyreg  data= epi752.datafinal1;
strata SDMVSTRA;  
cluster SDMVPSU;  
weight WTMEC; 
model bmi= gripmax_both/solution clparm; 
run;

/*Histrogram for BMI*/
proc univariate data=epi752.datafinal1;
var bmi; histogram /  cfill=gray normal midpoints=7.5 to 55.5 by 5 kernel; run; 



/*Histrogram for BMI*/
proc univariate data=epi752.bmidataset;
var bmi; histogram /  cfill=gray normal midpoints=12.5 to 37 by 1 kernel; run; 

proc univariate data=epi752.y_bmx;
var BMDBMIC; histogram /  cfill=gray normal midpoints=1 to 4 by 1 kernel; run;
proc univariate data=epi752.bmidataset;
var overweight; histogram /  cfill=gray normal midpoints=0 to 1 by 1 kernel; run;

/*QQ Plots*/
proc univariate data=epi752.bmidataset;
  var bmi ;
  qqplot / normal;
run;  
DATA epi752.bmidataset;
  SET epi752.datafinal1;
  log_bmi = log(bmi);
run;

proc univariate data=epi752.bmidataset noprint;
  var log_bmi ;
  histogram / cfill=grayd0  normal kernel (color = red);
run;

proc univariate data=epi752.bmidataset;
  var log_bmi ;
  qqplot / normal;
run; 

proc surveyreg  data= epi752.datafinal1;
strata SDMVSTRA;  
cluster SDMVPSU;  
weight WTMEC; 
model log_bmi= physicallyactive/solution clparm; 
run;

proc surveyreg  data= epi752.datafinal1;
strata SDMVSTRA;  
cluster SDMVPSU;  
weight WTMEC; 
class physicallyactive;
model bmi= physicallyactive/solution clparm; 
run;


proc surveyreg  data= epi752.datafinal1;
strata SDMVSTRA;  
cluster SDMVPSU;  
weight WTMEC; 
model log_gripmax_both= physicallyactive/solution clparm; 
run;

proc surveyreg  data= epi752.datafinal1;
strata SDMVSTRA;  
cluster SDMVPSU;  
weight WTMEC; 
model gripmax_both= physicallyactive/solution clparm; 
run;

proc freq data=epi752.datafinal1; tables PAQ706 physicallyactive; run; 


proc surveyreg  data= epi752.datafinal1;
strata SDMVSTRA;  
cluster SDMVPSU;  
weight WTMEC; 
class physicallyactive;
model gripmax_both= physicallyactive/solution clparm;
run;


/*Analysis*/

PROC SURVEYFREQ data=epi752.bmidataset;
TABLES  bmi_CAT overweight ; 
STRATA SDMVSTRA; 
CLUSTER SDMVPSU; 
WEIGHT WTMEC ; 
RUN;

PROC SURVEYFREQ data=epi752.bmidataset;
TABLES  physicallyactive*overweight; 
STRATA SDMVSTRA; 
CLUSTER SDMVPSU; 
WEIGHT WTMEC ; 
RUN;

PROC SURVEYLOGISTIC data=epi752.bmidataset;
Class physicallyactive /param=ref; 
Model overweight = physicallyactive ; 
STRATA SDMVSTRA; 
CLUSTER SDMVPSU; 
WEIGHT WTMEC ; 
RUN;

PROC SURVEYLOGISTIC data=epi752.bmidataset1; 
Model overweight (descending) = physicallyactive ; 
STRATA SDMVSTRA; 
CLUSTER SDMVPSU; 
WEIGHT WTMEC ; 
RUN;

/*This one may be it!*/

data epi752.bmidataset1; /*Strated a new data file here*/ 
set epi752.bmidataset;
total_SKF= sum (BMXSUB,BMXTRI,BMXCALFF); 
drop total_SKF; 
run; 
/*Means*/
proc sort data=epi752.bmidataset1; by RIAGENDR; run;
Proc Surveymeans data=epi752.bmidataset1
 mean STDERR median min max;
VAR bmi RIDAGEYR RIDEXAGY BMXARMC BMXWAIST BMXCALF BMXCALFF BMXTRI BMXSUB;
by RIAGENDR;
STRATA SDMVSTRA; 
CLUSTER SDMVPSU; 
RUN;

Proc Surveymeans data=epi752.bmidataset1
 mean STDERR median min max;
VAR BMXWAIST;
STRATA SDMVSTRA; 
CLUSTER SDMVPSU; 
RUN;

/*Freqs*/
PROC SURVEYFREQ data=epi752.bmidataset;
TABLES  physicallyactive PAQ706 overweight bmi_cat RIDRETH1; 
STRATA SDMVSTRA; 
CLUSTER SDMVPSU; 
WEIGHT WTMEC ; 
RUN;

PROC SURVEYFREQ data=epi752.bmidataset;
TABLES  BMXWAIST; 
STRATA SDMVSTRA; 
CLUSTER SDMVPSU; 
WEIGHT WTMEC ; 
RUN;

/*Chi Square*/
PROC SURVEYFREQ data=epi752.bmidataset;
TABLES physicallyactive*overweight/row CHISQ;
STRATA SDMVSTRA; 
CLUSTER SDMVPSU; 
WEIGHT WTMEC ; 
RUN;


PROC SURVEYLOGISTIC data=epi752.bmidataset1; 
CLASS physicallyactive (ref="Active") /param=ref ; /* */
MODEL overweight (event='overweight') = physicallyactive ; 
domain RIAGENDR;
STRATA SDMVSTRA; 
CLUSTER SDMVPSU; 
WEIGHT WTMEC ; 
RUN;


/**/
PROC SURVEYLOGISTIC data=epi752.bmidataset1;  
CLASS PAQ706(param=ref ref='7') ; 
MODEL overweight (descending) = PAQ706 RIDAGEYR ; 
domain RIAGENDR;
STRATA SDMVSTRA; 
CLUSTER SDMVPSU; 
WEIGHT WTMEC ; 
RUN;


PROC SURVEYLOGISTIC data=epi752.bmidataset1; 
CLASS physicallyactive/ param=ref ; 
MODEL overweight (descending) = physicallyactive RIDAGEYR; 
domain RIAGENDR;
STRATA SDMVSTRA; 
CLUSTER SDMVPSU; 
WEIGHT WTMEC ; 
RUN;

PROC SURVEYLOGISTIC data=epi752.bmidataset1; 
CLASS physicallyactive (ref="Active") /param=ref ; 
MODEL overweight (event='overweight') = physicallyactive ; 
domain RIAGENDR;
STRATA SDMVSTRA; 
CLUSTER SDMVPSU; 
WEIGHT WTMEC ; 
RUN;
/*Histrogram for WC*/
proc univariate data=epi752.datafinal1;
var BMXWAIST; histogram /  cfill=gray normal midpoints=7.5 to 55.5 by 5 kernel; run; 

/*Linear Regression*/
/*Waist Circumference*/
proc surveyreg  data= epi752.datafinal1;
strata SDMVSTRA;  
cluster SDMVPSU;  
weight WTMEC; 
CLASS physicallyactive (ref="Active") /param=ref ; 
model BMXWAIST= physicallyactive RIDAGEYR/solution clparm;
run;

/*Arm Circumference*/
proc surveyreg  data= epi752.datafinal1;
strata SDMVSTRA;  
cluster SDMVPSU;  
weight WTMEC; 
CLASS BMXARMC (ref="Active") /param=ref ; 
model BMXARMC= physicallyactive RIDAGEYR/solution clparm;
run;

/*Subscapular*/
proc surveyreg  data= epi752.datafinal1;
strata SDMVSTRA;  
cluster SDMVPSU;  
weight WTMEC; 
CLASS physicallyactive (ref="Active") /param=ref ; 
model BMXSUB= physicallyactive RIDAGEYR/solution clparm;
run;

/*Tricep*/
proc surveyreg  data= epi752.datafinal1;
strata SDMVSTRA;  
cluster SDMVPSU;  
weight WTMEC; 
CLASS physicallyactive (ref="Active") /param=ref ; 
model BMXTRI= physicallyactive RIDAGEYR/solution clparm;
run;
/*Calf*/
proc surveyreg  data= epi752.datafinal1;
strata SDMVSTRA;  
cluster SDMVPSU;  
weight WTMEC; 
CLASS physicallyactive (ref=" Not Active") /param=ref ; 
model BMXCALFF= physicallyactive RIDAGEYR/solution clparm;
run;

proc surveyreg  data= epi752.datafinal1;
strata SDMVSTRA;  
cluster SDMVPSU;  
weight WTMEC; 
model BMXCALFF= physicallyactive RIDAGEYR/solution clparm;
run;

/*Frequencies - Skinfolds*/
proc surveyfreq data=epi752.skf_F; 
tables total_skf_add ; strata wtint ; weight WTMEC ; run; 
/*Means - Skinfolds*/
PROC SURVEYMEANS 
data= epi752.skf; 
strata SDMVSTRA; 
cluster SDMVPSU;  
weight WTMEC;
domain  RIDAGEYR ; 
var BMXCALFF BMXTRI BMXSUB;
run;
PROC SURVEYMEANS 
data= epi752.datafinal1; 
strata SDMVSTRA; 
cluster SDMVPSU;  
weight WTMEC; 
var BMXCALFF BMXTRI BMXSUB;
run;


PROC SURVEYMEANS 
data= epi752.skf2; 
strata SDMVSTRA; 
cluster SDMVPSU;  
weight WTMEC;
var total_skf;
run;

PROC SURVEYMEANS 
data= epi752.skf_F; 
strata SDMVSTRA; 
cluster SDMVPSU;  
weight WTMEC;
var BMXCALFF BMXTRI BMXSUB total_skf_add ;
run;

/*Histrogram for total skinfolds*/
proc univariate data=epi752.skf_F;
var total_skf_add; histogram /  cfill=gray normal midpoints=12 to 110 by 5 kernel; run; 

proc univariate data=epi752.skf_F;
var log_skf_add; histogram /  cfill=gray normal midpoints=1 to 6 by .1 kernel; run; 


proc surveyreg  data= epi752.skf_F;
strata SDMVSTRA;  
cluster SDMVPSU;  
weight WTMEC; 
model log_skf_add= physicallyactive RIDAGEYR/solution clparm;
run;

proc surveyreg  data= epi752.skf_F;
strata SDMVSTRA;  
cluster SDMVPSU;  
weight WTMEC; 
model total_skf_add= physicallyactive RIDAGEYR/solution clparm;
run;


proc surveymeans data = epi752.skf_F;
strata SDMVSTRA;  
cluster SDMVPSU;  
weight WTMEC; 
domain RIAGENDR;
var total_skf_add;
run;

proc surveyreg data = epi752.skf_F;
strata SDMVSTRA;  
cluster SDMVPSU;  
model total_skf_add = physicallyactive;
domain RIAGENDR
weight WTMEC; 
run; 
 
proc surveyreg data=epi752.skf_F; 
strata SDMVSTRA;  
cluster SDMVPSU;  
weight WTMEC; 
 class RIAGENDR; 
 model total_skf_add=physicallyactive  RIAGENDR RIDAGEYR / solution; 
run; 
/*Means of Males and Females on total skinfold*/
proc surveymeans data=epi752.skf_F ;
strata SDMVSTRA;  
cluster SDMVPSU;
   var total_skf_add;
   domain RIAGENDR; 
weight WTMEC; 
run;

/*Comparing means*/
/*http://support.sas.com/documentation/cdl/en/statug/63347/HTML/default/viewer.htm#statug_surveyreg_a0000000315.htm*/
proc surveyreg data=epi752.skf_F ;
strata SDMVSTRA;  
cluster SDMVPSU;
   class RIAGENDR;
   model total_skf_add = RIAGENDR / vadjust=none;
   lsmeans RIAGENDR / diff;
weight WTMEC; 
run;


proc surveyreg data=epi752.skf_F ;
strata SDMVSTRA;  
cluster SDMVPSU;
   class RIAGENDR;
  model total_skf_add = RIAGENDR /solution vadjust=none;
weight WTMEC; 
run;

/*Table 1*/
/*How mayn males and females are physically active*/
PROC SURVEYFREQ data=epi752.bmidataset;
TABLES  RIAGENDR * physicallyactive;
STRATA SDMVSTRA; 
CLUSTER SDMVPSU; 
WEIGHT WTMEC ; 
RUN;



proc surveymeans data=epi752.skf_F  
mean stderr median min max std; 
strata SDMVSTRA;  
cluster SDMVPSU;
   var total_skf_add;
   domain RIAGENDR; 
weight WTMEC; 
run;
/*Males Only*/
/*Skinfolds */
proc surveymeans data=epi752.skf_Male  
all mean stderr median min max std; 
strata SDMVSTRA;  
cluster SDMVPSU;
   var total_skf_add;
   domain RIDAGEYR ; 
weight WTMEC; 
run;
/*WC*/
proc surveymeans data=epi752.skf_Male  
all mean stderr median min max std; 
strata SDMVSTRA;  
cluster SDMVPSU;
   var BMXWAIST;
   domain RIDAGEYR ; 
weight WTMEC; 
run;


/*Skinfolds Females Only*/
proc surveymeans data=epi752.skf_female 
all mean stderr median min max std; 
strata SDMVSTRA;  
cluster SDMVPSU;
   var total_skf_add;
   domain RIDAGEYR ; 
weight WTMEC; 
run;

/*WC*/
proc surveymeans data=epi752.skf1  
all mean stderr median min max std; 
strata SDMVSTRA;  
cluster SDMVPSU;
   var RIDAGEYR weight_kg height_cm bmi BMXARMC BMXWAIST BMXCALF BMXCALFF BMXTRI BMXSUB;
   domain RIAGENDR;
weight WTMEC; 
run;


proc univariate data=epi752.prodata noprint;
  var bmiz ;/*Histogram for BMI zscores*/
  histogram / cfill=grayd0  normal kernel (color = red);
run;

proc surveyreg  data= epi752.prodata;
strata SDMVSTRA;  
cluster SDMVPSU;  
weight WTMEC; 
model bmiz= physicallyactive/solution clparm;
run;

proc surveymeans data=epi752.prodata  
all mean stderr median min max std; 
strata SDMVSTRA;  
cluster SDMVPSU;
   var bmiz;
   domain RIAGENDR;
weight WTMEC; 
run;

proc surveymeans data=epi752.skf2  
all mean stderr median min max std; 
strata SDMVSTRA;  
cluster SDMVPSU;
   var 
total_skf_add
total_cir_add;
   domain RIAGENDR;
weight WTMEC; 
run;

total_skf_add = BMXCALFf+BMXTRI+BMXSUB; 
total_cir_add = BMXCALF+BMXWAIST+BMXARMC;
log_skf_add = log(total_skf_add);
run; 

proc univariate data=epi752.prodata;
 histogram total_skf_add;
run;
