****Tables 19, 20, 21 : Spillover Subscores****

clear all

cd "$repository/data_sets/pre_made"

use updated_unique_data_clean

sort child year

cd "$repository/data_sets/generated"

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
**Re-Standardizing spatial, ospan and same**
********************************************

foreach period in pre mid post sl ao_y1 ao_y2 ao_y3 ao_y4 ao_y5 ao_y6 {

rename std_spatial_`period' old_std_spatial_`period'
rename std_ospan_`period' old_std_ospan_`period'
rename std_same_`period' old_std_same_`period'

}


foreach period in pre mid post sl ao_y1 ao_y2 ao_y3 ao_y4 ao_y5 ao_y6 {
	foreach assess in spatial ospan same {
	
	egen std_`assess'_`period' = std(`assess'_`period') if (has_`assess'_`period' == 1 | has_`assess'_`period' == 2)
	
	}
}

****************************************************************
***INCLUDE THE SAME STEPS IN CONSTRUCTING THE FINAL SAMPLE******
****************************************************************

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

*****************************
****RECREATING PANEL*********
*****************************

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
merge m:1 child year using pre_scores

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
replace CK_prekinder = 1 if CK == 1 & first_random == 1 & (test == "pre" | test == "mid" | test == "post" | test == "sl" | test == "aoy1")
replace CK_prekinder = 0 if CK == 1 & first_random == 1 & (test == "aoy2" | test == "aoy3" | test == "aoy4")
replace CK_prekinder = 0 if CK == 1 & second_random == 1

*****************************
****MERGING ON NEIGHBOURS****
*****************************

**Merging with number of neighbours

merge 1:1 child test year using merged_neigh_count

**Dropping kids not pertaining to our sample 
drop if _merge == 2

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

**Creating the same sub-sample as for the Main Regression Analysis in 
**Table 7

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
	

local distance "500 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 15000 20000"
local num : list sizeof local(distance)
local i = 1

**Creating Table 19 - OLS

file open file16 using "$repository/analysis/tables/tables_pre_percentage_treated/table19_OLS.tex", replace write

file write file16 _n "\documentclass[11pt]{article}"
file write file16 _n "\usepackage{booktabs, multicol, multirow}"
file write file16 _n "\usepackage{caption}"
file write file16 _n "\userpackage[flushleft]{threeparttable}"
file write file16 _n	"\begin{document}"


file write file16 _n "\begin{table}[H]\centering \caption{Effect of a 1  Percentage Point  Increase in the Share of Treated Neighbors on Cognitive and Non-cognitive Subtest Scores of Control Kids--OLS Model \label{ols_subtests}}"
file write file16 _n "\begin{threeparttable} \centering"

file write file16 _n "\begin{tabular}{lccccc|ccc}" 
file write file16 _n "\toprule"
file write file16 _n "\midrule" 
file write file16 _n "& \multicolumn{5}{c}{Cognitive Sub-scores} & \multicolumn{5}{c}{Non-cognitive Sub-scores}\\" 
file write file16 _n "$ d $ (meters) & PPVT & WJL & WJA & WJS & WJQ & OSP & SPAT & PSRA & SAME & CARD \\"
file write file16 _n "\midrule"

**Running regressions	

