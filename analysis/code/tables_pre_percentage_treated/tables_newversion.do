****CREATING TABLES FOR NEW DEFINITION OF NON-COG****

clear all
set more off

cd "$repository/data_sets/pre_made"

use updated_unique_data_clean

********************************************************************************
*************Re-Coding Kinderprep Scores****************************************
********************************************************************************

**Re-code scores for kinderprep taking into account that "pre scores" are post-scores and "post scores" are sl-scores.
foreach test in wjl wjs wja wjq card ppvt psra ospan same spatial cog ncog std_wjl std_wjs std_wja std_wjq std_card std_ppvt std_psra std_ospan std_same std_spatial std_cog std_ncog {
	replace `test'_pre = `test'_post if treatment == "kinderprep"
	replace `test'_post = `test'_sl if treatment == "kinderprep"
	replace `test'_mid = . if treatment == "kinderprep"
	replace `test'_sl = . if treatment == "kinderprep"
}

foreach test in wjl wjs wja wjq card ppvt psra ospan same spatial cog ncog {
	replace has_`test'_pre = has_`test'_post if treatment == "kinderprep"
	replace has_`test'_post = has_`test'_sl if treatment == "kinderprep"
	replace has_`test'_mid = 0 if treatment == "kinderprep"
	replace has_`test'_sl = 0 if treatment == "kinderprep"
}



********************************************
**Re-Constructing Non-Cog ******************
********************************************

foreach period in pre mid post sl ao_y1 ao_y2 ao_y3 ao_y4 ao_y5 {

rename ncog_`period' old_ncog_`period'
rename std_ncog_`period' old_std_ncog_`period'
rename has_ncog_`period' old_has_ncog_`period'

gen has_ncog_`period' = has_ospan_`period' > 0 & has_spatial_`period' > 0 & has_psra_`period' > 0
egen ncog_`period' = rowmean(ospan_`period' spatial_`period' psra_`period') if has_ncog_`period' == 1
egen std_ncog_`period' = std(ncog_`period') if has_ncog_`period' == 1


}


****************************************************************
***INCLUDE THE SAME STEPS IN CONSTRUCTING THE FINAL SAMPLE******
****************************************************************

sort child year


********************************************************************************
*************Defining Multiple-Year Treatment Status****************************
********************************************************************************


**Identifying the observations for mislabeled kids who were first in treatment
**but then incorrectly labelled as "control" in second year of randomisation 
gen incorrect_treat_control = treatment != "control" & treatment[_n+1] == "control" & child == child[_n+1] & child != child[_n-1]
replace incorrect_treat_control = 2 if treatment == "control" & treatment[_n-1] != "control" & child == child[_n-1] & child != child[_n+1]
 
**Drop only the second year observation, which is the incorrect control year observation. Keep the first treated observation.
drop if incorrect_treat_control == 2

**Tagging those first randomised into control and then again into control
gen control_control = treatment == "control" & treatment[_n+1] == "control" & child == child[_n+1] & child != child[_n-1]
replace control_control = 2 if treatment[_n - 1] == "control" & treatment == "control" & child != child[_n+1] & child == child[_n-1]

gen CC = (control_control == 1 | control_control == 2)
**Define first and second years of randomisation
gen first_random = (control_control == 1)
gen second_random = (control_control == 2)

**Tagging those first randomised into control and then into treatment other than kinderprep
gen control_treat_not_kinderprep = treatment == "control" & treatment[_n+1] != "kinderprep" & treatment[_n+1] != "control" & child == child[_n+1] & child != child[_n-1]
replace control_treat_not_kinderprep = 2 if treatment[_n-1] == "control" & treatment != "kinderprep" & treatment != "control" & child != child[_n+1] & child == child[_n-1]

gen CT = (control_treat_not_kinderprep == 1 | control_treat_not_kinderprep == 2)
replace first_random = 1 if control_treat_not_kinderprep == 1
replace second_random = 1 if control_treat_not_kinderprep == 2

**Tagging those first randomised into control and then into kinderprep
gen control_kinderprep = treatment == "control" & treatment[_n+1] == "kinderprep" & child == child[_n+1] & child != child[_n-1]
replace control_kinderprep = 2 if treatment == "kinderprep" & treatment[_n-1] == "control" & child == child[_n-1] & child != child[_n+1] 

gen CK = (control_kinderprep == 1 | control_kinderprep == 2)
replace first_random = 1 if control_kinderprep == 1
replace second_random = 1 if control_kinderprep == 2

**Tagging those who have been randomised into treatment only once (different from kinderprep)
gen treated_once = treatment != "control" & treatment != "kinderprep" & child != child[_n+1] & child != child[_n-1]

gen T = (treated_once == 1)
replace first_random = 1 if treated_once == 1

**Tagging those randomised once into kinderprep
gen K = (treatment == "kinderprep" & child != child[_n+1] & child != child[_n-1])
replace first_random = 1 if K == 1

**Tagging those who have been randomised into treatment twice (other than kinderprep the second time)

gen treated_twice = treatment != "control" & treatment[_n+1] != "control" & treatment[_n+1] != "kinderprep"  & child == child[_n+1] & child != child[_n-1]
replace treated_twice = 2 if treatment[_n-1] != "control" & treatment != "control" & treatment != "kinderprep" & child == child[_n-1] & child != child[_n+1]

gen TT = (treated_twice == 1 | treated_twice == 2)
replace TT = 0 if child == 1109
replace first_random = 1 if treated_twice == 1
replace second_random = 1 if treated_twice == 2

*Define TTT for kid 1109 who was randomised 3 times
gen TTT = (child == 1109)
replace first_random = 0 if child == 1109
replace second_random = 0 if child == 1109
replace first_random = 1 if (child == 1109 & year == "2010")
replace second_random = 1 if (child == 1109 & year == "2011")
gen third_random = (child == 1109 & year == "2012")

**Tagging those who have been randomised into treatment and then into kinderprep
gen treated_kinderprep = treatment != "control" & treatment[_n+1] == "kinderprep" & child == child[_n+1] & child !=child[_n-1]
replace treated_kinderprep = 2 if treatment[_n-1] != "control" & treatment == "kinderprep" & child == child[_n-1] & child != child[_n+1]

gen TK = (treated_kinderprep == 1 | treated_kinderprep == 2)
replace first_random = 1 if treated_kinderprep == 1
replace second_random = 1 if treated_kinderprep == 2

**Tagging all those who have been randomised into control once
gen C = (treatment == "control" & child != child[_n+1] & child != child[_n-1])
replace first_random = 1 if C == 1

********************************************************************************
*************Identifyng Kids with No Pre or No Observations Beyond Pre**********
********************************************************************************
**Tagging those kids that do not have pre_scores
gen no_cog_pre = has_cog_pre == 0 
gen no_ncog_pre = has_ncog_pre == 0

**Tagging those kids that have zero cog/non_cog observations beyond pre

**a) Calculating number of cog observations beyond pre up until age out 4
egen num_cog_beyond_pre = rowtotal(has_cog_mid has_cog_post has_cog_sl has_cog_ao_y1 has_cog_ao_y2 has_cog_ao_y3 has_cog_ao_y4) 

**b) Calculating number of no-cog observations beyond pre up until age out 4
egen num_ncog_beyond_pre = rowtotal(has_ncog_mid has_ncog_post has_ncog_sl has_ncog_ao_y1 has_ncog_ao_y2 has_ncog_ao_y3 has_ncog_ao_y4) 

cd "$repository/data_sets/generated"

//Save Data to Create Panel
save newv_unique_data_clean_for_panel, replace


******************************************
*****EXTRACTING NEW VERSION PRE-SCORES****
******************************************

clear all

cd "$repository/data_sets/generated"

use newv_unique_data_clean_for_panel

keep year child treatment has_wjl_pre has_wjs_pre has_wja_pre has_wjq_pre has_card_pre has_ppvt_pre has_psra_pre has_ospan_pre has_same_pre has_spatial_pre has_cog_pre has_ncog_pre wjl_pre wjs_pre wja_pre wjq_pre card_pre ppvt_pre psra_pre ospan_pre same_pre cog_pre ncog_pre spatial_pre std_wjl_pre std_wjs_pre std_wja_pre std_wjq_pre std_card_pre std_ppvt_pre std_psra_pre std_ospan_pre std_same_pre std_spatial_pre std_cog_pre std_ncog_pre

save newv_pre_scores, replace	


*****************************
****RECREATING PANEL*********
*****************************

clear all

cd "$repository/data_sets/generated"

use newv_unique_data_clean_for_panel
///Creating a panel

keep year child treatment has_wjl_* has_wjs_* has_wja_* has_wjq_* has_card_* has_ppvt_* has_psra_* has_ospan_* has_same_* has_spatial_* has_cog_* has_ncog_* wjl_* wjs_* wja_* wjq_* card_* ppvt_* psra_* ospan_* same_* spatial_* cog_* ncog_* std_wjl_* std_wjs_* std_wja_* std_wjq_* std_card_* std_ppvt_* std_psra_* std_ospan_* std_same_* std_spatial_* std_cog_* std_ncog_* gender aid_unemployment_pre race age_pre hh_income_pre mother_education_pre father_education_pre no_cog_pre no_ncog_pre num_cog_beyond_pre num_ncog_beyond_pre first_random second_random third_random CC CT CK T K TT TTT TK C 

drop  *ao_5yo *ao_6yo *ao_7yo *maximum* *or_tvip* *y12 *y34

order has_wjl_* has_wjs_* has_wja_* has_wjq_* has_card_* has_ppvt_* has_psra_* has_ospan_* has_same_* has_spatial_* has_cog_* has_ncog_* wjl_* wjs_* wja_* wjq_* card_* ppvt_* psra_* ospan_* same_* spatial_* cog_* ncog_* std_wjl_* std_wjs_* std_wja_* std_wjq_* std_card_* std_ppvt_* std_psra_* std_ospan_* std_same_* std_spatial_* std_cog_* std_ncog_*

reshape long has_wjl_@ has_wjs_@ has_wja_@ has_wjq_@ wjl_@ wjs_@ wja_@ wjq_@ has_card_@ card_@ has_ppvt_@ ppvt_@ has_psra_@ psra_@ has_ospan_@ ospan_@ has_same_@ same_@ has_spatial_@ spatial_@ std_ppvt_@ std_wjl_@ std_wja_@ std_wjs_@ std_wjq_@ std_psra_@ std_card_@ std_spatial_@ std_ospan_@ std_same_@  has_cog_@ cog_@ std_cog_@ has_ncog_@ ncog_@ std_ncog_@, i(child year) j(test) s
	

**Dropping all observations for ao_y5, ao_y6
drop if (test == "ao_y5" | test == "ao_y6")

**Dropping observations without std cog and std_ncog
drop if has_cog_==0 & has_ncog_ ==0
 
**Saving file for Tables 3 and 4
merge m:1 child year using newv_pre_scores

**Drop those kids that have not been mathced on-prescores (these are kids that had num_cog_beyond_pre or num_ncog_beyond_pre greater than 0)
drop if _merge==2

drop _merge

rename *_ *
replace test = subinstr(test, "_", "", .)

**We don't need Basicopposite so drop
foreach x in pre mid post sl aoy1 aoy2 aoy3 aoy4 aoy5 aoy6 {

drop if test == "basicopposite`x'"

}

unique child

**6154 observations and 1660 unique control kids

**Create CT_pretreatment which is only defined for those who have been randomised twice: first into control and than into treatment (other than kinderprep). 
**"1" means that the kid has taken this test before undergoing treatment 
gen CT_pretreat = .
replace CT_pretreat = 1 if CT == 1 & first_random == 1 & (test == "pre" | test == "mid" | test == "post" | test == "sl")
replace CT_pretreat = 0 if CT == 1 & first_random == 1 & (test == "aoy1" | test == "aoy2" | test == "aoy3" | test == "aoy4")
replace CT_pretreat = 0 if CT == 1 & second_random == 1

**Create CK_prekinder which is only defined for those who have been randomised twice: first into control and than into kinderprep
**"1" means that the kid has taken this test before undergoing kinderprep 
gen CK_prekinder = .
replace CK_prekinder = 1 if CK == 1 & first_random == 1 & (test =="pre" | test == "mid" | test == "post" | test == "sl" | test == "aoy1")
replace CK_prekinder = 0 if CK == 1 & first_random == 1 & (test == "aoy2" | test == "aoy3" | test == "aoy4")
replace CK_prekinder = 0 if CK == 1 & second_random == 1

save newv_table34_unique_data_clean, replace


***********************************
******TABLES 3 and 4 **************
***********************************

merge 1:1 child test year using merged_neigh_count

**Dropping kids not pertaining to our sample
drop if _merge == 2

drop _merge

***********************************************************************************
**If want to reproduce table restricting sample to control kids, add the code below



keep if (C == 1 & first_random == 1) | (CC == 1 & first_random == 1) | (CT_pretreat == 1) | (CK_prekinder == 1)


***********************************************************************************



**Create Table 3
file open file0 using "$repository/analysis/tables/tables_pre_percentage_treated/newv_table3.tex", replace write


file write file0 "\documentclass[11pt]{article}"
file write file0 _n "\usepackage{booktabs, multicol, multirow}"
file write file0 _n "\usepackage{caption}"
file write file0 _n "\userpackage[flushleft]{threeparttable}"
file write file0 _n	"\begin{document}"

file write file0 _n	"\begin{table}[h]"
file write file0 _n	"\begin{threeparttable}"
file write file0 _n	"\centering"
file write file0 _n	"\caption{Assessments}"

file write file0 _n	"\label{tab:Nassess}"
file write file0 _n	"\begin{tabular}{c|cc|cc}"
file write file0 _n	"Assessment & $N_{Cog}$ & Cog Score &$N_{Noncog}$ &Non-Cog Score \\"
file write file0 _n	"\toprule"
file write file0 _n	"\midrule"

local i = 1
local j = 1

