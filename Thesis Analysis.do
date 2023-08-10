//Change working directory
//Start a log file
//Import data set 

 
********************************************************************************
*                             Missing Variables                                *
********************************************************************************
//Missing values for all variables
tab studentloan_amount if studentloan2020==1, m
tab stress_amountowe if studentloan2020==1, m 
tab expectedsalary2020 if studentloan2020==1, m
tab collegegoodinvestment if studentloan2020==1, m 
tab age2 if studentloan2020==1, m
tab yearschool if studentloan2020==1, m
tab gender_combined if studentloan2020==1, m
tab race_combined if studentloan2020==1, m
tab employmentstatus2020 if studentloan2020==1, m
tab financialaidcounselor_never if studentloan2020==1, m
tab financialaidcounselor_beforecoll if studentloan2020==1, m
tab financialaidcounselor_college if studentloan2020==1, m 
tab financialclass2020_highschool if studentloan2020==1, m 
tab financialclass2020_onetime_co if studentloan2020==1, m
tab financialclass2020_reoccuring_co if studentloan2020==1, m
tab expenses2020_parentincome if studentloan2020==1, m 
tab expenses2020_moneyborrowed if studentloan2020==1, m 
tab expenses2020_scholarshipsgrants if studentloan2020==1, m
tab expenses2020_moneyfromjob if studentloan2020==1, m
tab expenses2020_moneyfromsavings if studentloan2020==1, m
tab expenses2020_creditcards if studentloan2020==1, m
tab expenses2020_employeredbenefit if studentloan2020==1, m
tab expenses2020_militaryveteranbene if studentloan2020==1, m
tab studentloan_type if studentloan2020==1, m
tab finknowledge_SCORE if studentloan2020==1, m

********************************************************************************
*                               Cleaning Data                                  *
********************************************************************************

***************************** Student loan amount ******************************
//Obtaining current student loan amount
codebook studentloan_amount
describe studentloan_amount
tabulate studentloan_amount, missing

//Cleaning student loan amount
generate studentloan_amount2=studentloan_amount
replace studentloan_amount2=. if studentloan_amount==-99
replace studentloan_amount2=. if studentloan_amount==8
label variable studentloan_amount2 "Q33 Cleaned current student loan amount"
label define loanamount3 1"1.$1-$9,999"2"2.$10,000-$19,999"3"3.$20,000-$29,999"4"4.$30,000-$39,999"5"5.$40,000-$49,999"6"6.$50,000-$59,999"7"7.$60,000+"
label values studentloan_amount2 loanamount3
tabulate studentloan_amount2, missing
sum studentloan_amount2, d
codebook studentloan_amount


//Combining student loan amounts 
generate loancomb=.
replace loancomb=1 if studentloan_amount2<=2
replace loancomb=3 if studentloan_amount2>=3&studentloan_amount2<=7
label variable loancomb "current student loans combined"
label define studentloancategory 1"1.Low ($1-$19,999)"3"2.High ($20,000+)"
label values loancomb studentloancategory
tabulate loancomb, missing

***************************** Stress from debt *********************************
//Obtaining stress from debt
codebook stress_amountowe
describe stress_amountowe
tab stress_amountowe

//Cleaning stress from debt
generate stress_amountowe2=stress_amountowe
replace stress_amountowe2=. if stress_amountowe==-99
label variable stress_amountowe2 "Q46 Cleaned current stress data"
label define stressamount 1"1.None"2"2.Small Amount"3"3.Medium Amount"4"4.Large Amount"5"5.Extreme Amount"
label values stress_amountowe2 stressamount
tabulate stress_amountowe2, missing

//Combining stress from debt
generate stresscomb=.
replace stresscomb=1 if stress_amountowe2<=2
replace stresscomb=2 if stress_amountowe2>=3&stress_amountowe2<=5
label variable stresscomb "current stress combined"
label define stresscategory 1"1.Low Stress"2"2.High Stress"
label values stresscomb stresscategory
tabulate stresscomb, missing

***************************** Expected salary **********************************
//Obtaining expected salary
codebook expectedsalary2020
describe expectedsalary2020
tab expectedsalary2020

//Cleaning expected salary 
generate expectedsalary2=expectedsalary2020
replace expectedsalary2=. if expectedsalary2020==-99
replace expectedsalary2=0 if expectedsalary2020==1
replace expectedsalary2=0 if expectedsalary2020==2
replace expectedsalary2=7500 if expectedsalary2020==3
replace expectedsalary2=22500 if expectedsalary2020==4
replace expectedsalary2=35000 if expectedsalary2020==5
replace expectedsalary2=50000 if expectedsalary2020==6
replace expectedsalary2=70000 if expectedsalary2020==7
replace expectedsalary2=90000 if expectedsalary2020==8
replace expectedsalary2=100000 if expectedsalary2020==9
label variable expectedsalary2 "Q54 Cleaned expected salary"
tab expectedsalary2, missing
label define salary4 0"$0"7500"$7,500"22500"$22,500"35000"$35,000"50000"$50,000"70000"$70,000"90000"$90,000"100000"$100,000"
label values expectedsalary2 salary4
tab expectedsalary2, missing

***************************** Age **********************************************
//Obtaining age categorized
codebook age2
describe age2
tab age2, m

***************************** Year in school ***********************************
//Obtaining year in school
codebook yearschool
describe yearschool
tab yearschool, missing

//Cleaning year in school
generate yearschool2=yearschool
replace yearschool2=. if yearschool==-99
replace yearschool2=. if yearschool==6
label variable yearschool2 "Q2 Cleaned year in school"
tab yearschool2, missing
label define schoolyear 1"1.First-year undergraduate"2"2.Second-year undergraduate"3"3.Third-year undergraduate"4"4.Fourth-year undergraduate"5"5.Fifth-year or beyond undergraduate"
label values yearschool2 schoolyear
tab yearschool2, missing