foreach d of local distance  {	
	local j = 1
	foreach assess in ppvt wjl wja wjs wjq ospan spatial psra same card {
	
	
	if "`assess'" == "same" {
		***POOLED OLS
	quietly reg std_`assess' percent_treated_`d' std_cog_pre std_ncog_pre distto1 distto2 i.gender_num i.race_num i.year i.blockgroup_num i.test_num age_pre if (has_`assess' == 1 | has_`assess' == 2) & (year == 2012 | year == 2013) & (test_num == 0 | test_num == 1 |test_num == 2| test_num == 3) , cluster(child)
	
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
			
	else if "`assess'" == "card" {
		***POOLED OLS
	quietly reg std_`assess' percent_treated_`d' std_cog_pre std_ncog_pre distto1 distto2 i.gender_num i.race_num i.year i.blockgroup_num i.test_num age_pre if (has_`assess' == 1 | has_`assess' == 2) & (test_num == 4 |test_num == 5| test_num == 6 | test_num == 7) , cluster(child)
	
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
	
	
	
	else {
	***POOLED OLS
	quietly reg std_`assess' percent_treated_`d' std_cog_pre std_ncog_pre distto1 distto2 i.gender_num i.race_num i.year i.blockgroup_num i.test_num age_pre if (has_`assess' == 1 | has_`assess' == 2) , cluster(child)
	
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
		
		
	
	}
	
	file write file16 _n "\multirow{2}{*}{`d'} & `item_1_`d'' & `item_2_`d'' & `item_3_`d''  & `item_4_`d'' & `item_5_`d'' & `item_6_`d'' & `item_7_`d'' & `item_8_`d'' & `item_9_`d'' & `item_10_`d''  \\"
	file write file16 _n "& (`se_1_`d'') & (`se_2_`d'') & (`se_3_`d'') & (`se_4_`d'') & (`se_5_`d'') & (`se_6_`d'') & (`se_7_`d'') & (`se_8_`d'') & (`se_9_`d'') & (`se_10_`d'') \\"

	if `i' < `num' {
		file write file16 _n "& & & & & & & & & &\\"	
		}
	local i = `i' + 1
	
}
	
file write file16 _n "\midrule"
file write file16 _n "\bottomrule"
file write file16 _n "\end{tabular}"

file write file16 _n "\begin{tablenotes}"
file write file16 _n "\footnotesize"

file write file16 _n "\item \textit{Notes:}  Robust standard errors, clustered at the individual level in parentheses"
file write file16 _n "\item *** p$<$0.01, ** p$<$0.05, * p$<$0.1"
file write file16 _n "\end{tablenotes}"
file write file16 _n "\end{threeparttable}"
file write file16 _n "\end{table}"

file write file16 _n "\end{document}"
 
file close file16	
	
**Creating Table 20 - Fixed Effects

local i = 1

file open file17 using "$repository/analysis/tables/tables_pre_percentage_treated/table20_FE.tex", replace write

file write file17 _n "\documentclass[11pt]{article}"
file write file17 _n "\usepackage{booktabs, multicol, multirow}"
file write file17 _n "\usepackage{caption}"
file write file17 _n "\userpackage[flushleft]{threeparttable}"
file write file17 _n	"\begin{document}"


file write file17 _n "\begin{table}[H]\centering \caption{Effect of a 1  Percentage Point  Increase in the Share of Treated Neighbors on Cognitive and Non-cognitive Subtest Scores of Control Kids--Fixed Effect Model \label{fe_subtests}}"
file write file17 _n "\begin{threeparttable} \centering"

file write file17 _n "\begin{tabular}{lccccc|ccc}" 
file write file17 _n "\toprule"
file write file17 _n "\midrule" 
file write file17 _n "& \multicolumn{5}{c}{Cognitive Sub-scores} & \multicolumn{5}{c}{Non-cognitive Sub-scores}\\" 
file write file17 _n "$ d $ (meters) & PPVT & WJL & WJA & WJS & WJQ & OSP & SPAT & PSRA & SAME & CARD \\"
file write file17 _n "\midrule"

**Running regressions	

foreach d of local distance  {	
	local j = 1
	foreach assess in ppvt wjl wja wjs wjq ospan spatial psra same card {
	
	
	if "`assess'" == "same" {
		***FIXED EFFECTS
	quietly xtreg std_`assess' percent_treated_`d' i.test_num if (has_`assess' == 1 | has_`assess' == 2) & (year == 2012 | year == 2013) & (test_num == 0 | test_num == 1 |test_num == 2| test_num == 3) , fe cluster(child)
	
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
			
	else if "`assess'" == "card" {
		***FIXED EFFECTS
	quietly xtreg std_`assess' percent_treated_`d' i.test_num if (has_`assess' == 1 | has_`assess' == 2) & (test_num == 4 |test_num == 5| test_num == 6 | test_num == 7) , fe cluster(child)
	
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
	
	
	
	else {
	***FIXED EFFECTS
	quietly xtreg std_`assess' percent_treated_`d' i.test_num if (has_`assess' == 1 | has_`assess' == 2) , fe cluster(child)
	
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
		
		
	
	}
	
	file write file17 _n "\multirow{2}{*}{`d'} & `item_1_`d'' & `item_2_`d'' & `item_3_`d''  & `item_4_`d'' & `item_5_`d'' & `item_6_`d'' & `item_7_`d'' & `item_8_`d'' & `item_9_`d'' & `item_10_`d''  \\"
	file write file17 _n "& (`se_1_`d'') & (`se_2_`d'') & (`se_3_`d'') & (`se_4_`d'') & (`se_5_`d'') & (`se_6_`d'') & (`se_7_`d'') & (`se_8_`d'') & (`se_9_`d'') & (`se_10_`d'') \\"

	if `i' < `num' {
		file write file17 _n "& & & & & & & & & &\\"	
		}
	local i = `i' + 1
	
}
	
file write file17 _n "\midrule"
file write file17 _n "\bottomrule"
file write file17 _n "\end{tabular}"

file write file17 _n "\begin{tablenotes}"
file write file17 _n "\footnotesize"

file write file17 _n "\item \textit{Notes:}  Robust standard errors, clustered at the individual level in parentheses"
file write file17 _n "\item *** p$<$0.01, ** p$<$0.05, * p$<$0.1"
file write file17 _n "\end{tablenotes}"
file write file17 _n "\end{threeparttable}"
file write file17 _n "\end{table}"

file write file17 _n "\end{document}"
 
file close file17	

**Creating Table 21 - Random Effects

file open file18 using "$repository/analysis/tables/tables_pre_percentage_treated/table21_RE.tex", replace write

file write file18 _n "\documentclass[11pt]{article}"
file write file18 _n "\usepackage{booktabs, multicol, multirow}"
file write file18 _n "\usepackage{caption}"
file write file18 _n "\userpackage[flushleft]{threeparttable}"
file write file18 _n	"\begin{document}"


file write file18 _n "\begin{table}[H]\centering \caption{Effect of a 1  Percentage Point  Increase in the Share of Treated Neighbors on Cognitive and Non-cognitive Subtest Scores of Control Kids--Random Effect Model\label{re_subtests}}"
file write file18 _n "\begin{threeparttable} \centering"

file write file18 _n "\begin{tabular}{lccccc|ccc}" 
file write file18 _n "\toprule"
file write file18 _n "\midrule" 
file write file18 _n "& \multicolumn{5}{c}{Cognitive Sub-scores} & \multicolumn{5}{c}{Non-cognitive Sub-scores}\\" 
file write file18 _n "$ d $ (meters) & PPVT & WJL & WJA & WJS & WJQ & OSP & SPAT & PSRA & SAME & CARD \\"
file write file18 _n "\midrule"

**Running regressions	

local i = 1

foreach d of local distance  {	
	local j = 1
	foreach assess in ppvt wjl wja wjs wjq ospan spatial psra same card {
	
	
	if "`assess'" == "same" {
		***RANDOM EFFECTS
	quietly xtreg std_`assess' percent_treated_`d' std_cog_pre std_ncog_pre distto1 distto2 i.gender_num i.race_num i.year i.blockgroup_num i.test_num age_pre if (has_`assess' == 1 | has_`assess' == 2) & (year == 2012 | year == 2013) & (test_num == 0 | test_num == 1 |test_num == 2| test_num == 3) , re cluster(child)
	
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
			
	else if "`assess'" == "card" {
		***RANDOM EFFECTS
	quietly xtreg std_`assess' percent_treated_`d' std_cog_pre std_ncog_pre distto1 distto2 i.gender_num i.race_num i.year i.blockgroup_num i.test_num age_pre if (has_`assess' == 1 | has_`assess' == 2) & (test_num == 4 |test_num == 5| test_num == 6 | test_num == 7) , re cluster(child)
	
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
	
	
	
	else {
	***RANDOM EFFECTS
	quietly xtreg std_`assess' percent_treated_`d' std_cog_pre std_ncog_pre distto1 distto2 i.gender_num i.race_num i.year i.blockgroup_num i.test_num age_pre if (has_`assess' == 1 | has_`assess' == 2) , re cluster(child)
	
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
		
		
	
	}
	
	file write file18 _n "\multirow{2}{*}{`d'} & `item_1_`d'' & `item_2_`d'' & `item_3_`d''  & `item_4_`d'' & `item_5_`d'' & `item_6_`d'' & `item_7_`d'' & `item_8_`d'' & `item_9_`d'' & `item_10_`d''  \\"
	file write file18 _n "& (`se_1_`d'') & (`se_2_`d'') & (`se_3_`d'') & (`se_4_`d'') & (`se_5_`d'') & (`se_6_`d'') & (`se_7_`d'') & (`se_8_`d'') & (`se_9_`d'') & (`se_10_`d'') \\"

	if `i' < `num' {
		file write file18 _n "& & & & & & & & & &\\"	
		}
	local i = `i' + 1
	
}
	
file write file18 _n "\midrule"
file write file18 _n "\bottomrule"
file write file18 _n "\end{tabular}"

file write file18 _n "\begin{tablenotes}"
file write file18 _n "\footnotesize"

file write file18 _n "\item \textit{Notes:}  Robust standard errors, clustered at the individual level in parentheses"
file write file18 _n "\item *** p$<$0.01, ** p$<$0.05, * p$<$0.1"
file write file18 _n "\end{tablenotes}"
file write file18 _n "\end{threeparttable}"
file write file18 _n "\end{table}"

file write file18 _n "\end{document}"
 
file close file18