foreach x in cog ncog {
	tabstat std_`x' if has_`x' == 1, by(test) save stat(mean semean n)
	foreach stat in Stat7 Stat5 Stat6 Stat8 Stat1 Stat2 Stat3 Stat4 {
		mat a = r(`stat')
		local item`i' = string(a[3,1], "%13.0gc") //Num of observations
		local i = `i' + 1
		local item`i' = string(round(a[1,1], 0.0001), "%13.0gc") //Mean
		local i = `i' + 1
		local item`i' = string(round(a[2,1], 0.0001), "%13.0gc") //Standard Error
		local i = `i' + 1
		mat b = r(StatTotal)
		local itemtotal`j' = string(b[3,1], "%13.0gc")
		local j = `j' + 1
		}
}



file write file0 _n	"\multirow{2}{*}{Pre } & \multirow{2}{*}{`item1'} & `item2' & \multirow{2}{*}{`item25'} & `item26'\\"
file write file0 _n	"& & (`item3') & & (`item27')\\"
file write file0 _n	"& & & & \\"
file write file0 _n	"\multirow{2}{*}{Mid } & \multirow{2}{*}{`item4'} & `item5' & \multirow{2}{*}{`item28'} & `item29'\\"
file write file0 _n	"& & (`item6') & & (`item30')\\"
file write file0 _n	"& & & & \\"
file write file0 _n	"\multirow{2}{*}{Post } & \multirow{2}{*}{`item7'} & `item8' & \multirow{2}{*}{`item31'} & `item32'\\"
file write file0 _n	"& & (`item9') & & (`item33')\\"
file write file0 _n	"& & & & \\"
file write file0 _n	"Summer Loss & \multirow{2}{*}{`item10'} & `item11' & \multirow{2}{*}{`item34'} & `item35'\\"
file write file0 _n	"& & (`item12') & & (`item36')\\"
file write file0 _n	"& & & & \\"
file write file0 _n	"Aged-Out Year 1 & \multirow{2}{*}{`item13'} & `item14' & \multirow{2}{*}{`item37'} & `item38' \\"
file write file0 _n	"& & (`item15') & & (`item39')\\"
file write file0 _n	"& & & &\\"
file write file0 _n	"Aged-Out Year 2  & \multirow{2}{*}{`item16'} & `item17' & \multirow{2}{*}{`item40'} & `item41'\\"
file write file0 _n	"& & (`item18') & & (`item42')\\"
file write file0 _n	"& & & & \\"
file write file0 _n	"Aged-Out Year 3  & \multirow{2}{*}{`item19'} & `item20' & \multirow{2}{*}{`item43'} & `item44'\\"
file write file0 _n	"& & (`item21') & & (`item45')\\"
file write file0 _n	"& & & & \\"
file write file0 _n	"Aged-Out Year 4 & \multirow{2}{*}{`item22'} & `item23' & \multirow{2}{*}{`item46'} & `item47'\\"
file write file0 _n	"& & (`item24') & & (`item48')\\"
file write file0 _n	"& & & & \\"
file write file0 _n	"N Total  & `itemtotal1' &  & `itemtotal9' & \\"
file write file0 _n	"\bottomrule"
file write file0 _n	"\end{tabular}"
file write file0 _n	"\begin{tablenotes}"
file write file0 _n	"\footnotesize"

file write file0 _n	"\item \textit{Notes:} This table presents the summary statistics on each assessment from the control kids in our sample. The first and the third columns represent the number of observations for which we have the corresponding assessment, the second and the fourth columns present the means of scores on each assessment. Standard errors are reported in parentheses." 

file write file0 _n	"\end{tablenotes}"
file write file0 _n	"\end{threeparttable}"
file write file0 _n	"\end{table}"

file write file0 _n "\end{document}"
 
file close file0


**Create Table 4


clear all

cd "$repository/data_sets/generated"

use newv_table34_unique_data_clean

***********************************************************************************
**If want to reproduce table restricting sample to control kids, add the code below



keep if (C == 1 & first_random == 1) | (CC == 1 & first_random == 1) | (CT_pretreat == 1) | (CK_prekinder == 1)



***********************************************************************************

replace std_cog_pre = . if has_cog_pre == 0
replace std_ncog_pre = . if has_ncog_pre == 0

file open file1 using "$repository/analysis/tables/tables_pre_percentage_treated/newv_table4.tex", replace write

file write file1 "\documentclass[11pt]{article}"
file write file1 _n "\usepackage{booktabs, multicol, multirow}"
file write file1 _n "\usepackage{caption}"
file write file1 _n "\userpackage[flushleft]{threeparttable}"
file write file1 _n	"\begin{document}"

file write file1 _n "\setcounter{table}{0}"
file write file1 _n "\begin{table}[]"
file write file1 _n "\begin{threeparttable}"
file write file1 _n "\centering"
file write file1 _n "\caption{Baseline Summary Statistics for Final Sample}"
file write file1 _n "\label{tab:sum_stat_demog}"
file write file1 _n "\scriptsize"
file write file1 _n "\begin{tabular}{ll}"
file write file1 _n "Variable & Share \\ \hline \hline"

**Completing Gender Line
tab gender, m gen(gender_gr)
tabstat gender_gr2, save stat(mean)
mat a = r(StatTotal)
local a1 = string(round(a[1,1], 0.01), "%13.0gc") 

file write file1 _n "Male     & `a1'                  \\ \hline"
file write file1 _n "\multicolumn{2}{c}{Race} \\ \cline{1-2}"

**Completing Race Line
tab race, m gen(race_gr)
tabstat race_gr1, save stat(mean) 
mat b = r(StatTotal)
local b1 = string(round(b[1,1], 0.01), "%13.0gc") //Missing Race
tabstat race_gr2, save stat(mean) 
mat b = r(StatTotal)
local b2 = string(round(b[1,1], 0.01), "%13.0gc") //Black
tabstat race_gr3, save stat(mean) 
mat b = r(StatTotal)
local b3 = string(round(b[1,1], 0.01), "%13.0gc") //Hispanic
tabstat race_gr4, save stat(mean) 
mat b = r(StatTotal)
local b4 = string(round(b[1,1], 0.01), "%13.0gc") //Other
tabstat race_gr5, save stat(mean) 
mat b = r(StatTotal)
local b5 = string(round(b[1,1], 0.01), "%13.0gc") //White

file write file1 _n "Black      & `b2'         \\"
file write file1 _n "Hispanic   & `b3'    \\"
file write file1 _n "White         & `b5'     \\"
file write file1 _n "Other Race      & `b4' \\"
file write file1 _n "Missing Race &  `b1' \\ \hline"
file write file1 _n "\multicolumn{2}{c}{HH Income at Pre-assessment } \\ \cline{1-2}"

**Completing Household Income 
tab hh_income_pre, m gen(hh_income_gr)
tabstat hh_income_gr1, save stat(mean) 
mat c = r(StatTotal)
local c1 = c[1,1] //0-5
tabstat hh_income_gr2, save stat(mean) 
mat c = r(StatTotal)
local c2 = c[1,1] //16-25
tabstat hh_income_gr3, save stat(mean) 
mat c = r(StatTotal)
local c3 = c[1,1] //26-35
tabstat hh_income_gr4, save stat(mean) 
mat c = r(StatTotal)
local c4 = c[1,1] //36-45
tabstat hh_income_gr5, save stat(mean) 
mat c = r(StatTotal)
local c5 = c[1,1] //46-60
tabstat hh_income_gr6, save stat(mean) 
mat c = r(StatTotal)
local c6 = c[1,1] //6-15
tabstat hh_income_gr7, save stat(mean) 
mat c = r(StatTotal)
local c7 = c[1,1] //60-75
tabstat hh_income_gr8, save stat(mean) 
mat c = r(StatTotal)
local c8 = c[1,1] //61-75
tabstat hh_income_gr9, save stat(mean) 
mat c = r(StatTotal)
local c9 = string(round(c[1,1], 0.01), "%13.0gc") //75+
tabstat hh_income_gr10, save stat(mean) 
mat c = r(StatTotal)
local c10 = string(round(c[1,1], 0.01), "%13.0gc") //Missing

//below 35
local c1c2c3c6 = `c1' + `c2' + `c3' + `c6'
local below_35 = string(round(`c1c2c3c6', 0.01), "%13.0gc")

file write file1 _n "below 35K       & `below_35'                   \\"

//36K-75K
local c4c5c7c8 = `c4' + `c5' + `c7' + `c8'
local k36_75 = string(round(`c4c5c7c8', 0.01),"%13.0gc") 

file write file1 _n "36K-75K       & `k36_75'                  \\"

//75+, Missing
file write file1 _n "75K+      & `c9'                 \\"
file write file1 _n "Income Missing  &       `c10'                   \\ \hline"
file write file1 _n "\multicolumn{2}{c}{Mother's Education } \\ \cline{1-2}"

**Completing Mother Education
tab mother_education_pre, m gen(mother_education_gr)
tabstat mother_education_gr1, save stat(mean)
mat m =r(StatTotal)
local m1 = m[1,1] //Associates
tabstat mother_education_gr2, save stat(mean)
mat m =r(StatTotal)
local m2 = m[1,1] //Bachelor
tabstat mother_education_gr3, save stat(mean)
mat m =r(StatTotal)
local m3 = m[1,1] //Ged
tabstat mother_education_gr4, save stat(mean)
mat m =r(StatTotal)
local m4 = string(round(m[1,1], 0.01), "%13.0gc") //High School Diploma
tabstat mother_education_gr5, save stat(mean)
mat m =r(StatTotal)
local m5 = m[1,1] //Less than 9th Gr
tabstat mother_education_gr6, save stat(mean)
mat m =r(StatTotal)
local m6 = m[1,1] //Master
tabstat mother_education_gr7, save stat(mean)
mat m =r(StatTotal)
local m7 = m[1,1] //No formal
tabstat mother_education_gr8, save stat(mean)
mat m =r(StatTotal)
local m8 = m[1,1] //Other
tabstat mother_education_gr9, save stat(mean)
mat m =r(StatTotal)
local m9 = string(round(m[1,1], 0.01), "%13.0gc")  //Some college no degree
tabstat mother_education_gr10, save stat(mean)
mat m =r(StatTotal)
local m10 = m[1,1] //Some High School no diploma
tabstat mother_education_gr11, save stat(mean)
mat m =r(StatTotal)
local m11 = m[1,1] //Vocational/Technical
tabstat mother_education_gr12, save stat(mean)
mat m =r(StatTotal)
local m12 = string(round(m[1,1], 0.01), "%13.0gc") //Missing

//less than high school =  less than 9th grade + no formal schooling 
local m5m7= `m5' + `m7'
local less_high = string(round(`m5m7', 0.01), "%13.0gc")
file write file1 _n "Less than high school   & `less_high'                 \\"

//some high school but no diploma = ged + some highschool no diploma
local m3m10 = `m3' + `m10'
local high_no_dipl = string(round(`m3m10', 0.01), "%13.0gc")
file write file1 _n "Some high school but no diploma      & `high_no_dipl'     \\"

//high school diploma = high school diploma
file write file1 _n "High school diploma           & `m4'  \\"

//some college = some college no degree
file write file1 _n "Some college but no degree     & `m9'             \\"

//college degree =  associates degree + bachelors degree + master graduate professional
local m1m2m6 = `m1' + `m2' + `m6'
local college = string(round(`m1m2m6', 0.01), "%13.0gc")
file write file1 _n "College degree        & `college'                 \\"

//other = other + vocational/technical program
local m8m11 = `m8' + `m11'
local other = string(round(`m8m11', 0.01), "%13.0gc")
file write file1 _n "Other	& `other'	\\"

//Missing
file write file1 _n "Missing Mother's Education        &              `m12'            \\ \hline" 
file write file1 _n "\multicolumn{2}{c}{Father's Education }    \\  \cline{1-2}"

**Completing Father Education
tab father_education_pre, m gen(father_education_gr)
tabstat father_education_gr1, save stat(mean)
mat m =r(StatTotal)
local m1 = m[1,1] //Associates
tabstat father_education_gr2, save stat(mean)
mat m =r(StatTotal)
local m2 = m[1,1] //Bachelor
tabstat father_education_gr3, save stat(mean)
mat m =r(StatTotal)
local m3 = m[1,1] //Ged
tabstat father_education_gr4, save stat(mean)
mat m =r(StatTotal)
local m4 = string(round(m[1,1], 0.01), "%13.0gc") //High School Diploma
tabstat father_education_gr5, save stat(mean)
mat m =r(StatTotal)
local m5 = m[1,1] //Less than 9th Gr
tabstat father_education_gr6, save stat(mean)
mat m =r(StatTotal)
local m6 = m[1,1] //Master
tabstat father_education_gr7, save stat(mean)
mat m =r(StatTotal)
local m7 = m[1,1] //No formal
tabstat father_education_gr8, save stat(mean)
mat m =r(StatTotal)
local m8 = m[1,1] //Other
tabstat father_education_gr9, save stat(mean)
mat m =r(StatTotal)
local m9 = string(round(m[1,1], 0.01), "%13.0gc")  //Some college no degree
tabstat father_education_gr10, save stat(mean)
mat m =r(StatTotal)
local m10 = m[1,1] //Some High School no diploma
tabstat father_education_gr11, save stat(mean)
mat m =r(StatTotal)
local m11 = m[1,1] //Vocational/Technical
tabstat father_education_gr12, save stat(mean)
mat m =r(StatTotal)
local m12 = string(round(m[1,1], 0.01), "%13.0gc") //Missing

//less than high school =  less than 9th grade + no formal schooling 
local m5m7= `m5' + `m7'
local less_high = string(round(`m5m7', 0.01), "%13.0gc")
file write file1 _n "Less than high school   & `less_high'                 \\"

//some high school but no diploma = ged + some highschool no diploma
local m3m10 = `m3' + `m10'
local high_no_dipl = string(round(`m3m10', 0.01), "%13.0gc")
file write file1 _n "Some high school but no diploma      & `high_no_dipl'     \\"

//high school diploma = high school diploma
file write file1 _n "High school diploma           & `m4'  \\"

//some college = some college no degree
file write file1 _n "Some college but no degree     & `m9'             \\"

//college degree =  associates degree + bachelors degree + master graduate professional
local m1m2m6 = `m1' + `m2' + `m6'
local college = string(round(`m1m2m6', 0.01), "%13.0gc")
file write file1 _n "College degree        & `college'                 \\"

//other = other + vocational/technical program
local m8m11 = `m8' + `m11'
local other = string(round(`m8m11', 0.01), "%13.0gc")
file write file1 _n "Other	& `other'	\\"

//Missing
file write file1 _n "Missing Father's Education        &              `m12'            \\ \hline" 

**Completing Unemployment
tab aid_unemployment_pre, m gen (aid_unemp_gr)
tabstat aid_unemp_gr2, save stat(mean)
mat b = r(StatTotal)
local b2= string(round(b[1,1], 0.01), "%13.0gc")
tabstat aid_unemp_gr3, save stat(mean)
mat b = r(StatTotal)
local b3 = string(round(b[1,1], 0.01), "%13.0gc")

file write file1 _n "\begin{tabular}[c]{@{}l@{}}Receive unemployment benefit\end{tabular} &  `b2'    \\"
file write file1 _n "\begin{tabular}[c]{@{}l@{}} Missing unemployment benefit \end{tabular} &    `b3'             \\ \hline"

tabstat age_pre if age_pre != 0, save stat(mean semean n) 
mat a = r(StatTotal)
local a1 = string(round(a[1,1], 0.01), "%13.0gc")
local a2 = string(round(a[2,1], 0.001), "%13.0gc")

file write file1 _n "Pre-assessment Age (months) & \begin{tabular}[c]{@{}l@{}}`a1'\\ (`a2')\end{tabular}                        \\"


local i = 1

foreach x in cog ncog {
	tabstat std_`x'_pre if has_`x'_pre == 1, save stat(mean semean n)
	mat a = r(StatTotal)
	local item`i' = string(round(a[1,1], 0.001), "%13.0gc")
	local i = `i' + 1
	local item`i' = string(round(a[2,1], 0.0001), "%13.0gc")
	local i = `i' + 1
	}

file write file1 _n "Pre-assessment Cognitive Score   & \begin{tabular}[c]{@{}l@{}} `item1'\\ (`item2')\end{tabular}                        \\"
file write file1 _n "Pre-assessment Non-cognitive Score      & \begin{tabular}[c]{@{}l@{}} `item3' \\ (`item4')\end{tabular}              \\ \hline"
    
file write file1 _n "\end{tabular}"

file write file1 _n "\begin{tablenotes}"
file write file1 _n "     \footnotesize"

file write file1 _n "\item \textit{Notes:} This table presents the summary statistics for baseline demographic variables as well as baseline cognitive and non-cognitive performance. For the education levels, \textit{Some high school but not diploma} includes parents with GED or high school attendance without diploma, \textit{College degree} includes associate's, bachelor and master degrees, \textit{Less than high school} includes education below 9th grade or no formal schooling, and \textit{Other} includes vocational/technical or other unclassified programs."  
file write file1 _n "\item Standard errors in parentheses" 

file write file1 _n "\end{tablenotes}"
file write file1 _n "\end{threeparttable}"
file write file1 _n "\end{table}"
file write file1 _n "\end{document}"
 
file close file1

*****************************
****MERGING ON NEIGHBOURS****
*****************************


clear all

cd "$repository/data_sets/generated"

use newv_table34_unique_data_clean

**Merging with number of neighbours

merge 1:1 child test year using merged_neigh_count
keep if _merge == 3

**Some observations from the master file are not matched to the using file as those kids did not have any neighbors living in a radius
**smaller than 20,000

drop _merge
foreach distance in 500 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 15000 20000 {
gen percent_treated_`distance' = (treated_`distance' / (treated_`distance' + control_`distance'))*100
}

**Merging with distance to school and block group variable
foreach file in Relevant_DistToSchool_1 Relevant_DistToSchool_2 Relevant_censusblock_checc {
merge m:1 child using `file'
*drop if _merge == 2
drop _merge
} 

save newv_table56_unique_data_clean, replace

********************************
**Create Table 5 and Table 6****
********************************



clear all

cd "$repository/data_sets/generated"

use newv_table56_unique_data_clean

***********************************************************************************
**If want to reproduce table restricting sample to control kids, add the code below



keep if (C == 1 & first_random == 1) | (CC == 1 & first_random == 1) | (CT_pretreat == 1) | (CK_prekinder == 1)



***********************************************************************************

**Table 5

file open file2 using "$repository/analysis/tables/tables_pre_percentage_treated/newv_table5.tex", replace write


file write file2 "\documentclass[11pt]{article}"
file write file2 _n "\usepackage{booktabs, multicol, multirow}"
file write file2 _n "\usepackage{caption}"
file write file2 _n "\userpackage[flushleft]{threeparttable}"
file write file2 _n	"\begin{document}"

file write file2 _n "\begin{table}[h]"
file write file2 _n "\begin{threeparttable}"
file write file2 _n "\centering"
file write file2 _n "\caption{Number Neighbors at the Time of Each Assessment}"
file write file2 _n "\label{tab:Nstat}"
file write file2 _n "\begin{tabular}{l|cc|cc|cc|cc|cc|cc|cc|cc|cc|cc|cc|cc|cc}"
file write file2 _n "\toprule"
file write file2 _n "\midrule"
file write file2 _n "& \multicolumn{2}{c}{d $=$ 500} & \multicolumn{2}{c}{d $=$ 1000} & \multicolumn{2}{c}{d $=$ 2000} & \multicolumn{2}{c}{d $=$ 3000} & \multicolumn{2}{c}{d $=$ 4000} & \multicolumn{2}{c}{d $=$ 5000} & \multicolumn{2}{c}{d $=$ 6000} & \multicolumn{2}{c}{d $=$ 7000} & \multicolumn{2}{c}{d $=$ 8000} & \multicolumn{2}{c}{d $=$ 9000} & \multicolumn{2}{c}{d $=$ 10000} & \multicolumn{2}{c}{d $=$ 15000} & \multicolumn{2}{c}{d $=$ 20000}\\" 
file write file2 _n "Assessment (t) & $ N^{{treated}_{d}}$ & $ N^{{control}_{d}}$ & $ N^{{treated}_{d}}$ & $ N^{{control}_{d}}$ & $ N^{{treated}_{d}}$ & $ N^{{control}_{d}}$ & $ N^{{treated}_{d}}$ & $ N^{{control}_{d}}$ & $ N^{{treated}_{d}}$ & $ N^{{control}_{d}}$ & $ N^{{treated}_{d}}$ & $ N^{{control}_{d}}$ & $ N^{{treated}_{d}}$ & $ N^{{control}_{d}}$ & $ N^{{treated}_{d}}$ & $ N^{{control}_{d}}$ & $ N^{{treated}_{d}}$ & $ N^{{control}_{d}}$ & $ N^{{treated}_{d}}$ & $ N^{{control}_{d}}$ & $ N^{{treated}_{d}}$ & $ N^{{control}_{d}}$ & $ N^{{treated}_{d}}$ & $ N^{{control}_{d}}$\\"
file write file2 _n "\midrule"



local i = 1
local j = 1


foreach distance in 500 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 15000 20000 {
		tabstat treated_`distance', by(test) save stat(mean semean n)
		local i = 1
		local j = 1
		foreach stat in Stat7 Stat5 Stat6 Stat8 Stat1 Stat2 Stat3 Stat4 {
		mat a = r(`stat')
		mat list a
		local item`distance'_`i' = string(round(a[1,1], 0.01), "%13.0gc") //Mean
		di `item`distance'_`i''
		local i = `i' + 1
		local item`distance'_`i' = string(round(a[2,1], 0.01), "%13.0gc") //Standard Error
		local i = `i' + 1
		}
		mat b = r(StatTotal)
		local itemtotal`distance'_`j' = string(round(b[1,1], 0.01), "%13.0gc")
		local j = `j' + 1
		local itemtotal`distance'_`j' = string(round(b[2,1], 0.01), "%13.0gc")
		local j = `j' + 1
		local itemtotal`distance'_`j' = string(b[3,1], "%13.0gc")
		local j = `j' + 1
		
		tabstat control_`distance', by(test) save stat(mean semean n)
		foreach stat in Stat7 Stat5 Stat6 Stat8 Stat1 Stat2 Stat3 Stat4 {
		mat a = r(`stat')
		local item`distance'_`i' = string(round(a[1,1], 0.01), "%13.0gc") //Mean
		local i = `i' + 1
		local item`distance'_`i' = string(round(a[2,1], 0.01), "%13.0gc") //Standard Error
		local i = `i' + 1
		}
		mat b = r(StatTotal)
		local itemtotal`distance'_`j' = string(round(b[1,1], 0.01), "%13.0gc")
		local j = `j' + 1
		local itemtotal`distance'_`j' = string(round(b[2,1], 0.01), "%13.0gc")
		local j = `j' + 1
		local itemtotal`distance'_`j' = string(b[3,1], "%13.0gc")
		local j = `j' + 1
		
}



file write file2 _n "\multirow{2}{*}{Pre} & `item500_1' & `item500_17' & `item1000_1' & `item1000_17' & `item2000_1' & `item2000_17' &  `item3000_1' & `item3000_17' & `item4000_1' & `item4000_17' & `item5000_1' & `item5000_17' & `item6000_1' & `item6000_17' & `item7000_1' & `item7000_17' & `item8000_1' & `item8000_17' & `item9000_1' & `item9000_17' & `item10000_1' & `item10000_17' & `item15000_1' & `item15000_17' & `item20000_1' & `item20000_17' \\"
file write file2 _n "& (`item500_2') & (`item500_18') & (`item1000_2') & (`item1000_18') & (`item2000_2') & (`item2000_18') & (`item3000_2') & (`item3000_18') & (`item4000_2') & (`item4000_18') & (`item5000_2') & (`item5000_18')& (`item6000_2') & (`item6000_18') & (`item7000_2') & (`item7000_18') & (`item8000_2') & (`item8000_18') & (`item9000_2') & (`item9000_18') & (`item10000_2') & (`item10000_18') & (`item15000_2') & (`item15000_18') & (`item20000_2') & (`item20000_18')\\"
file write file2 _n "& & & & & & & & & & & & & & & & & & & & & & & & & &  \\"
file write file2 _n "\multirow{2}{*}{Mid} & `item500_3' & `item500_19' & `item1000_3' & `item1000_19' & `item2000_3' & `item2000_19' &  `item3000_3' & `item3000_19' & `item4000_3' & `item4000_19' & `item5000_3' & `item5000_19' & `item6000_3' & `item6000_19' & `item7000_3' & `item7000_19' & `item8000_3' & `item8000_19' & `item9000_3' & `item9000_19' & `item10000_3' & `item10000_19' & `item15000_3' & `item15000_19' & `item20000_3' & `item20000_19' \\"
file write file2 _n "& (`item500_4') & (`item500_20') & (`item1000_4') & (`item1000_20') & (`item2000_4') & (`item2000_20') & (`item3000_4') & (`item3000_20') & (`item4000_4') & (`item4000_20') & (`item5000_4') & (`item5000_20')& (`item6000_4') & (`item6000_20') & (`item7000_4') & (`item7000_20') & (`item8000_4') & (`item8000_20') & (`item9000_4') & (`item9000_20') & (`item10000_4') & (`item10000_20') & (`item15000_4') & (`item15000_20') & (`item20000_4') & (`item20000_20')\\"
file write file2 _n "& & & & & & & & & & & & & & & & & & & & & & & & & &  \\"
file write file2 _n "\multirow{2}{*}{Post} & `item500_5' & `item500_21' & `item1000_5' & `item1000_21' & `item2000_5' & `item2000_21' &  `item3000_5' & `item3000_21' & `item4000_5' & `item4000_21' & `item5000_5' & `item5000_21' & `item6000_5' & `item6000_21' & `item7000_5' & `item7000_21' & `item8000_5' & `item8000_21' & `item9000_5' & `item9000_21' & `item10000_5' & `item10000_21' & `item15000_5' & `item15000_21' & `item20000_5' & `item20000_21' \\"
file write file2 _n "& (`item500_6') & (`item500_22') & (`item1000_6') & (`item1000_22') & (`item2000_6') & (`item2000_22') & (`item3000_6') & (`item3000_22') & (`item4000_6') & (`item4000_22') & (`item5000_6') & (`item5000_22')& (`item6000_6') & (`item6000_22') & (`item7000_6') & (`item7000_22') & (`item8000_6') & (`item8000_22') & (`item9000_6') & (`item9000_22') & (`item10000_6') & (`item10000_22') & (`item15000_6') & (`item15000_22') & (`item20000_6') & (`item20000_22')\\"
file write file2 _n "& & & & & & & & & & & & & & & & & & & & & & & & & &  \\"
file write file2 _n "\multirow{2}{*}{Summer Loss} & `item500_7' & `item500_23' & `item1000_7' & `item1000_23' & `item2000_7' & `item2000_23' &  `item3000_7' & `item3000_23' & `item4000_7' & `item4000_23' & `item5000_7' & `item5000_23' & `item6000_7' & `item6000_23' & `item7000_7' & `item7000_23' & `item8000_7' & `item8000_23' & `item9000_7' & `item9000_23' & `item10000_7' & `item10000_23' & `item15000_7' & `item15000_23' & `item20000_7' & `item20000_23' \\"
file write file2 _n "& (`item500_8') & (`item500_24') & (`item1000_8') & (`item1000_24') & (`item2000_8') & (`item2000_24') & (`item3000_8') & (`item3000_24') & (`item4000_8') & (`item4000_24') & (`item5000_8') & (`item5000_24')& (`item6000_8') & (`item6000_24') & (`item7000_8') & (`item7000_24') & (`item8000_8') & (`item8000_24') & (`item9000_8') & (`item9000_24') & (`item10000_8') & (`item10000_24') & (`item15000_8') & (`item15000_24') & (`item20000_8') & (`item20000_24')\\"
file write file2 _n "& & & & & & & & & & & & & & & & & & & & & & & & & &  \\"
file write file2 _n "\multirow{2}{*}{Aged-Out Year 1} & `item500_9' & `item500_25' & `item1000_9' & `item1000_25' & `item2000_9' & `item2000_25' &  `item3000_9' & `item3000_25' & `item4000_9' & `item4000_25' & `item5000_9' & `item5000_25' & `item6000_9' & `item6000_25' & `item7000_9' & `item7000_25' & `item8000_9' & `item8000_25' & `item9000_9' & `item9000_25' & `item10000_9' & `item10000_25' & `item15000_9' & `item15000_25' & `item20000_9' & `item20000_25' \\"
file write file2 _n "& (`item500_10') & (`item500_26') & (`item1000_10') & (`item1000_26') & (`item2000_10') & (`item2000_26') & (`item3000_10') & (`item3000_26') & (`item4000_10') & (`item4000_26') & (`item5000_10') & (`item5000_26')& (`item6000_10') & (`item6000_26') & (`item7000_10') & (`item7000_26') & (`item8000_10') & (`item8000_26') & (`item9000_10') & (`item9000_26') & (`item10000_10') & (`item10000_26') & (`item15000_10') & (`item15000_26') & (`item20000_10') & (`item20000_26')\\"
file write file2 _n "& & & & & & & & & & & & & & & & & & & & & & & & & &  \\"
file write file2 _n "\multirow{2}{*}{Aged-Out Year 2} & `item500_11' & `item500_27' & `item1000_11' & `item1000_27' & `item2000_11' & `item2000_27' &  `item3000_11' & `item3000_27' & `item4000_11' & `item4000_27' & `item5000_11' & `item5000_27' & `item6000_11' & `item6000_27' & `item7000_11' & `item7000_27' & `item8000_11' & `item8000_27' & `item9000_11' & `item9000_27' & `item10000_11' & `item10000_27' & `item15000_11' & `item15000_27' & `item20000_11' & `item20000_27' \\"
file write file2 _n "& (`item500_12') & (`item500_28') & (`item1000_12') & (`item1000_28') & (`item2000_12') & (`item2000_28') & (`item3000_12') & (`item3000_28') & (`item4000_12') & (`item4000_28') & (`item5000_12') & (`item5000_28')& (`item6000_12') & (`item6000_28') & (`item7000_12') & (`item7000_28') & (`item8000_12') & (`item8000_28') & (`item9000_12') & (`item9000_28') & (`item10000_12') & (`item10000_28') & (`item15000_12') & (`item15000_28') & (`item20000_12') & (`item20000_28')\\"
file write file2 _n "& & & & & & & & & & & & & & & & & & & & & & & & & &  \\"
file write file2 _n "\multirow{2}{*}{Aged-Out Year 3} & `item500_13' & `item500_29' & `item1000_13' & `item1000_29' & `item2000_13' & `item2000_29' &  `item3000_13' & `item3000_29' & `item4000_13' & `item4000_29' & `item5000_13' & `item5000_29' & `item6000_13' & `item6000_29' & `item7000_13' & `item7000_29' & `item8000_13' & `item8000_29' & `item9000_13' & `item9000_29' & `item10000_13' & `item10000_29' & `item15000_13' & `item15000_29' & `item20000_13' & `item20000_29' \\"
file write file2 _n "& (`item500_14') & (`item500_30') & (`item1000_14') & (`item1000_30') & (`item2000_14') & (`item2000_30') & (`item3000_14') & (`item3000_30') & (`item4000_14') & (`item4000_30') & (`item5000_14') & (`item5000_30')& (`item6000_14') & (`item6000_30') & (`item7000_14') & (`item7000_30') & (`item8000_14') & (`item8000_30') & (`item9000_14') & (`item9000_30') & (`item10000_14') & (`item10000_30') & (`item15000_14') & (`item15000_30') & (`item20000_14') & (`item20000_30')\\"
file write file2 _n "& & & & & & & & & & & & & & & & & & & & & & & & & &  \\"
file write file2 _n "\multirow{2}{*}{Aged-Out Year 4} & `item500_15' & `item500_31' & `item1000_15' & `item1000_31' & `item2000_15' & `item2000_31' &  `item3000_15' & `item3000_31' & `item4000_15' & `item4000_31' & `item5000_15' & `item5000_31' & `item6000_15' & `item6000_31' & `item7000_15' & `item7000_31' & `item8000_15' & `item8000_31' & `item9000_15' & `item9000_31' & `item10000_15' & `item10000_31' & `item15000_15' & `item15000_31' & `item20000_15' & `item20000_31' \\"
file write file2 _n "& (`item500_16') & (`item500_32') & (`item1000_16') & (`item1000_32') & (`item2000_16') & (`item2000_32') & (`item3000_16') & (`item3000_32') & (`item4000_16') & (`item4000_32') & (`item5000_16') & (`item5000_32')& (`item6000_16') & (`item6000_32') & (`item7000_16') & (`item7000_32') & (`item8000_16') & (`item8000_32') & (`item9000_16') & (`item9000_32') & (`item10000_16') & (`item10000_32') & (`item15000_16') & (`item15000_32') & (`item20000_16') & (`item20000_32')\\"
file write file2 _n "\midrule"
file write file2 _n "\multirow{2}{*}{All} & `itemtotal500_1' & `itemtotal500_4' & `itemtotal1000_1' & `itemtotal1000_4' & `itemtotal2000_1' & `itemtotal2000_4' & `itemtotal13000_1' & `itemtotal3000_4' & `itemtotal14000_1' & `itemtotal4000_4' & `itemtotal15000_1' & `itemtotal5000_4'& `itemtotal16000_1' & `itemtotal6000_4'& `itemtotal7000_1' & `itemtotal7000_4' & `itemtotal8000_1' & `itemtotal8000_4' & `itemtotal9000_1' & `itemtotal9000_4' & `itemtotal10000_1' & `itemtotal10000_4' & `itemtotal15000_1' & `itemtotal15000_4' & `itemtotal20000_1' & `itemtotal20000_4'\\"
file write file2 _n "& (`itemtotal500_2') & (`itemtotal500_5') & (`itemtotal1000_2') & (`itemtotal1000_5') & (`itemtotal2000_2') & (`itemtotal2000_5') & (`itemtotal3000_2') & (`itemtotal3000_5') & (`itemtotal4000_2') & (`itemtotal4000_5') & (`itemtotal5000_2') & (`itemtotal5000_5') & (`itemtotal6000_2') & (`itemtotal6000_5') & (`itemtotal7000_2') & (`itemtotal7000_5') & (`itemtotal8000_2') & (`itemtotal8000_5') & (`itemtotal9000_2') & (`itemtotal9000_5') & (`itemtotal10000_2') & (`itemtotal10000_5') & (`itemtotal15000_2') & (`itemtotal15000_5') & (`itemtotal20000_2') & (`itemtotal20000_5')\\"
file write file2 _n "\midrule"
file write file2 _n "Obs. & `itemtotal500_3' &`itemtotal500_6' & `itemtotal1000_3' & `itemtotal1000_6' &`itemtotal2000_3' & `itemtotal2000_6' & `itemtotal3000_3' & `itemtotal3000_6' & `itemtotal4000_3' & `itemtotal4000_6' & `itemtotal5000_3' & `itemtotal5000_6' & `itemtotal6000_3' & `itemtotal6000_6' & `itemtotal7000_3' & `itemtotal7000_6' & `itemtotal8000_3' & `itemtotal8000_6' & `itemtotal9000_3' & `itemtotal9000_6' & `itemtotal10000_3' & `itemtotal10000_6' & `itemtotal15000_3' & `itemtotal15000_6' & `itemtotal20000_3' & `itemtotal20000_6'\\"
file write file2 _n "\midrule"
file write file2 _n "\bottomrule"
file write file2 _n "\end{tabular}"


file write file2 _n "\begin{tablenotes}"
file write file2 _n "\footnotesize"

file write file2 _n "\item \textit{Notes:} This table shows the average number of treated and control neighbors at the time of different assessments in our final sample of control kids, for different definitions  of  neighborhood radii.  It only included those observations for which we have child's assessment outcome. The last column shows average number of treated and control neighbors, across all assessments."
file write file2 _n "\item Standard errors are reported in parentheses." 

file write file2 _n "\end{tablenotes}"
file write file2 _n "\end{threeparttable}"

file write file2 _n "\end{table}"

file write file2 _n "\end{document}"

file close file2



	

**Table 6

clear all

cd "$repository/data_sets/generated"

use newv_table56_unique_data_clean

***********************************************************************************
**If want to reproduce table restricting sample to control kids, add the code below


keep if (C == 1 & first_random == 1) | (CC == 1 & first_random == 1) | (CT_pretreat == 1) | (CK_prekinder == 1)



***********************************************************************************

file open file3 using "$repository/analysis/tables/tables_pre_percentage_treated/newv_table6.tex", replace write


file write file3 "\documentclass[11pt]{article}"
file write file3 _n "\usepackage{booktabs, multicol, multirow}"
file write file3 _n "\usepackage{caption}"
file write file3 _n "\userpackage[flushleft]{threeparttable}"
file write file3 _n	"\begin{document}"

file write file3 _n	"\begin{table}[]"
file write file3 _n	"\begin{threeparttable}"
file write file3 _n	"\centering"
file write file3 _n	"\caption{Average Percentage of Treated Neighbors in Our Final Sample}"
file write file3 _n	"\label{tab:p_sum_stat}"
file write file3 _n	"\begin{tabular}{l|lllllllllllll}"
file write file3 _n	"Assessment         & 0.5K meters & 1K meters & 2K meters & 3K meters & 4K meters  & 5K meters & 6K meters & 7K meters & 8K meters & 9K meters & 10K meters & 15K meters & 20K meters \\ \hline \hline"


local i = 1
local j = 1

foreach distance in 500 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 15000 20000 {
		tabstat percent_treated_`distance', by(test) save stat(mean semean n)
		local i = 1
		foreach stat in Stat7 Stat5 Stat6 Stat8 Stat1 Stat2 Stat3 Stat4 StatTotal{
		mat a = r(`stat')
		mat list a
		local item`distance'_`i' = string(round(a[1,1], 0.01), "%13.0gc") //Mean
		di `item`distance'_`i''
		local i = `i' + 1
		local item`distance'_`i' = string(round(a[2,1], 0.01), "%13.0gc") //Standard Error
		local i = `i' + 1
		}
}


file write file3 _n	"Pre     & `item500_1' & `item1000_1' & `item2000_1'  &    `item3000_1'      &    `item4000_1' & `item5000_1' & `item6000_1' & `item7000_1' & `item8000_1' & `item9000_1' & `item10000_1' & `item15000_1' & `item20000_1'        \\"
file write file3 _n	"& (`item500_2')  & (`item1000_2')  & (`item2000_2')  &    (`item3000_2' )    &  (`item4000_2') & (`item5000_2')  & (`item6000_2')  & (`item7000_2')  &    (`item8000_2' )    &  (`item9000_2') & (`item10000_2')  &    (`item15000_2' )    &  (`item20000_2')    \\"
file write file3 _n	"Mid     & `item500_3' & `item1000_3' & `item2000_3'  &    `item3000_3'      &    `item4000_3' & `item5000_3' & `item6000_3' & `item7000_3' & `item8000_3' & `item9000_3' & `item10000_3' & `item15000_3' & `item20000_3'        \\"
file write file3 _n	"& (`item500_4')  & (`item1000_4')  & (`item2000_4')  &    (`item3000_4' )    &  (`item4000_4') & (`item5000_4')  & (`item6000_4')  & (`item7000_4')  &    (`item8000_4' )    &  (`item9000_4') & (`item10000_4')  &    (`item15000_4' )    &  (`item20000_4')    \\"
file write file3 _n	"Post     & `item500_5' & `item1000_5' & `item2000_5'  &    `item3000_5'      &    `item4000_5' & `item5000_5' & `item6000_5' & `item7000_5' & `item8000_5' & `item9000_5' & `item10000_5' & `item15000_5' & `item20000_5'        \\"
file write file3 _n	"& (`item500_6')  & (`item1000_6')  & (`item2000_6')  &    (`item3000_6' )    &  (`item4000_6') & (`item5000_6')  & (`item6000_6')  & (`item7000_6')  &    (`item8000_6' )    &  (`item9000_6') & (`item10000_6')  &    (`item15000_6' )    &  (`item20000_6')    \\"
file write file3 _n	"Summer Loss     & `item500_7' & `item1000_7' & `item2000_7'  &    `item3000_7'      &    `item4000_7' & `item5000_7' & `item6000_7' & `item7000_7' & `item8000_7' & `item9000_7' & `item10000_7' & `item15000_7' & `item20000_7'        \\"
file write file3 _n	"& (`item500_8')  & (`item1000_8')  & (`item2000_8')  &    (`item3000_8' )    &  (`item4000_8') & (`item5000_8')  & (`item6000_8')  & (`item7000_8')  &    (`item8000_8' )    &  (`item9000_8') & (`item10000_8')  &    (`item15000_8' )    &  (`item20000_8')    \\"
file write file3 _n	"Aged-Out Year 1     & `item500_9' & `item1000_9' & `item2000_9'  &    `item3000_9'      &    `item4000_9' & `item5000_9' & `item6000_9' & `item7000_9' & `item8000_9' & `item9000_9' & `item10000_9' & `item15000_9' & `item20000_9'        \\"
file write file3 _n	"& (`item500_10')  & (`item1000_10')  & (`item2000_10')  &    (`item3000_10' )    &  (`item4000_10') & (`item5000_10')  & (`item6000_10')  & (`item7000_10')  &    (`item8000_10' )    &  (`item9000_10') & (`item10000_10')  &    (`item15000_10' )    &  (`item20000_10')    \\"
file write file3 _n	"Aged-Out Year 2     & `item500_11' & `item1000_11' & `item2000_11'  &    `item3000_11'      &    `item4000_11' & `item5000_11' & `item6000_11' & `item7000_11' & `item8000_11' & `item9000_11' & `item10000_11' & `item15000_11' & `item20000_11'        \\"
file write file3 _n	"& (`item500_12')  & (`item1000_12')  & (`item2000_12')  &    (`item3000_12' )    &  (`item4000_12') & (`item5000_12')  & (`item6000_12')  & (`item7000_12')  &    (`item8000_12' )    &  (`item9000_12') & (`item10000_12')  &    (`item15000_12' )    &  (`item20000_12')    \\"
file write file3 _n	"Aged-Out Year 3     & `item500_13' & `item1000_13' & `item2000_13'  &    `item3000_13'      &    `item4000_13' & `item5000_13' & `item6000_13' & `item7000_13' & `item8000_13' & `item9000_13' & `item10000_13' & `item15000_13' & `item20000_13'        \\"
file write file3 _n	"& (`item500_14')  & (`item1000_14')  & (`item2000_14')  &    (`item3000_14' )    &  (`item4000_14') & (`item5000_14')  & (`item6000_14')  & (`item7000_14')  &    (`item8000_14' )    &  (`item9000_14') & (`item10000_14')  &    (`item15000_14' )    &  (`item20000_14')    \\"
file write file3 _n	"Aged-Out Year 4     & `item500_15' & `item1000_15' & `item2000_15'  &    `item3000_15'      &    `item4000_15' & `item5000_15' & `item6000_15' & `item7000_15' & `item8000_15' & `item9000_15' & `item10000_15' & `item15000_15' & `item20000_15'        \\"
file write file3 _n	"& (`item500_16')  & (`item1000_16')  & (`item2000_16')  &    (`item3000_16' )    &  (`item4000_16') & (`item5000_16')  & (`item6000_16')  & (`item7000_16')  &    (`item8000_16' )    &  (`item9000_16') & (`item10000_16')  &    (`item15000_16' )    &  (`item20000_16')    \\"
file write file3 _n	"Overall     & `item500_17' & `item1000_17' & `item2000_17'  &    `item3000_17'      &    `item4000_17' & `item5000_17' & `item6000_17' & `item7000_17' & `item8000_17' & `item9000_17' & `item10000_17' & `item15000_17' & `item20000_17'        \\"
file write file3 _n	"& (`item500_18')  & (`item1000_18')  & (`item2000_18')  &    (`item3000_18' )    &  (`item4000_18') & (`item5000_18')  & (`item6000_18')  & (`item7000_18')  &    (`item8000_18' )    &  (`item9000_18') & (`item10000_18')  &    (`item15000_18' )    &  (`item20000_18')    \\ \hline"
file write file3 _n	"\end{tabular}"

file write file3 _n	"\begin{tablenotes}"
file write file3 _n	"\footnotesize"

file write file3 _n	"\item \textit{Notes:} Mean percentage of treated neighbors $P_{i,t,d}^{treated}$, (of the final sample) at the time of each assessment is presented for $d=\{1000; 5000; 10000; 15000; 20000\}$ meters. Standard errors are reported in parentheses."

file write file3 _n	"\end{tablenotes}"
file write file3 _n	"\end{threeparttable}"
file write file3 _n	"\end{table}" 

file write file3 _n "\end{document}"

file close file3

********************************************************************* 
**Table 7************************************************************
*********************************************************************

clear all

cd "$repository/data_sets/generated"

use newv_table56_unique_data_clean

***********************************************************************************
**If want to reproduce table restricting sample to control kids, add the code below


keep if (C == 1 & first_random == 1) | (CC == 1 & first_random == 1) | (CT_pretreat == 1) | (CK_prekinder == 1)


***********************************************************************************

replace age_pre = . if age_pre == 0	

**Creating factor variables
egen gender_num = group(gender)
egen race_num = group(race)
egen blockgroup_num = group(blockgroup)
destring year, replace

**Setting up Time Dimension
gen test_num = 0 if test == "pre"
replace test_num = 1 if test == "mid"
replace test_num = 2 if test == "post"
replace test_num = 3 if test == "sl"
replace test_num = 4 if test == "aoy1"
replace test_num = 5 if test == "aoy2"
replace test_num = 6 if test == "aoy3"
replace test_num = 7 if test == "aoy4"

sort child test_num
xtset child test_num	
	

local distance "500 1000 2000 3000 5000 6000 7000 8000 9000 10000 15000 20000"
local num : list sizeof local(distance)
local i = 1


file open file4 using "$repository/analysis/tables/tables_pre_percentage_treated/newv_table7.tex", replace write

file write file4 _n "\documentclass[11pt]{article}"
file write file4 _n "\usepackage{booktabs, multicol, multirow}"
file write file4 _n "\usepackage{caption}"
file write file4 _n "\userpackage[flushleft]{threeparttable}"
file write file4 _n	"\begin{document}"

file write file4 _n "\begin{table}[h]\centering" 

file write file4 _n "\begin{threeparttable}"
file write file4 _n "\caption{Spillover on Cognitive and Non-cognitive Scores} \label{tab:results_all}"
file write file4 _n "\begin{tabular}{lc|c}"
file write file4 _n "\toprule"
file write file4 _n "\midrule"
file write file4 _n "& \multicolumn{1}{c}{Cognitive Scores} & \multicolumn{1}{c}{Non-cognitive Scores}\\ \cline{2-7}"
file write file4 _n "& Fixed Effect & Fixed Effect \\"
file write file4 _n " $ d $ (meters)& (1) & (2) \\"
file write file4 _n "\midrule"

**Running main regressions	

foreach d of local distance  {	
	local j = 1
	foreach assess in cog ncog {

	***FIXED EFFECTS
	quietly xtreg std_`assess' percent_treated_`d'  i.test_num if has_`assess' == 1, fe cluster(child) 
	
	matrix d = r(table) 

	*adding stars
		if d[4,1] < 0.01 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "***"
		}
		else if d[4,1] < 0.05 & d[4,1] >= 0.01 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "**"
		}	
		else if d[4,1] < 0.1 & d[4,1] >= 0.05 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "*"
		}
		else {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc")
		}		
		
		local se_`j'_`d' = string(round(_se[percent_treated_`d'], .0001), "%13.0gc")
		
		local j = `j' + 1

	}

	file write file4 _n "\multirow{2}{*}{`d'} & `item_1_`d'' & `item_2_`d'' \\"
	file write file4 _n "& (`se_1_`d'') & (`se_2_`d'') \\"

	if `i' < `num' {
		file write file4 _n "& & \\"	
	}
	local i = `i' + 1
}	
	
file write file4 _n "\midrule"
file write file4 _n "\bottomrule"
file write file4 _n "\end{tabular}"
file write file4 _n "\begin{tablenotes}"
file write file4 _n "\footnotesize"

file write file4 _n "\item \textit{Notes:} Columns 1-3 (4-6) display the effect of a 1 percentage point increase in the share of treated neighbors of a control child on his/her standardized cognitive (non-cognitive) score." 
file write file4 _n "\item Robust standard errors, clustered at the individual level in parentheses"
file write file4 _n "\item *** p$<$0.01, ** p$<$0.05, * p$<$0.1"
file write file4 _n "\end{tablenotes}"
file write file4 _n "\end{threeparttable}"
file write file4 _n "\end{table}"

file write file4 _n "\end{document}"

file close file4


**TABLE 8: SPILL OVER BY GENDER*****

clear all

cd "$repository/data_sets/generated"

use newv_table56_unique_data_clean

***********************************************************************************
**If want to reproduce table restricting sample to control kids, add the code below



keep if (C == 1 & first_random == 1) | (CC == 1 & first_random == 1) | (CT_pretreat == 1) | (CK_prekinder == 1)



***********************************************************************************



replace age_pre = . if age_pre == 0	

**Creating factor variables
egen gender_num = group(gender)
egen race_num = group(race)
egen blockgroup_num = group(blockgroup)
destring year, replace

**Setting up Time Dimension
gen test_num = 0 if test == "pre"
replace test_num = 1 if test == "mid"
replace test_num = 2 if test == "post"
replace test_num = 3 if test == "sl"
replace test_num = 4 if test == "aoy1"
replace test_num = 5 if test == "aoy2"
replace test_num = 6 if test == "aoy3"
replace test_num = 7 if test == "aoy4"

sort child test_num
xtset child test_num


**SPILLOVER BOYS

local distance "500 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 15000 20000"
local num : list sizeof local(distance)
local i = 1


file open file5 using "$repository/analysis/tables/tables_pre_percentage_treated/newv_table8spillover_gender.tex", replace write


file write file5 "\documentclass[11pt]{article}"
file write file5 _n "\usepackage{booktabs, multicol, multirow}"
file write file5 _n "\usepackage{caption}"
file write file5 _n "\userpackage[flushleft]{threeparttable}"
file write file5 _n	"\begin{document}"

file write file5 _n "\begin{table}[H]\centering \caption{\small Spillover Effects by Gender  }  \scalebox{1}{\label{tab:results_gender} \begin{threeparttable}" 
file write file5 _n "\begin{tabular}{lc|c}"
file write file5 _n "\toprule"
file write file5 _n "\midrule"
file write file5 _n "& \multicolumn{1}{c}{Cognitive Scores} & \multicolumn{1}{c}{Non-cognitive Scores}\\ \cline{2-7}"
file write file5 _n "& Fixed Effect & Fixed Effect \\"
file write file5 _n "$ d $ (meters) & (1) & (2) \\"
file write file5 _n "\midrule"
file write file5 _n "& \multicolumn{2}{c}{Control Boys}\\ \cline{2-7}"

**Running Regressions for Boys	

foreach d of local distance  {	
	local j = 1
	foreach assess in cog ncog {

	***FIXED EFFECTS
	quietly xtreg std_`assess' percent_treated_`d' i.test_num if (has_`assess' == 1 & gender_num == 2), fe cluster(child) 
	
	matrix d = r(table) 

	*adding stars
		if d[4,1] < 0.01 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "***"
		}
		else if d[4,1] < 0.05 & d[4,1] >= 0.01 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "**"
		}	
		else if d[4,1] < 0.1 & d[4,1] >= 0.05 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "*"
		}
		else {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc")
		}		
		
		local se_`j'_`d' = string(round(_se[percent_treated_`d'], .0001), "%13.0gc")
		
		local j = `j' + 1

	}

	file write file5 _n "\multirow{2}{*}{`d'} & `item_1_`d'' & `item_2_`d'' \\"
	file write file5 _n "& (`se_1_`d'') & (`se_2_`d'') \\"

	if `i' < `num' {
		file write file5 _n "& & \\"	
	}
	local i = `i' + 1
}

file write file5 _n "& \multicolumn{2}{c}{}\\"
file write file5 _n "& \multicolumn{2}{c}{Control Girls}\\ \cline{2-7}"


** SPILL-OVER GIRLS


local distance "500 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 15000 20000"
local num : list sizeof local(distance)
local i = 1

**Running Regressions for Girls	

foreach d of local distance  {	
	local j = 1
	foreach assess in cog ncog {

	***FIXED EFFECTS
	quietly xtreg std_`assess' percent_treated_`d' i.test_num if (has_`assess' == 1 & gender_num == 1), fe cluster(child) 
	
	matrix d = r(table) 

	*adding stars
		if d[4,1] < 0.01 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "***"
		}
		else if d[4,1] < 0.05 & d[4,1] >= 0.01 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "**"
		}	
		else if d[4,1] < 0.1 & d[4,1] >= 0.05 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "*"
		}
		else {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc")
		}		
		
		local se_`j'_`d' = string(round(_se[percent_treated_`d'], .0001), "%13.0gc")
		
		local j = `j' + 1

	}

	file write file5 _n "\multirow{2}{*}{`d'} & `item_1_`d'' & `item_2_`d'' \\"
	file write file5 _n "& (`se_1_`d'') & (`se_2_`d'') "

	if `i' < `num' {
		file write file5 _n "& & \\"	
	}
	local i = `i' + 1
}
	

	
file write file5 _n "\midrule"
file write file5 _n "\bottomrule"
file write file5 _n "\end{tabular}"
file write file5 _n "\begin{tablenotes}"
file write file5 _n "\footnotesize"

file write file5 _n "\item \textit{Notes:} Columns 1-3 (4-6) display the effect of a 1 percentage point increase in the share of treated neighbors of a control child on his/her standardized cognitive (non-cognitive) score. The upper panel shows the effects on control boys and the lower panel shows the effects on control girls." 
file write file5 _n "\item Robust standard errors, clustered at the individual level in parentheses"
file write file5 _n "\item *** p$<$0.01, ** p$<$0.05, * p$<$0.1"
file write file5 _n "\end{tablenotes}"
file write file5 _n "\end{threeparttable}"

file write file5 _n "} \end{table}"

file write file5 _n "\end{document}"

file close file5


**Table 9: Spillover from Boys to Boys


clear all

cd "$repository/data_sets/generated"

use newv_table34_unique_data_clean


***********************************************************************************
**If want to reproduce table restricting sample to control kids, add the code below



keep if (C == 1 & first_random == 1) | (CC == 1 & first_random == 1) | (CT_pretreat == 1) | (CK_prekinder == 1)


***********************************************************************************

**Merging with number of male neighbors

merge 1:1 child test year using merged_male_neigh_count

**Dropping kids not pertaining to our analytical sample
drop if _merge == 2

drop _merge

**Merging with number of female neighbors

merge 1:1 child test year using merged_female_neigh_count

**Dropping kids not pertaining to our analytical sample
drop if _merge == 2

drop _merge


**Defining Key Explanatory Variable
foreach distance in 500 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 15000 20000 {
gen percent_treated_`distance' = (treated_`distance'_male / (treated_`distance'_male + control_`distance'_male))*100
}

**Merging with distance to school and block group variable
foreach file in Relevant_DistToSchool_1 Relevant_DistToSchool_2 Relevant_censusblock_checc {
merge m:1 child using `file'
*drop if _merge == 2
drop _merge
} 

	
replace age_pre = . if age_pre == 0	

**Creating factor variables
egen gender_num = group(gender)
egen race_num = group(race)
egen blockgroup_num = group(blockgroup)
destring year, replace

**Setting up Time Dimension
gen test_num = 0 if test == "pre"
replace test_num = 1 if test == "mid"
replace test_num = 2 if test == "post"
replace test_num = 3 if test == "sl"
replace test_num = 4 if test == "aoy1"
replace test_num = 5 if test == "aoy2"
replace test_num = 6 if test == "aoy3"
replace test_num = 7 if test == "aoy4"

sort child test_num
xtset child test_num	
	
local distance "500 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 15000 20000"
local num : list sizeof local(distance)
local i = 1


file open file6 using "$repository/analysis/tables/tables_pre_percentage_treated/newv_table9spillover_boyboy.tex", replace write


file write file6 "\documentclass[11pt]{article}"
file write file6 _n "\usepackage{booktabs, multicol, multirow}"
file write file6 _n "\usepackage{caption}"
file write file6 _n "\userpackage[flushleft]{threeparttable}"
file write file6 _n	"\begin{document}"

file write file6 _n "\begin{table}[h]\centering" 

file write file6 _n "\caption{Spillover From Boys to  Boys} \scalebox{0.92} {\label{tab:results_boys} \begin{threeparttable}"
file write file6 _n "\begin{tabular}{lc|c}"
file write file6 _n "\toprule"
file write file6 _n "\midrule"
file write file6 _n "& \multicolumn{1}{c}{Cognitive Scores} & \multicolumn{1}{c}{Non-cognitive Scores}\\ \cline{2-7}"
file write file6 _n "& Fixed Effect &  Fixed Effect \\"
file write file6 _n " $ d $ (meters)& (1) & (2) \\"
file write file6 _n "\midrule"

**Running main regressions	

foreach d of local distance  {	
	local j = 1
	foreach assess in cog ncog {
	

	***FIXED EFFECTS
	quietly xtreg std_`assess' percent_treated_`d' i.test_num  if has_`assess' == 1 & gender == "Male", fe cluster(child) 
	
	matrix d = r(table) 

	*adding stars
		if d[4,1] < 0.01 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "***"
		}
		else if d[4,1] < 0.05 & d[4,1] >= 0.01 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "**"
		}	
		else if d[4,1] < 0.1 & d[4,1] >= 0.05 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "*"
		}
		else {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc")
		}		
		
		local se_`j'_`d' = string(round(_se[percent_treated_`d'], .0001), "%13.0gc")
		
		local j = `j' + 1
	}

	file write file6 _n "\multirow{2}{*}{`d'} & `item_1_`d'' & `item_2_`d'' \\"
	file write file6 _n "& (`se_1_`d'') & (`se_2_`d'') \\"

	if `i' < `num' {
		file write file6 _n "& & \\"	
	}
	local i = `i' + 1
}	
	
file write file6 _n "\midrule"
file write file6 _n "\bottomrule"
file write file6 _n "\end{tabular}"
file write file6 _n "\begin{tablenotes}"
file write file6 _n "\footnotesize"

file write file6 _n "\item \textit{Notes:} Columns 1-3 (4-6) display the effect of a 1 percentage point increase in the share of treated male neighbors of a male control child ($\frac{N^{treated}_{boys}}{N^{treated}_{boys}+N^{control}_{boys}}$) on his standardized cognitive (non-cognitive) score." 
file write file6 _n "\item Robust standard errors, clustered at the individual level in parentheses"
file write file6 _n "\item *** p$<$0.01, ** p$<$0.05, * p$<$0.1"
file write file6 _n "\end{tablenotes}"
file write file6 _n "\end{threeparttable}"
file write file6 _n "} \end{table}"

file write file6 _n "\end{document}"

file close file6


**Table 10: Spillover from Girls to Girls

clear all

cd "$repository/data_sets/generated"

use newv_table34_unique_data_clean

***********************************************************************************
**If want to reproduce table restricting sample to control kids, add the code below



keep if (C == 1 & first_random == 1) | (CC == 1 & first_random == 1) | (CT_pretreat == 1) | (CK_prekinder == 1)


***********************************************************************************

**Merging with number of neighbors for girls

merge 1:1 child test year using merged_female_neigh_count

**Keeping the observations pertaining to the "girl neighbors with at most 20,000 distance" subsample
keep if _merge == 3

drop _merge

**Defining Key Explanatory Variable
foreach distance in 500 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 15000 20000 {
gen percent_treated_`distance' = (treated_`distance'_female / (treated_`distance'_female + control_`distance'_female))*100
}

**Merging with distance to school and block group variable
foreach file in Relevant_DistToSchool_1 Relevant_DistToSchool_2 Relevant_censusblock_checc {
merge m:1 child using `file'
*drop if _merge == 2
drop _merge
} 

	
replace age_pre = . if age_pre == 0	

**Creating factor variables
egen gender_num = group(gender)
egen race_num = group(race)
egen blockgroup_num = group(blockgroup)
destring year, replace

**Setting up Time Dimension
gen test_num = 0 if test == "pre"
replace test_num = 1 if test == "mid"
replace test_num = 2 if test == "post"
replace test_num = 3 if test == "sl"
replace test_num = 4 if test == "aoy1"
replace test_num = 5 if test == "aoy2"
replace test_num = 6 if test == "aoy3"
replace test_num = 7 if test == "aoy4"

sort child test_num
xtset child test_num	
	
local distance "500 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 15000 20000"
local num : list sizeof local(distance)
local i = 1


file open file7 using "$repository/analysis/tables/tables_pre_percentage_treated/newv_table10spillover_girlgirl.tex", replace write


file write file7 "\documentclass[11pt]{article}"
file write file7 _n "\usepackage{booktabs, multicol, multirow}"
file write file7 _n "\usepackage{caption}"
file write file7 _n "\userpackage[flushleft]{threeparttable}"
file write file7 _n	"\begin{document}"

file write file7 _n "\begin{table}[h]\centering" 

file write file7 _n "\caption{Spillover From Girls to  Girls} \scalebox{0.92} {\label{tab:results_girls} \begin{threeparttable}"
file write file7 _n "\begin{tabular}{lc|c}"
file write file7 _n "\toprule"
file write file7 _n "\midrule"
file write file7 _n "& \multicolumn{1}{c}{Cognitive Scores} & \multicolumn{1}{c}{Non-cognitive Scores}\\ \cline{2-7}"
file write file7 _n "& Fixed Effect & Fixed Effect \\"
file write file7 _n " $ d $ (meters)& (1) & (2) \\"
file write file7 _n "\midrule"

**Running main regressions	

foreach d of local distance  {	
	local j = 1
	foreach assess in cog ncog {
	

	***FIXED EFFECTS
	quietly xtreg std_`assess' percent_treated_`d'  i.test_num if has_`assess' == 1 & gender == "Female", fe cluster(child) 
	
	matrix d = r(table) 

	*adding stars
		if d[4,1] < 0.01 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "***"
		}
		else if d[4,1] < 0.05 & d[4,1] >= 0.01 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "**"
		}	
		else if d[4,1] < 0.1 & d[4,1] >= 0.05 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "*"
		}
		else {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc")
		}		
		
		local se_`j'_`d' = string(round(_se[percent_treated_`d'], .0001), "%13.0gc")
		
		local j = `j' + 1

	}

	file write file7 _n "\multirow{2}{*}{`d'} & `item_1_`d'' & `item_2_`d'' \\"
	file write file7 _n "& (`se_1_`d'') & (`se_2_`d'') \\"

	if `i' < `num' {
		file write file7 _n "& & \\"	
	}
	local i = `i' + 1
}	
	
file write file7 _n "\midrule"
file write file7 _n "\bottomrule"
file write file7 _n "\end{tabular}"
file write file7 _n "\begin{tablenotes}"
file write file7 _n "\footnotesize"

file write file7 _n "\item \textit{Notes:} Columns 1-3 (4-6) display the effect of a 1 percentage point increase in the share of treated female neighbors of a female control child ($\frac{N^{treated}_{girls}}{N^{treated}_{girls}+N^{control}_{girls}}$) on her standardized cognitive (non-cognitive) score." 
file write file7 _n "\item Robust standard errors, clustered at the individual level in parentheses"
file write file7 _n "\item *** p$<$0.01, ** p$<$0.05, * p$<$0.1"
file write file7 _n "\end{tablenotes}"
file write file7 _n "\end{threeparttable}"
file write file7 _n "} \end{table}"

file write file7 _n "\end{document}"

file close file7


**TABLE 11: SPILL OVER BY RACE*****



clear all

cd "$repository/data_sets/generated"

use newv_table56_unique_data_clean

***********************************************************************************
**If want to reproduce table restricting sample to control kids, add the code below



keep if (C == 1 & first_random == 1) | (CC == 1 & first_random == 1) | (CT_pretreat == 1) | (CK_prekinder == 1)



***********************************************************************************


replace age_pre = . if age_pre == 0	

**Creating factor variables
egen gender_num = group(gender)
egen race_num = group(race)
egen blockgroup_num = group(blockgroup)
destring year, replace

**Setting up Time Dimension
gen test_num = 0 if test == "pre"
replace test_num = 1 if test == "mid"
replace test_num = 2 if test == "post"
replace test_num = 3 if test == "sl"
replace test_num = 4 if test == "aoy1"
replace test_num = 5 if test == "aoy2"
replace test_num = 6 if test == "aoy3"
replace test_num = 7 if test == "aoy4"

sort child test_num
xtset child test_num


**SPILLOVER HISPANICS

local distance "500 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 15000 20000"
local num : list sizeof local(distance)
local i = 1


file open file8 using "$repository/analysis/tables/tables_pre_percentage_treated/newv_table11spillover_race.tex", replace write


file write file8 "\documentclass[11pt]{article}"
file write file8 _n "\usepackage{booktabs, multicol, multirow}"
file write file8 _n "\usepackage{caption}"
file write file8 _n "\userpackage[flushleft]{threeparttable}"
file write file8 _n	"\begin{document}"

file write file8 _n "\begin{table}[H]\centering \caption{\small Spillover Effects by Race  }  \scalebox{1}{\label{tab:results_race} \begin{threeparttable}" 
file write file8 _n "\begin{tabular}{lc|c}"
file write file8 _n "\toprule"
file write file8 _n "\midrule"
file write file8 _n "& \multicolumn{1}{c}{Cognitive Scores} & \multicolumn{1}{c}{Non-cognitive Scores}\\ \cline{2-7}"
file write file8 _n "& Fixed Effect & Fixed Effect \\"
file write file8 _n "$ d $ (meters) & (1) & (2) \\"
file write file8 _n "\midrule"
file write file8 _n "& \multicolumn{2}{c}{Control Hispanics}\\ \cline{2-7}"

**Running Regressions for Hispanics	

foreach d of local distance  {	
	local j = 1
	foreach assess in cog ncog { 

	***FIXED EFFECTS
	quietly xtreg std_`assess' percent_treated_`d' i.test_num if (has_`assess' == 1 & race_num == 2), fe cluster(child) 
	
	matrix d = r(table) 

	*adding stars
		if d[4,1] < 0.01 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "***"
		}
		else if d[4,1] < 0.05 & d[4,1] >= 0.01 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "**"
		}	
		else if d[4,1] < 0.1 & d[4,1] >= 0.05 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "*"
		}
		else {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc")
		}		
		
		local se_`j'_`d' = string(round(_se[percent_treated_`d'], .0001), "%13.0gc")
		
		local j = `j' + 1

	}

	file write file8 _n "\multirow{2}{*}{`d'} & `item_1_`d'' & `item_2_`d'' \\"
	file write file8 _n "& (`se_1_`d'') & (`se_2_`d'') \\"

	if `i' < `num' {
		file write file8 _n "& & \\"	
	}
	local i = `i' + 1
}

file write file8 _n "& \multicolumn{2}{c}{}\\"
file write file8 _n "& \multicolumn{2}{c}{Control Blacks}\\ \cline{2-7}"


** SPILL-OVER BLACKS


local distance "500 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 15000 20000"
local num : list sizeof local(distance)
local i = 1

**Running Regressions for Blacks	

foreach d of local distance  {	
	local j = 1
	foreach assess in cog ncog {
	

	***FIXED EFFECTS
	quietly xtreg std_`assess' percent_treated_`d' i.test_num if (has_`assess' == 1 & race_num == 1), fe cluster(child) 
	
	matrix d = r(table) 

	*adding stars
		if d[4,1] < 0.01 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "***"
		}
		else if d[4,1] < 0.05 & d[4,1] >= 0.01 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "**"
		}	
		else if d[4,1] < 0.1 & d[4,1] >= 0.05 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "*"
		}
		else {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc")
		}		
		
		local se_`j'_`d' = string(round(_se[percent_treated_`d'], .0001), "%13.0gc")
		
		local j = `j' + 1

	}

	file write file8 _n "\multirow{2}{*}{`d'} & `item_1_`d'' & `item_2_`d'' \\"
	file write file8 _n "& (`se_1_`d'') & (`se_2_`d'') \\"

	if `i' < `num' {
		file write file8 _n "& & \\"	
	}
	local i = `i' + 1
}
	
	
file write file8 _n "\midrule"
file write file8 _n "\bottomrule"
file write file8 _n "\end{tabular}"
file write file8 _n "\begin{tablenotes}"
file write file8 _n "\footnotesize"

file write file8 _n "\item \textit{Notes:} Columns 1-3 (4-6) display the effect of a 1 percentage point increase in the share of treated neighbors of a control child on his/her standardized cognitive (non-cognitive) score. The upper panel shows the effects on Hispanic and the lower panel shows the effects on Black control kids." 
file write file8 _n "\item Robust standard errors, clustered at the individual level in parentheses"
file write file8 _n "\item *** p$<$0.01, ** p$<$0.05, * p$<$0.1"
file write file8 _n "\end{tablenotes}"
file write file8 _n "\end{threeparttable}"

file write file8 _n "} \end{table}"

file write file8 _n "\end{document}"

file close file8


**Table 12: Spillover from Hispanic to Hispanic


clear all

cd "$repository/data_sets/generated"

use newv_table34_unique_data_clean

***********************************************************************************
**If want to reproduce table restricting sample to control kids, add the code below



keep if (C == 1 & first_random == 1) | (CC == 1 & first_random == 1) | (CT_pretreat == 1) | (CK_prekinder == 1)



***********************************************************************************


**Merging with number of Hispanic neighbors

merge 1:1 child test year using merged_hispanic_neigh_count

**Drop observations not pertaining to our analytical sample
drop if _merge == 2

drop _merge

**Merging with number of Black neighbors

merge 1:1 child test year using merged_black_neigh_count

**Drop observations not pertaining to our analytical sample
drop if _merge == 2

drop _merge

**Defining Key Explanatory Variable
foreach distance in 500 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 15000 20000 {
gen percent_treated_`distance' = (treated_`distance'_hispanic / (treated_`distance'_hispanic + control_`distance'_hispanic))*100
}

**Merging with distance to school and block group variable
foreach file in Relevant_DistToSchool_1 Relevant_DistToSchool_2 Relevant_censusblock_checc {
merge m:1 child using `file'
*drop if _merge == 2
drop _merge
} 

	
replace age_pre = . if age_pre == 0	

**Creating factor variables
egen gender_num = group(gender)
egen race_num = group(race)
egen blockgroup_num = group(blockgroup)
destring year, replace

**Setting up Time Dimension
gen test_num = 0 if test == "pre"
replace test_num = 1 if test == "mid"
replace test_num = 2 if test == "post"
replace test_num = 3 if test == "sl"
replace test_num = 4 if test == "aoy1"
replace test_num = 5 if test == "aoy2"
replace test_num = 6 if test == "aoy3"
replace test_num = 7 if test == "aoy4"

sort child test_num
xtset child test_num	
	
local distance "500 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 15000 20000"
local num : list sizeof local(distance)
local i = 1


file open file9 using "$repository/analysis/tables/tables_pre_percentage_treated/newv_table12spillover_hispanichispanic.tex", replace write


file write file9 "\documentclass[11pt]{article}"
file write file9 _n "\usepackage{booktabs, multicol, multirow}"
file write file9 _n "\usepackage{caption}"
file write file9 _n "\userpackage[flushleft]{threeparttable}"
file write file9 _n	"\begin{document}"

file write file9 _n "\begin{table}[h]\centering" 

file write file9 _n "\caption{Spillover From Hispanic to Hispanic} \scalebox{0.92} {\label{tab:results_hispanics} \begin{threeparttable}"
file write file9 _n "\begin{tabular}{lc|c}"
file write file9 _n "\toprule"
file write file9 _n "\midrule"
file write file9 _n "& \multicolumn{1}{c}{Cognitive Scores} & \multicolumn{1}{c}{Non-cognitive Scores}\\ \cline{2-7}"
file write file9 _n "& Fixed Effect & Fixed Effect \\"
file write file9 _n " $ d $ (meters)& (1) & (2) \\"
file write file9 _n "\midrule"

**Running main regressions	

foreach d of local distance  {	
	local j = 1
	foreach assess in cog ncog { 

	***FIXED EFFECTS
	quietly xtreg std_`assess' percent_treated_`d' i.test_num  if has_`assess' == 1 & race == "Hispanic", fe cluster(child) 
	
	matrix d = r(table) 

	*adding stars
		if d[4,1] < 0.01 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "***"
		}
		else if d[4,1] < 0.05 & d[4,1] >= 0.01 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "**"
		}	
		else if d[4,1] < 0.1 & d[4,1] >= 0.05 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "*"
		}
		else {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc")
		}		
		
		local se_`j'_`d' = string(round(_se[percent_treated_`d'], .0001), "%13.0gc")
		
		local j = `j' + 1

	}

	file write file9 _n "\multirow{2}{*}{`d'} & `item_1_`d'' & `item_2_`d'' \\"
	file write file9 _n "& (`se_1_`d'') & (`se_2_`d'') \\"

	if `i' < `num' {
		file write file9 _n "& & \\"	
	}
	local i = `i' + 1
}	
	
file write file9 _n "\midrule"
file write file9 _n "\bottomrule"
file write file9 _n "\end{tabular}"
file write file9 _n "\begin{tablenotes}"
file write file9 _n "\footnotesize"

file write file9 _n "\item \textit{Notes:} Columns 1-3 (4-6) display the effect of a 1 percentage point increase in the share of treated Hispanic neighbors of a Hispanic control child ($\frac{N^{treated}_{hispanic}}{N^{treated}_{hispanic}+N^{control}_{hispanic}}$) on his standardized cognitive (non-cognitive) score." 
file write file9 _n "\item Robust standard errors, clustered at the individual level in parentheses"
file write file9 _n "\item *** p$<$0.01, ** p$<$0.05, * p$<$0.1"
file write file9 _n "\end{tablenotes}"
file write file9 _n "\end{threeparttable}"
file write file9 _n "} \end{table}"

file write file9 _n "\end{document}"

file close file9


**Table 11: Spillover from Black to Black


clear all

cd "$repository/data_sets/generated"

use newv_table34_unique_data_clean

***********************************************************************************
**If want to reproduce table restricting sample to control kids, add the code below



keep if (C == 1 & first_random == 1) | (CC == 1 & first_random == 1) | (CT_pretreat == 1) | (CK_prekinder == 1)


***********************************************************************************

**Merging with number of Black neighbors

merge 1:1 child test year using merged_black_neigh_count

**Keeping the observations pertaining to the "Black neighbors within distance of 20,000" subsample
keep if _merge == 3

drop _merge

**Defining Key Explanatory Variable
foreach distance in 500 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 15000 20000 {
gen percent_treated_`distance' = (treated_`distance'_black / (treated_`distance'_black + control_`distance'_black))*100
}

**Merging with distance to school and block group variable
foreach file in Relevant_DistToSchool_1 Relevant_DistToSchool_2 Relevant_censusblock_checc {
merge m:1 child using `file'
*drop if _merge == 2
drop _merge
} 
	
replace age_pre = . if age_pre == 0	

**Creating factor variables
egen gender_num = group(gender)
egen race_num = group(race)
egen blockgroup_num = group(blockgroup)
destring year, replace

**Setting up Time Dimension
gen test_num = 0 if test == "pre"
replace test_num = 1 if test == "mid"
replace test_num = 2 if test == "post"
replace test_num = 3 if test == "sl"
replace test_num = 4 if test == "aoy1"
replace test_num = 5 if test == "aoy2"
replace test_num = 6 if test == "aoy3"
replace test_num = 7 if test == "aoy4"

sort child test_num
xtset child test_num	
	
local distance "500 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 15000 20000"
local num : list sizeof local(distance)
local i = 1


file open file10 using "$repository/analysis/tables/tables_pre_percentage_treated/newv_table13spillover_blackblack.tex", replace write


file write file10 "\documentclass[11pt]{article}"
file write file10 _n "\usepackage{booktabs, multicol, multirow}"
file write file10 _n "\usepackage{caption}"
file write file10 _n "\userpackage[flushleft]{threeparttable}"
file write file10 _n	"\begin{document}"

file write file10 _n "\begin{table}[h]\centering" 

file write file10 _n "\caption{Spillover From Black to Black} \scalebox{0.92} {\label{tab:results_blacks} \begin{threeparttable}"
file write file10 _n "\begin{tabular}{lc|c}"
file write file10 _n "\toprule"
file write file10 _n "\midrule"
file write file10 _n "& \multicolumn{1}{c}{Cognitive Scores} & \multicolumn{1}{c}{Non-cognitive Scores}\\ \cline{2-7}"
file write file10 _n "& Fixed Effect & Fixed Effect \\"
file write file10 _n " $ d $ (meters)& (1) & (2) \\"
file write file10 _n "\midrule"

**Running main regressions	

foreach d of local distance  {	
	local j = 1
	foreach assess in cog ncog {

	***FIXED EFFECTS
	quietly xtreg std_`assess' percent_treated_`d' i.test_num  if has_`assess' == 1 & race == "African American", fe cluster(child) 
	
	matrix d = r(table) 

	*adding stars
		if d[4,1] < 0.01 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "***"
		}
		else if d[4,1] < 0.05 & d[4,1] >= 0.01 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "**"
		}	
		else if d[4,1] < 0.1 & d[4,1] >= 0.05 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "*"
		}
		else {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc")
		}		
		
		local se_`j'_`d' = string(round(_se[percent_treated_`d'], .0001), "%13.0gc")
		
		local j = `j' + 1

	}

	file write file10 _n "\multirow{2}{*}{`d'} & `item_1_`d'' & `item_2_`d'' \\"
	file write file10 _n "& (`se_1_`d'') & (`se_2_`d'') \\"

	if `i' < `num' {
		file write file10 _n "& & \\"	
	}
	local i = `i' + 1
}	
	
file write file10 _n "\midrule"
file write file10 _n "\bottomrule"
file write file10 _n "\end{tabular}"
file write file10 _n "\begin{tablenotes}"
file write file10 _n "\footnotesize"

file write file10 _n "\item \textit{Notes:} Columns 1-3 (4-6) display the effect of a 1 percentage point increase in the share of treated Black neighbors of a Black control child ($\frac{N^{treated}_{black}}{N^{treated}_{black}+N^{control}_{black}}$) on his standardized cognitive (non-cognitive) score." 
file write file10 _n "\item Robust standard errors, clustered at the individual level in parentheses"
file write file10 _n "\item *** p$<$0.01, ** p$<$0.05, * p$<$0.1"
file write file10 _n "\end{tablenotes}"
file write file10 _n "\end{threeparttable}"
file write file10 _n "} \end{table}"

file write file10 _n "\end{document}"

file close file10

**Create Table 14: Summary Statistics By Ring****

clear all

cd "$repository/data_sets/generated"

use newv_table34_unique_data_clean

***********************************************************************************
**If want to reproduce table restricting sample to control kids, add the code below



keep if (C == 1 & first_random == 1) | (CC == 1 & first_random == 1) | (CT_pretreat == 1) | (CK_prekinder == 1)



***********************************************************************************


**Merging with number of neighbors by rings

merge 1:1 child test year using merged_neigh_count_rings

**Drop observations not pertaining to our analytical sample
drop if _merge == 2

drop _merge

**Defining Key Explanatory Variable
foreach ring in 0_10000 10000_20000 20000_30000 30000_40000 40000_50000 {
gen percent_treated_`ring' = (treated_`ring' / (treated_`ring' + control_`ring'))*100
}

file open file11 using "$repository/analysis/tables/tables_pre_percentage_treated/newv_table14_summary_rings.tex", replace write


file write file11 "\documentclass[11pt]{article}"
file write file11 _n "\usepackage{booktabs, multicol, multirow}"
file write file11 _n "\usepackage{caption}"
file write file11 _n "\userpackage[flushleft]{threeparttable}"
file write file11 _n	"\begin{document}"

file write file11 _n "\begin{table}[H]"
file write file11 _n "\centering"
file write file11 _n "\caption{Descriptive Statistics for Rings}"
file write file11 _n "\label{ring_stat}  \begin{threeparttable}"
file write file11 _n "\begin{tabular}{lccc}"
file write file11 _n "$ d_j $ & $ N^{treated}$  & $N^{control}$ & $ P^{treated}_{i,t,d_j}$\\" 
file write file11 _n "\toprule"
file write file11 _n "\midrule"


local i = 1

foreach ring in 0_10000 10000_20000 20000_30000 30000_40000 40000_50000 {
		local i = 1
		tabstat treated_`ring', save stat(mean semean n)
		mat a = r(StatTotal)
		mat list a
		local item`i' = string(round(a[1,1], 0.01), "%13.0gc") //Mean
		di `item`i''
		local i = `i' + 1
		local item`i' = string(round(a[2,1], 0.01), "%13.0gc") //Standard Error
		local i = `i' + 1
		tabstat control_`ring', save stat(mean semean n)
		mat a = r(StatTotal)
		mat list a
		local item`i' = string(round(a[1,1], 0.01), "%13.0gc") //Mean
		local i = `i' + 1
		local item`i' = string(round(a[2,1], 0.01), "%13.0gc") //Standard Error
		local i = `i' + 1
		tabstat percent_treated_`ring', save stat(mean semean n)
		mat a = r(StatTotal)
		mat list a
		local item`i' = string(round(a[1,1], 0.01), "%13.0gc") //Mean
		local i = `i' + 1
		local item`i' = string(round(a[2,1], 0.01), "%13.0gc") //Standard Error
		local i = `i' + 1
		
		 file write file11 _n "\multirow{2}{*}{`ring'} & `item1' & `item3' & `item5'\% \\"
		 file write file11 _n "& (`item2') & (`item4') & (`item6') \\"
		}
		

file write file11 _n "\midrule"
file write file11 _n "\bottomrule"
file write file11 _n "\end{tabular}"
file write file11 _n "\begin{tablenotes}"
file write file11 _n "\footnotesize"

file write file11 _n "\item \textit{Notes:} This table provides a descriptive statistics on the number of treated and control neighbors at various distances from a control child, as well as the percentage of neighbors who have been assigned to one of the treatment groups."
file write file11 _n "\item Standard errors in parenthesis."

file write file11 _n "\end{tablenotes}"
file write file11 _n "\end{threeparttable}"
file write file11 _n "\end{table}"

file write file11 _n	"\end{document}"

file close file11

*******************************************
**Create Table 15: Fade-Out Regressions****
*******************************************

**Merging with distance to school and block group variable
foreach file in Relevant_DistToSchool_1 Relevant_DistToSchool_2 Relevant_censusblock_checc {
merge m:1 child using `file'
*drop if _merge == 2
drop _merge
} 

	
replace age_pre = . if age_pre == 0	

**Creating factor variables
egen gender_num = group(gender)
egen race_num = group(race)
egen blockgroup_num = group(blockgroup)
destring year, replace

**Setting up Time Dimension
gen test_num = 0 if test == "pre"
replace test_num = 1 if test == "mid"
replace test_num = 2 if test == "post"
replace test_num = 3 if test == "sl"
replace test_num = 4 if test == "aoy1"
replace test_num = 5 if test == "aoy2"
replace test_num = 6 if test == "aoy3"
replace test_num = 7 if test == "aoy4"

sort child test_num
xtset child test_num	
	

local ring "0_10000 10000_20000 20000_30000 30000_40000 40000_50000"
local num : list sizeof local(ring)
local i = 1


file open file12 using "$repository/analysis/tables/tables_pre_percentage_treated/newv_table15_fadeout.tex", replace write



*file open file4 using "$repository/analysis/tables/table7.tex", replace write

file write file12 _n "\documentclass[11pt]{article}"
file write file12 _n "\usepackage{booktabs, multicol, multirow}"
file write file12 _n "\usepackage{caption}"
file write file12 _n "\userpackage[flushleft]{threeparttable}"
file write file12 _n	"\begin{document}"


file write file12 _n "\begin{table}[H]\centering \caption{Spatial Fade-out of Spillover Effects}  \scalebox{1}{ \label{tab:donuts}  \begin{threeparttable}"
file write file12 _n "\begin{tabular}{lccc|ccc}"
file write file12 _n "\toprule"
file write file12 _n "\midrule"
file write file12 _n "& \multicolumn{3}{c}{Cognitive Scores} & \multicolumn{3}{c}{Non-cognitive Scores}\\ \cline{2-7}"
file write file12 _n "Step Size & Pooled OLS & Fixed Effect & Random Effect & Pooled OLS & Fixed Effect & Random Effect\\"
file write file12 _n "10000 & (1) & (2) & (3) & (4) & (5) & (6)\\"
file write file12 _n "\midrule"

**Running main regressions	

foreach d of local ring  {	
	local j = 1
	foreach assess in cog ncog {
	***POOLED OLS
	quietly reg std_`assess' percent_treated_`d' std_cog_pre std_ncog_pre distto1 distto2 i.gender_num i.race_num i.year i.blockgroup_num i.test_num age_pre if has_`assess' == 1, cluster(child)
	
	matrix d = r(table) 

	*adding stars
		if d[4,1] < 0.01 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "***"
		}
		else if d[4,1] < 0.05 & d[4,1] >= 0.01 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "**"
		}
		else if d[4,1] < 0.1 & d[4,1] >= 0.05 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "*"
		}
		else {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc")
		}		
		
		local se_`j'_`d' = string(round(_se[percent_treated_`d'], .0001), "%13.0gc")
		
		local j = `j' + 1 

	***FIXED EFFECTS
	quietly xtreg std_`assess' percent_treated_`d' i.test_num if has_`assess' == 1, fe cluster(child) 
	
	matrix d = r(table) 

	*adding stars
		if d[4,1] < 0.01 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "***"
		}
		else if d[4,1] < 0.05 & d[4,1] >= 0.01 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "**"
		}	
		else if d[4,1] < 0.1 & d[4,1] >= 0.05 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "*"
		}
		else {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc")
		}		
		
		local se_`j'_`d' = string(round(_se[percent_treated_`d'], .0001), "%13.0gc")
		
		local j = `j' + 1


	***RANDOM EFFECTS
	quietly xtreg std_`assess' percent_treated_`d' std_cog_pre std_ncog_pre distto1 distto2 i.gender_num i.race_num i.year i.blockgroup_num i.test_num age_pre if has_`assess' == 1, re cluster(child) 
	matrix d = r(table) 

	*adding stars
		if d[4,1] < 0.01 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "***"
		}
		else if d[4,1] < 0.05 & d[4,1] >= 0.01 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "**"
		}
		else if d[4,1] < 0.1 & d[4,1] >= 0.05 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "*"
		}
		else {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc")
		}		
		
		local se_`j'_`d' = string(round(_se[percent_treated_`d'], .0001), "%13.0gc")
		
		local j = `j' + 1
	}

	file write file12 _n "\multirow{2}{*}{`d'} & `item_1_`d'' & `item_2_`d'' & `item_3_`d''  & `item_4_`d'' & `item_5_`d'' & `item_6_`d''\\"
	file write file12 _n "& (`se_1_`d'') & (`se_2_`d'') & (`se_3_`d'') & (`se_4_`d'') & (`se_5_`d'') & (`se_6_`d'')\\"

	if `i' < `num' {
		file write file12 _n "& & & & & &\\"	
	}
	local i = `i' + 1
}	
	
file write file12 _n "\midrule"
file write file12 _n "\bottomrule"
file write file12 _n "\end{tabular}"
file write file12 _n "\begin{tablenotes}"
file write file12 _n "\footnotesize"

file write file12 _n "\item \textit{Notes:} This table shows the impact of a 1\% increase in the share of treated neighbors  living at various distances away from a control child on his/her cognitive and non-cognitive performance."
file write file12 _n "\item Robust standard errors, clustered at the individual level in parentheses."
file write file12 _n "\item *** p$<$0.01, ** p$<$0.05, * p$<$0.1"
file write file12 _n "\end{tablenotes}"
file write file12 _n "\end{threeparttable}"
file write file12 _n "} \end{table}"


file write file12 _n "\end{document}"

file close file12

***Create Table 16 : Kinder vs. Parent Treated********

clear all

cd "$repository/data_sets/generated"

use newv_table34_unique_data_clean

***********************************************************************************
**If want to reproduce table restricting sample to control kids, add the code below



keep if (C == 1 & first_random == 1) | (CC == 1 & first_random == 1) | (CT_pretreat == 1) | (CK_prekinder == 1)


***********************************************************************************

**Merging with number of neighbors by rings

merge 1:1 child test year using merged_neigh_count

**Keeping the observations pertaining to our relevant sample
keep if _merge == 3

drop _merge

**Defining Percent Parent Treated and Percent Child Treated
foreach d in 500 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 15000 20000 {
gen percent_parent_treated_`d' = ((cash_`d'+ college_`d') / (treated_`d' + control_`d'))*100
gen percent_child_treated_`d' = ((cogx_`d' + preschool_`d' + kinderprep_`d' + pka_`d' + pkb_`d')/ (treated_`d' + control_`d'))*100
}

**Merging with distance to school and block group variable
foreach file in Relevant_DistToSchool_1 Relevant_DistToSchool_2 Relevant_censusblock_checc {
merge m:1 child using `file'
*drop if _merge == 2
drop _merge
} 

replace age_pre = . if age_pre == 0	

**Creating factor variables
egen gender_num = group(gender)
egen race_num = group(race)
egen blockgroup_num = group(blockgroup)
destring year, replace

**Setting up Time Dimension
gen test_num = 0 if test == "pre"
replace test_num = 1 if test == "mid"
replace test_num = 2 if test == "post"
replace test_num = 3 if test == "sl"
replace test_num = 4 if test == "aoy1"
replace test_num = 5 if test == "aoy2"
replace test_num = 6 if test == "aoy3"
replace test_num = 7 if test == "aoy4"

sort child test_num
xtset child test_num	
	

local distance "500 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 15000 20000"
local num : list sizeof local(distance)
local i = 1


file open file13 using "$repository/analysis/tables/tables_pre_percentage_treated/newv_table16_mechanism.tex", replace write


file write file13 _n "\documentclass[11pt]{article}"
file write file13 _n "\usepackage{booktabs, multicol, multirow}"
file write file13 _n "\usepackage{caption}"
file write file13 _n "\userpackage[flushleft]{threeparttable}"
file write file13 _n	"\begin{document}"

file write file13 _n "\begin{table}[H]\centering \caption{The Effect from Parent vs. Child Programs}  \scalebox{.99}{\label{tab:treatments}  \begin{threeparttable}"
file write file13 _n "\begin{tabular}{cc|c}"
file write file13 _n "\toprule"
file write file13 _n "\midrule"
file write file13 _n "& \multicolumn{1}{c}{Cognitive Scores} & \multicolumn{1}{c}{Non-cognitive Scores}\\ \cline{2-7}"
file write file13 _n "& Fixed Effect & Fixed Effect\\"
file write file13 _n "Distance & (1) & (2) \\"
file write file13 _n "\midrule"

**Running mechanism regressions	


foreach d of local distance  {	
	local j = 1
	foreach assess in cog ncog {

	***FIXED EFFECTS
	quietly xtreg std_`assess' percent_parent_treated_`d' percent_child_treated_`d' i.test_num if has_`assess' == 1, fe cluster(child) 
	
	matrix d = r(table) 

		*adding stars for parent effect
		if d[4,1] < 0.01 {
			local item_p`j'_`d' = string(round(_b[percent_parent_treated_`d'], .0001), "%13.0gc") + "***"
		}
		else if d[4,1] < 0.05 & d[4,1] >= 0.01 {
			local item_p`j'_`d' = string(round(_b[percent_parent_treated_`d'], .0001), "%13.0gc") + "**"
		}
		else if d[4,1] < 0.1 & d[4,1] >= 0.05 {
			local item_p`j'_`d' = string(round(_b[percent_parent_treated_`d'], .0001), "%13.0gc") + "*"
		}
		else {
			local item_p`j'_`d' = string(round(_b[percent_parent_treated_`d'], .0001), "%13.0gc")
		}		
		
		local se_p`j'_`d' = string(round(_se[percent_parent_treated_`d'], .0001), "%13.0gc")

		*adding stars for child effect
		if d[4,2] < 0.01 {
			local item_c`j'_`d' = string(round(_b[percent_child_treated_`d'], .0001), "%13.0gc") + "***"
		}
		else if d[4,2] < 0.05 & d[4,2] >= 0.01 {
			local item_c`j'_`d' = string(round(_b[percent_child_treated_`d'], .0001), "%13.0gc") + "**"
		}
		else if d[4,2] < 0.1 & d[4,2] >= 0.05 {
			local item_c`j'_`d' = string(round(_b[percent_child_treated_`d'], .0001), "%13.0gc") + "*"
		}
		else {
			local item_c`j'_`d' = string(round(_b[percent_child_treated_`d'], .0001), "%13.0gc")
		}		
		
		local se_c`j'_`d' = string(round(_se[percent_child_treated_`d'], .0001), "%13.0gc")

		
		local j = `j' + 1

	}

file write file13 _n "$P^{Parent}_{i,t,`d'}$ & `item_p1_`d'' & `item_p2_`d'' \\"
file write file13 _n "& (`se_p1_`d'') & (`se_p2_`d'') \\"
file write file13 _n "$P^{Child}_{i,t,`d'}$ & `item_c1_`d'' & `item_c2_`d'' \\"
file write file13 _n "& (`se_c1_`d'') & (`se_c2_`d'') \\"

	if `i' < `num' {
		file write file13 _n "& & \\"	
	}
	local i = `i' + 1
}	
	
file write file13 _n "\midrule"
file write file13 _n "\bottomrule"
file write file13 _n "\end{tabular}"
file write file13 _n "\begin{tablenotes}"
file write file13 _n "\footnotesize"

file write file13 _n "\item \textit{Notes:} The point estimates from the effect of a 1\% increase in the share of neighbors in which parents have been treated and 1\% increase in the share of treated neighbors in which the child has been treated directly."
file write file13 _n "\item Robust standard errors, clustered at the individual level in parentheses"
file write file13 _n "\item *** p$<$0.01, ** p$<$0.05, * p$<$0.1"
file write file13 _n "\end{tablenotes}"
file write file13 _n "\end{threeparttable}"
file write file13 _n "} \end{table}"

file write file13 _n "\end{document}"

file close file13

/*
************************************************
***Final Data Set for Friend Network Analysis****
************************************************

clear all

cd "$repository/data_sets/pre_made"
use share_survey

keep origin_gecc_id 
rename origin_gecc_id child

cd "$repository/data_sets/generated"



merge 1:m child using newv_table34_unique_data_clean

****6 out of of the 187 kids in the list were not matched to the overall sample of control kids:
	**the most recent status of 3 of the 6 kids (2443, 2768, 3154) was "treated" according to the randomization file list, so they cannot be counted as control
	**the other 3 kids were randomized into control, but possibly did not satisfy some of the criteria used to construct the sample of unique control kids (e.g. they had zero observations beyond pre for both cog and non-cog)

keep if _m == 3


**Calculating average cog and non-cog scores
replace std_cog = . if has_cog == 0
replace std_ncog = . if has_ncog == 0

sort child test
collapse (mean) std_cog std_ncog, by(child)

rename child origin_gecc_id


**Merge with Friend Count
merge 1:1 origin_gecc_id using merged_origin_destination_friend

keep if _m == 3

rename origin_gecc_id child

drop _m

**Merge into Final Dataset
merge 1:1 child using unique_most_recent_treatment

keep if _m == 3

keep child-treatment has_cog_pre has_ncog_pre cog_pre ncog_pre std_cog_pre std_ncog_pre age_pre race gender 

***CREATE TABLES 17 and 18*********


****Table 17: Friend Network Summary Statistics****

drop if treatment != "control"

foreach x in 1 2 3 4 5 6 7 8 9 10 {
gen same_race`x' = 1 if (race`x' == race & checc_friend`x' == 1 & race != "")
replace same_race`x' = 0 if same_race`x' !=1

gen same_race_control`x' = 1 if (race`x' == race & control`x' == 1 & race != "")
replace same_race_control`x' = 0 if same_race_control`x' != 1

