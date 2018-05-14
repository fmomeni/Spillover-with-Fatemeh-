*Purpose: create average performance dummies
*The commands involving scores that are not avaialble yet are commented out


clear all

cd "$repository/data_sets/generated"

use unique_data_clean_for_panel

sort child year

**Drop kids with kinderprep status in 2011 which is wrong 

drop if treatment == "kinderprep" & year == "2011"

foreach assess in pre mid post sl ao_y1 ao_y2 ao_y3 ao_y4 ao_y5 {
	
	foreach score in cog_`assess' ncog_`assess' {

		replace std_`score' = . if has_`score' == 0
	} 
}

keep treatment year child std_cog_* std_ncog_*

**Dummies for whether a child has been randomised twice
gen randomised_twice = (child == child[_n+1])
replace randomised_twice = 1 if child == child[_n-1]


**Only child 1109 has been randomised three times
replace randomised_twice = 0 if child == 1109
gen randomised_thrice = 1 if child == 1109 


reshape wide treatment std_cog_pre-std_ncog_ao_7yo, i(child) j(year) string

save scores_by_year.dta, replace


**********

clear all

cd "$repository/data_sets/generated"

use unique_data_clean_for_panel

drop if treatment == "kinderprep" & year == "2011"

duplicates drop child, force

keep year child
rename year randomization_dest
save first_randomization_year.dta, replace 

**********

clear all

cd "$repository/data_sets/generated"

use neighbor_count_by_oriassessments_dummies_Fatemeh_all_years

rename destination_gecc_id child

merge m:1 child using first_randomization_year

drop _m

destring randomization_dest, replace

merge m:1 child using scores_by_year

drop _m

rename child  destination_gecc_id

rename randomised_twice randomized_twice

**********************************************************
*Defining Corresponding Types of Assessments for Neighbors
**********************************************************

/* This part of the code starts with a type of assessment of the origin kid
and finds the equivalent assessment type for the neighbor kid. For version 1,
"equivalent assessment" means the most recent assessment of the neighbor kid that
 happened right before the given assessment of the origin kid. For version 2, 
 "equivalent assessment" means the most recent assessment of the neighbor kid that
 might coincide with the date of the given assessment of the origin kid.
*/



**********************************************************
*Defining Corresponding Performance Scores for Neighbors
**********************************************************

/* This part of the code matches the score of the neighbor to the score 
of the origin kid following the date rules defined by version 1 and 2 respectively
For instance "v1std_cog_pre_origin_dest" defines the relevant cognitive score of the DESTINATION kid at the 
pre assessment of the ORIGIN kid. The date of the relevant cognitive score of the DESTINATION kid is determined
according to the date rule of version 1.
*/

* There are 8 main cases altogether, each with their subcases. These codes have been checked by multiple RAs.
*The lines that are commented out are for assessments beyound aoy5.


foreach score in cog ncog {

foreach version in v1 v2 {

gen `version'std_`score'_pre_origin_dest = . 
gen `version'std_`score'_mid_origin_dest = . 
gen `version'std_`score'_post_origin_dest = . 
gen `version'std_`score'_sl_origin_dest = . 
gen `version'std_`score'_ao1_origin_dest = . 
gen `version'std_`score'_ao2_origin_dest = . 
gen `version'std_`score'_ao3_origin_dest = . 
gen `version'std_`score'_ao4_origin_dest = . 
gen `version'std_`score'_ao5_origin_dest = .

}
}



*Case 1) The neighbor was randomized in 2010 once