***************************** Gender *******************************************
//Obtaining gender
codebook gender_combined
describe gender_combined
tab gender_combined, missing

//Creating dummy for gender
tab gender_combined, missing
gen gender2=.
replace gender2=1 if gender_combined==3
replace gender2=0 if gender_combined==6
label var gender2 "Q4 Dummy gender variable"
label define gen2 0"0.Female"1"1.Male"
label values gender2 gen2
tab gender2, missing

***************************** Race *********************************************
//Obtaining race
codebook race_combined
describe race_combined
tab race_combined, missing

//Creating categorical variable for race
gen racecat=.
replace racecat=1 if race_combined==7
replace racecat=2 if race_combined==1
replace racecat=3 if race_combined==2
replace racecat=4 if race_combined==4
replace racecat=5 if race_combined==8
replace racecat=6 if race_combined==9|race_combined==3|race_combined==5|race_combined==6
replace racecat=. if race_combined==10
label variable racecat "Q5 Constructed race"
label define catrace 1"1.White or European American"2"2.Asian or Asian American"3"3.Black or African American"4"4.Hispanic or Latinx"5"5.More than one race or ethnicity"6"6.Other"
label values racecat catrace
tab racecat, missing

//Creating dummy for White or European American
tab racecat, missing
generate racewhite=.
replace racewhite=1 if racecat==1
replace racewhite=0 if racecat>=2&racecat<=6
label variable racewhite "Q5 Dummy race-white"
label define whiterace 0"0.No"1"1.Yes"
label values racewhite whiterace
tab racewhite, missing

//Creating dummy for Asian or Asian American
tab racecat, missing
generate raceasian=.
replace raceasian=1 if racecat==2
replace raceasian=0 if racecat==1|racecat>=3&racecat<=6
label variable raceasian "Q5 Dummy race-asian"
label define asianrace 0"0.No"1"1.Yes"
label values raceasian asianrace
tab raceasian, missing

//Creating dummy for Black or African American
tab racecat, missing
generate raceblack=.
replace raceblack=1 if racecat==3
replace raceblack=0 if racecat==1|racecat==2|racecat>=4&racecat<=6
label variable raceblack "Q5 Dummy race-black"
label define blackrace 0"0.No"1"1.Yes"
label values raceblack blackrace
tab raceblack, missing

//Creating dummy for Hispanic or Latinx
tab racecat, missing
generate racehispanic=.
replace racehispanic=1 if racecat==4
replace racehispanic=0 if racecat>=1&racecat<=3|racecat==5|racecat==6
label variable racehispanic "Q5 Dummy race-hispanic"
label define hispanicrace 0"0.No"1"1.Yes"
label values racehispanic hispanicrace
tab racehispanic, missing

//Creating dummy for More than one race or ethnicity
tab racecat, missing
generate racemixed=.
replace racemixed=1 if racecat==5
replace racemixed=0 if racecat>=1&racecat<=4|racecat==6
label variable racemixed "Q5 Dummy race-mixed"
label define mixedrace 0"0.No"1"1.Yes"
label values racemixed mixedrace
tab racemixed, missing

//Creating dummy for Other
tab racecat, missing
generate raceother=.
replace raceother=1 if racecat==6
replace raceother=0 if racecat>=1&racecat<=5
label variable raceother "Q5 Dummy race-other"
label define otherrace 0"0.No"1"1.Yes"
label values raceother otherrace
tab raceother, missing

***************************** Employment status ********************************
//Obtaining employment status
codebook employmentstatus2020
describe employmentstatus2020
tab employmentstatus2020, missing

//Cleaning employment status
generate employmentstatus2=employmentstatus2020
replace employmentstatus2=. if employmentstatus2020==-99
label variable employmentstatus2 "Q21 Cleaned employment status"
label define employ 0"0.No"1"1.Yes"
label values employmentstatus2 employ
tab employmentstatus2, missing

***************************** Financial aid counselor **************************
//Obtaining financial aid counselor-never
codebook financialaidcounselor_never
describe financialaidcounselor_never
tab financialaidcounselor_never, missing

//Cleaning financial aid counselor-never
generate financialaidcounselor_never2=financialaidcounselor_never
replace financialaidcounselor_never2=. if financialaidcounselor_never==-99
label variable financialaidcounselor_never2 "Q8 Cleaned financial aid counselor-never"
label define finnever2 0"0"1"1.Never"
label values financialaidcounselor_never2 finnever2
tab financialaidcounselor_never2, missing

//Obtaining financial aid counselor-before college
codebook financialaidcounselor_beforecoll
describe financialaidcounselor_beforecoll
tab financialaidcounselor_beforecoll, missing

//Cleaning financial aid counselor-before college
generate financialaidcounselor_beforeco2=financialaidcounselor_beforecoll
replace financialaidcounselor_beforeco2=. if financialaidcounselor_beforecoll==-99
label variable financialaidcounselor_beforeco2 "Q8 Cleaned financial aid counselor-before college"
label define finbc2 0"0"1"1.Before entering college"
label values financialaidcounselor_beforeco2 finbc2
tab financialaidcounselor_beforeco2, missing

//Obtaining financial aid counselor-college
codebook financialaidcounselor_college
describe financialaidcounselor_college
tab financialaidcounselor_college, missing

//Cleaning financial aid counselor-college
generate financialaidcounselor_college2=financialaidcounselor_college
replace financialaidcounselor_college2=. if financialaidcounselor_college==-99
label variable financialaidcounselor_college2 "Q8 Cleaned financial aid counselor-college"
label define fincollege2 0"0"1"1.Since entering college"
label values financialaidcounselor_college2 fincollege2
tab financialaidcounselor_college2, missing