gen same_race_treat`x' = 1 if (race`x' == race & treated`x' == 1 & race != "")
replace same_race_treat`x' = 0 if same_race_treat`x' != 1
 
gen same_gender`x' = 1 if (gender`x' == gender & checc_friend`x' == 1 & gender != "")
replace same_gender`x' = 0 if same_gender`x' != 1

gen same_gender_control`x' = 1 if (gender`x' == gender & control`x' == 1 & gender != "")
replace same_gender_control`x' = 0 if same_gender_control`x' != 1

gen same_gender_treat`x' = 1 if (gender`x' == gender & treated`x' == 1 & gender != "")
replace same_gender_treat`x' = 0 if same_gender_treat`x' != 1
}



**Generating Number of Same Race Checc Friends
egen num_checc_friends_srace = rowtotal(same_race1  same_race2  same_race3  same_race4  same_race5  same_race6 same_race7  same_race8  same_race9  same_race10)

**Generating Number of Same Gender Checc Friends
egen num_checc_friends_sgender = rowtotal(same_gender1  same_gender2  same_gender3  same_gender4  same_gender5  same_gender6 same_gender7  same_gender8  same_gender9  same_gender10)

**Generating Number of Same Race Control Checc Friends
egen num_checc_friends_controlsrace = rowtotal(same_race_control1  same_race_control2  same_race_control3  same_race_control4  same_race_control5  same_race_control6 same_race_control7  same_race_control8  same_race_control9  same_race_control10)

