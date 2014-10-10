/*Merge datasets*/
data nnyfsmerged;
merge Y_demo Y_paq Y_mgx y_bmx;
by SEQN;
/*Save Dataset*/
Data epi752.demo_paq_mgx;/*this is where you will save it to*/
Set work.nnyfsmerged; /*this is the file you want to save*/
Run;

/*Rename varables*/
data epi752.demo_paq_mgx; set epi752.demo_paq_mgx;
rename 
bmicat=bmi_cat; 
run;
data epi752.demo_paq_mgx; set epi752.demo_paq_mgx;
rename MGDCGSZ=grip_combined; 
run;
data epi752.demo_paq_mgx; set epi752.demo_paq_mgx;
rename 
bmxbmi=bmi; 
run;

data epi752.demo_paq_mgxA1; /*Strated a new data file here*/ 
set epi752.demo_paq_mgxA;
gripmax_both = max(MGXH1T1,MGXH1T2,MGXH1T3MGXH2T1,MGXH2T2,MGXH2T3);run;

/*Create a Subset Males Only*/
DATA epi752.demo_paq_mgxA_Males;
  SET epi752.demo_paq_mgxA;
 IF RIAGENDR = 2 THEN DELETE ;
run;

/*Import Y_PAQ File*/
libname epi xport  "E:\EPI 752 Project\Project\Data\y_paq.xpt";   
data epi752.y_paq;  
   set epi.y_paq;  
run;
/*merge Y_PAQ file with demo_paq_mgxA */

data epi752.data_3_31;
merge epi752.Y_paq epi752.demo_paq_mgxA1;
by SEQN;
run; 
/**************************************************************************************/
/*Log Transformation of GripMax_Both*/
data epi752.demo_paq_mgxA2;
  set epi752.demo_paq_mgxA1;
log_gripmax_both = log(gripmax_both);/*Log Transformation of Grip max Both*/
log_bmi = log(bmi); /*Log Transformation of BMI*/
if 0=<paq706<=6 then paq60_min=0;/*Physical Activity Recode*/
if paq706=7 then paq60_min=1; 
if paq706=99 then paq60_min=999;
run; 

/*Import Y_BMX File*/
libname epi xport  "E:\School\EPI 752 Project\Project\Data\y_bmx.xpt";   
data epi752.y_bmx;  
   set epi.y_bmx;  
run;

/*Create New Variables*/
data epi752.demo_paq_mgxA; /*Strated a new data file here*/ 
set epi752.demo_paq_mgx;
gripmean_h1= mean(MGXH1T1,MGXH1T2,MGXH1T3); /*Average grip strength hand 1*/
gripmean_h2= mean(MGXH2T1,MGXH2T2,MGXH2T3); /*Average grip strength hand 2*/
gripmax_h1= max(MGXH1T1,MGXH1T2,MGXH1T3); /* Peak grip strength hand 1*/
gripmax_h2= max(MGXH2T1,MGXH2T2,MGXH2T3); /* Peak grip strength hand 2*/
gripmax_both = max(MGXH1T1,MGXH1T2,MGXH1T3MGXH2T1,MGXH2T2,MGXH2T3);
/*Create Average Grip Strength Both Hands*/
/*Create Peak Grip Strength Both Hands*/
run;  

DATA epi752.datafinal1; SET epi752.datafinal; 
 physicallyactive = .; 
 IF (PAQ706=7) THEN physicallyactive = 1; 
 IF (PAQ706=6) THEN physicallyactive = 0; 
 IF (PAQ706=5) THEN physicallyactive = 0; 
 IF (PAQ706=4) THEN physicallyactive = 0; 
 IF (PAQ706=3) THEN physicallyactive = 0; 
 IF (PAQ706=2) THEN physicallyactive = 0; 
 IF (PAQ706=1) THEN physicallyactive = 0; 
 IF (PAQ706=0) THEN physicallyactive = 0; 
IF (PAQ706=99) THEN physicallyactive = .; 

PAQ706_nomiss=.;
 IF (PAQ706=0) THEN PAQ706_nomiss = 0; 
 IF (PAQ706=1) THEN PAQ706_nomiss = 1; 
 IF (PAQ706=2) THEN PAQ706_nomiss = 2; 
 IF (PAQ706=3) THEN PAQ706_nomiss = 3; 
 IF (PAQ706=4) THEN PAQ706_nomiss = 4; 
 IF (PAQ706=5) THEN PAQ706_nomiss = 5; 
 IF (PAQ706=6) THEN PAQ706_nomiss = 6; 
 IF (PAQ706=7) THEN PAQ706_nomiss = 7; 
 IF (PAQ706=99) THEN PAQ706_nomiss = .;

 IF (bmi=>40) THEN bmi =.;
 IF (bmi=<12) THEN bmi =.;
 if (bmi_cat =1) then overweight =0;
 if (bmi_cat=2)then overweight =0;
 if (bmi_cat =3)  then overweight =1;
 if(bmi_cat=4)then overweight =1;
 if (bmi_cat =.) then overweight=.; 


Run;


/*Create Total Skinfolds Dataset - By Deleting varables*/
/*sum skf*/
DATA epi752.skf2; SET epi752.datafinal1; 
total_skf_add = BMXCALFf+BMXTRI+BMXSUB; 
total_cir_add = BMXCALF+BMXWAIST+BMXARMC;
log_skf_add = log(total_skf_add);
run; 

/*Male Data Set*/
DATA epi752.skf_Male; SET epi752.skf_F; 
if (RIAGENDR=2) then delete;
run; 

/*Female Data Set*/
DATA epi752.skf_female; SET epi752.skf_F; 
if (RIAGENDR=1) then delete;
run; 


data epi752.bmidataset_hw;
merge epi752.bmidataset1 epi752.Y_bmx;
by SEQN;
run; 

/*4/12/2014*/
/*Create Z scores - http://www.cdc.gov/nccdphp/dnpao/growthcharts/resources/sas.htm*/

data mydata; /*Strated a new data file here*/ 
set epi752.bmidataset_hw;
agemos= RIDAGEYR*12+6; 
if RIAGENDR= 1 then sex=(1);
if RIAGENDR = 2 then sex=(2);
if RIAGENDR =. then sex=(.); 
height= BMXHT*1;  
weight= BMXWT*1;
run; 

%include 'E:\School\EPI 752 Project\Project\Data\zscore\CDC-source-code.sas';  run;

data epi752.prodata; 
set _cdcdata;
run; 

/*Male Data Set*/
DATA epi752.Pro_Male; SET epi752.prodata; 
if (RIAGENDR=2) then delete;
run; 

/*Female Data Set*/
DATA epi752.Pro_Female; SET epi752.prodata; 
if (RIAGENDR=1) then delete;
run; 