***************************** Financial knowledge ******************************
//Obtaining financial knowledge score (already cleaned)
codebook finknowledge_SCORE
describe finknowledge_SCORE
tab finknowledge_SCORE, missing

***************************** Financial class **********************************

//Obtaining financial class-high school
codebook financialclass2020_highschool
describe financialclass2020_highschool
tab financialclass2020_highschool, missing

//Cleaning financial class-high school
generate financialclass2020_highschool2=financialclass2020_highschool
replace financialclass2020_highschool2=. if financialclass2020_highschool==-99
label variable financialclass2020_highschool2 "Q9 Cleaned financial class-high school"
label define fchs 0"0.No"1"1.Yes"
label values financialclass2020_highschool2 fchs
tab financialclass2020_highschool2, missing

//Obtaining financial class-reoccuring in college
codebook financialclass2020_reoccuring_co
describe financialclass2020_reoccuring_co
tab financialclass2020_reoccuring_co, missing

//Cleaning financial class-reoccuring in college
generate financialclass2020_reoccuringco2=financialclass2020_reoccuring_co
replace financialclass2020_reoccuringco2=. if financialclass2020_reoccuring_co==-99
label variable financialclass2020_reoccuringco2 "Q9 Cleaned financial class-reoccuring in college"
label define fcrc 0"0.No"1"1.Yes"
label values financialclass2020_reoccuringco2 fcrc
tab financialclass2020_reoccuringco2, missing

//Obtaining financial class-onetime in college
codebook financialclass2020_onetime_colle
describe financialclass2020_onetime_colle
tab financialclass2020_onetime_colle, missing

//Cleaning financial class-onetime in college
generate financialclass2020_onetimeco2=financialclass2020_onetime_colle
replace financialclass2020_onetimeco2=. if financialclass2020_onetime_colle==-99
label variable financialclass2020_onetimeco2 "Q9 Cleaned financial class-onetime in college"
label define fcoc 0"0.No"1"1.Yes"
label values financialclass2020_onetimeco2 fcoc
tab financialclass2020_onetimeco2, missing

***************************** College expenses source **************************

//Obtaining expenses-parentincome
codebook expenses2020_parentincome
describe expenses2020_parentincome
tab expenses2020_parentincome

//Cleaning expenses-parent income
generate expenses2020_parentincome2=expenses2020_parentincome
replace expenses2020_parentincome2=. if expenses2020_parentincome==-99
label variable expenses2020_parentincome2 "Q29 Cleaned expenses-parent income"
label define epi 1"1.None"2"2.Some"3"3.Most"4"4.All"
label values expenses2020_parentincome2 epi
tab expenses2020_parentincome2, missing

//Obtaining expenses-money borrowed
codebook expenses2020_moneyborrowed
describe expenses2020_moneyborrowed
tab expenses2020_moneyborrowed

//Cleaning expenses-money borrowed
generate expenses2020_moneyborrowed2=expenses2020_moneyborrowed
replace expenses2020_moneyborrowed2=. if expenses2020_moneyborrowed==-99
label variable expenses2020_moneyborrowed2 "Q29 Cleaned expenses-money borrowed"
label define emb 1"1.None"2"2.Some"3"3.Most"4"4.All"
label values expenses2020_moneyborrowed2 emb
tab expenses2020_moneyborrowed2, missing

//Obtaining expenses-scholarship grants
codebook expenses2020_scholarshipsgrants
describe expenses2020_scholarshipsgrants
tab expenses2020_scholarshipsgrants

//Cleaning expenses-scholarship grants
generate expenses2020_scholarshipsgrants2=expenses2020_scholarshipsgrants
replace expenses2020_scholarshipsgrants2=. if expenses2020_scholarshipsgrants==-99
label variable expenses2020_scholarshipsgrants2 "Q29 Cleaned expenses-scholarship grants"
label define esg 1"1.None"2"2.Some"3"3.Most"4"4.All"
label values expenses2020_scholarshipsgrants2 esg
tab expenses2020_scholarshipsgrants2, missing

//Obtaining expenses-money from job
codebook expenses2020_moneyfromjob
describe expenses2020_moneyfromjob
tab expenses2020_moneyfromjob

//Cleaning expenses-money from job
generate expenses2020_moneyfromjob2=expenses2020_moneyfromjob
replace expenses2020_moneyfromjob2=. if expenses2020_moneyfromjob==-99
label variable expenses2020_moneyfromjob2 "Q29 Cleaned expenses-money from job"
label define emj 1"1.None"2"2.Some"3"3.Most"4"4.All"
label values expenses2020_moneyfromjob2 emj
tab expenses2020_moneyfromjob2, missing

//Obtaining expenses-money from savings
codebook expenses2020_moneyfromsavings
describe expenses2020_moneyfromsavings
tab expenses2020_moneyfromsavings

//Cleaning expenses-money from savings
generate expenses2020_moneyfromsavings2=expenses2020_moneyfromsavings
replace expenses2020_moneyfromsavings2=. if expenses2020_moneyfromsavings==-99
label variable expenses2020_moneyfromsavings2 "Q29 Cleaned expenses-money from savings"
label define ems 1"1.None"2"2.Some"3"3.Most"4"4.All"
label values expenses2020_moneyfromsavings2 ems
tab expenses2020_moneyfromsavings2, missing

//Obtaining expenses-credit cards
codebook expenses2020_creditcards
describe expenses2020_creditcards
tab expenses2020_creditcards