**Generating Number of Same Race Treated Checc Friends
egen num_checc_friends_treatsrace = rowtotal(same_race_treat1  same_race_treat2  same_race_treat3  same_race_treat4  same_race_treat5  same_race_treat6 same_race_treat7  same_race_treat8  same_race_treat9  same_race_treat10)

**Generating Number of Same Gender Control Friends
egen num_checc_friends_controlsgender = rowtotal(same_gender_control1  same_gender_control2  same_gender_control3  same_gender_control4  same_gender_control5  same_gender_control6 same_gender_control7  same_gender_control8  same_gender_control9  same_gender_control10)

**Generating Number of Same Gender Treated Friends
egen num_checc_friends_treatsgender = rowtotal(same_gender_treat1  same_gender_treat2  same_gender_treat3  same_gender_treat4  same_gender_treat5  same_gender_treat6 same_gender_treat7  same_gender_treat8  same_gender_treat9  same_gender_treat10)

gen percent_treated_friends = (num_checc_treated_friends / (num_checc_treated_friends + num_checc_control_friends))*100

**********************
**Creating Table 17***
**********************


file open file14 using "$repository/analysis/tables/newv_table17_friend_network_summary.tex", replace write

file write file14 _n "\documentclass[11pt]{article}"
file write file14 _n "\usepackage{booktabs, multicol, multirow}"
file write file14 _n "\usepackage{caption}"
file write file14 _n "\userpackage[flushleft]{threeparttable}"
file write file14 _n	"\begin{document}"

