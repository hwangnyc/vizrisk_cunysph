/*Create Vizrisk Libname*/
libname vizrisk "C:\Users\hwang1\Dropbox\School\viz";
/*Create Vizrisk transport libnames*/
libname XP1 xport "C:\Users\hwang1\Dropbox\School\viz\data\BMX_E.xpt";
libname XP2 xport "C:\Users\hwang1\Dropbox\School\viz\data\bp.xpt";
libname XP3 xport "C:\Users\hwang1\Dropbox\School\viz\data\GLU_E.xpt";
libname XP4 xport "C:\Users\hwang1\Dropbox\School\viz\data\HDL_E.xpt";
libname XP5 xport "C:\Users\hwang1\Dropbox\School\viz\data\TRIGLY_E.xpt";
libname XP6 xport "C:\Users\hwang1\Dropbox\School\viz\data\DEMO_E.xpt";
/*Extract data to the vizrisk library*/
proc copy in = XP1 out=vizrisk; run;
proc copy in = XP2 out=vizrisk; run;
proc copy in = XP3 out=vizrisk; run;
proc copy in = XP4 out=vizrisk; run;
proc copy in = XP5 out=vizrisk; run;
proc copy in = XP6 out=vizrisk; run;
/*Sort all the values by SEQN*/
PROC SORT DATA=vizrisk.bmx_e OUT=vizrisk.bmx_e; 
  BY SEQN; 
RUN; 
PROC SORT DATA=vizrisk.bpx_e OUT=vizrisk.bpx_e; 
  BY SEQN; 
RUN; 
PROC SORT DATA=vizrisk.demo_e OUT=vizrisk.demo_e; 
  BY SEQN; 
RUN; 
PROC SORT DATA=vizrisk.glu_e OUT=vizrisk.glu_e; 
  BY SEQN; 
RUN; 
PROC SORT DATA=vizrisk.hdl_e OUT=vizrisk.hdl_e; 
  BY SEQN; 
RUN; 
PROC SORT DATA=vizrisk.trigly_e OUT=vizrisk.trigly_e; 
  BY SEQN; 
RUN; 

/*merge all datasets by ID*/
data vizrisk_merged;
merge bmx_e bpx_e demo_e glu_e hdl_e trigly_e;
by SEQN;

/*Save Dataset*/
Data vizrisk.vizrisk_merged;/*this is where you will save it to*/
Set work.vizrisk_merged; /*this is the file you want to save*/
Run;

/*Check on the merged dataset*/
proc contents data=vizrisk.vizrisk_merged;run;
 


/*Create seperate Male and Female datasets*/
DATA vizrisk.female;
  SET vizrisk.vizrisk_merged;
 IF (RIAGENDR=1) THEN delete ;
run;
DATA vizrisk.male;
  SET vizrisk.vizrisk_merged;
 IF (RIAGENDR=2) THEN delete ;
run;

/*Freqs*/
PROC SURVEYFREQ data=vizrisk.vizrisk_merged;
TABLES  RIAGENDR ; 
STRATA SDMVSTRA; 
CLUSTER SDMVPSU; 
WEIGHT WTMEC2yr ; 
RUN;

proc sort data=vizrisk.vizrisk_merged; by RIAGENDR; run;
/*Check datasets*/
PROC SURVEYFREQ data=vizrisk.vizrisk_merged;
TABLES  BMXWAIST ; by RIAGENDR;
STRATA SDMVSTRA; 
CLUSTER SDMVPSU; 
WEIGHT WTMEC2yr ; 
RUN;

PROC SURVEYFREQ data=vizrisk.female;
TABLES  BMXWAIST ; by RIAGENDR;
STRATA SDMVSTRA; 
CLUSTER SDMVPSU; 
WEIGHT WTMEC2yr ; 
RUN;

PROC SURVEYFREQ data=vizrisk.male;
TABLES  BMXWAIST ; by RIAGENDR;
STRATA SDMVSTRA; 
CLUSTER SDMVPSU; 
WEIGHT WTMEC2yr ; 
RUN;
/*Metabolic Syndrom Definactions - http://www.nhlbi.nih.gov/health/health-topics/topics/ms/diagnosis.html*/
/*Waist Circumference (>=35in, 88.9cm)  for women) (>=40in, 101.6cm) for men */
DATA vizrisk.female;
  SET vizrisk.female;
  avg_sbp_f=mean(BPXSY1,BPXSY2,BPXSY3,BPXSY4);
  avg_dbp_f=mean(BPXDI1,BPXDI2,BPXDI3,BPXDI4);
if BMXWAIST>=88.9 then MSWaist=1; *WC Risk for MS;
if BMXWAIST<88.9 then MSWaist=0; *WC Risk for MS; 
if avg_sbp_f>=130 or avg_dbp_f >=85 then MSbp=1;
if avg_sbp_f<130 and avg_dbp_f <85 then MSbp=0;
if LBDHDD<=50 then MSHDL=1;
if LBDHDD>50 then MSHDL=0;
if LBXTR>150 then MStri=1;
if LBXTR<150 then MStri=0;
if LBXGLU>=126 then MSglu=1;
if LBXGLU<126 then MSglu=0;
if mswaist=0 and msbp=0 and mshdl=0 and mstri=0 and msglu=0 then ms=0;
if mswaist=1 and msbp=1 and mshdl=1 and mstri=1 and msglu=1 then ms=1;
run; 
 DATA vizrisk.male;
  SET vizrisk.male;
  avg_sbp_m=mean(BPXSY1,BPXSY2,BPXSY3,BPXSY4);
  avg_dbp_m=mean(BPXDI1,BPXDI2,BPXDI3,BPXDI4);
if BMXWAIST>=88.9 then MSWaist=1; *WC Risk for MS;
if BMXWAIST<88.9 then MSWaist=0; *WC Risk for MS; 
if avg_sbp_m>=130 or avg_dbp_f >=85 then MSbp=1;
if avg_sbp_m<130 and avg_dbp_f <85 then MSbp=0;
if LBDHDD<=50 then MSHDL=1;
if LBDHDD>50 then MSHDL=0;
if LBXTR>150 then MStri=1;
if LBXTR<150 then MStri=0;
if LBXGLU>=126 then MSglu=1;
if LBXGLU<126 then MSglu=0;

run;      

 
PROC SURVEYFREQ data=vizrisk.female;
TABLES  ms mswaist msbp mshdl mstri msglu  ; 
STRATA SDMVSTRA; 
CLUSTER SDMVPSU; 


WEIGHT WTMEC2yr ; 
RUN;

PROC SURVEYFREQ data=vizrisk.male;
TABLES  mswaist msbp mshdl mstri msglu  ; 
STRATA SDMVSTRA; 
CLUSTER SDMVPSU; 
WEIGHT WTMEC2yr ; 
RUN;