//Cleaning expenses-credit cards
generate expenses2020_creditcards2=expenses2020_creditcards
replace expenses2020_creditcards2=. if expenses2020_creditcards==-99
label variable expenses2020_creditcards2 "Q29 Cleaned expenses-credit cards"
label define ecc 1"1.None"2"2.Some"3"3.Most"4"4.All"
label values expenses2020_creditcards2 ecc
tab expenses2020_creditcards2, missing

//Obtaining expenses-employer benefits
codebook expenses2020_employeredbenefit
describe expenses2020_employeredbenefit
tab expenses2020_employeredbenefit

//Cleaning expenses-employer benefits
generate expenses2020_employeredbenefit2=expenses2020_employeredbenefit
replace expenses2020_employeredbenefit2=. if expenses2020_employeredbenefit==-99
label variable expenses2020_employeredbenefit2 "Q29 Cleaned expenses-employer benefits"
label define eeb 1"1.None"2"2.Some"3"3.Most"4"4.All"
label values expenses2020_employeredbenefit2 eeb
tab expenses2020_employeredbenefit2, missing

//Obtaining expenses-military benefits
codebook expenses2020_militaryveteranbene
describe expenses2020_militaryveteranbene
tab expenses2020_militaryveteranbene

//Cleaning expenses-military benefits
generate expenses2020_militarybenefits2=expenses2020_militaryveteranbene
replace expenses2020_militarybenefits2=. if expenses2020_militaryveteranbene==-99
label variable expenses2020_militarybenefits2 "Q29 Cleaned expenses-military benefits"
label define emb2 1"1.None"2"2.Some"3"3.Most"4"4.All"
label values expenses2020_militarybenefits2 emb2
tab expenses2020_militarybenefits2, missing

***************************** Student loan type ********************************
//Obtaining student loan type
codebook studentloan_type
describe studentloan_type
tab studentloan_type

//Cleaning student loan type
generate studentloan_type2=studentloan_type
replace studentloan_type2=. if studentloan_type==-99
replace studentloan_type2=. if studentloan_type==4
label variable studentloan_type2 "Q32 Cleaned student loan type"
label define slt1 1"1.Federal (e.g., Direct Loan, Perkins, or Stafford)"2"2.Private (e.g., from a bank, from a credit union)"3"3.Both federal and private"
label values studentloan_type2 slt1
tab studentloan_type2, missing

//Creating dummy for student loan type-federal
tab studentloan_type2, missing
generate loanfederal=.
replace loanfederal=1 if studentloan_type2==1
replace loanfederal=0 if studentloan_type2>=2&studentloan_type2<=4
label variable loanfederal "Q32 Dummy loan type-federal"
label define federalloan 0"0.No"1"1.Yes"
label values loanfederal federalloan
tab loanfederal, missing

//Creating dummy for student loan type-private
tab studentloan_type2, missing
generate loanprivate=.
replace loanprivate=1 if studentloan_type2==2
replace loanprivate=0 if studentloan_type2==1|studentloan_type2==3|studentloan_type2==4
label variable loanprivate "Q32 Dummy loan type-private"
label define privateloan 0"0.No"1"1.Yes"
label values loanprivate privateloan
tab loanprivate, missing

//Creating dummy for student loan type-both federal and private
tab studentloan_type2, missing
generate loanboth=.
replace loanboth=1 if studentloan_type2==3
replace loanboth=0 if studentloan_type2==1|studentloan_type2==2|studentloan_type2==4
label variable loanboth "Q32 Dummy loan type-both"
label define bothloan 0"0.No"1"1.Yes"
label values loanboth bothloan
tab loanboth, missing

*********************** Cleaning college good investment ***********************
codebook collegegoodinvestment
describe collegegoodinvestment
tab collegegoodinvestment, m 

//Cleaning financial self efficacy-plan future variable 
generate collegegoodinvestment2=collegegoodinvestment
replace collegegoodinvestment2=. if collegegoodinvestment==-99
label variable collegegoodinvestment2 "Q19 Cleaned college good investment"
label define cgi 1"1.Strongly disagree"2"2.Disagree"3"3.Agree"4"4.Strongly agree"
label values collegegoodinvestment2 cgi
tab collegegoodinvestment2, m


********************************************************************************
*                 Calcualtions for quadrant sample totals                      *
********************************************************************************

//Creating table with all quadrants
generate table1=.
replace table1=1 if stresscomb==2&loancomb==3
replace table1=2 if stresscomb==1&loancomb==3
replace table1=3 if stresscomb==2&loancomb==1
replace table1=4 if stresscomb==1&loancomb==1
label variable table1 "Table Quadrants"
label define tablecomb 1"1.High Loans High Stress"2"2.High Loans Low Stress"3"3.Low Loans High Stress"4"4.Low Loans Low Stress"
label values table1 tablecomb
tabulate table1, missing



********************************************************************************
*                              Creating quadrants                              *
********************************************************************************

//Quadrant 1 Dummy Code
tab table1, missing
generate quadrant1_hh=.
replace quadrant1_hh=1 if table1==1
replace quadrant1_hh=0 if table1>=2&table1<=4
label variable quadrant1_hh "Quadrant 1-high loans high stress"
label define qhh 0"0.No"1"1.Yes"
label values quadrant1_hh qhh
tab quadrant1_hh, missing

//Quadrant 2 Dummy Code
tab table1, missing
generate quadrant2_hl=.
replace quadrant2_hl=1 if table1==2
replace quadrant2_hl=0 if table1==1|table1==3|table1==4
label variable quadrant2_hl "Quadrant 2-high loans low stress"
label define qhl 0"0.No"1"1.Yes"
label values quadrant2_hl qhl
tab quadrant2_hl, missing