file write file14 _n "\begin{table}[H]\centering \caption{Summary statistics of surveyed kids \label{sumstat_survey}}"
file write file14 _n "\begin{threeparttable}"
file write file14 _n "\begin{tabular}{l c c  c}\hline\hline"
file write file14 _n "\multicolumn{1}{c}{\textbf{Variable}} & \textbf{Mean}"
file write file14 _n "& \textbf{Std. Dev.} & \textbf{N}\\ \hline"



tab race, m gen(race_gr)

tabstat race_gr1, save stat(mean semean n)
mat a = r(StatTotal)
local a1 = string(round(a[1,1], 0.001), "%13.0gc") //Mean
local a2 = string(round(a[2,1], 0.001), "%13.0gc") //Standard Error
local a3 = string(round(a[3,1], 0.001), "%13.0gc") //N

file write file14 _n "Black & `a1' & `a2'  & `a3'\\"


tabstat race_gr2, save stat(mean semean n)
mat a = r(StatTotal)
local a1 = string(round(a[1,1], 0.001), "%13.0gc") //Mean
local a2 = string(round(a[2,1], 0.001), "%13.0gc") //Standard Error
local a3 = string(round(a[3,1], 0.001), "%13.0gc") //N

file write file14 _n "Hispanic & `a1' & `a2'  & `a3'\\"