foreach score in cog ncog {

*if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 0  {

replace v1std_`score'_pre_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 0 
replace v1std_`score'_mid_origin_dest = std_`score'_pre2010 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 0
replace v1std_`score'_post_origin_dest = std_`score'_mid2010 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 0
replace v1std_`score'_sl_origin_dest = std_`score'_post2010 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 0
replace v1std_`score'_ao1_origin_dest = std_`score'_sl2010 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 0
replace v1std_`score'_ao2_origin_dest = std_`score'_ao_y12010 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 0
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y22010 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 0
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 0
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y42010 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 0

replace v2std_`score'_pre_origin_dest = std_`score'_pre2010 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 0
replace v2std_`score'_mid_origin_dest = std_`score'_mid2010 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 0
replace v2std_`score'_post_origin_dest = std_`score'_post2010 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 0
replace v2std_`score'_sl_origin_dest = std_`score'_sl2010 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 0
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y12010 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 0
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y22010 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 0
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 0
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y42010 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 0
replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y52010 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 0



*else if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 0   {

replace v1std_`score'_pre_origin_dest = std_`score'_mid2010 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 0
replace v1std_`score'_mid_origin_dest = std_`score'_sl2010 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 0
replace v1std_`score'_post_origin_dest = std_`score'_ao_y12010 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 0
replace v1std_`score'_sl_origin_dest = std_`score'_ao_y12010 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 0
replace v1std_`score'_ao1_origin_dest = std_`score'_ao_y12010 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 0
replace v1std_`score'_ao2_origin_dest = std_`score'_ao_y22010 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 0
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 0
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y42010 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 0
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y52010 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 0

replace v2std_`score'_pre_origin_dest = std_`score'_post2010 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 0
replace v2std_`score'_mid_origin_dest = std_`score'_sl2010 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 0
replace v2std_`score'_post_origin_dest = std_`score'_ao_y12010 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 0
replace v2std_`score'_sl_origin_dest = std_`score'_ao_y12010 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 0
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y22010 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 0
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 0
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y42010 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 0
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y52010 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 0
*replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y62010 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 0



*else if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0  {

replace v1std_`score'_pre_origin_dest = std_`score'_ao_y12010 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
replace v1std_`score'_mid_origin_dest = std_`score'_ao_y12010 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
replace v1std_`score'_post_origin_dest = std_`score'_ao_y22010 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
replace v1std_`score'_sl_origin_dest = std_`score'_ao_y22010 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
replace v1std_`score'_ao1_origin_dest = std_`score'_ao_y22010 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
replace v1std_`score'_ao2_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y42010 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y52010 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
*replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y62010 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0

replace v2std_`score'_pre_origin_dest = std_`score'_ao_y12010 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
replace v2std_`score'_mid_origin_dest = std_`score'_ao_y12010 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
replace v2std_`score'_post_origin_dest = std_`score'_ao_y22010 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
replace v2std_`score'_sl_origin_dest = std_`score'_ao_y22010 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y42010 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y52010 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
*replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y62010 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
*re place v2std_`score'_ao5_origin_dest = std_`score'_ao_y72010 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0





*else if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0  {


replace v1std_`score'_pre_origin_dest = std_`score'_ao_y22010 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0 
replace v1std_`score'_mid_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0 
replace v1std_`score'_post_origin_dest = std_`score'_ao_y22010 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0 
replace v1std_`score'_sl_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0 
replace v1std_`score'_ao1_origin_dest = std_`score'_ao_y22010 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0 
replace v1std_`score'_ao2_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0 
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y42010 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0 
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y52010 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0 
*replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y62010 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0 

replace v2std_`score'_pre_origin_dest = std_`score'_ao_y22010 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0 
replace v2std_`score'_mid_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0 
replace v2std_`score'_post_origin_dest = std_`score'_ao_y22010 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0 
replace v2std_`score'_sl_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0 
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0 
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y42010 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0 
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y52010 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0 
*replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y62010 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0 
*replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y72010 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0 







*else if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0  {

replace v1std_`score'_pre_origin_dest = std_`score'_ao_y22010 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
replace v1std_`score'_mid_origin_dest = std_`score'_ao_y22010 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
replace v1std_`score'_post_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
replace v1std_`score'_sl_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
replace v1std_`score'_ao1_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
replace v1std_`score'_ao2_origin_dest = std_`score'_ao_y42010 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y52010 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
*replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y62010 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
*replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y72010 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0

replace v2std_`score'_pre_origin_dest = std_`score'_ao_y22010 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
replace v2std_`score'_mid_origin_dest = std_`score'_ao_y22010 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
replace v2std_`score'_post_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
replace v2std_`score'_sl_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y42010 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y52010 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
*replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y62010 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
*replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y72010 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
*replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y82010 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0







*else if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0  {

replace v1std_`score'_pre_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0
replace v1std_`score'_mid_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0
replace v1std_`score'_post_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0
replace v1std_`score'_sl_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0
replace v1std_`score'_ao1_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0
replace v1std_`score'_ao2_origin_dest = std_`score'_ao_y42010 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y52010 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0
*replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y62010 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0
*replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y72010 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0

replace v2std_`score'_pre_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0
replace v2std_`score'_mid_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0
replace v2std_`score'_post_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0
replace v2std_`score'_sl_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y42010 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y52010 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0
*replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y62010 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0
*replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y72010 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0
*replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y82010 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0
 
}

*save origin_neighbor_score.dta, replace 


*Case 2) The neighbor was randomized twice: in 2010 and 2011

foreach score in cog ncog {

*if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 1 {

replace v1std_`score'_pre_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 1
replace v1std_`score'_mid_origin_dest = std_`score'_pre2010 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 1
replace v1std_`score'_post_origin_dest = std_`score'_mid2010 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 1
replace v1std_`score'_sl_origin_dest = std_`score'_post2010 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 1
replace v1std_`score'_ao1_origin_dest = std_`score'_mid2011 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 1
replace v1std_`score'_ao2_origin_dest = std_`score'_sl2011 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 1
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y22010 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 1
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 1
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y42010 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 1

replace v2std_`score'_pre_origin_dest = std_`score'_pre2010 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 1
replace v2std_`score'_mid_origin_dest = std_`score'_mid2010 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 1
replace v2std_`score'_post_origin_dest = std_`score'_post2010 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 1
replace v2std_`score'_sl_origin_dest = std_`score'_sl2010 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 1
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y12010 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 1
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y22010 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 1
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 1
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y42010 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 1
replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y52010 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 1



*else if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 1  {

replace v1std_`score'_pre_origin_dest = std_`score'_mid2010 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 1
replace v1std_`score'_mid_origin_dest = std_`score'_sl2010 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 1
replace v1std_`score'_post_origin_dest = std_`score'_ao_y12010 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 1
replace v1std_`score'_sl_origin_dest = std_`score'_post2011 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 1
replace v1std_`score'_ao1_origin_dest = std_`score'_sl2011 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 1
replace v1std_`score'_ao2_origin_dest = std_`score'_ao_y22010 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 1
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 1
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y42010 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 1
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y52010 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 1

replace v2std_`score'_pre_origin_dest = std_`score'_post2010 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 1
replace v2std_`score'_mid_origin_dest = std_`score'_mid2011 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 1
replace v2std_`score'_post_origin_dest = std_`score'_post2011 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 1
replace v2std_`score'_sl_origin_dest = std_`score'_sl2011 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 1
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y22010 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 1
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 1
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y42010 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 1
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y52010 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 1
*replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y62010 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 1



*else if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1 {

replace v1std_`score'_pre_origin_dest = std_`score'_ao_y12010 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v1std_`score'_mid_origin_dest = std_`score'_sl2011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v1std_`score'_post_origin_dest = std_`score'_ao_y22010 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v1std_`score'_sl_origin_dest = std_`score'_ao_y22010 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v1std_`score'_ao1_origin_dest = std_`score'_ao_y22010 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v1std_`score'_ao2_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y42010 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y52010 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
*replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y62010 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1

replace v2std_`score'_pre_origin_dest = std_`score'_post2011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v2std_`score'_mid_origin_dest = std_`score'_sl2011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v2std_`score'_post_origin_dest = std_`score'_ao_y22010 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v2std_`score'_sl_origin_dest = std_`score'_ao_y22010 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y42010 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y52010 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
*replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y62010 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
*replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y72010 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1





*else if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1 {


replace v1std_`score'_pre_origin_dest = std_`score'_ao_y22010 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v1std_`score'_mid_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v1std_`score'_post_origin_dest = std_`score'_ao_y22010 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v1std_`score'_sl_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v1std_`score'_ao1_origin_dest = std_`score'_ao_y22010 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v1std_`score'_ao2_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y42010 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y52010 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
*replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y62010 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1

replace v2std_`score'_pre_origin_dest = std_`score'_ao_y22010 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v2std_`score'_mid_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v2std_`score'_post_origin_dest = std_`score'_ao_y22010 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v2std_`score'_sl_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y42010 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y52010 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
*replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y62010 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
*replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y72010 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1







*else if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1 {

replace v1std_`score'_pre_origin_dest = std_`score'_ao_y22010 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v1std_`score'_mid_origin_dest = std_`score'_ao_y22010 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v1std_`score'_post_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v1std_`score'_sl_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v1std_`score'_ao1_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v1std_`score'_ao2_origin_dest = std_`score'_ao_y42010 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y52010 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
*replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y62010 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
*replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y72010 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
 
replace v2std_`score'_pre_origin_dest = std_`score'_ao_y22010 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v2std_`score'_mid_origin_dest = std_`score'_ao_y22010 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v2std_`score'_post_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v2std_`score'_sl_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y42010 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y52010 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
*replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y62010 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
*replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y72010 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
*replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y82010 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1







*else if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1 {

replace v1std_`score'_pre_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v1std_`score'_mid_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v1std_`score'_post_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v1std_`score'_sl_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v1std_`score'_ao1_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v1std_`score'_ao2_origin_dest = std_`score'_ao_y42010 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y52010 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
*replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y62010 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
*replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y72010 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
 
replace v2std_`score'_pre_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v2std_`score'_mid_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v2std_`score'_post_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v2std_`score'_sl_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y42010 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y52010 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
*replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y62010 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
*replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y72010 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
*replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y82010 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1


}


*save origin_neighbor_score.dta, replace 

*Case 3) The neighbor was randomized once in 2011


foreach score in cog ncog {

*if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 0  {

replace v1std_`score'_pre_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 0  
replace v1std_`score'_mid_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 0 
replace v1std_`score'_post_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 0 
replace v1std_`score'_sl_origin_dest = std_`score'_pre2011 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 0 
replace v1std_`score'_ao1_origin_dest = std_`score'_mid2011 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 0 
replace v1std_`score'_ao2_origin_dest = std_`score'_sl2011 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 0 
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y12011 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 0 
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 0 
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y32011 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 0 

replace v2std_`score'_pre_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 0 
replace v2std_`score'_mid_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 0 
replace v2std_`score'_post_origin_dest = std_`score'_pre2011 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 0  
replace v2std_`score'_sl_origin_dest = std_`score'_pre2011 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 0 
replace v2std_`score'_ao1_origin_dest = std_`score'_mid2011 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 0 
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y12011 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 0 
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 0 
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y32011 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 0 
replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y42011 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 0 



*else if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 0   {

replace v1std_`score'_pre_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 0
replace v1std_`score'_mid_origin_dest = std_`score'_pre2011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 0
replace v1std_`score'_post_origin_dest = std_`score'_mid2011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 0
replace v1std_`score'_sl_origin_dest = std_`score'_post2011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 0
replace v1std_`score'_ao1_origin_dest = std_`score'_sl2011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 0
replace v1std_`score'_ao2_origin_dest = std_`score'_ao_y12011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 0
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 0
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y32011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 0
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y42011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 0

replace v2std_`score'_pre_origin_dest = std_`score'_pre2011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 0
replace v2std_`score'_mid_origin_dest = std_`score'_mid2011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 0
replace v2std_`score'_post_origin_dest = std_`score'_post2011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 0
replace v2std_`score'_sl_origin_dest = std_`score'_sl2011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 0
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y12011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 0
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 0
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y32011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 0
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y42011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 0
replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y52011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 0



*else if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0  {

replace v1std_`score'_pre_origin_dest = std_`score'_mid2011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0 
replace v1std_`score'_mid_origin_dest = std_`score'_sl2011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0 
replace v1std_`score'_post_origin_dest = std_`score'_ao_y12011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0 
replace v1std_`score'_sl_origin_dest = std_`score'_ao_y12011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0 
replace v1std_`score'_ao1_origin_dest = std_`score'_ao_y12011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0 
replace v1std_`score'_ao2_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0 
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y32011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0 
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y42011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0 
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y52011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0 

replace v2std_`score'_pre_origin_dest = std_`score'_post2011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0 
replace v2std_`score'_mid_origin_dest = std_`score'_sl2011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0 
replace v2std_`score'_post_origin_dest = std_`score'_ao_y12011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0 
replace v2std_`score'_sl_origin_dest = std_`score'_ao_y12011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0 
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0 
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y32011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0 
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y42011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0 
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y52011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0 
*replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y62011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0 





*else if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0  {


replace v1std_`score'_pre_origin_dest = std_`score'_ao_y12011 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
replace v1std_`score'_mid_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
replace v1std_`score'_post_origin_dest = std_`score'_ao_y12011 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
replace v1std_`score'_sl_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
replace v1std_`score'_ao1_origin_dest = std_`score'_ao_y12011 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
replace v1std_`score'_ao2_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y32011 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y42011 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y52011 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0

replace v2std_`score'_pre_origin_dest = std_`score'_ao_y12011 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
replace v2std_`score'_mid_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
replace v2std_`score'_post_origin_dest = std_`score'_ao_y12011 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
replace v2std_`score'_sl_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y32011 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y42011 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y52011 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
*replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y62011 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0







*else if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0  {

replace v1std_`score'_pre_origin_dest = std_`score'_ao_y12011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
replace v1std_`score'_mid_origin_dest = std_`score'_ao_y12011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
replace v1std_`score'_post_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
replace v1std_`score'_sl_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
replace v1std_`score'_ao1_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
replace v1std_`score'_ao2_origin_dest = std_`score'_ao_y32011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y42010 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y52011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
*replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y62011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0

replace v2std_`score'_pre_origin_dest = std_`score'_ao_y12011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
replace v2std_`score'_mid_origin_dest = std_`score'_ao_y12011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
replace v2std_`score'_post_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
replace v2std_`score'_sl_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y32011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y42011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y52011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
*replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y62011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
*replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y72011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0







*else if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0 {

replace v1std_`score'_pre_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
replace v1std_`score'_mid_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
replace v1std_`score'_post_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
replace v1std_`score'_sl_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
replace v1std_`score'_ao1_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
replace v1std_`score'_ao2_origin_dest = std_`score'_ao_y32011 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y42011 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y52011 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
*replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y62011 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0

replace v2std_`score'_pre_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
replace v2std_`score'_mid_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
replace v2std_`score'_post_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
replace v2std_`score'_sl_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y32011 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y42011 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y52011 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
*replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y62010 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
*replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y72010 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0

}

*save origin_neighbor_score.dta, replace 

*Case 4) The neighbor was randomized twice: in 2011 and 2012. Here we pay particular attention
*to cases where the 2012 randomization was in kinderprep.

foreach score in cog ncog {

*if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep" {

replace v1std_`score'_pre_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_mid_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_post_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_sl_origin_dest = std_`score'_pre2011 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_ao1_origin_dest = std_`score'_mid2011 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_ao2_origin_dest = std_`score'_mid2012 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_sl2012 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y32011 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"

replace v2std_`score'_pre_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2std_`score'_mid_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2std_`score'_post_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2std_`score'_sl_origin_dest = std_`score'_pre2011 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2std_`score'_ao1_origin_dest = std_`score'_mid2011 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y12011 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y32011 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y42011 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"




*else if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep" {

replace v1std_`score'_pre_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_mid_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_post_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_sl_origin_dest = std_`score'_pre2011 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_ao1_origin_dest = std_`score'_mid2011 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_ao2_origin_dest = std_`score'_sl2011 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_post2012 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y32011 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"

replace v2std_`score'_pre_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2std_`score'_mid_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2std_`score'_post_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2std_`score'_sl_origin_dest = std_`score'_pre2011 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2std_`score'_ao1_origin_dest = std_`score'_mid2011 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y12011 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y32011 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y42011 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"





*else if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"  {

replace v1std_`score'_pre_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_mid_origin_dest = std_`score'_pre2011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_post_origin_dest = std_`score'_mid2011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_sl_origin_dest = std_`score'_post2011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_ao1_origin_dest = std_`score'_mid2012 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_ao2_origin_dest = std_`score'_sl2012 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y32011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y42011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"

replace v2std_`score'_pre_origin_dest = std_`score'_pre2011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2std_`score'_mid_origin_dest = std_`score'_mid2011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2std_`score'_post_origin_dest = std_`score'_post2011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2std_`score'_sl_origin_dest = std_`score'_sl2011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y12011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y32011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y42011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y52011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"




*else if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"  {

replace v1std_`score'_pre_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_mid_origin_dest = std_`score'_pre2011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_post_origin_dest = std_`score'_mid2011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_sl_origin_dest = std_`score'_post2011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_ao1_origin_dest = std_`score'_sl2011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_ao2_origin_dest = std_`score'_post2012 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y32011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y42011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"

replace v2std_`score'_pre_origin_dest = std_`score'_pre2011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2std_`score'_mid_origin_dest = std_`score'_mid2011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2std_`score'_post_origin_dest = std_`score'_post2011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2std_`score'_sl_origin_dest = std_`score'_sl2011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y12011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y32011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y42011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y52011 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"




*else if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep" {

replace v1std_`score'_pre_origin_dest = std_`score'_mid2011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_mid_origin_dest = std_`score'_sl2011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_post_origin_dest = std_`score'_ao_y12011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_sl_origin_dest = std_`score'_post2012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_ao1_origin_dest = std_`score'_sl2012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_ao2_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y32011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y42011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y52011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"

replace v2std_`score'_pre_origin_dest = std_`score'_post2011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2std_`score'_mid_origin_dest = std_`score'_mid2012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2std_`score'_post_origin_dest = std_`score'_post2012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2std_`score'_sl_origin_dest = std_`score'_sl2012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y32011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y42011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y52011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
*replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y62011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"



*****Adding
*else if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep" {
replace v1std_`score'_pre_origin_dest = std_`score'_mid2011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_mid_origin_dest = std_`score'_sl2011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_post_origin_dest = std_`score'_ao_y12011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_sl_origin_dest = std_`score'_pre2012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_ao1_origin_dest = std_`score'_post2012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_ao2_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y32011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y42011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y52011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"

replace v2std_`score'_pre_origin_dest = std_`score'_post2011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2std_`score'_mid_origin_dest = std_`score'_sl2011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2std_`score'_post_origin_dest = std_`score'_pre2012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2std_`score'_sl_origin_dest = std_`score'_post2012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y32011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y42011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y52011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
*replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y62011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"



*else if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep" {
replace v1std_`score'_pre_origin_dest = std_`score'_ao_y12011 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_mid_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_post_origin_dest = std_`score'_post2012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_sl_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_ao1_origin_dest = std_`score'_sl2012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_ao2_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y32011 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y42011 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y52011 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"

replace v2std_`score'_pre_origin_dest = std_`score'_post2012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2std_`score'_mid_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2std_`score'_post_origin_dest = std_`score'_sl2012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2std_`score'_sl_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y32011 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y42011 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y52011 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
*replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y62011 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"


*****


*else if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep" {


replace v1std_`score'_pre_origin_dest = std_`score'_ao_y12011 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_mid_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_post_origin_dest = std_`score'_pre2012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_sl_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_ao1_origin_dest = std_`score'_post2012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_ao2_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y32011 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y42011 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y52011 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"

replace v2std_`score'_pre_origin_dest = std_`score'_pre2012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2std_`score'_mid_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2std_`score'_post_origin_dest = std_`score'_post2012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2std_`score'_sl_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y32011 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y42011 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y52011 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
*replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y62011 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"






*else if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep" {


replace v1std_`score'_pre_origin_dest = std_`score'_ao_y12011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_mid_origin_dest = std_`score'_sl2011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_post_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_sl_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_ao1_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_ao2_origin_dest = std_`score'_ao_y32011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y42011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y52011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
*replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y62011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"

replace v2std_`score'_pre_origin_dest = std_`score'_post2012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2std_`score'_mid_origin_dest = std_`score'_sl2012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2std_`score'_post_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2std_`score'_sl_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y32011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y42011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y52011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
*replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y62011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
*replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y72011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"



*else if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep" {


replace v1std_`score'_pre_origin_dest = std_`score'_ao_y12011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_mid_origin_dest = std_`score'_post2012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_post_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_sl_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_ao1_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_ao2_origin_dest = std_`score'_ao_y32011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y42011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y52011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
*replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y62011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"

replace v2std_`score'_pre_origin_dest = std_`score'_pre2012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2std_`score'_mid_origin_dest = std_`score'_post2012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2std_`score'_post_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2std_`score'_sl_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y32011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y42011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y52011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
*replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y62011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
*replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y72011 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"



*else if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep" {


replace v1std_`score'_pre_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_mid_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_post_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_sl_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_ao1_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_ao2_origin_dest = std_`score'_ao_y32011 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y42011 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y52011 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
*replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y62011 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"

replace v2std_`score'_pre_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2std_`score'_mid_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2std_`score'_post_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2std_`score'_sl_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y32011 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y42011 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y52011 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
*replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y62011 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
*replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y72011 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"



*else if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep" {


replace v1std_`score'_pre_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_mid_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_post_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_sl_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_ao1_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_ao2_origin_dest = std_`score'_ao_y32011 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y42011 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y52011 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
*replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y62011 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"

replace v2std_`score'_pre_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2std_`score'_mid_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2std_`score'_post_origin_dest = std_`score'_ao_y22011 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2std_`score'_sl_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y32011 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y42011 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y52011 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
*replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y62011 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
*replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y72011 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"

}


*save origin_neighbor_score.dta, replace 

*Case 5) The neighbor was randomized once in 2012. Here we pay particular attention to cases where
*2012 randomization was in kinderprep


foreach score in cog ncog {

*else if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" {


replace v1std_`score'_pre_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_mid_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_post_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_sl_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_ao1_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_ao2_origin_dest = std_`score'_mid2012 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_sl2012 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"

replace v2std_`score'_pre_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_mid_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_post_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_sl_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_ao1_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_ao2_origin_dest = std_`score'_mid2012 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y32012 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"



*else if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" {


replace v1std_`score'_pre_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_mid_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_post_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_sl_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_ao1_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_ao2_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_post2012 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"

replace v2std_`score'_pre_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_mid_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_post_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_sl_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_ao1_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_ao2_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y32012 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"



*else if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" {


replace v1std_`score'_pre_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_mid_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_post_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_sl_origin_dest = std_`score'_pre2012 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_ao1_origin_dest = std_`score'_mid2012 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_ao2_origin_dest = std_`score'_sl2012 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y32012 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"

replace v2std_`score'_pre_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_mid_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_post_origin_dest = std_`score'_pre2012 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_sl_origin_dest = std_`score'_pre2012 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_ao1_origin_dest = std_`score'_mid2012 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y32012 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y42012 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"



*else if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" {


replace v1std_`score'_pre_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_mid_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_post_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_sl_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_ao1_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_ao2_origin_dest = std_`score'_post2012 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y32012 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"

replace v2std_`score'_pre_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_mid_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_post_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_sl_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_ao1_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y32012 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y42012 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"



*else if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" {


replace v1std_`score'_pre_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_mid_origin_dest = std_`score'_pre2012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_post_origin_dest = std_`score'_mid2012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_sl_origin_dest = std_`score'_post2012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_ao1_origin_dest = std_`score'_sl2012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_ao2_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y32012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y42012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"

replace v2std_`score'_pre_origin_dest = std_`score'_pre2012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_mid_origin_dest = std_`score'_mid2012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_post_origin_dest = std_`score'_post2012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_sl_origin_dest = std_`score'_sl2012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y32012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y42012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y52012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"



*else if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" {


replace v1std_`score'_pre_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_mid_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_post_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_sl_origin_dest = std_`score'_pre2012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_ao1_origin_dest = std_`score'_post2012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_ao2_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y32012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y42012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"

replace v2std_`score'_pre_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_mid_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_post_origin_dest = std_`score'_pre2012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_sl_origin_dest = std_`score'_post2012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y32012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y42012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y52012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"



*else if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" {


replace v1std_`score'_pre_origin_dest = std_`score'_mid2012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_mid_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_post_origin_dest = std_`score'_post2012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_sl_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_ao1_origin_dest = std_`score'_sl2012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_ao2_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y32012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y42012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"

replace v2std_`score'_pre_origin_dest = std_`score'_post2012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_mid_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_post_origin_dest = std_`score'_sl2012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_sl_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y32012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y42012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y52012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"



*else if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" {


replace v1std_`score'_pre_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_mid_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_post_origin_dest = std_`score'_pre2012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_sl_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_ao1_origin_dest = std_`score'_post2012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_ao2_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y32012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y42012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"

replace v2std_`score'_pre_origin_dest = std_`score'_pre2012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_mid_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_post_origin_dest = std_`score'_post2012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_sl_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y32012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y42012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y52012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"



*else if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" {


replace v1std_`score'_pre_origin_dest = std_`score'_mid2012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_mid_origin_dest = std_`score'_sl2012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_post_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_sl_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_ao1_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_ao2_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y32012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y42012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y52012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"

replace v2std_`score'_pre_origin_dest = std_`score'_post2012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_mid_origin_dest = std_`score'_sl2012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_post_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_sl_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y32012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y42012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y52012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
*replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y62012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"



*else if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" {


replace v1std_`score'_pre_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_mid_origin_dest = std_`score'_post2012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_post_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_sl_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_ao1_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_ao2_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y32012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y42012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y52012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"

replace v2std_`score'_pre_origin_dest = std_`score'_pre2012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_mid_origin_dest = std_`score'_post2012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_post_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_sl_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y32012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y42012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y52012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
*replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y62012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"



*else if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 &  randomized_twice == 0 & treatment2012 != "kinderprep" {


replace v1std_`score'_pre_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 &  randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_mid_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 &  randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_post_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 &  randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_sl_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 &  randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_ao1_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 &  randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_ao2_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 &  randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y32012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 &  randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y42012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 &  randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y52012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 &  randomized_twice == 0 & treatment2012 != "kinderprep"

replace v2std_`score'_pre_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 &  randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_mid_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 &  randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_post_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 &  randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_sl_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 &  randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 &  randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y32012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 &  randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y42012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 &  randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y52012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 &  randomized_twice == 0 & treatment2012 != "kinderprep"
*replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y62012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 &  randomized_twice == 0 & treatment2012 != "kinderprep"



*else if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" {


replace v1std_`score'_pre_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_mid_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_post_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_sl_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_ao1_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_ao2_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y32012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y42012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y52012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"

replace v2std_`score'_pre_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_mid_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_post_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_sl_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y32012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y42012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y52012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
*replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y62012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"

}


*save origin_neighbor_score.dta, replace 

*Case 6) The neighbor was randomized twice in 2012 and 2013. Here we pay particular attention to cases where
*2013 randomization was in kinderprep. We exclude cases where a kid was randomised into kinderprep in 2012 and not in 2013
*and when a kid was randomised both in 2012 and 2013 in kinderprep as no such kids exist. So basically, there are no cases such that a kid was randomised twice in 2012 and 2013 such that
*the first randomization in 2012 was in kinder


foreach score in cog ncog {

*else if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" {


replace v1std_`score'_pre_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_mid_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_post_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_sl_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_ao1_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_ao2_origin_dest = std_`score'_mid2012 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_mid2013 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_sl2013 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"

replace v2std_`score'_pre_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_mid_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_post_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_sl_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_ao1_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_ao2_origin_dest = std_`score'_mid2012 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y32012 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"



*else if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" {


replace v1std_`score'_pre_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_mid_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_post_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_sl_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_ao1_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_ao2_origin_dest = std_`score'_mid2012 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_sl2012 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_post2013 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"

replace v2std_`score'_pre_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_mid_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_post_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_sl_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_ao1_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_ao2_origin_dest = std_`score'_mid2012 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y32012 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"



*else if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" {


replace v1std_`score'_pre_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_mid_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_post_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_sl_origin_dest = std_`score'_pre2012 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_ao1_origin_dest = std_`score'_mid2012 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_ao2_origin_dest = std_`score'_mid2013 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_sl2013 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y32012 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"

replace v2std_`score'_pre_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_mid_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_post_origin_dest = std_`score'_pre2012 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_sl_origin_dest = std_`score'_pre2012 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_ao1_origin_dest = std_`score'_mid2012 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y32012 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y42012 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"



*else if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" {


replace v1std_`score'_pre_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_mid_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_post_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_sl_origin_dest = std_`score'_pre2012 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_ao1_origin_dest = std_`score'_mid2012 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_ao2_origin_dest = std_`score'_sl2012 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_post2013 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y32012 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"

replace v2std_`score'_pre_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_mid_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_post_origin_dest = std_`score'_pre2012 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_sl_origin_dest = std_`score'_pre2012 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_ao1_origin_dest = std_`score'_mid2012 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y32012 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y42012 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"



*else if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" {


replace v1std_`score'_pre_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_mid_origin_dest = std_`score'_pre2012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_post_origin_dest = std_`score'_mid2012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_sl_origin_dest = std_`score'_post2012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_ao1_origin_dest = std_`score'_mid2013 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_ao2_origin_dest = std_`score'_sl2013 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y32012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y42012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"

replace v2std_`score'_pre_origin_dest = std_`score'_pre2012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_mid_origin_dest = std_`score'_mid2012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_post_origin_dest = std_`score'_post2012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_sl_origin_dest = std_`score'_sl2012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y32012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y42012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y52012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"



*else if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" {


replace v1std_`score'_pre_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_mid_origin_dest = std_`score'_pre2012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_post_origin_dest = std_`score'_mid2012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_sl_origin_dest = std_`score'_post2012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_ao1_origin_dest = std_`score'_sl2012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_ao2_origin_dest = std_`score'_post2013 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y32012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y42012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"

replace v2std_`score'_pre_origin_dest = std_`score'_pre2012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_mid_origin_dest = std_`score'_mid2012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_post_origin_dest = std_`score'_post2012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_sl_origin_dest = std_`score'_sl2012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y32012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y42012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y52012 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"



*else if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" {


replace v1std_`score'_pre_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_mid_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_post_origin_dest = std_`score'_post2012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_sl_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_ao1_origin_dest = std_`score'_mid2013 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_ao2_origin_dest = std_`score'_sl2013 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y32012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y42012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"

replace v2std_`score'_pre_origin_dest = std_`score'_post2012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_mid_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_post_origin_dest = std_`score'_sl2012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_sl_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y32012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y42012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y52012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"



*else if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" {


replace v1std_`score'_pre_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_mid_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_post_origin_dest = std_`score'_post2012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_sl_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_ao1_origin_dest = std_`score'_sl2012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_ao2_origin_dest = std_`score'_post2013 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y32012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y42012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"

replace v2std_`score'_pre_origin_dest = std_`score'_post2012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_mid_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_post_origin_dest = std_`score'_sl2012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_sl_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y32012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y42012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y52012 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"



*else if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" {


replace v1std_`score'_pre_origin_dest = std_`score'_mid2012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_mid_origin_dest = std_`score'_sl2012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_post_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_sl_origin_dest = std_`score'_post2013 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_ao1_origin_dest = std_`score'_sl2013 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_ao2_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y32012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y42012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y52012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"

replace v2std_`score'_pre_origin_dest = std_`score'_post2012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_mid_origin_dest = std_`score'_mid2013 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_post_origin_dest = std_`score'_post2013 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_sl_origin_dest = std_`score'_sl2013 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y32012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y42012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y52012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
*replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y62012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"



*else if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" {


replace v1std_`score'_pre_origin_dest = std_`score'_mid2012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_mid_origin_dest = std_`score'_sl2012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_post_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_sl_origin_dest = std_`score'_pre2013 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_ao1_origin_dest = std_`score'_post2013 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_ao2_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y32012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y42012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y52012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"

replace v2std_`score'_pre_origin_dest = std_`score'_post2012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_mid_origin_dest = std_`score'_sl2012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_post_origin_dest = std_`score'_pre2013 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_sl_origin_dest = std_`score'_post2013 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y32012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y42012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y52012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
*replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y62012 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"



*else if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" {


replace v1std_`score'_pre_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_mid_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_post_origin_dest = std_`score'_post2013 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_sl_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_ao1_origin_dest = std_`score'_sl2013 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_ao2_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y32012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y42012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y52012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"

replace v2std_`score'_pre_origin_dest = std_`score'_post2013 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_mid_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_post_origin_dest = std_`score'_sl2013 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_sl_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y32012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y42012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y52012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
*replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y62012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"



*else if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" {


replace v1std_`score'_pre_origin_dest = std_`score'_ao_y12012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_mid_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_post_origin_dest = std_`score'_pre2013 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_sl_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_ao1_origin_dest = std_`score'_post2013 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_ao2_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y32012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y42012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y52012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"

replace v2std_`score'_pre_origin_dest = std_`score'_pre2013 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_mid_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_post_origin_dest = std_`score'_post2013 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_sl_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y22012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y32012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y42012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y52012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
*replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y62012 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"

}
*save origin_neighbor_score.dta, replace 
*Case 7) The neighbor was randomized once in 2013. Here we pay particular attention to cases where
*2013 randomization was in kinderprep


foreach score in cog ncog {

*else if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" {


replace v1std_`score'_pre_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_mid_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_post_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_sl_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_ao1_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_ao2_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_mid2013 if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_sl2013 if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y12013 if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"

replace v2std_`score'_pre_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_mid_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_post_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_sl_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_ao1_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_ao2_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_mid2013 if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y12013 if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y22013 if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"



*else if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep" {


replace v1std_`score'_pre_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_mid_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_post_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_sl_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_ao1_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_ao2_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_ao3_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_post2013 if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y12013 if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"

replace v2std_`score'_pre_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_mid_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_post_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_sl_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_ao1_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_ao2_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_ao3_origin_dest = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y12013 if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y22013 if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"



*else if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" {


replace v1std_`score'_pre_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_mid_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_post_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_sl_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_ao1_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_ao2_origin_dest = std_`score'_mid2013 if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_sl2013 if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y12013 if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y22013 if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"

replace v2std_`score'_pre_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_mid_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_post_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_sl_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_ao1_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_ao2_origin_dest = std_`score'_mid2013 if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y12013 if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y22013 if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y32013 if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"



*else if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep" {


replace v1std_`score'_pre_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_mid_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_post_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_sl_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_ao1_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_ao2_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_post2013 if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y12013 if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y22013 if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"

replace v2std_`score'_pre_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_mid_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_post_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_sl_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_ao1_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_ao2_origin_dest = . if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y12013 if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y22013 if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y32013 if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"



*else if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" {


replace v1std_`score'_pre_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_mid_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_post_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_sl_origin_dest = std_`score'_pre2013 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_ao1_origin_dest = std_`score'_mid2013 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_ao2_origin_dest = std_`score'_sl2013 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y12013 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y22013 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y32013 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"

replace v2std_`score'_pre_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_mid_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_post_origin_dest = std_`score'_pre2013 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_sl_origin_dest = std_`score'_pre2013 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_ao1_origin_dest = std_`score'_mid2013 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y12013 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y22013 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y32013 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y42013 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"



*else if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep" {


replace v1std_`score'_pre_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_mid_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_post_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_sl_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_ao1_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_ao2_origin_dest = std_`score'_post2013 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y12013 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y22013 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y32013 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"

replace v2std_`score'_pre_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_mid_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_post_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_sl_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_ao1_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y12013 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y22013 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y32013 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y42013 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"



*else if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" {


replace v1std_`score'_pre_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_mid_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_post_origin_dest = std_`score'_pre2013 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_sl_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_ao1_origin_dest = std_`score'_mid2013 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_ao2_origin_dest = std_`score'_sl2013 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y12013 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y22013 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y32013 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"

replace v2std_`score'_pre_origin_dest = std_`score'_pre2013 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_mid_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_post_origin_dest = std_`score'_pre2013 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_sl_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_ao1_origin_dest = std_`score'_mid2013 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y12013 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y22013 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y32013 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y42013 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"



*else if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep" {


replace v1std_`score'_pre_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_mid_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_post_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_sl_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_ao1_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_ao2_origin_dest = std_`score'_post2013 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y12013 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y22013 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y32013 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"

replace v2std_`score'_pre_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_mid_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_post_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_sl_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_ao1_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y12013 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y22013 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y32013 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y42013 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"



*else if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" {


replace v1std_`score'_pre_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_mid_origin_dest = std_`score'_pre2013 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_post_origin_dest = std_`score'_mid2013 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_sl_origin_dest = std_`score'_post2013 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_ao1_origin_dest = std_`score'_sl2013 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_ao2_origin_dest = std_`score'_ao_y12013 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y22013 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y32013 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y42013 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"

replace v2std_`score'_pre_origin_dest = std_`score'_pre2013 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_mid_origin_dest = std_`score'_mid2013 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_post_origin_dest = std_`score'_post2013 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_sl_origin_dest = std_`score'_sl2013 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y12013 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y22013 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y32013 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y42013 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y52013 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"



*else if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep" {


replace v1std_`score'_pre_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_mid_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_post_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_sl_origin_dest = std_`score'_pre2013 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_ao1_origin_dest = std_`score'_post2013 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_ao2_origin_dest = std_`score'_ao_y12013 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y22013 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y32013 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y42013 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"

replace v2std_`score'_pre_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_mid_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_post_origin_dest = std_`score'_pre2013 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_sl_origin_dest = std_`score'_post2013 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y12013 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y22013 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y32013 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y42013 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y52013 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"



*else if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" {


replace v1std_`score'_pre_origin_dest = std_`score'_mid2013 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_mid_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_post_origin_dest = std_`score'_post2013 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_sl_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_ao1_origin_dest = std_`score'_sl2013 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_ao2_origin_dest = std_`score'_ao_y12013 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y22013 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y32013 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y42013 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"

replace v2std_`score'_pre_origin_dest = std_`score'_post2013 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_mid_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_post_origin_dest = std_`score'_sl2013 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_sl_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y12013 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y22013 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y32013 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y42013 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y52013 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"


*else if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep" {


replace v1std_`score'_pre_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_mid_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_post_origin_dest = std_`score'_pre2013 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_sl_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_ao1_origin_dest = std_`score'_post2013 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_ao2_origin_dest = std_`score'_ao_y12013 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y22013 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y32013 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y42013 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"

replace v2std_`score'_pre_origin_dest = std_`score'_pre2013 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_mid_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_post_origin_dest = std_`score'_post2013 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_sl_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y12013 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y22013 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y32013 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y42013 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y52013 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"


}
*save origin_neighbor_score.dta, replace 
*Case 8) Kid 1109 as neighbor, who was the only kid treated three times (2010, 2011, 2012; all different from kinderprep)

foreach score in cog ncog {

*if randomization_ori == 2010 & destination_gecc_id == 1109 {


replace v1std_`score'_pre_origin_dest = . if randomization_ori == 2010 & destination_gecc_id == 1109
replace v1std_`score'_mid_origin_dest = std_`score'_pre2010 if randomization_ori == 2010 & destination_gecc_id == 1109
replace v1std_`score'_post_origin_dest = std_`score'_mid2010 if randomization_ori == 2010 & destination_gecc_id == 1109
replace v1std_`score'_sl_origin_dest = std_`score'_post2010 if randomization_ori == 2010 & destination_gecc_id == 1109
replace v1std_`score'_ao1_origin_dest = std_`score'_mid2011 if randomization_ori == 2010 & destination_gecc_id == 1109
replace v1std_`score'_ao2_origin_dest = std_`score'_mid2012 if randomization_ori == 2010 & destination_gecc_id == 1109
replace v1std_`score'_ao3_origin_dest = std_`score'_sl2012 if randomization_ori == 2010 & destination_gecc_id == 1109
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2010 & destination_gecc_id == 1109
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y42010 if randomization_ori == 2010 & destination_gecc_id == 1109

replace v2std_`score'_pre_origin_dest = std_`score'_pre2010 if randomization_ori == 2010 & destination_gecc_id == 1109
replace v2std_`score'_mid_origin_dest = std_`score'_mid2010 if randomization_ori == 2010 & destination_gecc_id == 1109
replace v2std_`score'_post_origin_dest = std_`score'_post2010 if randomization_ori == 2010 & destination_gecc_id == 1109
replace v2std_`score'_sl_origin_dest = std_`score'_sl2010 if randomization_ori == 2010 & destination_gecc_id == 1109
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y12010 if randomization_ori == 2010 & destination_gecc_id == 1109
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y22010 if randomization_ori == 2010 & destination_gecc_id == 1109
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2010 & destination_gecc_id == 1109
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y42010 if randomization_ori == 2010 & destination_gecc_id == 1109
replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y52010 if randomization_ori == 2010 & destination_gecc_id == 1109

*else if randomization_ori == 2011 & destination_gecc_id == 1109 {


replace v1std_`score'_pre_origin_dest = std_`score'_mid2010 if randomization_ori == 2011 & destination_gecc_id == 1109
replace v1std_`score'_mid_origin_dest = std_`score'_sl2010 if randomization_ori == 2011 & destination_gecc_id == 1109
replace v1std_`score'_post_origin_dest = std_`score'_ao_y12010 if randomization_ori == 2011 & destination_gecc_id == 1109
replace v1std_`score'_sl_origin_dest = std_`score'_post2011 if randomization_ori == 2011 & destination_gecc_id == 1109
replace v1std_`score'_ao1_origin_dest = std_`score'_mid2012  if randomization_ori == 2011 & destination_gecc_id == 1109
replace v1std_`score'_ao2_origin_dest = std_`score'_sl2012 if randomization_ori == 2011 & destination_gecc_id == 1109
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2011 & destination_gecc_id == 1109
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y42010 if randomization_ori == 2011 & destination_gecc_id == 1109
replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y52010 if randomization_ori == 2011 & destination_gecc_id == 1109

replace v2std_`score'_pre_origin_dest = std_`score'_post2010 if randomization_ori == 2011 & destination_gecc_id == 1109
replace v2std_`score'_mid_origin_dest = std_`score'_mid2011 if randomization_ori == 2011 & destination_gecc_id == 1109
replace v2std_`score'_post_origin_dest = std_`score'_post2011 if randomization_ori == 2011 & destination_gecc_id == 1109
replace v2std_`score'_sl_origin_dest = std_`score'_sl2011 if randomization_ori == 2011 & destination_gecc_id == 1109
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y22010 if randomization_ori == 2011 & destination_gecc_id == 1109
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2011 & destination_gecc_id == 1109
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y42010 if randomization_ori == 2011 & destination_gecc_id == 1109
replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y52010 if randomization_ori == 2011 & destination_gecc_id == 1109
*replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y62010 if randomization_ori == 2011 & destination_gecc_id == 1109

*else if randomization_ori == 2012 & kinderprep_ori == 0 & destination_gecc_id == 1109 {


replace v1std_`score'_pre_origin_dest = std_`score'_ao_y12010 if randomization_ori == 2012 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v1std_`score'_mid_origin_dest = std_`score'_sl2011 if randomization_ori == 2012 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v1std_`score'_post_origin_dest = std_`score'_ao_y22010 if randomization_ori == 2012 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v1std_`score'_sl_origin_dest = std_`score'_post2012 if randomization_ori == 2012 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v1std_`score'_ao1_origin_dest = std_`score'_sl2012 if randomization_ori == 2012 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v1std_`score'_ao2_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2012 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y42010 if randomization_ori == 2012 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y52010 if randomization_ori == 2012 & kinderprep_ori == 0 & destination_gecc_id == 1109
*replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y62010 if randomization_ori == 2012 & kinderprep_ori == 0 & destination_gecc_id == 1109

replace v2std_`score'_pre_origin_dest = std_`score'_post2011 if randomization_ori == 2012 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v2std_`score'_mid_origin_dest = std_`score'_mid2012 if randomization_ori == 2012 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v2std_`score'_post_origin_dest = std_`score'_post2012 if randomization_ori == 2012 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v2std_`score'_sl_origin_dest = std_`score'_sl2012 if randomization_ori == 2012 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2012 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y42010 if randomization_ori == 2012 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y52010 if randomization_ori == 2012 & kinderprep_ori == 0 & destination_gecc_id == 1109
*replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y62010 if randomization_ori == 2012 & kinderprep_ori == 0 & destination_gecc_id == 1109
*replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y72010 if randomization_ori == 2012 & kinderprep_ori == 0 & destination_gecc_id == 1109



*else if randomization_ori == 2012 & kinderprep_ori == 1 & destination_gecc_id == 1109 {


replace v1std_`score'_pre_origin_dest = std_`score'_ao_y22010 if randomization_ori == 2012 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v1std_`score'_mid_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v1std_`score'_post_origin_dest = std_`score'_post2012 if randomization_ori == 2012 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v1std_`score'_sl_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v1std_`score'_ao1_origin_dest = std_`score'_sl2012 if randomization_ori == 2012 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v1std_`score'_ao2_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2012 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y42010 if randomization_ori == 2012 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y52010 if randomization_ori == 2012 & kinderprep_ori == 1 & destination_gecc_id == 1109
*replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y62010 if randomization_ori == 2012 & kinderprep_ori == 1 & destination_gecc_id == 1109

replace v2std_`score'_pre_origin_dest =  std_`score'_post2012 if randomization_ori == 2012 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v2std_`score'_mid_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v2std_`score'_post_origin_dest = std_`score'_sl2012 if randomization_ori == 2012 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v2std_`score'_sl_origin_dest = . if randomization_ori == 2012 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2012 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y42010 if randomization_ori == 2012 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y52010  if randomization_ori == 2012 & kinderprep_ori == 1 & destination_gecc_id == 1109
*replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y62010 if randomization_ori == 2012 & kinderprep_ori == 1 & destination_gecc_id == 1109
*replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y72010 if randomization_ori == 2012 & kinderprep_ori == 1 & destination_gecc_id == 1109


*else if randomization_ori == 2013 & kinderprep_ori == 0 & destination_gecc_id == 1109 {


replace v1std_`score'_pre_origin_dest = std_`score'_ao_y22010 if randomization_ori == 2013 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v1std_`score'_mid_origin_dest = std_`score'_sl2012 if randomization_ori == 2013 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v1std_`score'_post_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2013 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v1std_`score'_sl_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2013 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v1std_`score'_ao1_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2013 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v1std_`score'_ao2_origin_dest = std_`score'_ao_y42010 if randomization_ori == 2013 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y52010 if randomization_ori == 2013 & kinderprep_ori == 0 & destination_gecc_id == 1109
*replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y62010 if randomization_ori == 2013 & kinderprep_ori == 0 & destination_gecc_id == 1109
*replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y72010 if randomization_ori == 2013 & kinderprep_ori == 0 & destination_gecc_id == 1109

replace v2std_`score'_pre_origin_dest = std_`score'_post2012 if randomization_ori == 2013 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v2std_`score'_mid_origin_dest = std_`score'_sl2012 if randomization_ori == 2013 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v2std_`score'_post_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2013 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v2std_`score'_sl_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2013 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y42010 if randomization_ori == 2013 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y52010 if randomization_ori == 2013 & kinderprep_ori == 0 & destination_gecc_id == 1109
*replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y62010 if randomization_ori == 2013 & kinderprep_ori == 0 & destination_gecc_id == 1109
*replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y72010 if randomization_ori == 2013 & kinderprep_ori == 0 & destination_gecc_id == 1109
*replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y82010 if randomization_ori == 2013 & kinderprep_ori == 0 & destination_gecc_id == 1109



*else if randomization_ori == 2013 & kinderprep_ori == 1 & destination_gecc_id == 1109


replace v1std_`score'_pre_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2013 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v1std_`score'_mid_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v1std_`score'_post_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2013 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v1std_`score'_sl_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v1std_`score'_ao1_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2013 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v1std_`score'_ao2_origin_dest = std_`score'_ao_y42010 if randomization_ori == 2013 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v1std_`score'_ao3_origin_dest = std_`score'_ao_y52010 if randomization_ori == 2013 & kinderprep_ori == 1 & destination_gecc_id == 1109
*replace v1std_`score'_ao4_origin_dest = std_`score'_ao_y62010 if randomization_ori == 2013 & kinderprep_ori == 1 & destination_gecc_id == 1109
*replace v1std_`score'_ao5_origin_dest = std_`score'_ao_y72010 if randomization_ori == 2013 & kinderprep_ori == 1 & destination_gecc_id == 1109

replace v2std_`score'_pre_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2013 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v2std_`score'_mid_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v2std_`score'_post_origin_dest = std_`score'_ao_y32010 if randomization_ori == 2013 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v2std_`score'_sl_origin_dest = . if randomization_ori == 2013 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v2std_`score'_ao1_origin_dest = std_`score'_ao_y42010 if randomization_ori == 2013 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v2std_`score'_ao2_origin_dest = std_`score'_ao_y52010 if randomization_ori == 2013 & kinderprep_ori == 1 & destination_gecc_id == 1109
*replace v2std_`score'_ao3_origin_dest = std_`score'_ao_y62010 if randomization_ori == 2013 & kinderprep_ori == 1 & destination_gecc_id == 1109
*replace v2std_`score'_ao4_origin_dest = std_`score'_ao_y72010 if randomization_ori == 2013 & kinderprep_ori == 1 & destination_gecc_id == 1109
*replace v2std_`score'_ao5_origin_dest = std_`score'_ao_y82010 if randomization_ori == 2013 & kinderprep_ori == 1 & destination_gecc_id == 1109


}


*save origin_neighbor_score.dta, replace 


**Renaming the variables so that the period is put at the end of the variable name
foreach score in cog ncog {

foreach period in pre mid post sl ao1 ao2 ao3 ao4 ao5 {
rename   v1std_`score'_`period'_origin_dest `period'_v1std_`score'
rename   v2std_`score'_`period'_origin_dest `period'_v2std_`score'
}

}

foreach score in cog ncog {


rename   ao1_v1std_`score' aoy1_v1std_`score'
rename   ao2_v1std_`score' aoy2_v1std_`score' 
rename   ao3_v1std_`score' aoy3_v1std_`score' 
rename   ao4_v1std_`score' aoy4_v1std_`score' 
rename   ao5_v1std_`score' aoy5_v1std_`score'

  

rename   ao1_v2std_`score' aoy1_v2std_`score'
rename   ao2_v2std_`score' aoy2_v2std_`score' 
rename   ao3_v2std_`score' aoy3_v2std_`score' 
rename   ao4_v2std_`score' aoy4_v2std_`score' 
rename   ao5_v2std_`score' aoy5_v2std_`score'

}

 
**For the neighbor test scores, attach the neighbor's treatment status to each assessment date
**This allows us to calculate average performance scores by type of neighbor treatment
foreach score in cog ncog {

foreach period in pre mid post sl aoy1 aoy2 aoy3 aoy4 aoy5 {

foreach treat in cash college control kinderprep pka pkb preschool cogx treated { 

gen `period'_v1std_`score'_`treat' = `period'_v1std_`score'*`period'_`treat'
gen `period'_v2std_`score'_`treat' = `period'_v2std_`score'*`period'_`treat'


}
}
}


**Tag missing score observations by treatment so that we take the correct averages later on
**Indeed, when we collapse the  scores by origin kid later on, STATA treats missing scores as 0.
**If we disregard the missing scores for some neighbors, we will count those neighbors in for the 
**average score which is incorrect. Say, origin kid X has three neighbors A, B, C at pre. The scores 
**for neighbor A  is missing, and the scores for neigh B, C are 10 and 20 respectively. If we disregard
**misssing scores, we would calculate average neighbor performance as (10+20)/3. However, if we correctly 
**account for it we would correctly calculate (10+20)/(3-1).   

foreach score in cog ncog {

foreach period in pre mid post sl aoy1 aoy2 aoy3 aoy4 aoy5 {

foreach treat in cash college control kinderprep pka pkb preschool cogx treated { 

gen mis`period'_v1std_`score'_`treat' = 0 
replace mis`period'_v1std_`score'_`treat' = 1 if `period'_v1std_`score'_`treat' == . & `period'_`treat' == 1

gen mis`period'_v2std_`score'_`treat' = 0 
replace mis`period'_v2std_`score'_`treat' = 1 if `period'_v2std_`score'_`treat' == . & `period'_`treat' == 1


}
}
}



*****************************************************************
*Defining Corresponding Length of Treatment/Control for Neighbors
*****************************************************************

/* This part of the code defines the length of a neighbor being in treated or in control at a particular 
assessment date. We also calculate the lenghth of being treated/being in control for neighbors who do not have a score at 
a particular date. The first term of the difference is the date at which the particular assessment occurs. The second term of the difference
is the date at which the kids starts the programme (be it control or treatment or kinderprep). For control and treatment we choose August, 15 of each year of randomisation. 
For kinderprep, we choose June, 15 of the year subsequent to year of randomisation.
*/

/* Notice that we define the lenght variable only for cog as the length is independent on whether we 
focus on cog or noncog scores as they happen at  the same time.
*/

*We again distinguish between several cases.

foreach period in pre mid post sl aoy1 aoy2 aoy3 aoy4 aoy5 {

gen mt_`period' = 0
gen mc_`period' = 0

}

*******LENGTH OF BEING IN TREATMENT

foreach year in 2010 2011 2012 2013  {

local year1 = `year' + 1
local year2 = `year' + 2
local year3 = `year' + 3
local year4 = `year' + 4
local year5 = `year' + 5
local year6 = `year' + 6





*if randomization_dest == 2010 & randomized_twice == 0 & treatment2010 != "control" {


replace mt_pre = mofd(date("08/15/2010", "MDY")  - date("08/15/2010", "MDY"))      if randomization_ori == 2010 &  randomization_dest == 2010 & randomized_twice == 0 & treatment2010 != "control"
replace mt_pre = mofd(date("05/15/`year'", "MDY")  - date("08/15/2010", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori != 1 &  randomization_dest == 2010 & randomized_twice == 0 & treatment2010 != "control"
replace mt_pre = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2010", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori == 1 &  randomization_dest == 2010 & randomized_twice == 0 & treatment2010 != "control"
replace mt_mid = mofd(date("01/15/`year1'", "MDY")  - date("08/15/2010", "MDY"))   if randomization_ori == `year' & kinderprep_ori != 1 &  randomization_dest == 2010 & randomized_twice == 0 & treatment2010 != "control"
replace mt_post = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1 &  randomization_dest == 2010 & randomized_twice == 0 & treatment2010 != "control"
replace mt_post = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year' & kinderprep_ori == 1 &  randomization_dest == 2010 & randomized_twice == 0 & treatment2010 != "control"
replace mt_sl = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1 &  randomization_dest == 2010 & randomized_twice == 0 & treatment2010 != "control"
replace mt_sl = mt_post if randomization_ori == `year' & kinderprep_ori == 1 &  randomization_dest == 2010 & randomized_twice == 0 & treatment2010 != "control"
replace mt_mid = mt_post   if randomization_ori == `year' & kinderprep_ori == 1 &  randomization_dest == 2010 & randomized_twice == 0 & treatment2010 != "control"
replace mt_aoy1 = mofd(date("04/15/`year2'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year'  &  randomization_dest == 2010 & randomized_twice == 0 & treatment2010 != "control"
replace mt_aoy2 = mofd(date("04/15/`year3'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year' &  randomization_dest == 2010 & randomized_twice == 0 & treatment2010 != "control"
replace mt_aoy3 = mofd(date("04/15/`year4'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year' &  randomization_dest == 2010 & randomized_twice == 0 & treatment2010 != "control"
replace mt_aoy4 = mofd(date("04/15/`year5'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year' &  randomization_dest == 2010 & randomized_twice == 0 & treatment2010 != "control"
replace mt_aoy5 = mofd(date("04/15/`year6'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year' &  randomization_dest == 2010 & randomized_twice == 0 & treatment2010 != "control"



*else & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control" {





replace mt_pre =  mofd(date("08/15/2010", "MDY")  - date("08/15/2011", "MDY"))   if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mt_pre = mofd(date("05/15/`year'", "MDY")  - date("08/15/2011", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori != 1 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mt_pre = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2011", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mt_mid = mofd(date("01/15/`year1'", "MDY")  - date("08/15/2011", "MDY"))   if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mt_post = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mt_post = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mt_sl = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mt_sl = mt_post if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mt_mid = mt_post   if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mt_aoy1 = mofd(date("04/15/`year2'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year' &  randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mt_aoy2 = mofd(date("04/15/`year3'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year' &  randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mt_aoy3 = mofd(date("04/15/`year4'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year' & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mt_aoy4 = mofd(date("04/15/`year5'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year' &  randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mt_aoy5 = mofd(date("04/15/`year6'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year' &  randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"



*else & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 != "control" & treatment2011 != "control" {

 
 



replace mt_pre = mofd(date("08/15/2010", "MDY")  - date("08/15/2010", "MDY"))      if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 != "control" & treatment2011 != "control"
replace mt_pre = mofd(date("05/15/`year'", "MDY")  - date("08/15/2010", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori != 1 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 != "control" & treatment2011 != "control"
replace mt_pre = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2010", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 != "control" & treatment2011 != "control"
replace mt_mid = mofd(date("01/15/`year1'", "MDY")  - date("08/15/2010", "MDY"))   if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 != "control" & treatment2011 != "control"
replace mt_post = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 != "control" & treatment2011 != "control"
replace mt_post = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 != "control" & treatment2011 != "control"
replace mt_sl = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 != "control" & treatment2011 != "control"
replace mt_sl = mt_post if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 != "control" & treatment2011 != "control"
replace mt_mid = mt_post   if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 != "control" & treatment2011 != "control"
replace mt_aoy1 = mofd(date("04/15/`year2'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year' &  randomization_dest == 2010 & randomized_twice == 1 & treatment2010 != "control" & treatment2011 != "control"
replace mt_aoy2 = mofd(date("04/15/`year3'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year' &  randomization_dest == 2010 & randomized_twice == 1 & treatment2010 != "control" & treatment2011 != "control"
replace mt_aoy3 = mofd(date("04/15/`year4'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year' &  randomization_dest == 2010 & randomized_twice == 1 & treatment2010 != "control" & treatment2011 != "control"
replace mt_aoy4 = mofd(date("04/15/`year5'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year' &  randomization_dest == 2010 & randomized_twice == 1 & treatment2010 != "control" & treatment2011 != "control"
replace mt_aoy5 = mofd(date("04/15/`year6'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year' &  randomization_dest == 2010 & randomized_twice == 1 & treatment2010 != "control" & treatment2011 != "control"


*else & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 != "control" {





replace mt_pre = mofd(date("08/15/2010", "MDY")  - date("08/15/2011", "MDY"))      if randomization_ori == 2010  & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 != "control"
replace mt_pre = mofd(date("05/15/`year'", "MDY")  - date("08/15/2011", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori != 1 & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 != "control"
replace mt_pre = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2011", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 != "control"
replace mt_mid = mofd(date("01/15/`year1'", "MDY")  - date("08/15/2011", "MDY"))   if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 != "control"
replace mt_post = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 != "control"
replace mt_post = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 != "control"
replace mt_sl = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 != "control"
replace mt_sl = mt_post if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 != "control"
replace mt_mid = mt_post   if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 != "control"
replace mt_aoy1 = mofd(date("04/15/`year2'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year'  & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 != "control"
replace mt_aoy2 = mofd(date("04/15/`year3'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year' & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 != "control"
replace mt_aoy3 = mofd(date("04/15/`year4'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year' & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 != "control"
replace mt_aoy4 = mofd(date("04/15/`year5'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year' & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 != "control"
replace mt_aoy5 = mofd(date("04/15/`year6'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year' & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 != "control"



*else & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep" {







replace mt_pre = mofd(date("08/15/2010", "MDY")  - date("08/15/2012", "MDY"))      if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep" 
replace mt_pre = mofd(date("05/15/`year'", "MDY")  - date("08/15/2012", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori != 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt_pre = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2012", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt_mid = mofd(date("01/15/`year1'", "MDY")  - date("08/15/2012", "MDY"))   if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt_post = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt_post = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt_sl = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt_sl = mt_post if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt_mid = mt_post   if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt_aoy1 = mofd(date("04/15/`year2'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year' &  randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt_aoy2 = mofd(date("04/15/`year3'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year' & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt_aoy3 = mofd(date("04/15/`year4'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year' & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt_aoy4 = mofd(date("04/15/`year5'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year' & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt_aoy5 = mofd(date("04/15/`year6'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year' & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"



*else & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "kinderprep" {





 
replace mt_pre = mofd(date("08/15/2010", "MDY")  - date("06/15/2013", "MDY"))      if randomization_ori == 2010  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "kinderprep" & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "kinderprep"
replace mt_pre = mofd(date("05/15/`year'", "MDY")  - date("06/15/2013", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori != 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "kinderprep"
replace mt_pre = mofd(date("05/15/`year1'", "MDY")  - date("06/15/2013", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "kinderprep"
replace mt_mid = mofd(date("01/15/`year1'", "MDY")  - date("06/15/2013", "MDY"))   if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "kinderprep"
replace mt_post = mofd(date("05/15/`year1'", "MDY")  - date("06/15/2013", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "kinderprep"
replace mt_post = mofd(date("08/15/`year1'", "MDY")  - date("06/15/2013", "MDY"))  if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "kinderprep"
replace mt_sl = mofd(date("08/15/`year1'", "MDY")  - date("06/15/2013", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "kinderprep"
replace mt_sl = mt_post if randomization_ori == `year' & kinderprep_ori == 1& randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "kinderprep" 
replace mt_mid = mt_post   if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "kinderprep"
replace mt_aoy1 = mofd(date("04/15/`year2'", "MDY")  - date("06/15/2013", "MDY"))  if randomization_ori == `year' & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "kinderprep"
replace mt_aoy2 = mofd(date("04/15/`year3'", "MDY")  - date("06/15/2013", "MDY"))  if randomization_ori == `year' & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "kinderprep"
replace mt_aoy3 = mofd(date("04/15/`year4'", "MDY")  - date("06/15/2013", "MDY"))  if randomization_ori == `year' & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "kinderprep"
replace mt_aoy4 = mofd(date("04/15/`year5'", "MDY")  - date("06/15/2013", "MDY"))  if randomization_ori == `year' & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "kinderprep"
replace mt_aoy5 = mofd(date("04/15/`year6'", "MDY")  - date("06/15/2013", "MDY"))  if randomization_ori == `year' & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "kinderprep"



*else & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 != "control" & treatment2012 != "control" & treatment2012 != "kinderprep" {



replace mt_pre = mofd(date("08/15/2010", "MDY")  - date("08/15/2011", "MDY"))      if randomization_ori == 2010  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 != "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt_pre = mofd(date("05/15/`year'", "MDY")  - date("08/15/2011", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori != 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 != "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt_pre = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2011", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 != "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt_mid = mofd(date("01/15/`year1'", "MDY")  - date("08/15/2011", "MDY"))   if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 != "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt_post = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 != "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt_post = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 != "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt_sl = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 != "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt_sl = mt_post if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 != "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt_mid = mt_post   if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 != "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt_aoy1 = mofd(date("04/15/`year2'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year' & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 != "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt_aoy2 = mofd(date("04/15/`year3'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year' & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 != "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt_aoy3 = mofd(date("04/15/`year4'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year' & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 != "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt_aoy4 = mofd(date("04/15/`year5'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year' & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 != "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt_aoy5 = mofd(date("04/15/`year6'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year' & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 != "control" & treatment2012 != "control" & treatment2012 != "kinderprep"



*else if  randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "control" & treatment2012 != "kinderprep" {





replace mt_pre = mofd(date("08/15/2010", "MDY")  - date("08/15/2012", "MDY"))      if randomization_ori == 2010 &   randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt_pre = mofd(date("05/15/`year'", "MDY")  - date("08/15/2012", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori != 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt_pre = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2012", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt_mid = mofd(date("01/15/`year1'", "MDY")  - date("08/15/2012", "MDY"))   if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt_post = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt_post = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt_sl = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt_sl = mt_post if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt_mid = mt_post   if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt_aoy1 = mofd(date("04/15/`year2'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year' & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt_aoy2 = mofd(date("04/15/`year3'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year' &  randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt_aoy3 = mofd(date("04/15/`year4'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year' & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt_aoy4 = mofd(date("04/15/`year5'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year' & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt_aoy5 = mofd(date("04/15/`year6'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year' &  randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "control" & treatment2012 != "kinderprep"



*else & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" {






replace mt_pre = mofd(date("08/15/2010", "MDY")  - date("06/15/2013", "MDY"))      if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace mt_pre = mofd(date("05/15/`year'", "MDY")  - date("06/15/2013", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori != 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace mt_pre = mofd(date("05/15/`year1'", "MDY")  - date("06/15/2013", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace mt_mid = mofd(date("01/15/`year1'", "MDY")  - date("06/15/2013", "MDY"))   if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace mt_post = mofd(date("05/15/`year1'", "MDY")  - date("06/15/2013", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace mt_post = mofd(date("08/15/`year1'", "MDY")  - date("06/15/2013", "MDY"))  if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace mt_sl = mofd(date("08/15/`year1'", "MDY")  - date("06/15/2013", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace mt_sl = mt_post if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace mt_mid = mt_post   if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace mt_aoy1 = mofd(date("04/15/`year2'", "MDY")  - date("06/15/2013", "MDY"))  if randomization_ori == `year' & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace mt_aoy2 = mofd(date("04/15/`year3'", "MDY")  - date("06/15/2013", "MDY"))  if randomization_ori == `year' & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace mt_aoy3 = mofd(date("04/15/`year4'", "MDY")  - date("06/15/2013", "MDY"))  if randomization_ori == `year' & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace mt_aoy4 = mofd(date("04/15/`year5'", "MDY")  - date("06/15/2013", "MDY"))  if randomization_ori == `year' & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace mt_aoy5 = mofd(date("04/15/`year6'", "MDY")  - date("06/15/2013", "MDY"))  if randomization_ori == `year' & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"



*else & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep" {



replace mt_pre = mofd(date("08/15/2010", "MDY")  - date("08/15/2013", "MDY"))      if randomization_ori == 2010  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt_pre = mofd(date("05/15/`year'", "MDY")  - date("08/15/2013", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori != 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt_pre = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2013", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt_mid = mofd(date("01/15/`year1'", "MDY")  - date("08/15/2013", "MDY"))   if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt_post = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2013", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt_post = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2013", "MDY"))  if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt_sl = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2013", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt_sl = mt_post if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt_mid = mt_post   if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt_aoy1 = mofd(date("04/15/`year2'", "MDY")  - date("08/15/2013", "MDY"))  if randomization_ori == `year' & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt_aoy2 = mofd(date("04/15/`year3'", "MDY")  - date("08/15/2013", "MDY"))  if randomization_ori == `year' & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt_aoy3 = mofd(date("04/15/`year4'", "MDY")  - date("08/15/2013", "MDY"))  if randomization_ori == `year' & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt_aoy4 = mofd(date("04/15/`year5'", "MDY")  - date("08/15/2013", "MDY"))  if randomization_ori == `year' & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt_aoy5 = mofd(date("04/15/`year6'", "MDY")  - date("08/15/2013", "MDY"))  if randomization_ori == `year' & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"


*else & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "kinderprep" {





replace mt_pre = mofd(date("08/15/2010", "MDY")  - date("06/15/2014", "MDY"))      if randomization_ori == 2010  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "kinderprep"
replace mt_pre = mofd(date("05/15/`year'", "MDY")  - date("06/15/2014", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori != 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "kinderprep"
replace mt_pre = mofd(date("05/15/`year1'", "MDY")  - date("06/15/2014", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "kinderprep"
replace mt_mid = mofd(date("01/15/`year1'", "MDY")  - date("06/15/2014", "MDY"))   if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "kinderprep"
replace mt_post = mofd(date("05/15/`year1'", "MDY")  - date("06/15/2014", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "kinderprep"
replace mt_post = mofd(date("08/15/`year1'", "MDY")  - date("06/15/2014", "MDY"))  if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "kinderprep"
replace mt_sl = mofd(date("08/15/`year1'", "MDY")  - date("06/15/2014", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "kinderprep"
replace mt_sl = mt_post if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "kinderprep" 
replace mt_mid = mt_post   if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "kinderprep"
replace mt_aoy1 = mofd(date("04/15/`year2'", "MDY")  - date("06/15/2014", "MDY"))  if randomization_ori == `year' & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "kinderprep"
replace mt_aoy2 = mofd(date("04/15/`year3'", "MDY")  - date("06/15/2014", "MDY"))  if randomization_ori == `year' & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "kinderprep"
replace mt_aoy3 = mofd(date("04/15/`year4'", "MDY")  - date("06/15/2014", "MDY"))  if randomization_ori == `year' & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "kinderprep"
replace mt_aoy4 = mofd(date("04/15/`year5'", "MDY")  - date("06/15/2014", "MDY"))  if randomization_ori == `year' & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "kinderprep"
replace mt_aoy5 = mofd(date("04/15/`year6'", "MDY")  - date("06/15/2014", "MDY"))  if randomization_ori == `year' & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "kinderprep"


*else & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 != "control" & treatment2013 != "control" & treatment2013 != "kinderprep" {

**the only case corresponding to TT since TK, KT and KK do not exist




replace mt_pre = mofd(date("08/15/2010", "MDY")  - date("08/15/2012", "MDY"))      if randomization_ori == 2010  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 != "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt_pre = mofd(date("05/15/`year'", "MDY")  - date("08/15/2012", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori != 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 != "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt_pre = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2012", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 != "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt_mid = mofd(date("01/15/`year1'", "MDY")  - date("08/15/2012", "MDY"))   if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 != "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt_post = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 != "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt_post = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 != "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt_sl = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 != "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt_sl = mt_post if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 != "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt_mid = mt_post   if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 != "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt_aoy1 = mofd(date("04/15/`year2'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year' & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 != "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt_aoy2 = mofd(date("04/15/`year3'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year'  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 != "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt_aoy3 = mofd(date("04/15/`year4'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year' & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 != "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt_aoy4 = mofd(date("04/15/`year5'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year' & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 != "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt_aoy5 = mofd(date("04/15/`year6'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year' & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 != "control" & treatment2013 != "control" & treatment2013 != "kinderprep"



*else & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "control" & treatment2013 != "kinderprep" {





replace mt_pre = mofd(date("08/15/2010", "MDY")  - date("08/15/2013", "MDY"))      if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt_pre = mofd(date("05/15/`year'", "MDY")  - date("08/15/2013", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori != 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt_pre = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2013", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt_mid = mofd(date("01/15/`year1'", "MDY")  - date("08/15/2013", "MDY"))   if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt_post = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2013", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt_post = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2013", "MDY"))  if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt_sl = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2013", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt_sl = mt_post if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt_mid = mt_post   if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt_aoy1 = mofd(date("04/15/`year2'", "MDY")  - date("08/15/2013", "MDY"))  if randomization_ori == `year' & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt_aoy2 = mofd(date("04/15/`year3'", "MDY")  - date("08/15/2013", "MDY"))  if randomization_ori == `year' & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt_aoy3 = mofd(date("04/15/`year4'", "MDY")  - date("08/15/2013", "MDY"))  if randomization_ori == `year' & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt_aoy4 = mofd(date("04/15/`year5'", "MDY")  - date("08/15/2013", "MDY"))  if randomization_ori == `year' & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt_aoy5 = mofd(date("04/15/`year6'", "MDY")  - date("08/15/2013", "MDY"))  if randomization_ori == `year' &  randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "control" & treatment2013 != "kinderprep"


*else & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep" {




replace mt_pre = mofd(date("08/15/2010", "MDY")  - date("06/15/2014", "MDY"))      if randomization_ori == 2010  & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace mt_pre = mofd(date("05/15/`year'", "MDY")  - date("06/15/2014", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori != 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace mt_pre = mofd(date("05/15/`year1'", "MDY")  - date("06/15/2014", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace mt_mid = mofd(date("01/15/`year1'", "MDY")  - date("06/15/2014", "MDY"))   if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace mt_post = mofd(date("05/15/`year1'", "MDY")  - date("06/15/2014", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace mt_post = mofd(date("08/15/`year1'", "MDY")  - date("06/15/2014", "MDY"))  if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace mt_sl = mofd(date("08/15/`year1'", "MDY")  - date("06/15/2014", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace mt_sl = mt_post if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace mt_mid = mt_post   if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace mt_aoy1 = mofd(date("04/15/`year2'", "MDY")  - date("06/15/2014", "MDY"))  if randomization_ori == `year' & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace mt_aoy2 = mofd(date("04/15/`year3'", "MDY")  - date("06/15/2014", "MDY"))  if randomization_ori == `year' & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace mt_aoy3 = mofd(date("04/15/`year4'", "MDY")  - date("06/15/2014", "MDY"))  if randomization_ori == `year' & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace mt_aoy4 = mofd(date("04/15/`year5'", "MDY")  - date("06/15/2014", "MDY"))  if randomization_ori == `year' & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace mt_aoy5 = mofd(date("04/15/`year6'", "MDY")  - date("06/15/2014", "MDY"))  if randomization_ori == `year' & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"

*else if destination_gecc_id == 1109 {





replace mt_pre = mofd(date("08/15/2010", "MDY")  - date("08/15/2010", "MDY"))      if randomization_ori == 2010 & destination_gecc_id == 1109
replace mt_pre = mofd(date("05/15/`year'", "MDY")  - date("08/15/2010", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori != 1 & destination_gecc_id == 1109
replace mt_pre = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2010", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace mt_mid = mofd(date("01/15/`year1'", "MDY")  - date("08/15/2010", "MDY"))   if randomization_ori == `year' & kinderprep_ori != 1 & destination_gecc_id == 1109
replace mt_post = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1 & destination_gecc_id == 1109
replace mt_post = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year' & kinderprep_ori == 1 & destination_gecc_id == 1109
replace mt_sl = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1 &  destination_gecc_id == 1109
replace mt_sl = mt_post if randomization_ori == `year' & kinderprep_ori == 1 & destination_gecc_id == 1109
replace mt_mid = mt_post   if randomization_ori == `year' & kinderprep_ori == 1 & destination_gecc_id == 1109
replace mt_aoy1 = mofd(date("04/15/`year2'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year' & destination_gecc_id == 1109
replace mt_aoy2 = mofd(date("04/15/`year3'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year' & destination_gecc_id == 1109
replace mt_aoy3 = mofd(date("04/15/`year4'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year' & destination_gecc_id == 1109
replace mt_aoy4 = mofd(date("04/15/`year5'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year' & destination_gecc_id == 1109
replace mt_aoy5 = mofd(date("04/15/`year6'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year' & destination_gecc_id == 1109


}

*******LENGTH OF BEING IN CONTROL
 
 
foreach year in 2010 2011 2012 2013  {

local year1 = `year' + 1
local year2 = `year' + 2
local year3 = `year' + 3
local year4 = `year' + 4
local year5 = `year' + 5
local year6 = `year' + 6

*& randomization_dest == 2010 & randomized_twice == 0 & treatment2010 == "control" {

 
replace mc_pre = mofd(date("08/15/2010", "MDY")  - date("08/15/2010", "MDY"))      if randomization_ori == 2010  & randomization_dest == 2010 & randomized_twice == 0 & treatment2010 == "control"
replace mc_pre = mofd(date("05/15/`year'", "MDY")  - date("08/15/2010", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori != 1  & randomization_dest == 2010 & randomized_twice == 0 & treatment2010 == "control"
replace mc_pre = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2010", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori == 1  & randomization_dest == 2010 & randomized_twice == 0 & treatment2010 == "control"
replace mc_mid = mofd(date("01/15/`year1'", "MDY")  - date("08/15/2010", "MDY"))   if randomization_ori == `year' & kinderprep_ori != 1  & randomization_dest == 2010 & randomized_twice == 0 & treatment2010 == "control"
replace mc_post = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2010", "MDY")) if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2010 & randomized_twice == 0 & treatment2010 == "control"
replace mc_post = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0 & treatment2010 == "control"
replace mc_sl = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2010 & randomized_twice == 0 & treatment2010 == "control"
replace mc_sl = mc_post if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0 & treatment2010 == "control"
replace mc_mid = mc_post   if randomization_ori == `year' & kinderprep_ori == 1  & randomization_dest == 2010 & randomized_twice == 0 & treatment2010 == "control" 
replace mc_aoy1 = mofd(date("04/15/`year2'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year'  & randomization_dest == 2010 & randomized_twice == 0 & treatment2010 == "control"
replace mc_aoy2 = mofd(date("04/15/`year3'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year' & randomization_dest == 2010 & randomized_twice == 0 & treatment2010 == "control"
replace mc_aoy3 = mofd(date("04/15/`year4'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year' & randomization_dest == 2010 & randomized_twice == 0 & treatment2010 == "control"
replace mc_aoy4 = mofd(date("04/15/`year5'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year' & randomization_dest == 2010 & randomized_twice == 0 & treatment2010 == "control"
replace mc_aoy5 = mofd(date("04/15/`year6'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year' & randomization_dest == 2010 & randomized_twice == 0 & treatment2010 == "control"

*else & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 == "control" {

replace mc_pre = mofd(date("08/15/2010", "MDY")  - date("08/15/2010", "MDY"))      if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 == "control"
replace mc_pre = mofd(date("05/15/`year'", "MDY")  - date("08/15/2010", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori != 1 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 == "control"
replace mc_pre = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2010", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori == 1  & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 == "control"
replace mc_mid = mofd(date("01/15/`year1'", "MDY")  - date("08/15/2010", "MDY"))   if randomization_ori == `year' & kinderprep_ori != 1  & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 == "control"
replace mc_post = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1  & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 == "control"
replace mc_post = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year' & kinderprep_ori == 1  & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 == "control"
replace mc_sl = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1  & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 == "control"
replace mc_sl = mc_post if randomization_ori == `year' & kinderprep_ori == 1  & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 == "control"
replace mc_mid = mc_post   if randomization_ori == `year' & kinderprep_ori == 1  & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 == "control"
replace mc_aoy1 = mofd(date("04/15/`year2'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year'  & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 == "control"
replace mc_aoy2 = mofd(date("04/15/`year3'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year'  & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 == "control"
replace mc_aoy3 = mofd(date("04/15/`year4'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year'  & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 == "control"
replace mc_aoy4 = mofd(date("04/15/`year5'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year'  & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 == "control"
replace mc_aoy5 = mofd(date("04/15/`year6'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year'  & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 == "control"

*else & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control" {

replace mc_pre = mofd(date("08/15/2010", "MDY")  - date("08/15/2010", "MDY"))      if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mc_pre = mofd(date("05/15/`year'", "MDY")  - date("08/15/2010", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori != 1  & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mc_pre = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2010", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori == 1  & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mc_mid = mofd(date("01/15/`year1'", "MDY")  - date("08/15/2010", "MDY"))   if randomization_ori == `year' & kinderprep_ori != 1  & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mc_post = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1  & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mc_post = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year' & kinderprep_ori == 1  & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mc_sl = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1  & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mc_sl = mc_post if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mc_mid = mc_post   if randomization_ori == `year' & kinderprep_ori == 1  & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mc_aoy1 = mofd(date("04/15/`year2'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year' & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mc_aoy2 = mofd(date("04/15/`year3'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year'  & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mc_aoy3 = mofd(date("04/15/`year4'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year'  & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mc_aoy4 = mofd(date("04/15/`year5'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year'  & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mc_aoy5 = mofd(date("04/15/`year6'", "MDY")  - date("08/15/2010", "MDY"))  if randomization_ori == `year'  & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"

replace mc_pre = 12 if mc_pre > 12  & randomization_ori == 2010  & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mc_pre = 12 if mc_pre > 12  & randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori != 1  & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mc_pre = 12 if mc_pre > 12  & randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori == 1  & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mc_mid = 12  if mc_mid > 12  & randomization_ori == `year' & kinderprep_ori != 1  & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mc_mid = 12   if mc_mid > 12  & randomization_ori == `year' & kinderprep_ori == 1  & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mc_post = 12 if mc_post > 12  & randomization_ori == `year' & kinderprep_ori != 1  & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mc_post = 12 if mc_post > 12  & randomization_ori == `year' & kinderprep_ori == 1  & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mc_sl = 12  if mc_sl > 12  & randomization_ori == `year' & kinderprep_ori != 1  & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mc_sl = 12  if mc_sl > 12  & randomization_ori == `year' & kinderprep_ori == 1  & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mc_aoy1 = 12  if mc_aoy1 > 12  & randomization_ori == `year'  & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mc_aoy2 = 12  if mc_aoy2 > 12  & randomization_ori == `year' & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mc_aoy3 = 12 if mc_aoy3 > 12  &   randomization_ori == `year'  & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mc_aoy4 = 12 if mc_aoy4 > 12  &  randomization_ori == `year'  & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mc_aoy5 = 12 if mc_aoy5 > 12  &  randomization_ori == `year' & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"

*else & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 == "control" {
replace mc_pre = mofd(date("08/15/2010", "MDY")  - date("08/15/2011", "MDY"))      if randomization_ori == 2010  & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 == "control"
replace mc_pre = mofd(date("05/15/`year'", "MDY")  - date("08/15/2011", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori != 1 & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 == "control" 
replace mc_pre = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2011", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 == "control"
replace mc_mid = mofd(date("01/15/`year1'", "MDY")  - date("08/15/2011", "MDY"))   if randomization_ori == `year' & kinderprep_ori != 1  & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 == "control"
replace mc_post = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1  & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 == "control"
replace mc_post = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 == "control"
replace mc_sl = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 == "control"
replace mc_sl = mc_post if randomization_ori == `year' & kinderprep_ori == 1  & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 == "control"
replace mc_mid = mc_post   if randomization_ori == `year' & kinderprep_ori == 1  & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 == "control"
replace mc_aoy1 = mofd(date("04/15/`year2'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year' & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 == "control"
replace mc_aoy2 = mofd(date("04/15/`year3'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year' & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 == "control"
replace mc_aoy3 = mofd(date("04/15/`year4'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year' & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 == "control"
replace mc_aoy4 = mofd(date("04/15/`year5'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year' & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 == "control"
replace mc_aoy5 = mofd(date("04/15/`year6'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year' & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 == "control"


*else & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "control" {

replace mc_pre = mofd(date("08/15/2010", "MDY")  - date("08/15/2011", "MDY"))      if randomization_ori == 2010  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "control"
replace mc_pre = mofd(date("05/15/`year'", "MDY")  - date("08/15/2011", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori != 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "control"
replace mc_pre = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2011", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori == 1  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "control"
replace mc_mid = mofd(date("01/15/`year1'", "MDY")  - date("08/15/2011", "MDY"))   if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "control"
replace mc_post = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "control"
replace mc_post = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year' & kinderprep_ori == 1  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "control"
replace mc_sl = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "control"
replace mc_sl = mc_post if randomization_ori == `year' & kinderprep_ori == 1  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "control"
replace mc_mid = mc_post   if randomization_ori == `year' & kinderprep_ori == 1  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "control"
replace mc_aoy1 = mofd(date("04/15/`year2'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year'  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "control"
replace mc_aoy2 = mofd(date("04/15/`year3'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year'  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "control"
replace mc_aoy3 = mofd(date("04/15/`year4'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year'  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "control"
replace mc_aoy4 = mofd(date("04/15/`year5'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year'  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "control"
replace mc_aoy5 = mofd(date("04/15/`year6'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year'  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "control"

*else & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep" {

replace mc_pre = mofd(date("08/15/2010", "MDY")  - date("08/15/2011", "MDY"))      if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mc_pre = mofd(date("05/15/`year'", "MDY")  - date("08/15/2011", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori != 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mc_pre = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2011", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori == 1  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mc_mid = mofd(date("01/15/`year1'", "MDY")  - date("08/15/2011", "MDY"))   if randomization_ori == `year' & kinderprep_ori != 1  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mc_post = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mc_post = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year' & kinderprep_ori == 1  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mc_sl = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mc_sl = mc_post if randomization_ori == `year' & kinderprep_ori == 1  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mc_mid = mc_post   if randomization_ori == `year' & kinderprep_ori == 1  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mc_aoy1 = mofd(date("04/15/`year2'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year'  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mc_aoy2 = mofd(date("04/15/`year3'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year'  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mc_aoy3 = mofd(date("04/15/`year4'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year'  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mc_aoy4 = mofd(date("04/15/`year5'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year'  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mc_aoy5 = mofd(date("04/15/`year6'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year'  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"


replace mc_pre = 12 if mc_pre > 12  & randomization_ori == 2010  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mc_pre = 12 if mc_pre > 12  & randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori != 1  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mc_pre = 12 if mc_pre > 12  & randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori == 1  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mc_mid = 12  if mc_mid > 12  & randomization_ori == `year' & kinderprep_ori != 1  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mc_mid = 12   if mc_mid > 12  & randomization_ori == `year' & kinderprep_ori == 1  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mc_post = 12 if mc_post > 12  & randomization_ori == `year' & kinderprep_ori != 1  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mc_post = 12 if mc_post > 12  & randomization_ori == `year' & kinderprep_ori == 1  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mc_sl = 12  if mc_sl > 12  & randomization_ori == `year' & kinderprep_ori != 1  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mc_sl = 12  if mc_sl > 12  & randomization_ori == `year' & kinderprep_ori == 1  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mc_aoy1 = 12  if mc_aoy1 > 12  & randomization_ori == `year'  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mc_aoy2 = 12  if mc_aoy2 > 12  & randomization_ori == `year'  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mc_aoy3 = 12 if mc_aoy3 > 12  &   randomization_ori == `year'  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mc_aoy4 = 12 if mc_aoy4 > 12  &  randomization_ori == `year'  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mc_aoy5 = 12 if mc_aoy5 > 12  &  randomization_ori == `year'  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"

*else & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep" {

replace mc_pre = mofd(date("08/15/2010", "MDY")  - date("08/15/2011", "MDY"))      if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"
replace mc_pre = mofd(date("05/15/`year'", "MDY")  - date("08/15/2011", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori != 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"
replace mc_pre = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2011", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"
replace mc_mid = mofd(date("01/15/`year1'", "MDY")  - date("08/15/2011", "MDY"))   if randomization_ori == `year' & kinderprep_ori != 1  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"
replace mc_post = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"
replace mc_post = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year' & kinderprep_ori == 1  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"
replace mc_sl = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"
replace mc_sl = mc_post if randomization_ori == `year' & kinderprep_ori == 1  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"
replace mc_mid = mc_post   if randomization_ori == `year' & kinderprep_ori == 1  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"
replace mc_aoy1 = mofd(date("04/15/`year2'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year'  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"
replace mc_aoy2 = mofd(date("04/15/`year3'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year'  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"
replace mc_aoy3 = mofd(date("04/15/`year4'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year'  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"
replace mc_aoy4 = mofd(date("04/15/`year5'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year'  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"
replace mc_aoy5 = mofd(date("04/15/`year6'", "MDY")  - date("08/15/2011", "MDY"))  if randomization_ori == `year'  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"


replace mc_pre = 22 if mc_pre > 22  & randomization_ori == 2010  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"
replace mc_pre = 22 if mc_pre > 22  & randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori != 1  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"
replace mc_pre = 22 if mc_pre > 22  & randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori == 1  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"
replace mc_mid = 22  if mc_mid > 22  & randomization_ori == `year' & kinderprep_ori != 1  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"
replace mc_mid = 22   if mc_mid > 22  & randomization_ori == `year' & kinderprep_ori == 1  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"
replace mc_post = 22 if mc_post > 22  & randomization_ori == `year' & kinderprep_ori != 1  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"
replace mc_post = 22 if mc_post > 22  & randomization_ori == `year' & kinderprep_ori == 1  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"
replace mc_sl = 22  if mc_sl > 22  & randomization_ori == `year' & kinderprep_ori != 1  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"
replace mc_sl = 22  if mc_sl > 22  & randomization_ori == `year' & kinderprep_ori == 1  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"
replace mc_aoy1 = 22  if mc_aoy1 > 22  & randomization_ori == `year'  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"
replace mc_aoy2 = 22  if mc_aoy2 > 22  & randomization_ori == `year'  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"
replace mc_aoy3 = 22 if mc_aoy3 > 22  &   randomization_ori == `year'  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"
replace mc_aoy4 = 22 if mc_aoy4 > 22  &  randomization_ori == `year'  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"
replace mc_aoy5 = 22 if mc_aoy5 > 22  &  randomization_ori == `year'  & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"

*else & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "control" {

replace mc_pre = mofd(date("08/15/2010", "MDY")  - date("08/15/2012", "MDY"))      if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "control" 
replace mc_pre = mofd(date("05/15/`year'", "MDY")  - date("08/15/2012", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori != 1  & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "control"
replace mc_pre = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2012", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "control"
replace mc_mid = mofd(date("01/15/`year1'", "MDY")  - date("08/15/2012", "MDY"))   if randomization_ori == `year' & kinderprep_ori != 1  & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "control"
replace mc_post = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "control"
replace mc_post = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "control"
replace mc_sl = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "control"
replace mc_sl = mc_post if randomization_ori == `year' & kinderprep_ori == 1  & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "control"
replace mc_mid = mc_post   if randomization_ori == `year' & kinderprep_ori == 1  & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "control"
replace mc_aoy1 = mofd(date("04/15/`year2'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year' & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "control"
replace mc_aoy2 = mofd(date("04/15/`year3'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year' & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "control"
replace mc_aoy3 = mofd(date("04/15/`year4'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year' & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "control"
replace mc_aoy4 = mofd(date("04/15/`year5'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year' & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "control"
replace mc_aoy5 = mofd(date("04/15/`year6'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year' & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "control"

*else & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "control" {


replace mc_pre = mofd(date("08/15/2010", "MDY")  - date("08/15/2012", "MDY"))      if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "control"
replace mc_pre = mofd(date("05/15/`year'", "MDY")  - date("08/15/2012", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori != 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "control"
replace mc_pre = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2012", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori == 1  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "control"
replace mc_mid = mofd(date("01/15/`year1'", "MDY")  - date("08/15/2012", "MDY"))   if randomization_ori == `year' & kinderprep_ori != 1  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "control"
replace mc_post = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "control"
replace mc_post = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year' & kinderprep_ori == 1  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "control"
replace mc_sl = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "control"
replace mc_sl = mc_post if randomization_ori == `year' & kinderprep_ori == 1  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "control"
replace mc_mid = mc_post   if randomization_ori == `year' & kinderprep_ori == 1  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "control"
replace mc_aoy1 = mofd(date("04/15/`year2'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year' & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "control"
replace mc_aoy2 = mofd(date("04/15/`year3'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year' & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "control"
replace mc_aoy3 = mofd(date("04/15/`year4'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year' & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "control"
replace mc_aoy4 = mofd(date("04/15/`year5'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year'  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "control"
replace mc_aoy5 = mofd(date("04/15/`year6'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year'  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "control"


*else & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep" {

replace mc_pre = mofd(date("08/15/2010", "MDY")  - date("08/15/2012", "MDY"))      if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mc_pre = mofd(date("05/15/`year'", "MDY")  - date("08/15/2012", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori != 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mc_pre = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2012", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori == 1  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mc_mid = mofd(date("01/15/`year1'", "MDY")  - date("08/15/2012", "MDY"))   if randomization_ori == `year' & kinderprep_ori != 1  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mc_post = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mc_post = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mc_sl = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mc_sl = mc_post if randomization_ori == `year' & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mc_mid = mc_post   if randomization_ori == `year' & kinderprep_ori == 1  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mc_aoy1 = mofd(date("04/15/`year2'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year'  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mc_aoy2 = mofd(date("04/15/`year3'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year'  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mc_aoy3 = mofd(date("04/15/`year4'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year'  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mc_aoy4 = mofd(date("04/15/`year5'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year'  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mc_aoy5 = mofd(date("04/15/`year6'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year'  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"


replace mc_pre = 12 if mc_pre > 12  & randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mc_pre = 12 if mc_pre > 12  & randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori != 1  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mc_pre = 12 if mc_pre > 12  & randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori == 1  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mc_mid = 12  if mc_mid > 12  & randomization_ori == `year' & kinderprep_ori != 1  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mc_mid = 12   if mc_mid > 12  & randomization_ori == `year' & kinderprep_ori == 1  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mc_post = 12 if mc_post > 12  & randomization_ori == `year' & kinderprep_ori != 1  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mc_post = 12 if mc_post > 12  & randomization_ori == `year' & kinderprep_ori == 1  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mc_sl = 12  if mc_sl > 12  & randomization_ori == `year' & kinderprep_ori != 1  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mc_sl = 12  if mc_sl > 12  & randomization_ori == `year' & kinderprep_ori == 1  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mc_aoy1 = 12  if mc_aoy1 > 12  & randomization_ori == `year'  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mc_aoy2 = 12  if mc_aoy2 > 12  & randomization_ori == `year'  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mc_aoy3 = 12 if mc_aoy3 > 12  &   randomization_ori == `year'  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mc_aoy4 = 12 if mc_aoy4 > 12  &  randomization_ori == `year'  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mc_aoy5 = 12 if mc_aoy5 > 12  &  randomization_ori == `year'  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"

*else & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep" {

replace mc_pre = mofd(date("08/15/2010", "MDY")  - date("08/15/2012", "MDY"))      if randomization_ori == 2010  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"
replace mc_pre = mofd(date("05/15/`year'", "MDY")  - date("08/15/2012", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori != 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"
replace mc_pre = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2012", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep" 
replace mc_mid = mofd(date("01/15/`year1'", "MDY")  - date("08/15/2012", "MDY"))   if randomization_ori == `year' & kinderprep_ori != 1  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"
replace mc_post = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"
replace mc_post = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year' & kinderprep_ori == 1  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"
replace mc_sl = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"
replace mc_sl = mc_post if randomization_ori == `year' & kinderprep_ori == 1  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"
replace mc_mid = mc_post   if randomization_ori == `year' & kinderprep_ori == 1  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"
replace mc_aoy1 = mofd(date("04/15/`year2'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year'  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"
replace mc_aoy2 = mofd(date("04/15/`year3'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year'  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"
replace mc_aoy3 = mofd(date("04/15/`year4'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year'  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"
replace mc_aoy4 = mofd(date("04/15/`year5'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year'  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"
replace mc_aoy5 = mofd(date("04/15/`year6'", "MDY")  - date("08/15/2012", "MDY"))  if randomization_ori == `year'  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"


replace mc_pre = 22 if mc_pre > 22  & randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"
replace mc_pre = 22 if mc_pre > 22  & randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori != 1  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"
replace mc_pre = 22 if mc_pre > 22  & randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori == 1  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"
replace mc_mid = 22  if mc_mid > 22  & randomization_ori == `year' & kinderprep_ori != 1  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"
replace mc_mid = 22   if mc_mid > 22  & randomization_ori == `year' & kinderprep_ori == 1  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"
replace mc_post = 22 if mc_post > 22  & randomization_ori == `year' & kinderprep_ori != 1  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"
replace mc_post = 22 if mc_post > 22  & randomization_ori == `year' & kinderprep_ori == 1  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"
replace mc_sl = 22  if mc_sl > 22  & randomization_ori == `year' & kinderprep_ori != 1  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"
replace mc_sl = 22  if mc_sl > 22  & randomization_ori == `year' & kinderprep_ori == 1  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"
replace mc_aoy1 = 22  if mc_aoy1 > 22  & randomization_ori == `year'  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"
replace mc_aoy2 = 22  if mc_aoy2 > 22  & randomization_ori == `year'  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"
replace mc_aoy3 = 22 if mc_aoy3 > 22  &   randomization_ori == `year'  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"
replace mc_aoy4 = 22 if mc_aoy4 > 22  &  randomization_ori == `year'  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"
replace mc_aoy5 = 22 if mc_aoy5 > 22  &  randomization_ori == `year'  & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"

*else & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "control" {

replace mc_pre = mofd(date("08/15/2010", "MDY")  - date("08/15/2013", "MDY"))      if randomization_ori == 2010  & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "control"
replace mc_pre = mofd(date("05/15/`year'", "MDY")  - date("08/15/2013", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori != 1  & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "control"
replace mc_pre = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2013", "MDY"))      if randomization_ori == `year' & randomization_ori != 2010 & kinderprep_ori == 1  & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "control"
replace mc_mid = mofd(date("01/15/`year1'", "MDY")  - date("08/15/2013", "MDY"))   if randomization_ori == `year' & kinderprep_ori != 1  & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "control"
replace mc_post = mofd(date("05/15/`year1'", "MDY")  - date("08/15/2013", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1  & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "control"
replace mc_post = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2013", "MDY"))  if randomization_ori == `year' & kinderprep_ori == 1  & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "control"
replace mc_sl = mofd(date("08/15/`year1'", "MDY")  - date("08/15/2013", "MDY"))  if randomization_ori == `year' & kinderprep_ori != 1  & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "control"
replace mc_sl = mc_post if randomization_ori == `year' & kinderprep_ori == 1  & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "control"
replace mc_mid = mc_post   if randomization_ori == `year' & kinderprep_ori == 1  & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "control"
replace mc_aoy1 = mofd(date("04/15/`year2'", "MDY")  - date("08/15/2013", "MDY"))  if randomization_ori == `year'  & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "control"
replace mc_aoy2 = mofd(date("04/15/`year3'", "MDY")  - date("08/15/2013", "MDY"))  if randomization_ori == `year'  & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "control"
replace mc_aoy3 = mofd(date("04/15/`year4'", "MDY")  - date("08/15/2013", "MDY"))  if randomization_ori == `year'  & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "control"
replace mc_aoy4 = mofd(date("04/15/`year5'", "MDY")  - date("08/15/2013", "MDY"))  if randomization_ori == `year' & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "control"
replace mc_aoy5 = mofd(date("04/15/`year6'", "MDY")  - date("08/15/2013", "MDY"))  if randomization_ori == `year' & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "control"

}

*Negative values obviously mean zeros.
foreach period in pre mid post sl aoy1 aoy2 aoy3 aoy4 aoy5 {
foreach var of varlist mt_`period' mc_`period' {

replace `var' = 0 if `var' < 0 & `var' != .

}
}

*For the length of being in treatment or control, attach the neighbor's treatment status to each assessment date
*In this way, we have average length by treatment type.


foreach period in pre mid post sl aoy1 aoy2 aoy3 aoy4 aoy5 {

foreach treat in cash college control kinderprep pka pkb preschool cogx treated { 

gen `period'_mt_`treat' = mt_`period'*`period'_`treat'
gen `period'_mc_`treat' = mc_`period'*`period'_`treat'
}
}


save multiple_year_neighbor_number_score.dta, replace 