//Quadrant 3 Dummy Code
tab table1, missing
generate quadrant3_lh=.
replace quadrant3_lh=1 if table1==3
replace quadrant3_lh=0 if table1==1|table1==2|table1==4
label variable quadrant3_lh "Quadrant 3-low loans high stress"
label define qlh 0"0.No"1"1.Yes"
label values quadrant3_lh qlh
tab quadrant3_lh, missing

//Quadrant 4 Dummy Code
tab table1, missing
generate quadrant4_ll=.
replace quadrant4_ll=1 if table1==4
replace quadrant4_ll=0 if table1>=1&table1<=3
label variable quadrant4_ll "Quadrant 4-low loans low stress"
label define qll 0"0.No"1"1.Yes"
label values quadrant4_ll qll
tab quadrant4_ll, missing


********************************************************************************
*                             Analytic sample                                     *
********************************************************************************
//Analytic sample
keep studentloan2020 studentloan_amount2 stress_amountowe2 expectedsalary2 collegegoodinvestment2 age2 yearschool2 gender2 racecat employmentstatus2 financialaidcounselor_never2 financialaidcounselor_beforeco2 financialaidcounselor_college2 financialclass2020_highschool2 financialclass2020_onetimeco2 financialclass2020_reoccuringco2  expenses2020_parentincome2 expenses2020_moneyborrowed2 expenses2020_scholarshipsgrants2 expenses2020_moneyfromjob2 expenses2020_moneyfromsavings2 expenses2020_creditcards2 expenses2020_employeredbenefit2 expenses2020_militarybenefits2 studentloan_type2 finknowledge_SCORE table1 stresscomb loancomb quadrant1_hh quadrant2_hl quadrant3_lh quadrant4_ll loanfederal loanprivate loanboth racewhite raceasian raceblack racehispanic racemixed raceother

egen nmis=rmiss(studentloan2020 studentloan_amount2 stress_amountowe2 expectedsalary2 collegegoodinvestment2 age2 yearschool2 gender2 racecat employmentstatus2 financialaidcounselor_never2 financialaidcounselor_beforeco2 financialaidcounselor_college2 financialclass2020_highschool2 financialclass2020_onetimeco2 financialclass2020_reoccuringco2 expenses2020_parentincome2 expenses2020_moneyborrowed2 expenses2020_scholarshipsgrants2 expenses2020_moneyfromjob2 expenses2020_moneyfromsavings2 expenses2020_creditcards2 expenses2020_employeredbenefit2 expenses2020_militarybenefits2 studentloan_type2 finknowledge_SCORE table1 stresscomb loancomb quadrant1_hh quadrant2_hl quadrant3_lh quadrant4_ll loanfederal loanprivate loanboth racewhite raceasian raceblack racehispanic racemixed raceother)

tab nmis,m 
keep if nmis==0

********************************************************************************
*                             ANOVA                                            *
********************************************************************************
anova expectedsalary2 table1
anova collegegoodinvestment2 table1
anova age2 table1
anova yearschool2 table1
anova gender2 table1
anova racecat table1
anova employmentstatus2 table1
anova financialaidcounselor_never2 table1
anova financialaidcounselor_beforeco2 table1
anova financialaidcounselor_college2 table1
anova financialclass2020_highschool2 table1
anova financialclass2020_onetimeco2 table1
anova financialclass2020_reoccuringco2 table1
anova expenses2020_parentincome2 table1
anova expenses2020_moneyborrowed2 table1
anova expenses2020_scholarshipsgrants2 table1
anova expenses2020_moneyfromjob2 table1
anova expenses2020_moneyfromsavings2 table1
anova expenses2020_creditcards2 table1
anova expenses2020_employeredbenefit2 table1
anova expenses2020_militarybenefits2 table1
anova studentloan_type2 table1
anova finknowledge_SCORE table1


********************************************************************************
*                      Bivariate Log Regression                                *
********************************************************************************

//High loans high stress
logit quadrant1_hh i.expectedsalary2 collegegoodinvestment2 age2 gender2 i.racecat employmentstatus2 i.yearschool2 financialclass2020_highschool2 financialclass2020_onetimeco2 financialclass2020_reoccuringco2 finknowledge_SCORE financialaidcounselor_never2 financialaidcounselor_beforeco2 financialaidcounselor_college2  expenses2020_parentincome2 expenses2020_moneyborrowed2 expenses2020_scholarshipsgrants2 expenses2020_moneyfromjob2 expenses2020_moneyfromsavings2 expenses2020_creditcards2 expenses2020_employeredbenefit2 expenses2020_militarybenefits2 i.studentloan_type2, or 

listcoef, percent help

//High loans low stress
logit quadrant2_hl i.expectedsalary2 collegegoodinvestment2 age2 gender2 i.racecat employmentstatus2 i.yearschool2 financialclass2020_highschool2 financialclass2020_onetimeco2 financialclass2020_reoccuringco2 finknowledge_SCORE financialaidcounselor_never2 financialaidcounselor_beforeco2 financialaidcounselor_college2  expenses2020_parentincome2 expenses2020_moneyborrowed2 expenses2020_scholarshipsgrants2 expenses2020_moneyfromjob2 expenses2020_moneyfromsavings2 expenses2020_creditcards2 expenses2020_employeredbenefit2 expenses2020_militarybenefits2 i.studentloan_type2, or 

listcoef, percent help

//Low loans high stress
logit quadrant3_lh i.expectedsalary2 collegegoodinvestment2 age2 gender2 i.racecat employmentstatus2 i.yearschool2 financialclass2020_highschool2 financialclass2020_onetimeco2 financialclass2020_reoccuringco2 finknowledge_SCORE financialaidcounselor_never2 financialaidcounselor_beforeco2 financialaidcounselor_college2  expenses2020_parentincome2 expenses2020_moneyborrowed2 expenses2020_scholarshipsgrants2 expenses2020_moneyfromjob2 expenses2020_moneyfromsavings2 expenses2020_creditcards2 expenses2020_employeredbenefit2 expenses2020_militarybenefits2 i.studentloan_type2, or 

