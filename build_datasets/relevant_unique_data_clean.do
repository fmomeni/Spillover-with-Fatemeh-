//CLEANING THE CHECC DATA SET FOR SUBSEQUENT ANALYSIS




clear all

cd "$repository/data_sets/pre_made"

use updated_unique_data_clean

sort child year


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


********************************************************************************
*************Define Age Variables for Entry in Kindergarten and School**********
********************************************************************************




**Age Variable for School Entry

foreach year in 2010 2011 2012 2013 2014 2015 2016 2017 2018 {

gen age_begin_syear`year' = mofd(date("08/17/`year'", "MDY") - birthday)

}



foreach period in pre mid post sl {

gen school_age_`period' = .

	foreach year in 2010 2011 2012 2013 {
	
	replace school_age_`period' = age_begin_syear`year' if year == "`year'"

	}
	
}


foreach period in ao_y1 ao_y2 ao_y3 ao_y4 ao_y5 {

gen school_age_`period' = .

	foreach year in 2010 2011 2012 2013 {
	
	if "`period'" == "ao_y1" {
	
	local year1 = `year' + 1
	replace school_age_`period' = age_begin_syear`year1' if year == "`year'"	
	}
	
	else if "`period'" == "ao_y2" {
	
	local year2 = `year' + 2
	replace school_age_`period' = age_begin_syear`year2' if year == "`year'"	
	}
	
	else if "`period'" == "ao_y3" {
	
	local year3 = `year' + 3
	replace school_age_`period' = age_begin_syear`year3' if year == "`year'"	
	}
	
	else if "`period'" == "ao_y4" {
	
	local year4 = `year' + 4
	replace school_age_`period' = age_begin_syear`year4' if year == "`year'"	
	}
	
	else if "`period'" == "ao_y5" {
	
	local year5 = `year' + 5
	replace school_age_`period' = age_begin_syear`year5' if year == "`year'"	
	}
	
	}
}

**Age Variable for Kindergarten Entry

foreach year in 2010 2011 2012 2013 2014 2015 2016 2017 2018 {

gen age_begin_kyear`year' = mofd(date("09/01/`year'", "MDY") - birthday)

}



foreach period in pre mid post sl {

gen kinder_age_`period' = .

	foreach year in 2010 2011 2012 2013 {
	
	replace kinder_age_`period' = age_begin_kyear`year' if year == "`year'"

	}
	
}


foreach period in ao_y1 ao_y2 ao_y3 ao_y4 ao_y5 {

gen kinder_age_`period' = .

	foreach year in 2010 2011 2012 2013 {
	
	if "`period'" == "ao_y1" {
	
	local year1 = `year' + 1
	replace kinder_age_`period' = age_begin_kyear`year1' if year == "`year'"	
	}
	
	else if "`period'" == "ao_y2" {
	
	local year2 = `year' + 2
	replace kinder_age_`period' = age_begin_kyear`year2' if year == "`year'"	
	}
	
	else if "`period'" == "ao_y3" {
	
	local year3 = `year' + 3
	replace kinder_age_`period' = age_begin_kyear`year3' if year == "`year'"	
	}
	
	else if "`period'" == "ao_y4" {
	
	local year4 = `year' + 4
	replace kinder_age_`period' = age_begin_kyear`year4' if year == "`year'"	
	}
	
	else if "`period'" == "ao_y5" {
	
	local year5 = `year' + 5
	replace kinder_age_`period' = age_begin_kyear`year5' if year == "`year'"	
	}
	
	}
}






********************************************************************************
*************Defining Multiple-Year Treatment Status****************************
********************************************************************************


**Dropping all observations for kinderpreps in 2011
drop if year == "2011" & treatment == "kinderprep"

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
save unique_data_clean_for_panel, replace