tabstat race_gr3, save stat(mean semean n)
mat a = r(StatTotal)
local a1 = string(round(a[1,1], 0.001), "%13.0gc") //Mean
local a2 = string(round(a[2,1], 0.001), "%13.0gc") //Standard Error
local a3 = string(round(a[3,1], 0.001), "%13.0gc") //N

file write file14 _n "White & `a1' & `a2'  & `a3'\\"

tab gender, m gen(gender_gr)

tabstat gender_gr1, save stat(mean semean n)
mat a = r(StatTotal)
local a1 = string(round(a[1,1], 0.001), "%13.0gc") //Mean
local a2 = string(round(a[2,1], 0.001), "%13.0gc") //Standard Error
local a3 = string(round(a[3,1], 0.001), "%13.0gc") //N

file write file14 _n "Female & `a1' & `a2'  & `a3'\\"

tabstat age_pre if age_pre != 0, save stat(mean semean n)
mat a = r(StatTotal)
local a1 = string(round(a[1,1], 0.001), "%13.0gc") //Mean
local a2 = string(round(a[2,1], 0.001), "%13.0gc") //Standard Error
local a3 = string(round(a[3,1], 0.001), "%13.0gc") //N

file write file14 _n "Baseline Age (months) & `a1' & `a2'  & `a3'\\"