listcoef, percent help

//Low loans low stress
logit quadrant4_ll i.expectedsalary2 collegegoodinvestment2 age2 gender2 i.racecat employmentstatus2 i.yearschool2 financialclass2020_highschool2 financialclass2020_onetimeco2 financialclass2020_reoccuringco2 finknowledge_SCORE financialaidcounselor_never2 financialaidcounselor_beforeco2 financialaidcounselor_college2  expenses2020_parentincome2 expenses2020_moneyborrowed2 expenses2020_scholarshipsgrants2 expenses2020_moneyfromjob2 expenses2020_moneyfromsavings2 expenses2020_creditcards2 expenses2020_employeredbenefit2 expenses2020_militarybenefits2 i.studentloan_type2, or 

listcoef, percent help

********************************************************************************
*                    Multinomial Log Regression                                *
********************************************************************************

//Base: High loans, high stress
mlogit table1 i.expectedsalary2 collegegoodinvestment2 age2 gender2 i.racecat employmentstatus2 i.yearschool2 financialclass2020_highschool2 financialclass2020_onetimeco2 financialclass2020_reoccuringco2 finknowledge_SCORE financialaidcounselor_never2 financialaidcounselor_beforeco2 financialaidcounselor_college2  expenses2020_parentincome2 expenses2020_moneyborrowed2 expenses2020_scholarshipsgrants2 expenses2020_moneyfromjob2 expenses2020_moneyfromsavings2 expenses2020_creditcards2 expenses2020_employeredbenefit2 expenses2020_militarybenefits2 i.studentloan_type2, b(1) rr

//Base: High loans, low stress
mlogit table1 i.expectedsalary2 collegegoodinvestment2 age2 gender2 i.racecat employmentstatus2 i.yearschool2 financialclass2020_highschool2 financialclass2020_onetimeco2 financialclass2020_reoccuringco2 finknowledge_SCORE financialaidcounselor_never2 financialaidcounselor_beforeco2 financialaidcounselor_college2  expenses2020_parentincome2 expenses2020_moneyborrowed2 expenses2020_scholarshipsgrants2 expenses2020_moneyfromjob2 expenses2020_moneyfromsavings2 expenses2020_creditcards2 expenses2020_employeredbenefit2 expenses2020_militarybenefits2 i.studentloan_type2, b(2) rr

//Base: Low loans, high stress
mlogit table1 i.expectedsalary2 collegegoodinvestment2 age2 gender2 i.racecat employmentstatus2 i.yearschool2 financialclass2020_highschool2 financialclass2020_onetimeco2 financialclass2020_reoccuringco2 finknowledge_SCORE financialaidcounselor_never2 financialaidcounselor_beforeco2 financialaidcounselor_college2  expenses2020_parentincome2 expenses2020_moneyborrowed2 expenses2020_scholarshipsgrants2 expenses2020_moneyfromjob2 expenses2020_moneyfromsavings2 expenses2020_creditcards2 expenses2020_employeredbenefit2 expenses2020_militarybenefits2 i.studentloan_type2, b(3) rr

********************************************************************************
*                             Descriptives                                     *
********************************************************************************

//Total sample
summarize studentloan_amount2 stress_amountowe2 expectedsalary2 collegegoodinvestment2 age2 gender2 i.racecat employmentstatus2 yearschool2 financialclass2020_highschool2 financialclass2020_onetimeco2 financialclass2020_reoccuringco2 finknowledge_SCORE financialaidcounselor_never2 financialaidcounselor_beforeco2 financialaidcounselor_college2  expenses2020_parentincome2 expenses2020_moneyborrowed2 expenses2020_scholarshipsgrants2 expenses2020_moneyfromjob2 expenses2020_moneyfromsavings2 expenses2020_creditcards2 expenses2020_employeredbenefit2 expenses2020_militarybenefits2 i.studentloan_type2

tab studentloan_amount2 
tab age2
tab yearschool2
tab gender2
tab racecat
tab employmentstatus2
tab financialaidcounselor_never2
tab financialaidcounselor_beforeco2
tab financialaidcounselor_college2
tab financialclass2020_highschool2
tab financialclass2020_onetimeco2
tab financialclass2020_reoccuringco2
tab expenses2020_parentincome2 
tab expenses2020_moneyborrowed2 
tab expenses2020_scholarshipsgrants2 
tab expenses2020_moneyfromjob2 
tab expenses2020_moneyfromsavings2 
tab expenses2020_creditcards2 
tab expenses2020_employeredbenefit2
tab expenses2020_militarybenefits2 
tab studentloan_type2
tab finknowledge_SCORE 


//Q1
summarize studentloan_amount2 stress_amountowe2 expectedsalary2 collegegoodinvestment2 age2 gender2 i.racecat employmentstatus2 yearschool2 financialclass2020_highschool2 financialclass2020_onetimeco2 financialclass2020_reoccuringco2 finknowledge_SCORE financialaidcounselor_never2 financialaidcounselor_beforeco2 financialaidcounselor_college2  expenses2020_parentincome2 expenses2020_moneyborrowed2 expenses2020_scholarshipsgrants2 expenses2020_moneyfromjob2 expenses2020_moneyfromsavings2 expenses2020_creditcards2 expenses2020_employeredbenefit2 expenses2020_militarybenefits2 i.studentloan_type2 if table1==1

