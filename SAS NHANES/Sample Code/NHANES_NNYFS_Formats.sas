

/*Physically active vs. Overweight obese*/
/*4/4/2014*/
proc format;
value physicallyactiveF
0="Not Active"
1="Active";

value overweightF
1="Normal"
0="Overweight";

format
physicallyactive physicallyactiveF.
overweight overweightf.;
run;