tabstat num_friends, save stat(mean semean n)
mat a = r(StatTotal)
local a1 = string(round(a[1,1], 0.001), "%13.0gc") //Mean
local a2 = string(round(a[2,1], 0.001), "%13.0gc") //Standard Error
local a3 = string(round(a[3,1], 0.001), "%13.0gc") //N

file write file14 _n "$ F_{i,total} $ & `a1' & `a2'  & `a3'\\"

tabstat num_checc_friends, save stat(mean semean n)
mat a = r(StatTotal)
local a1 = string(round(a[1,1], 0.001), "%13.0gc") //Mean
local a2 = string(round(a[2,1], 0.001), "%13.0gc") //Standard Error
local a3 = string(round(a[3,1], 0.001), "%13.0gc") //N

file write file14 _n "$ F_{i,checc} $ & `a1' & `a2'  & `a3'\\"

tabstat num_checc_control_friends, save stat(mean semean n)
mat a = r(StatTotal)
local a1 = string(round(a[1,1], 0.001), "%13.0gc") //Mean
local a2 = string(round(a[2,1], 0.001), "%13.0gc") //Standard Error
local a3 = string(round(a[3,1], 0.001), "%13.0gc") //N


file write file14 _n "$ F_{i, survey}^{control} $ & `a1' & `a2'  & `a3'\\"