tab studentloan_amount2 if table1==1
tab age2 if table1==1
tab yearschool2 if table1==1
tab gender2 if table1==1
tab racecat if table1==1
tab employmentstatus2 if table1==1
tab financialaidcounselor_never2 if table1==1
tab financialaidcounselor_beforeco2 if table1==1
tab financialaidcounselor_college2 if table1==1
tab financialclass2020_highschool2 if table1==1
tab financialclass2020_onetimeco2 if table1==1
tab financialclass2020_reoccuringco2 if table1==1
tab expenses2020_parentincome2 if table1==1
tab expenses2020_moneyborrowed2 if table1==1
tab expenses2020_scholarshipsgrants2 if table1==1
tab expenses2020_moneyfromjob2 if table1==1
tab expenses2020_moneyfromsavings2 if table1==1
tab expenses2020_creditcards2 if table1==1
tab expenses2020_employeredbenefit2 if table1==1
tab expenses2020_militarybenefits2 if table1==1
tab studentloan_type2 if table1==1
tab finknowledge_SCORE if table1==1


//Q2
summarize studentloan_amount2 stress_amountowe2 expectedsalary2 collegegoodinvestment2 age2 gender2 i.racecat employmentstatus2 yearschool2 financialclass2020_highschool2 financialclass2020_onetimeco2 financialclass2020_reoccuringco2 finknowledge_SCORE financialaidcounselor_never2 financialaidcounselor_beforeco2 financialaidcounselor_college2  expenses2020_parentincome2 expenses2020_moneyborrowed2 expenses2020_scholarshipsgrants2 expenses2020_moneyfromjob2 expenses2020_moneyfromsavings2 expenses2020_creditcards2 expenses2020_employeredbenefit2 expenses2020_militarybenefits2 i.studentloan_type2 if table1==2

tab yearschool2 if table1==2
tab racecat if table1==2
tab studentloan_type2 if table1==2
tab studentloan_amount2 if table1==2
tab stress_amountowe2 if table1==2

//Q3
summarize studentloan_amount2 stress_amountowe2 expectedsalary2 collegegoodinvestment2 age2 gender2 i.racecat employmentstatus2 yearschool2 financialclass2020_highschool2 financialclass2020_onetimeco2 financialclass2020_reoccuringco2 finknowledge_SCORE financialaidcounselor_never2 financialaidcounselor_beforeco2 financialaidcounselor_college2  expenses2020_parentincome2 expenses2020_moneyborrowed2 expenses2020_scholarshipsgrants2 expenses2020_moneyfromjob2 expenses2020_moneyfromsavings2 expenses2020_creditcards2 expenses2020_employeredbenefit2 expenses2020_militarybenefits2 i.studentloan_type2 if table1==3

tab yearschool2 if table1==3
tab racecat if table1==3
tab studentloan_type2 if table1==3
tab studentloan_amount2 if table1==3
tab stress_amountowe2 if table1==3

//Q4
summarize studentloan_amount2 stress_amountowe2 expectedsalary2 collegegoodinvestment2 age2 gender2 i.racecat employmentstatus2 yearschool2 financialclass2020_highschool2 financialclass2020_onetimeco2 financialclass2020_reoccuringco2 finknowledge_SCORE financialaidcounselor_never2 financialaidcounselor_beforeco2 financialaidcounselor_college2  expenses2020_parentincome2 expenses2020_moneyborrowed2 expenses2020_scholarshipsgrants2 expenses2020_moneyfromjob2 expenses2020_moneyfromsavings2 expenses2020_creditcards2 expenses2020_employeredbenefit2 expenses2020_militarybenefits2 i.studentloan_type2 if table1==4

tab yearschool2 if table1==4
tab racecat if table1==4
tab studentloan_type2 if table1==4
tab studentloan_amount2 if table1==4

************************* Descriptives table extras ****************************

//Stress by segment (mean)
tab stresscomb if table1==1
tab stresscomb if table1==2
tab stresscomb if table1==3
tab stresscomb if table1==4
summarize i.stresscomb

***************************** T tests ******************************************

//Student Loan Amount
ttest studentloan_amount2 if table1==1|table1==2, by(table1) 
ttest studentloan_amount2 if table1==1|table1==3, by(table1) 
ttest studentloan_amount2 if table1==1|table1==4, by(table1) 

//Financial Stress From Debt
ttest stress_amountowe2 if table1==1|table1==2, by(table1) 
ttest stress_amountowe2 if table1==1|table1==3, by(table1) 
ttest stress_amountowe2 if table1==1|table1==4, by(table1) 

//Expected Salary
ttest expectedsalary2 if table1==1|table1==2, by(table1) 
ttest expectedsalary2 if table1==1|table1==3, by(table1) 
ttest expectedsalary2 if table1==1|table1==4, by(table1) 

//College good investment
ttest collegegoodinvestment2 if table1==1|table1==2, by(table1) 
ttest collegegoodinvestment2 if table1==1|table1==3, by(table1) 
ttest collegegoodinvestment2 if table1==1|table1==4, by(table1) 

//Age
ttest age2 if table1==1|table1==2, by(table1) 
ttest age2 if table1==1|table1==3, by(table1) 
ttest age2 if table1==1|table1==4, by(table1) 

//Gender
ttest gender2 if table1==1|table1==2, by(table1) 
ttest gender2 if table1==1|table1==3, by(table1) 
ttest gender2 if table1==1|table1==4, by(table1) 

//Race or Ethnicity
ttest racewhite if table1==1|table1==2, by(table1)
ttest racewhite if table1==1|table1==3, by(table1)
ttest racewhite if table1==1|table1==4, by(table1)

ttest raceasian if table1==1|table1==2, by(table1)
ttest raceasian if table1==1|table1==3, by(table1)
ttest raceasian if table1==1|table1==4, by(table1)

ttest raceblack if table1==1|table1==2, by(table1)
ttest raceblack if table1==1|table1==3, by(table1)
ttest raceblack if table1==1|table1==4, by(table1)

ttest racehispanic if table1==1|table1==2, by(table1)
ttest racehispanic if table1==1|table1==3, by(table1)
ttest racehispanic if table1==1|table1==4, by(table1)

ttest racemixed if table1==1|table1==2, by(table1)
ttest racemixed if table1==1|table1==3, by(table1)
ttest racemixed if table1==1|table1==4, by(table1)

ttest raceother if table1==1|table1==2, by(table1)
ttest raceother if table1==1|table1==3, by(table1)
ttest raceother if table1==1|table1==4, by(table1)

//Employment Status
ttest employmentstatus2 if table1==1|table1==2, by(table1) 
ttest employmentstatus2 if table1==1|table1==3, by(table1) 
ttest employmentstatus2 if table1==1|table1==4, by(table1) 

//Year in School
ttest yearschool2 if table1==1|table1==2, by(table1) 
ttest yearschool2 if table1==1|table1==3, by(table1) 
ttest yearschool2 if table1==1|table1==4, by(table1) 

//Financial Education Class
ttest financialclass2020_highschool2 if table1==1|table1==2, by(table1)
ttest financialclass2020_highschool2 if table1==1|table1==3, by(table1)
ttest financialclass2020_highschool2 if table1==1|table1==4, by(table1)

ttest financialclass2020_onetimeco2 if table1==1|table1==2, by(table1)
ttest financialclass2020_onetimeco2 if table1==1|table1==3, by(table1)
ttest financialclass2020_onetimeco2 if table1==1|table1==4, by(table1)

ttest financialclass2020_reoccuringco2 if table1==1|table1==2, by(table1)
ttest financialclass2020_reoccuringco2 if table1==1|table1==3, by(table1)
ttest financialclass2020_reoccuringco2 if table1==1|table1==4, by(table1)

//Financial Knowledge Score
ttest finknowledge_SCORE if table1==1|table1==2, by(table1) 
ttest finknowledge_SCORE if table1==1|table1==3, by(table1) 
ttest finknowledge_SCORE if table1==1|table1==4, by(table1)

//Financial Aid Counselor
ttest financialaidcounselor_never2 if table1==1|table1==2, by(table1)
ttest financialaidcounselor_never2 if table1==1|table1==3, by(table1)
ttest financialaidcounselor_never2 if table1==1|table1==4, by(table1)

ttest financialaidcounselor_beforeco2 if table1==1|table1==2, by(table1)
ttest financialaidcounselor_beforeco2 if table1==1|table1==3, by(table1)
ttest financialaidcounselor_beforeco2 if table1==1|table1==4, by(table1)

ttest financialaidcounselor_college2 if table1==1|table1==2, by(table1)
ttest financialaidcounselor_college2 if table1==1|table1==3, by(table1) 
ttest financialaidcounselor_college2 if table1==1|table1==4, by(table1) 

//College Expenses Source
ttest expenses2020_parentincome2 if table1==1|table1==2, by(table1)
ttest expenses2020_parentincome2 if table1==1|table1==3, by(table1)
ttest expenses2020_parentincome2 if table1==1|table1==4, by(table1)

ttest expenses2020_moneyborrowed2 if table1==1|table1==2, by(table1)
ttest expenses2020_moneyborrowed2 if table1==1|table1==3, by(table1)
ttest expenses2020_moneyborrowed2 if table1==1|table1==4, by(table1)

ttest expenses2020_scholarshipsgrants2 if table1==1|table1==2, by(table1)
ttest expenses2020_scholarshipsgrants2 if table1==1|table1==3, by(table1)
ttest expenses2020_scholarshipsgrants2 if table1==1|table1==4, by(table1)

ttest expenses2020_moneyfromjob2 if table1==1|table1==2, by(table1)
ttest expenses2020_moneyfromjob2 if table1==1|table1==3, by(table1)
ttest expenses2020_moneyfromjob2 if table1==1|table1==4, by(table1)

ttest expenses2020_moneyfromsavings2 if table1==1|table1==2, by(table1)
ttest expenses2020_moneyfromsavings2 if table1==1|table1==3, by(table1)
ttest expenses2020_moneyfromsavings2 if table1==1|table1==4, by(table1)

ttest expenses2020_creditcards2 if table1==1|table1==2, by(table1)
ttest expenses2020_creditcards2 if table1==1|table1==3, by(table1)
ttest expenses2020_creditcards2 if table1==1|table1==4, by(table1)

ttest expenses2020_employeredbenefit2 if table1==1|table1==2, by(table1)
ttest expenses2020_employeredbenefit2 if table1==1|table1==3, by(table1)
ttest expenses2020_employeredbenefit2 if table1==1|table1==4, by(table1)

ttest expenses2020_militarybenefits2 if table1==1|table1==2, by(table1)
ttest expenses2020_militarybenefits2 if table1==1|table1==3, by(table1) 
ttest expenses2020_militarybenefits2 if table1==1|table1==4, by(table1) 
 
//Loan Type
ttest loanfederal if table1==1|table1==2, by(table1)
ttest loanfederal if table1==1|table1==3, by(table1)
ttest loanfederal if table1==1|table1==4, by(table1)

ttest loanprivate if table1==1|table1==2, by(table1)
ttest loanprivate if table1==1|table1==3, by(table1)
ttest loanprivate if table1==1|table1==4, by(table1)

ttest loanboth if table1==1|table1==2, by(table1)
ttest loanboth if table1==1|table1==3, by(table1)
ttest loanboth if table1==1|table1==4, by(table1)