tabstat num_checc_treated_friends, save stat(mean semean n)

mat a = r(StatTotal)
local a1 = string(round(a[1,1], 0.001), "%13.0gc") //Mean
local a2 = string(round(a[2,1], 0.001), "%13.0gc") //Standard Error
local a3 = string(round(a[3,1], 0.001), "%13.0gc") //N


file write file14 _n "$ F_{i,survey}^{treated} $ & `a1' & `a2'  & `a3'\\"

tabstat num_checc_friends_srace, save stat(mean semean n)

mat a = r(StatTotal)
local a1 = string(round(a[1,1], 0.001), "%13.0gc") //Mean
local a2 = string(round(a[2,1], 0.001), "%13.0gc") //Standard Error
local a3 = string(round(a[3,1], 0.001), "%13.0gc") //N

file write file14 _n "$ F_{i,checc, samerace} $ & `a1' & `a2'  & `a3'\\"


tabstat num_checc_friends_treatsrace, save stat(mean semean n)

mat a = r(StatTotal)
local a1 = string(round(a[1,1], 0.001), "%13.0gc") //Mean
local a2 = string(round(a[2,1], 0.001), "%13.0gc") //Standard Error
local a3 = string(round(a[3,1], 0.001), "%13.0gc") //N

file write file14 _n "$ F_{i,checc, samerace}^{treated} $ & `a1' & `a2'  & `a3'\\"

tabstat num_checc_friends_controlsrace, save stat(mean semean n)

mat a = r(StatTotal)
local a1 = string(round(a[1,1], 0.001), "%13.0gc") //Mean
local a2 = string(round(a[2,1], 0.001), "%13.0gc") //Standard Error
local a3 = string(round(a[3,1], 0.001), "%13.0gc") //N

file write file14 _n "$ F_{i,checc, samerace}^{control} $ & `a1' & `a2'  & `a3'\\"

tabstat num_checc_friends_sgender, save stat(mean semean n)

mat a = r(StatTotal)
local a1 = string(round(a[1,1], 0.001), "%13.0gc") //Mean
local a2 = string(round(a[2,1], 0.001), "%13.0gc") //Standard Error
local a3 = string(round(a[3,1], 0.001), "%13.0gc") //N

file write file14 _n "$ F_{i,checc, samegender} $ & `a1' & `a2'  & `a3'\\"

tabstat num_checc_friends_treatsgender, save stat(mean semean n)

mat a = r(StatTotal)
local a1 = string(round(a[1,1], 0.001), "%13.0gc") //Mean
local a2 = string(round(a[2,1], 0.001), "%13.0gc") //Standard Error
local a3 = string(round(a[3,1], 0.001), "%13.0gc") //N

file write file14 _n "$ F_{i,checc, samegender}^{treated} $ & `a1' & `a2'  & `a3'\\"

tabstat num_checc_friends_controlsgender, save stat(mean semean n)

mat a = r(StatTotal)
local a1 = string(round(a[1,1], 0.001), "%13.0gc") //Mean
local a2 = string(round(a[2,1], 0.001), "%13.0gc") //Standard Error
local a3 = string(round(a[3,1], 0.001), "%13.0gc") //N

file write file14 _n "$ F_{i,checc, samegender}^{control} $  & `a1' & `a2'  & `a3'\\"

tabstat percent_treated_friends, save stat(mean semean n)

mat a = r(StatTotal)
local a1 = string(round(a[1,1], 0.001), "%13.0gc") //Mean
local a2 = string(round(a[2,1], 0.001), "%13.0gc") //Standard Error
local a3 = string(round(a[3,1], 0.001), "%13.0gc") //N


file write file14 _n "$ P^{treated}_{i,survey} $ & `a1' & `a2'  & `a3'\\"

file write file14 _n "\hline"
file write file14 _n "\end{tabular}"
file write file14 _n "\begin{tablenotes}"
file write file14 _n "\footnotesize"

file write file14 _n "\item \textit{Notes:} Descriptive statistics on key demographic and social network variables in our surveyed sample."
file write file14 _n "\end{tablenotes}"
file write file14 _n "\end{threeparttable}"
file write file14 _n "\end{table}"

file write file14 _n "\end{document}"
 
file close file14

****Table 18: Friend Network Summary Statistics****

xtile std_cog_quintile = std_cog, n(5)
xtile std_ncog_quintile = std_ncog, n(5)

file open file15 using "$repository/analysis/tables/newv_table18_friend_network_quantiles.tex", replace write

file write file15 _n "\documentclass[11pt]{article}"
file write file15 _n "\usepackage{booktabs, multicol, multirow}"
file write file15 _n "\usepackage{caption}"
file write file15 _n "\userpackage[flushleft]{threeparttable}"
file write file15 _n	"\begin{document}"


file write file15 _n "\begin{table}[H]"
file write file15 _n "\centering"
file write file15 _n "\caption{Social Network and Cognitive and Non-cognitive Scores}"
file write file15 _n "\label{tab:quantiles}"
file write file15 _n "\begin{threeparttable}"
file write file15 _n "\begin{tabular}{ll|ll}"
file write file15 _n "\hline \hline"
file write file15 _n "Score Quantiles & $ P^{treated}_{i,survey} $ & Non-Cognitive Score Quantiles & $ P^{treated}_{i,survey} $ \\ \hline"


foreach x in 1 2 3 4 5 {
	local j = 1
	foreach var of varlist std_cog_quintile  std_ncog_quintile {

	tabstat percent_treated_friends, by(`var') save stat(mean semean)
	mat a = r(Stat`x')
	local a`j' = string(round(a[1,1], 0.001), "%13.0gc") //Mean
    local j = `j' + 1
	local a`j' = string(round(a[2,1], 0.001), "%13.0gc") //Standard Error
	local j = `j' + 1
	}
	if `x' != 5 { 
	file write file15 _n "`x'st Quantile              & `a1'\%                     & `x'st Quantile                  & `a3'\%                     \\"
    file write file15 _n "                      & (`a2')                    &                               & (`a4')                    \\"
	}

	else if `x' == 5 {

	file write file15 _n "`x'st Quantile              & `a1'\%                     & `x'st Quantile                  & `a3'\%                     \\"
    file write file15 _n "                      & (`a2')                    &                               & (`a4')                    \\ \hline"
	}

}



file write file15 _n "\end{tabular}"
file write file15 _n "\begin{tablenotes}"
file write file15 _n "\footnotesize"

file write file15 _n "\item \textit{Notes:} This table presents the percentage of treated friends (among all CHECC friends) for different quantiles of cognitive and non-cognitive performances."

file write file15 _n "\item  Standard errors  are reported in parentheses."


file write file15 _n "\end{tablenotes}"
file write file15 _n "\end{threeparttable}"
file write file15 _n "\end{table}"

file write file15 _n "\end{document}"
 
file close file15
