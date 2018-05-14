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

/*We code the dates numerically using the following key

pre2010 = 1
mid2010 = 2
post2010 = 3
sl2010 = 4
ao12010 = 5
ao22010 = 6
ao32010 = 7
ao42010 = 8
ao52010 = 9

pre2011 = 11
mid2011 = 12
post2011 = 13
sl2011 = 14
ao12011 = 15
ao22011 = 16
ao32011 = 17
ao42011 = 18
ao52011 = 19

pre2012 = 21
mid2012 = 22
post2012 = 23
sl2012 = 24
ao12012 = 25
ao22012 = 26
ao32012 = 27
ao42012 = 28
ao52012 = 29

pre2013 = 31
mid2013 = 32
post2013 = 33
sl2013 = 34
ao12013 = 35
ao22013 = 36
ao32013 = 37
ao42013 = 38
ao52013 = 39

*/

/*
foreach score in cog ncog {

foreach version in v1 v2 {

gen `version'`score'_corr_neigh_pre = .
gen `version'`score'_corr_neigh_mid = .
gen `version'`score'_corr_neigh_post = .
gen `version'`score'_corr_neigh_sl = .
gen `version'`score'_corr_neigh_ao1 = .
gen `version'`score'_corr_neigh_ao2 = .
gen `version'`score'_corr_neigh_ao3 = .
gen `version'`score'_corr_neigh_ao4 = .
gen `version'`score'_corr_neigh_ao5 = .

}
}

*Case 1) The neighbor was randomized in 2010 once


foreach score in cog ncog {

*if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 0

replace v1`score'_corr_neigh_pre = .   if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 0
replace v1`score'_corr_neigh_mid = 1 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 0
replace v1`score'_corr_neigh_post = 2 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 0
replace v1`score'_corr_neigh_sl = 3 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 0
replace v1`score'_corr_neigh_ao1 = 4 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 0
replace v1`score'_corr_neigh_ao2 = 5 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 0
replace v1`score'_corr_neigh_ao3 = 6 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 0
replace v1`score'_corr_neigh_ao4 = 7 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 0
replace v1`score'_corr_neigh_ao5 = 8 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 0

replace v2`score'_corr_neigh_pre = 1 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 0
replace v2`score'_corr_neigh_mid = 2 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 0
replace v2`score'_corr_neigh_post = 3 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 0
replace v2`score'_corr_neigh_sl = 4 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 0
replace v2`score'_corr_neigh_ao1 = 5 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 0
replace v2`score'_corr_neigh_ao2 = 6 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 0
replace v2`score'_corr_neigh_ao3= 7 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 0
replace v2`score'_corr_neigh_ao4 = 8 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 0
replace v2`score'_corr_neigh_ao5 = 9 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 0



*else if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 0


replace v1`score'_corr_neigh_pre = 2 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 0
replace v1`score'_corr_neigh_mid = 4 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 0
replace v1`score'_corr_neigh_post = 5 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 0
replace v1`score'_corr_neigh_sl = 5 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 0
replace v1`score'_corr_neigh_ao1 = 5 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 0
replace v1`score'_corr_neigh_ao2 = 6 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 0
replace v1`score'_corr_neigh_ao3 = 7 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 0
replace v1`score'_corr_neigh_ao4 = 8 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 0
replace v1`score'_corr_neigh_ao5 = 9 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 0

replace v2`score'_corr_neigh_pre = 3 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 0
replace v2`score'_corr_neigh_mid = 4 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 0
replace v2`score'_corr_neigh_post = 5 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 0
replace v2`score'_corr_neigh_sl = 5 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 0
replace v2`score'_corr_neigh_ao1 = 6 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 0
replace v2`score'_corr_neigh_ao2 = 7 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 0
replace v2`score'_corr_neigh_ao3= 8 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 0
replace v2`score'_corr_neigh_ao4 = 9 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 0
*replace v2`score'_corr_neigh_ao5 = "ao62010" if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 0


*else if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0  {

replace v1`score'_corr_neigh_pre = 5 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
replace v1`score'_corr_neigh_mid = 5 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0 
replace v1`score'_corr_neigh_post = 6 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0 
replace v1`score'_corr_neigh_sl = 6 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0 
replace v1`score'_corr_neigh_ao1 = 6 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0 
replace v1`score'_corr_neigh_ao2 = 7 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0 
replace v1`score'_corr_neigh_ao3 = 8 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0 
replace v1`score'_corr_neigh_ao4 = 9 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0 
*replace v1`score'_corr_neigh_ao5 = "ao62010" if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0 

replace v2`score'_corr_neigh_pre = 5 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0 
replace v2`score'_corr_neigh_mid = 5 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0 
replace v2`score'_corr_neigh_post = 6 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0 
replace v2`score'_corr_neigh_sl = 6 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0 
replace v2`score'_corr_neigh_ao1 = 7 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0 
replace v2`score'_corr_neigh_ao2 = 8 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0 
replace v2`score'_corr_neigh_ao3= 9 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0 
*replace v2`score'_corr_neigh_ao4 = "ao62010" if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0 
*replace v2`score'_corr_neigh_ao5 = "ao72010" if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0 





*else if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0  {


replace v1`score'_corr_neigh_pre = 6 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0 
replace v1`score'_corr_neigh_mid = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0 
replace v1`score'_corr_neigh_post = 6 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0 
replace v1`score'_corr_neigh_sl = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0 
replace v1`score'_corr_neigh_ao1 = 6 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0 
replace v1`score'_corr_neigh_ao2 = 7 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0 
replace v1`score'_corr_neigh_ao3 = 8 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0 
replace v1`score'_corr_neigh_ao4 = 9 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0 
*replace v1`score'_corr_neigh_ao5 = "ao62010" if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0 

replace v2`score'_corr_neigh_pre = 6 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0 
replace v2`score'_corr_neigh_mid = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0 
replace v2`score'_corr_neigh_post = 6 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0 
replace v2`score'_corr_neigh_sl = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0 
replace v2`score'_corr_neigh_ao1 = 7 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0 
replace v2`score'_corr_neigh_ao2 = 8 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0 
replace v2`score'_corr_neigh_ao3= 9 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0 
*replace v2`score'_corr_neigh_ao4 = "ao62010" if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0 
*replace v2`score'_corr_neigh_ao5 = "ao72010" if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0 







*else if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0  {

replace v1`score'_corr_neigh_pre = 6 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
replace v1`score'_corr_neigh_mid = 6 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
replace v1`score'_corr_neigh_post = 7 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
replace v1`score'_corr_neigh_sl = 7 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
replace v1`score'_corr_neigh_ao1 = 7 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
replace v1`score'_corr_neigh_ao2 = 8 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
replace v1`score'_corr_neigh_ao3 = 9 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
*replace v1`score'_corr_neigh_ao4 = "ao62010" if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
*replace v1`score'_corr_neigh_ao5 = "ao72010" if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0

replace v2`score'_corr_neigh_pre = 6 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
replace v2`score'_corr_neigh_mid = 6 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
replace v2`score'_corr_neigh_post = 7 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
replace v2`score'_corr_neigh_sl = 7 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
replace v2`score'_corr_neigh_ao1 = 8 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
replace v2`score'_corr_neigh_ao2 = 9 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
*replace v2`score'_corr_neigh_ao3= "ao62010" if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
*replace v2`score'_corr_neigh_ao4 = "ao72010" if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
*replace v2`score'_corr_neigh_ao5 = "ao82010" if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 0
 






*else if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0  {

replace v1`score'_corr_neigh_pre = 7 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0
replace v1`score'_corr_neigh_mid = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0
replace v1`score'_corr_neigh_post = 7 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0
replace v1`score'_corr_neigh_sl = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0
replace v1`score'_corr_neigh_ao1 = 7 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0
replace v1`score'_corr_neigh_ao2 = 8 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0
replace v1`score'_corr_neigh_ao3 = 9 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0
*replace v1`score'_corr_neigh_ao4 = "ao62010" if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0
*replace v1`score'_corr_neigh_ao5 = "ao72010" if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0

replace v2`score'_corr_neigh_pre = 7 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0
replace v2`score'_corr_neigh_mid = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0
replace v2`score'_corr_neigh_post = 7 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0     
replace v2`score'_corr_neigh_sl = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0
replace v2`score'_corr_neigh_ao1 = 8 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0
replace v2`score'_corr_neigh_ao2 = 9 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0
*replace v2`score'_corr_neigh_ao3= "ao62010" if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0
*replace v2`score'_corr_neigh_ao4 = "ao72010" if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0
*replace v2`score'_corr_neigh_ao5 = "ao82010" if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 0

}

*save origin_neighbor_score.dta, replace 

*Case 2) The neighbor was randomized twice: in 2010 and 2011


foreach score in cog ncog {

*if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 1 {

replace v1`score'_corr_neigh_pre = . if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 1
replace v1`score'_corr_neigh_mid = 1 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 1
replace v1`score'_corr_neigh_post = 2 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 1
replace v1`score'_corr_neigh_sl = 3 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 1
replace v1`score'_corr_neigh_ao1 = 12 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 1
replace v1`score'_corr_neigh_ao2 = 14 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 1
replace v1`score'_corr_neigh_ao3 = 6 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 1
replace v1`score'_corr_neigh_ao4 = 7 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 1
replace v1`score'_corr_neigh_ao5 = 8 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 1

replace v2`score'_corr_neigh_pre = 1 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 1
replace v2`score'_corr_neigh_mid = 2 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 1
replace v2`score'_corr_neigh_post = 3 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 1
replace v2`score'_corr_neigh_sl = 4 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 1
replace v2`score'_corr_neigh_ao1 = 5 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 1
replace v2`score'_corr_neigh_ao2 = 6 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 1
replace v2`score'_corr_neigh_ao3= 7 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 1
replace v2`score'_corr_neigh_ao4 = 8 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 1
replace v2`score'_corr_neigh_ao5 = 9 if randomization_ori == 2010 & randomization_dest == 2010 & randomized_twice == 1



*else if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 1  {

replace v1`score'_corr_neigh_pre = 2 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 1 
replace v1`score'_corr_neigh_mid = 4 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 1 
replace v1`score'_corr_neigh_post = 5 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 1 
replace v1`score'_corr_neigh_sl = 13 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 1 
replace v1`score'_corr_neigh_ao1 = 14 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 1 
replace v1`score'_corr_neigh_ao2 = 6 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 1 
replace v1`score'_corr_neigh_ao3 = 7 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 1 
replace v1`score'_corr_neigh_ao4 = 8 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 1 
replace v1`score'_corr_neigh_ao5 = 9 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 1 

replace v2`score'_corr_neigh_pre = 3 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 1 
replace v2`score'_corr_neigh_mid = 12 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 1 
replace v2`score'_corr_neigh_post = 13 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 1 
replace v2`score'_corr_neigh_sl = 14 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 1 
replace v2`score'_corr_neigh_ao1 = 6 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 1 
replace v2`score'_corr_neigh_ao2 = 7 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 1 
replace v2`score'_corr_neigh_ao3= 8 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 1 
replace v2`score'_corr_neigh_ao4 = 9 if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 1 
*replace v2`score'_corr_neigh_ao5 = "ao62010" if randomization_ori == 2011 & randomization_dest == 2010 & randomized_twice == 1 



*else if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1 {

replace v1`score'_corr_neigh_pre = 5 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v1`score'_corr_neigh_mid = 14 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v1`score'_corr_neigh_post = 6 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v1`score'_corr_neigh_sl = 6 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v1`score'_corr_neigh_ao1 = 6 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v1`score'_corr_neigh_ao2 = 7 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v1`score'_corr_neigh_ao3 = 8 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v1`score'_corr_neigh_ao4 = 9 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
*replace v1`score'_corr_neigh_ao5 = "ao62010" if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1

replace v2`score'_corr_neigh_pre = 13 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v2`score'_corr_neigh_mid = 14 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v2`score'_corr_neigh_post = 6 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v2`score'_corr_neigh_sl = 6 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v2`score'_corr_neigh_ao1 = 7 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v2`score'_corr_neigh_ao2 = 8 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v2`score'_corr_neigh_ao3= 9 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
*replace v2`score'_corr_neigh_ao4 = "ao62010" if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
*replace v2`score'_corr_neigh_ao5 = "ao72010" if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1  





*else if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1 {


replace v1`score'_corr_neigh_pre = 6 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v1`score'_corr_neigh_mid = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1 
replace v1`score'_corr_neigh_post = 6 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v1`score'_corr_neigh_sl = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v1`score'_corr_neigh_ao1 = 6 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v1`score'_corr_neigh_ao2 = 7 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v1`score'_corr_neigh_ao3 = 8 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v1`score'_corr_neigh_ao4 = 9 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
*replace v1`score'_corr_neigh_ao5 = "ao62010" if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1

replace v2`score'_corr_neigh_pre = 6 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v2`score'_corr_neigh_mid = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v2`score'_corr_neigh_post = 6 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v2`score'_corr_neigh_sl = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v2`score'_corr_neigh_ao1 = 7 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v2`score'_corr_neigh_ao2 = 8 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v2`score'_corr_neigh_ao3= 9 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
*replace v2`score'_corr_neigh_ao4 = "ao62010" if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
*replace v2`score'_corr_neigh_ao5 = "ao72010" if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1







*else if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1 {

replace v1`score'_corr_neigh_pre = 6 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v1`score'_corr_neigh_mid = 6 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v1`score'_corr_neigh_post = 7 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v1`score'_corr_neigh_sl = 7 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v1`score'_corr_neigh_ao1 = 7 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v1`score'_corr_neigh_ao2 = 8 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v1`score'_corr_neigh_ao3 = 9 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
*replace v1`score'_corr_neigh_ao4 = "ao62010" if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
*replace v1`score'_corr_neigh_ao5 = "ao72010" if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1

replace v2`score'_corr_neigh_pre = 6 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v2`score'_corr_neigh_mid = 6 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v2`score'_corr_neigh_post = 7 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v2`score'_corr_neigh_sl = 7 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v2`score'_corr_neigh_ao1 = 8 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
replace v2`score'_corr_neigh_ao2 = 9 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
*replace v2`score'_corr_neigh_ao3= "ao62010" if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
*replace v2`score'_corr_neigh_ao4 = "ao72010" if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
*replace v2`score'_corr_neigh_ao5 = "ao82010" if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2010 & randomized_twice == 1
 






*else if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1 {

replace v1`score'_corr_neigh_pre = 7 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v1`score'_corr_neigh_mid = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v1`score'_corr_neigh_post = 7 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v1`score'_corr_neigh_sl = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v1`score'_corr_neigh_ao1 = 7 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v1`score'_corr_neigh_ao2 = 8 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v1`score'_corr_neigh_ao3 = 9 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
*replace v1`score'_corr_neigh_ao4 = "ao62010" if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
*replace v1`score'_corr_neigh_ao5 = "ao72010" if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1

replace v2`score'_corr_neigh_pre = 7 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v2`score'_corr_neigh_mid = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v2`score'_corr_neigh_post = 7 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1 
replace v2`score'_corr_neigh_sl = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v2`score'_corr_neigh_ao1 = 8 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
replace v2`score'_corr_neigh_ao2 = 9 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
*replace v2`score'_corr_neigh_ao3= "ao62010" if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
*replace v2`score'_corr_neigh_ao4 = "ao72010" if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1
*replace v2`score'_corr_neigh_ao5 = "ao82010" if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2010 & randomized_twice == 1


}

*save origin_neighbor_score.dta, replace 

*Case 3) The neighbor was randomized once in 2011

foreach score in cog ncog {

*if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 0  {

replace v1`score'_corr_neigh_pre = . if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 0 
replace v1`score'_corr_neigh_mid = . if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 0 
replace v1`score'_corr_neigh_post = . if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 0 
replace v1`score'_corr_neigh_sl = 11 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 0 
replace v1`score'_corr_neigh_ao1 = 12 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 0 
replace v1`score'_corr_neigh_ao2 = 14 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 0 
replace v1`score'_corr_neigh_ao3 = 15 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 0 
replace v1`score'_corr_neigh_ao4 = 16 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 0 
replace v1`score'_corr_neigh_ao5 = 17 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 0 

replace v2`score'_corr_neigh_pre = . if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 0 
replace v2`score'_corr_neigh_mid = . if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 0 
replace v2`score'_corr_neigh_post = 11 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 0 
replace v2`score'_corr_neigh_sl = 11 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 0 
replace v2`score'_corr_neigh_ao1 = 12 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 0 
replace v2`score'_corr_neigh_ao2 = 15 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 0 
replace v2`score'_corr_neigh_ao3= 16 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 0 
replace v2`score'_corr_neigh_ao4 = 17 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 0 
replace v2`score'_corr_neigh_ao5 = 18 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 0 



*else if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 0   {

replace v1`score'_corr_neigh_pre = . if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 0 
replace v1`score'_corr_neigh_mid = 11 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 0 
replace v1`score'_corr_neigh_post = 12 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 0 
replace v1`score'_corr_neigh_sl = 13 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 0 
replace v1`score'_corr_neigh_ao1 = 14 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 0 
replace v1`score'_corr_neigh_ao2 = 15 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 0 
replace v1`score'_corr_neigh_ao3 = 16 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 0 
replace v1`score'_corr_neigh_ao4 = 17 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 0 
replace v1`score'_corr_neigh_ao5 = 18 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 0 

replace v2`score'_corr_neigh_pre = 11 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 0 
replace v2`score'_corr_neigh_mid = 12 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 0 
replace v2`score'_corr_neigh_post = 13 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 0 
replace v2`score'_corr_neigh_sl = 14 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 0 
replace v2`score'_corr_neigh_ao1 = 15 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 0 
replace v2`score'_corr_neigh_ao2 = 16 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 0  
replace v2`score'_corr_neigh_ao3= 17 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 0 
replace v2`score'_corr_neigh_ao4 = 18 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 0 
replace v2`score'_corr_neigh_ao5 = 19 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 0 



*else if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0  {

replace v1`score'_corr_neigh_pre = 12 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
replace v1`score'_corr_neigh_mid = 14 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
replace v1`score'_corr_neigh_post = 15 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
replace v1`score'_corr_neigh_sl = 15 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
replace v1`score'_corr_neigh_ao1 = 15 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
replace v1`score'_corr_neigh_ao2 = 16 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
replace v1`score'_corr_neigh_ao3 = 17 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
replace v1`score'_corr_neigh_ao4 = 18 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
replace v1`score'_corr_neigh_ao5 = 19 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0

replace v2`score'_corr_neigh_pre = 13 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
replace v2`score'_corr_neigh_mid = 14 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
replace v2`score'_corr_neigh_post = 15 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
replace v2`score'_corr_neigh_sl = 15 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
replace v2`score'_corr_neigh_ao1 = 16 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
replace v2`score'_corr_neigh_ao2 = 17 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
replace v2`score'_corr_neigh_ao3= 18 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
replace v2`score'_corr_neigh_ao4 = 19 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
*replace v2`score'_corr_neigh_ao5 = "ao62011" if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0





*else if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0  {


replace v1`score'_corr_neigh_pre = 15 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
replace v1`score'_corr_neigh_mid = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
replace v1`score'_corr_neigh_post = 15 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
replace v1`score'_corr_neigh_sl = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
replace v1`score'_corr_neigh_ao1 = 15 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
replace v1`score'_corr_neigh_ao2 = 16 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
replace v1`score'_corr_neigh_ao3 = 17 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
replace v1`score'_corr_neigh_ao4 = 18 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
replace v1`score'_corr_neigh_ao5 = 19 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0

replace v2`score'_corr_neigh_pre = 15 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
replace v2`score'_corr_neigh_mid = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
replace v2`score'_corr_neigh_post = 15 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
replace v2`score'_corr_neigh_sl = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
replace v2`score'_corr_neigh_ao1 = 16 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
replace v2`score'_corr_neigh_ao2 = 17 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
replace v2`score'_corr_neigh_ao3= 18 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
replace v2`score'_corr_neigh_ao4 = 19 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0
*replace v2`score'_corr_neigh_ao5 = "ao62011" if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0







*else if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0  {

replace v1`score'_corr_neigh_pre = 15 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
replace v1`score'_corr_neigh_mid = 15 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
replace v1`score'_corr_neigh_post = 16 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
replace v1`score'_corr_neigh_sl = 16 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
replace v1`score'_corr_neigh_ao1 = 16 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
replace v1`score'_corr_neigh_ao2 = 17 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
replace v1`score'_corr_neigh_ao3 = 8 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
replace v1`score'_corr_neigh_ao4 = 19 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
*replace v1`score'_corr_neigh_ao5 = "ao62011" if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0

replace v2`score'_corr_neigh_pre = 15 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
replace v2`score'_corr_neigh_mid = 15 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
replace v2`score'_corr_neigh_post = 16 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
replace v2`score'_corr_neigh_sl = 16 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
replace v2`score'_corr_neigh_ao1 = 17 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
replace v2`score'_corr_neigh_ao2 = 18 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
replace v2`score'_corr_neigh_ao3= 19 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
*replace v2`score'_corr_neigh_ao4 = "ao62011" if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0
*replace v2`score'_corr_neigh_ao5 = "ao72011" if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 0







*else if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0 {
 
replace v1`score'_corr_neigh_pre = 16 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0 
replace v1`score'_corr_neigh_mid = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0 
replace v1`score'_corr_neigh_post = 16 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0 
replace v1`score'_corr_neigh_sl = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0 
replace v1`score'_corr_neigh_ao1 = 16 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0 
replace v1`score'_corr_neigh_ao2 = 17 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0 
replace v1`score'_corr_neigh_ao3 = 18 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0 
replace v1`score'_corr_neigh_ao4 = 19 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0 
*replace v1`score'_corr_neigh_ao5 = "ao62011" if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0 

replace v2`score'_corr_neigh_pre = 16 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0 
replace v2`score'_corr_neigh_mid = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0 
replace v2`score'_corr_neigh_post = 16 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0 
replace v2`score'_corr_neigh_sl = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0 
replace v2`score'_corr_neigh_ao1 = 17 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0 
replace v2`score'_corr_neigh_ao2 = 18 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0 
replace v2`score'_corr_neigh_ao3= 19 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0 
*replace v2`score'_corr_neigh_ao4 = "ao62010" if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0 
*replace v2`score'_corr_neigh_ao5 = "ao72010" if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 0 


}

*save origin_neighbor_score.dta, replace 

*Case 4) The neighbor was randomized twice: in 2011 and 2012. Here we pay particular attention
*to cases where the 2012 randomization was in kinderprep.

foreach score in cog ncog {

*if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep" {

replace v1`score'_corr_neigh_pre = . if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_mid = . if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_post = . if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_sl = 11 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao1 = 12 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao2 = 22 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao3 = 24 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao4 = 16 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao5 = 17 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
 
replace v2`score'_corr_neigh_pre = . if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_mid = . if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_post = . if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_sl = 11 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_ao1 = 12 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_ao2 = 15 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_ao3= 16 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_ao4 = 17 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_ao5 = 18 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"




*else if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep" {

replace v1`score'_corr_neigh_pre = . if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_mid = . if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_post = . if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_sl = 11 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_ao1 = 12 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_ao2 = 14 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_ao3 = 23 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_ao4 = 16 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep" 
replace v1`score'_corr_neigh_ao5 = 17 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"

replace v2`score'_corr_neigh_pre = . if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_mid = . if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_post = . if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_sl = 11 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_ao1 = 12 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_ao2 = 15 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_ao3= 16 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_ao4 = 17 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_ao5 = 18 if randomization_ori == 2010 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"





*else if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"  {

replace v1`score'_corr_neigh_pre = . if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_mid = 11 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_post = 12 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_sl = 13 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao1 = 22 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao2 = 24 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao3 = 16 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao4 = 17 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao5 = 18 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"

replace v2`score'_corr_neigh_pre = 11 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_mid = 12 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_post = 13 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_sl = 14 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_ao1 = 15 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_ao2 = 16 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_ao3= 17 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_ao4 = 18 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_ao5 = 19 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"




*else if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"  {

replace v1`score'_corr_neigh_pre = . if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_mid = 11 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_post = 12 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_sl = 13 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_ao1 = 14 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_ao2 = 23 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_ao3 = 16 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_ao4 = 17 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_ao5 = 18 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
 
replace v2`score'_corr_neigh_pre = 11 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_mid = 12 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_post = 13 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_sl = 14 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_ao1 = 15 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_ao2 = 16 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_ao3= 17 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_ao4 = 18 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_ao5 = 19 if randomization_ori == 2011 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"




*else if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep" {

replace v1`score'_corr_neigh_pre = 12 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_mid = 14 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_post = 15 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_sl = 23 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao1 = 24 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao2 = 16 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao3 = 17 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao4 = 18 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao5 = 19 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"

replace v2`score'_corr_neigh_pre = 13 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_mid = 22 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_post = 23 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_sl = 24 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_ao1 = 16 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_ao2 = 17 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_ao3= 18 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_ao4 = 19 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
*replace v2`score'_corr_neigh_ao5 = "ao62011" if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep" 




*****Adding
*else if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep" {
replace v1`score'_corr_neigh_pre = 12 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_mid = 13 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_post = 14 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_sl = 21 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_ao1 = 23 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_ao2 = 16 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_ao3 = 17 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_ao4 = 18 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_ao5 = 19 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"

replace v2`score'_corr_neigh_pre = 13 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_mid = 14 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_post = 21 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_sl = 23 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_ao1 = 16 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_ao2 = 17 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_ao3 = 18 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_ao4 = 19 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
*replace v2`score'_corr_neigh_ao5 = std_`score'_ao_y62011 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"



*else if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep" {
replace v1`score'_corr_neigh_pre = 15 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_mid = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_post = 23 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_sl = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao1 = 24 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao2 = 16 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao3 = 17 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao4 = 18 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao5 = 19 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"

replace v2`score'_corr_neigh_pre = 23 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_mid = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_post = 24 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_sl = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_ao1 = 16 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_ao2 = 17 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_ao3 = 18 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_ao4 = 19 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
*replace v2`score'_corr_neigh__ao5 = std_`score'_ao_y62011 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"


*****

*else if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep" {


replace v1`score'_corr_neigh_pre = 15 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_mid = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep" 
replace v1`score'_corr_neigh_post = 21 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_sl = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_ao1 = 23 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_ao2 = 16 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_ao3 = 17 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_ao4 = 18 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_ao5 = 19 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
 
replace v2`score'_corr_neigh_pre = 21 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_mid = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_post = 23 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_sl = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_ao1 = 16 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_ao2 = 17 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_ao3= 18 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_ao4 = 19 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
*replace v2`score'_corr_neigh_ao5 = "ao62011" if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"






*else if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep" {


replace v1`score'_corr_neigh_pre = 15 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_mid = 14 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_post = 16 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_sl = 16 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao1 = 16 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao2 = 17 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao3 = 18 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao4 = 19 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
*replace v1`score'_corr_neigh_ao5 = "ao62011" if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"

replace v2`score'_corr_neigh_pre = 23 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_mid = 24 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_post = 16 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_sl = 16 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_ao1 = 17 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_ao2 = 18 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_ao3= 19 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
*replace v2`score'_corr_neigh_ao4 = "ao62011" if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
*replace v2`score'_corr_neigh_ao5 = "ao72011" if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"



*else if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep" {


replace v1`score'_corr_neigh_pre = 15 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep" 
replace v1`score'_corr_neigh_mid = 23 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_post = 16 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_sl = 16 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_ao1 = 16 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_ao2 = 17 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_ao3 = 18 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_ao4 = 19 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
*replace v1`score'_corr_neigh_ao5 = "ao62011" if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"

replace v2`score'_corr_neigh_pre = 21 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_mid = 23 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_post = 16 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_sl = 16 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_ao1 = 17 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_ao2 = 18 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_ao3= 19 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
*replace v2`score'_corr_neigh_ao4 = "ao62011" if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
*replace v2`score'_corr_neigh_ao5 = "ao72011" if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"



*else if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep" {


replace v1`score'_corr_neigh_pre = 16 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_mid = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_post = 16 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_sl = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_ao1 = 16 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_ao2 = 17 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_ao3 = 18 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_ao4 = 19 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
*replace v1`score'_corr_neigh_ao5 = "ao62011" if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"

replace v2`score'_corr_neigh_pre = 16 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_mid = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_post = 16 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_sl = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_ao1 = 17 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_ao2 = 18 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_ao3= 19 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
*replace v2`score'_corr_neigh_ao4 = "ao62011" if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"
*replace v2`score'_corr_neigh_ao5 = "ao72011" if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 == "kinderprep"


*else if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep" {


replace v1`score'_corr_neigh_pre = 16 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_mid = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_post = 16 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_sl = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao1 = 16 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao2 = 17 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao3 = 18 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao4 = 19 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
*replace v1`score'_ao5 = std_`score'_ao_y62011 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"

replace v2`score'_corr_neigh_pre = 16 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_mid = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_post = 16 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_sl = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_ao1 = 17 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_ao2 = 18 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_ao3 = 19 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
*replace v2`score'_corr_neigh_ao4 = std_`score'_ao_y62011 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"
*replace v2`score'_corr_neigh_ao5 = std_`score'_ao_y72011 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2011 & randomized_twice == 1 & treatment2012 != "kinderprep"

}

*save origin_neighbor_score.dta, replace 

*Case 5) The neighbor was randomized once in 2012. Here we pay particular attention to cases where
*2012 randomization was in kinderprep


foreach score in cog ncog {
*else if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" {


replace v1`score'_corr_neigh_pre = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 
replace v1`score'_corr_neigh_mid = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 
replace v1`score'_corr_neigh_post = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 
replace v1`score'_corr_neigh_sl = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 
replace v1`score'_corr_neigh_ao1 = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 
replace v1`score'_corr_neigh_ao2 = 22 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 
replace v1`score'_corr_neigh_ao3 = 24 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 
replace v1`score'_corr_neigh_ao4 = 25 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 
replace v1`score'_corr_neigh_ao5 = 26 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 
 
replace v2`score'_corr_neigh_pre = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 
replace v2`score'_corr_neigh_mid = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 
replace v2`score'_corr_neigh_post = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 
replace v2`score'_corr_neigh_sl = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 
replace v2`score'_corr_neigh_ao1 = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 
replace v2`score'_corr_neigh_ao2 = 22 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 
replace v2`score'_corr_neigh_ao3= 25 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 
replace v2`score'_corr_neigh_ao4 = 26 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 
replace v2`score'_corr_neigh_ao5 = 27 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 



*else if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" {


replace v1`score'_corr_neigh_pre = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v1`score'_corr_neigh_mid = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v1`score'_corr_neigh_post = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v1`score'_corr_neigh_sl = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v1`score'_corr_neigh_ao1 = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v1`score'_corr_neigh_ao2 = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v1`score'_corr_neigh_ao3 = 23 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v1`score'_corr_neigh_ao4 = 25 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v1`score'_corr_neigh_ao5 = 26 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 

replace v2`score'_corr_neigh_pre = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v2`score'_corr_neigh_mid = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v2`score'_corr_neigh_post = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v2`score'_corr_neigh_sl = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v2`score'_corr_neigh_ao1 = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v2`score'_corr_neigh_ao2 = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v2`score'_corr_neigh_ao3= 25 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v2`score'_corr_neigh_ao4 = 26 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v2`score'_corr_neigh_ao5 = 27 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
 


*else if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" {


replace v1`score'_corr_neigh_pre = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 
replace v1`score'_corr_neigh_mid = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 
replace v1`score'_corr_neigh_post = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 
replace v1`score'_corr_neigh_sl = 21 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 
replace v1`score'_corr_neigh_ao1 = 22 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 
replace v1`score'_corr_neigh_ao2 = 24 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 
replace v1`score'_corr_neigh_ao3 = 25 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 
replace v1`score'_corr_neigh_ao4 = 26 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 
replace v1`score'_corr_neigh_ao5 = 27 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 

replace v2`score'_corr_neigh_pre = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 
replace v2`score'_corr_neigh_mid = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 
replace v2`score'_corr_neigh_post = 21 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 
replace v2`score'_corr_neigh_sl = 21 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 
replace v2`score'_corr_neigh_ao1 = 22 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 
replace v2`score'_corr_neigh_ao2 = 25 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 
replace v2`score'_corr_neigh_ao3= 26 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 
replace v2`score'_corr_neigh_ao4 = 27 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 
replace v2`score'_corr_neigh_ao5 = 28 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 



*else if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" {


replace v1`score'_corr_neigh_pre = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_mid = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_post = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_sl = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_ao1 = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_ao2 = 23 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_ao3 = 25 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_ao4 = 26 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_ao5 = 27 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"

replace v2`score'_corr_neigh_pre = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_mid = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_post = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_sl = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_ao1 = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_ao2 = 25 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_ao3= 26 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_ao4 = 27 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_ao5 = 28 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"



*else if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" {


replace v1`score'_corr_neigh_pre = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_mid = 21 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_post = 22 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_sl = 23 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao1 = 24 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao2 = 25 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao3 = 26 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao4 = 27 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao5 = 28 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 

replace v2`score'_corr_neigh_pre = 21 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 
replace v2`score'_corr_neigh_mid = 22 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 
replace v2`score'_corr_neigh_post = 23 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 
replace v2`score'_corr_neigh_sl = 24 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 
replace v2`score'_corr_neigh_ao1 = 25 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 
replace v2`score'_corr_neigh_ao2 = 26 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 
replace v2`score'_corr_neigh_ao3= 27 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 
replace v2`score'_corr_neigh_ao4 = 28 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 
replace v2`score'_corr_neigh_ao5 = 29 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" 



*else if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" {


replace v1`score'_corr_neigh_pre = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v1`score'_corr_neigh_mid = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v1`score'_corr_neigh_post = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v1`score'_corr_neigh_sl = 21 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v1`score'_corr_neigh_ao1 = 23 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v1`score'_corr_neigh_ao2 = 25 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v1`score'_corr_neigh_ao3 = 26 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v1`score'_corr_neigh_ao4 = 27 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v1`score'_corr_neigh_ao5 = 28 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 

replace v2`score'_corr_neigh_pre = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v2`score'_corr_neigh_mid = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v2`score'_corr_neigh_post = 21 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v2`score'_corr_neigh_sl = 23 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v2`score'_corr_neigh_ao1 = 25 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v2`score'_corr_neigh_ao2 = 26 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v2`score'_corr_neigh_ao3= 27 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v2`score'_corr_neigh_ao4 = 28 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v2`score'_corr_neigh_ao5 = 29 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 



*else if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" {


replace v1`score'_corr_neigh_pre = 22 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_mid = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_post = 23 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_sl = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao1 = 24 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao2 = 25 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao3 = 26 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao4 = 27 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao5 = 28 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
 
replace v2`score'_corr_neigh_pre = 23 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_mid = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_post = 24 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_sl = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_ao1 = 25 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_ao2 = 26 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_ao3= 27 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_ao4 = 28 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_ao5 = 29 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"



*else if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" {


replace v1`score'_corr_neigh_pre = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v1`score'_corr_neigh_mid = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v1`score'_corr_neigh_post = 21 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v1`score'_corr_neigh_sl = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v1`score'_corr_neigh_ao1 = 23 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v1`score'_corr_neigh_ao2 = 25 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v1`score'_corr_neigh_ao3 = 26 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v1`score'_corr_neigh_ao4 = 27 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v1`score'_corr_neigh_ao5 = 28 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 

replace v2`score'_corr_neigh_pre = 21 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v2`score'_corr_neigh_mid = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v2`score'_corr_neigh_post = 23 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v2`score'_corr_neigh_sl = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v2`score'_corr_neigh_ao1 = 25 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v2`score'_corr_neigh_ao2 = 26 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v2`score'_corr_neigh_ao3= 27 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v2`score'_corr_neigh_ao4 = 28 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 
replace v2`score'_corr_neigh_ao5 = 29 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" 



*else if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep" {


replace v1`score'_corr_neigh_pre = 22 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_mid = 24 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_post = 25 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_sl = 25 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao1 = 25 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao2 = 26 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao3 = 27 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao4 = 28 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao5 = 29 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"

replace v2`score'_corr_neigh_pre = 23 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_mid = 24 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_post = 25 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_sl = 25 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_ao1 = 26 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_ao2 = 27 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_ao3= 28 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_ao4 = 29 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"
*replace v2`score'_corr_neigh_ao5 = "ao62012" if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "kinderprep"



*else if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" {


replace v1`score'_corr_neigh_pre = . if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_mid = 23 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_post = 25 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_sl = 25 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_ao1 = 25 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_ao2 = 26 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_ao3 = 27 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_ao4 = 28 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_ao5 = 29 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"

replace v2`score'_corr_neigh_pre = 21 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_mid = 23 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_post = 25 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_sl = 25 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_ao1 = 26 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_ao2 = 27 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_ao3= 28 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_ao4 = 29 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
*replace v2`score'_corr_neigh_ao5 = "ao62012" if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"



*else if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 &  randomized_twice == 0 & treatment2012 != "kinderprep" {


replace v1`score'_corr_neigh_pre = 25 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 &  randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_mid = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 &  randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_post = 25 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 &  randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_sl = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 &  randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao1 = 25 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 &  randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao2 = 26 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 &  randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao3 = 27 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 &  randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao4 = 28 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 &  randomized_twice == 0 & treatment2012 != "kinderprep"
replace v1`score'_corr_neigh_ao5 = 29 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 &  randomized_twice == 0 & treatment2012 != "kinderprep"

replace v2`score'_corr_neigh_pre = 25 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 &  randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_mid = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 &  randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_post = 25 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 &  randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_sl = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 &  randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_ao1 = 26 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 &  randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_ao2 = 27 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 &  randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_ao3= 28 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 &  randomized_twice == 0 & treatment2012 != "kinderprep"
replace v2`score'_corr_neigh_ao4 = 29 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 &  randomized_twice == 0 & treatment2012 != "kinderprep"
*replace v2`score'_corr_neigh_ao5 = "ao62012" if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 &  randomized_twice == 0 & treatment2012 != "kinderprep"



*else if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" {


replace v1`score'_corr_neigh_pre = 25 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_mid = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_post = 25 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_sl = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_ao1 = 25 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_ao2 = 26 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_ao3 = 27 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_ao4 = 28 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v1`score'_corr_neigh_ao5 = 29 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"

replace v2`score'_corr_neigh_pre = 25 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_mid = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_post = 25 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_sl = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_ao1 = 26 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_ao2 = 27 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_ao3= 28 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace v2`score'_corr_neigh_ao4 = 29 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
*replace v2`score'_corr_neigh_ao5 = "ao62012" if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"

}

*save origin_neighbor_score.dta, replace 

*Case 6) The neighbor was randomized twice in 2012 and 2013. Here we pay particular attention to cases where
*2013 randomization was in kinderprep. We exclude cases where a kid was randomised into kinderprep in 2012 and not in 2013
*and when a kid was randomised both in 2012 and 2013 in kinderprep as no such kids exist.So basically, there are no cases such that a kid was randomised twice in 2012 and 2013 such that
*the first randomization in 2012 was in kinder


foreach score in cog ncog {

*else if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" {


replace v1`score'_corr_neigh_pre = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_mid = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_post = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_sl = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_ao1 = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_ao2 = 22 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_ao3 = 32 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_ao4 = 34 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_ao5 = 26 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" 

replace v2`score'_corr_neigh_pre = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" 
replace v2`score'_corr_neigh_mid = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" 
replace v2`score'_corr_neigh_post = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" 
replace v2`score'_corr_neigh_sl = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" 
replace v2`score'_corr_neigh_ao1 = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" 
replace v2`score'_corr_neigh_ao2 = 22 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" 
replace v2`score'_corr_neigh_ao3= 25 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" 
replace v2`score'_corr_neigh_ao4 = 26 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" 
replace v2`score'_corr_neigh_ao5 = 27 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" 



*else if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" {


replace v1`score'_corr_neigh_pre = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v1`score'_corr_neigh_mid = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v1`score'_corr_neigh_post = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v1`score'_corr_neigh_sl = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v1`score'_corr_neigh_ao1 = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v1`score'_corr_neigh_ao2 = 22 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v1`score'_corr_neigh_ao3 = 24 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v1`score'_corr_neigh_ao4 = 33 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v1`score'_corr_neigh_ao5 = 26 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 

replace v2`score'_corr_neigh_pre = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v2`score'_corr_neigh_mid = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v2`score'_corr_neigh_post = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v2`score'_corr_neigh_sl = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v2`score'_corr_neigh_ao1 = . if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v2`score'_corr_neigh_ao2 = 22 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v2`score'_corr_neigh_ao3= 25 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v2`score'_corr_neigh_ao4 = 26 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v2`score'_corr_neigh_ao5 = 27 if randomization_ori == 2010 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 



*else if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" {


replace v1`score'_corr_neigh_pre = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_mid = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_post = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_sl = 21 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_ao1 = 22 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_ao2 = 32 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_ao3 = 34 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_ao4 = 26 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_ao5 = 27 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"

replace v2`score'_corr_neigh_pre = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_mid = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_post = 21 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_sl = 21 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_ao1 = 22 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_ao2 = 25 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_ao3= 26 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_ao4 = 27 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_ao5 = 28 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"



*else if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" {


replace v1`score'_corr_neigh_pre = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v1`score'_corr_neigh_mid = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v1`score'_corr_neigh_post = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v1`score'_corr_neigh_sl = 21 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v1`score'_corr_neigh_ao1 = 22 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v1`score'_corr_neigh_ao2 = 24 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v1`score'_corr_neigh_ao3 = 33 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v1`score'_corr_neigh_ao4 = 26 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v1`score'_corr_neigh_ao5 = 27 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 

replace v2`score'_corr_neigh_pre = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v2`score'_corr_neigh_mid = . if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v2`score'_corr_neigh_post = 21 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v2`score'_corr_neigh_sl = 21 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v2`score'_corr_neigh_ao1 = 22 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v2`score'_corr_neigh_ao2 = 25 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v2`score'_corr_neigh_ao3= 26 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v2`score'_corr_neigh_ao4 = 27 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v2`score'_corr_neigh_ao5 = 28 if randomization_ori == 2011 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 



*else if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" {


replace v1`score'_corr_neigh_pre = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_mid = 21 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_post = 22 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_sl = 23 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_ao1 = 32 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_ao2 = 34 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_ao3 = 26 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_ao4 = 27 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_ao5 = 28 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"

replace v2`score'_corr_neigh_pre = 21 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_mid = 22 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_post = 23 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_sl = 24 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_ao1 = 25 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_ao2 = 26 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_ao3= 27 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_ao4 = 28 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_ao5 = 29 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"



*else if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" {


replace v1`score'_corr_neigh_pre = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_mid = 21 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_post = 22 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_sl = 23 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_ao1 = 24 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_ao2 = 33 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_ao3 = 26 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_ao4 = 27 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_ao5 = 28 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"

replace v2`score'_corr_neigh_pre = 21 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_mid = 22 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_post = 23 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_sl = 24 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_ao1 = 25 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_ao2 = 26 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_ao3= 27 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_ao4 = 28 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_ao5 = 29 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"



*else if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" {


replace v1`score'_corr_neigh_pre = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_mid = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_post = 23 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_sl = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_ao1 = 32 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"  
replace v1`score'_corr_neigh_ao2 = 34 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_ao3 = 26 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_ao4 = 27 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_ao5 = 28 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" 
 
replace v2`score'_corr_neigh_pre = 23 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" 
replace v2`score'_corr_neigh_mid = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" 
replace v2`score'_corr_neigh_post = 24 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" 
replace v2`score'_corr_neigh_sl = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" 
replace v2`score'_corr_neigh_ao1 = 25 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" 
replace v2`score'_corr_neigh_ao2 = 26 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" 
replace v2`score'_corr_neigh_ao3= 27 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" 
replace v2`score'_corr_neigh_ao4 = 28 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" 
replace v2`score'_corr_neigh_ao5 = 29 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" 



*else if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" {


replace v1`score'_corr_neigh_pre = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_mid = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_post = 23 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_sl = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_ao1 = 24 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_ao2 = 33 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_ao3 = 26 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_ao4 = 27 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_ao5 = 28 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"

replace v2`score'_corr_neigh_pre = 23 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_mid = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_post = 24 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_sl = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_ao1 = 25 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_ao2 = 26 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_ao3= 27 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_ao4 = 28 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_ao5 = 29 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep"



*else if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" {


replace v1`score'_corr_neigh_pre = 22 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_mid = 24 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_post = 25 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_sl = 33 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_ao1 = 34 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_ao2 = 26 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_ao3 = 27 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_ao4 = 28 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_ao5 = 29 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
 
replace v2`score'_corr_neigh_pre = 23 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_mid = 32 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_post = 33 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_sl = 34 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_ao1 = 26 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_ao2 = 27 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_ao3= 28 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_ao4 = 29 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
*replace v2`score'_corr_neigh_ao5 = "ao62012" if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"



*else if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" {


replace v1`score'_corr_neigh_pre = 22 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v1`score'_corr_neigh_mid = 24 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v1`score'_corr_neigh_post = 25 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v1`score'_corr_neigh_sl = 31 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v1`score'_corr_neigh_ao1 = 33 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v1`score'_corr_neigh_ao2 = 26 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v1`score'_corr_neigh_ao3 = 27 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v1`score'_corr_neigh_ao4 = 28 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v1`score'_corr_neigh_ao5 = 29 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 

replace v2`score'_corr_neigh_pre = 23 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v2`score'_corr_neigh_mid = 24 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v2`score'_corr_neigh_post = 31 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v2`score'_corr_neigh_sl = 33 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v2`score'_corr_neigh_ao1 = 26 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v2`score'_corr_neigh_ao2 = 27 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v2`score'_corr_neigh_ao3= 28 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v2`score'_corr_neigh_ao4 = 29 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
*replace v2`score'_corr_neigh_ao5 = "ao62012" if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 



*else if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep" {


replace v1`score'_corr_neigh_pre = 25 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_mid = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_post = 33 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_sl = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_ao1 = 34 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_ao2 = 26 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_ao3 = 27 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_ao4 = 28 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_ao5 = 29 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"

replace v2`score'_corr_neigh_pre = 33 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_mid = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_post = 34 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_sl = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_ao1 = 26 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_ao2 = 27 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_ao3= 28 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_ao4 = 29 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"
*replace v2`score'_corr_neigh_ao5 = "ao62012" if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 != "kinderprep"



*else if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" {


replace v1`score'_corr_neigh_pre = 25 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v1`score'_corr_neigh_mid = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v1`score'_corr_neigh_post = 31 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v1`score'_corr_neigh_sl = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v1`score'_corr_neigh_ao1 = 33 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v1`score'_corr_neigh_ao2 = 26 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v1`score'_corr_neigh_ao3 = 27 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v1`score'_corr_neigh_ao4 = 28 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v1`score'_corr_neigh_ao5 = 29 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 

replace v2`score'_corr_neigh_pre = 31 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v2`score'_corr_neigh_mid = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v2`score'_corr_neigh_post = 33 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v2`score'_corr_neigh_sl = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v2`score'_corr_neigh_ao1 = 26 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v2`score'_corr_neigh_ao2 = 27 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v2`score'_corr_neigh_ao3= 28 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
replace v2`score'_corr_neigh_ao4 = 29 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 
*replace v2`score'_corr_neigh_ao5 = "ao62012" if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2012 & randomized_twice == 1 & treatment2013 == "kinderprep" 

}

*save origin_neighbor_score.dta, replace 


*Case 7) The neighbor was randomized once in 2013. Here we pay particular attention to cases where
*2013 randomization was in kinderprep

foreach score in cog ncog {

*else if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" {


replace v1`score'_corr_neigh_pre = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_mid = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_post = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_sl = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_ao1 = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_ao2 = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_ao3 = 32 if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_ao4 = 34 if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_ao5 = 35 if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 

replace v2`score'_corr_neigh_pre = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v2`score'_corr_neigh_mid = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v2`score'_corr_neigh_post = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v2`score'_corr_neigh_sl = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v2`score'_corr_neigh_ao1 = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v2`score'_corr_neigh_ao2 = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v2`score'_corr_neigh_ao3= 32 if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v2`score'_corr_neigh_ao4 = 35 if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v2`score'_corr_neigh_ao5 = 36 if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 



*else if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep" {


replace v1`score'_corr_neigh_pre = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_mid = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_post = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_sl = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_ao1 = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_ao2 = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_ao3 = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_ao4 = 33 if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_ao5 = 35 if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"

replace v2`score'_corr_neigh_pre = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_mid = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_post = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_sl = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_ao1 = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_ao2 = . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_ao3= . if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_ao4 = 35 if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_ao5 = 36 if randomization_ori == 2010 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"


*else if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" {


replace v1`score'_corr_neigh_pre = . if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_mid = . if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_post = . if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_sl = . if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_ao1 = . if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_ao2 = 32 if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_ao3 = 34 if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_ao4 = 35 if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_ao5 = 36 if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 

replace v2`score'_corr_neigh_pre = . if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v2`score'_corr_neigh_mid = . if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v2`score'_corr_neigh_post = . if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v2`score'_corr_neigh_sl = . if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v2`score'_corr_neigh_ao1 = . if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v2`score'_corr_neigh_ao2 = 32 if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v2`score'_corr_neigh_ao3= 35 if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v2`score'_corr_neigh_ao4 = 36 if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v2`score'_corr_neigh_ao5 = 37 if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 



*else if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep" {


replace v1`score'_corr_neigh_pre = . if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_mid = . if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_post = . if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_sl = . if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_ao1 = . if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_ao2 = . if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_ao3 = 33 if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_ao4 = 35 if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_ao5 = 36 if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"

replace v2`score'_corr_neigh_pre = . if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_mid = . if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_post = . if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_sl = . if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_ao1 = . if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_ao2 = . if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_ao3= 35 if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_ao4 = 36 if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_ao5 = 37 if randomization_ori == 2011 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"



*else if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" {


replace v1`score'_corr_neigh_pre = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_mid = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_post = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_sl = 31 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_ao1 = 32 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_ao2 = 34 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_ao3 = 35 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_ao4 = 36 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_ao5 = 37 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
 
replace v2`score'_corr_neigh_pre = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_mid = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_post = 31 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_sl = 31 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_ao1 = 32 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_ao2 = 35 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_ao3= 36 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_ao4 = 37 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_ao5 = 38 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
 


*else if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep" {


replace v1`score'_corr_neigh_pre = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_mid = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_post = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_sl = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_ao1 = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_ao2 = 33 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep "
replace v1`score'_corr_neigh_ao3 = 35 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_ao4 = 36 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_ao5 = 37 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
 
replace v2`score'_corr_neigh_pre = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_mid = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_post = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_sl = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_ao1 = . if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_ao2 = 35 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_ao3= 36 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_ao4 = 37 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_ao5 = 38 if randomization_ori == 2012 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"



*else if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" {


replace v1`score'_corr_neigh_pre = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_mid = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_post = 31 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_sl = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_ao1 = 32 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_ao2 = 34 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_ao3 = 35 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_ao4 = 36 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v1`score'_corr_neigh_ao5 = 37 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 

replace v2`score'_corr_neigh_pre = 31 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v2`score'_corr_neigh_mid = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v2`score'_corr_neigh_post = 31 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v2`score'_corr_neigh_sl = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v2`score'_corr_neigh_ao1 = 32 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v2`score'_corr_neigh_ao2 = 35 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v2`score'_corr_neigh_ao3= 36 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v2`score'_corr_neigh_ao4 = 37 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 
replace v2`score'_corr_neigh_ao5 = 38 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" 



*else if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep" {


replace v1`score'_corr_neigh_pre = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_mid = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_post = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_sl = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_ao1 = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_ao2 = 33 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_ao3 = 35 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_ao4 = 36 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_ao5 = 37 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"

replace v2`score'_corr_neigh_pre = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_mid = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_post = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_sl = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_ao1 = . if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_ao2 = 35 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_ao3= 36 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_ao4 = 37 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_ao5 = 38 if randomization_ori == 2012 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"



*else if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" {


replace v1`score'_corr_neigh_pre = . if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_mid = 31 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_post = 32 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_sl = 33 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_ao1 = 34 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_ao2 = 35 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_ao3 = 36 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_ao4 = 37 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_ao5 = 38 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"

replace v2`score'_corr_neigh_pre = 31 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_mid = 32 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_post = 33 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_sl = 34 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_ao1 = 35 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_ao2 = 36 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_ao3= 37 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_ao4 = 38 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_ao5 = 39 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"



*else if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep" {


replace v1`score'_corr_neigh_pre = . if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_mid = . if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_post = . if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_sl = 31 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_ao1 = 33 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_ao2 = 35 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_ao3 = 36 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_ao4 = 37 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v1`score'_corr_neigh_ao5 = 38 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"

replace v2`score'_corr_neigh_pre = . if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_mid = . if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_post = 31 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_sl = 33 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_ao1 = 35 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_ao2 = 36 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_ao3= 37 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_ao4 = 38 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace v2`score'_corr_neigh_ao5 = 39 if randomization_ori == 2013 & kinderprep_ori == 0 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"



*else if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep" {


replace v1`score'_corr_neigh_pre = 32 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_mid = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_post = 33 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_sl = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_ao1 = 34 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_ao2 = 35 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_ao3 = 36 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_ao4 = 37 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v1`score'_corr_neigh_ao5 = 38 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
 
replace v2`score'_corr_neigh_pre = 33 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_mid = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_post = 34 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_sl = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_ao1 = 35 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_ao2 = 36 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_ao3= 37 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_ao4 = 38 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"
replace v2`score'_corr_neigh_ao5 = 39 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "kinderprep"



*else if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep" {


replace v1`score'_corr_neigh_pre = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep" 
replace v1`score'_corr_neigh_mid = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep" 
replace v1`score'_corr_neigh_post = 31 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep" 
replace v1`score'_corr_neigh_sl = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep" 
replace v1`score'_corr_neigh_ao1 = 33 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep" 
replace v1`score'_corr_neigh_ao2 = 35 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep" 
replace v1`score'_corr_neigh_ao3 = 36 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep" 
replace v1`score'_corr_neigh_ao4 = 37 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep" 
replace v1`score'_corr_neigh_ao5 = 38 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep" 

replace v2`score'_corr_neigh_pre = 31 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep" 
replace v2`score'_corr_neigh_mid = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep" 
replace v2`score'_corr_neigh_post = 33 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep" 
replace v2`score'_corr_neigh_sl = . if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep" 
replace v2`score'_corr_neigh_ao1 = 35 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep" 
replace v2`score'_corr_neigh_ao2 = 36 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep" 
replace v2`score'_corr_neigh_ao3= 37 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep" 
replace v2`score'_corr_neigh_ao4 = 38 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep" 
replace v2`score'_corr_neigh_ao5 = 39 if randomization_ori == 2013 & kinderprep_ori == 1 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep" 


}

*save origin_neighbor_score.dta, replace 

*Case 8) Kid 1109 as neighbor, who was the only kid treated three times (2010, 2011, 2012; all different from kinderprep)

foreach score in cog ncog {

*if randomization_ori == 2010 & destination_gecc_id == 1109 {


replace v1`score'_corr_neigh_pre = . if randomization_ori == 2010 & destination_gecc_id == 1109
replace v1`score'_corr_neigh_mid = 1 if randomization_ori == 2010 & destination_gecc_id == 1109
replace v1`score'_corr_neigh_post = 2 if randomization_ori == 2010 & destination_gecc_id == 1109
replace v1`score'_corr_neigh_sl = 3 if randomization_ori == 2010 & destination_gecc_id == 1109
replace v1`score'_corr_neigh_ao1 = 12 if randomization_ori == 2010 & destination_gecc_id == 1109
replace v1`score'_corr_neigh_ao2 = 22 if randomization_ori == 2010 & destination_gecc_id == 1109
replace v1`score'_corr_neigh_ao3 = 24 if randomization_ori == 2010 & destination_gecc_id == 1109
replace v1`score'_corr_neigh_ao4 = 7 if randomization_ori == 2010 & destination_gecc_id == 1109
replace v1`score'_corr_neigh_ao5 = 8 if randomization_ori == 2010 & destination_gecc_id == 1109

replace v2`score'_corr_neigh_pre = 1 if randomization_ori == 2010 & destination_gecc_id == 1109
replace v2`score'_corr_neigh_mid = 2 if randomization_ori == 2010 & destination_gecc_id == 1109
replace v2`score'_corr_neigh_post = 3 if randomization_ori == 2010 & destination_gecc_id == 1109
replace v2`score'_corr_neigh_sl = 4 if randomization_ori == 2010 & destination_gecc_id == 1109
replace v2`score'_corr_neigh_ao1 = 5 if randomization_ori == 2010 & destination_gecc_id == 1109
replace v2`score'_corr_neigh_ao2 = 6 if randomization_ori == 2010 & destination_gecc_id == 1109
replace v2`score'_corr_neigh_ao3 = 7 if randomization_ori == 2010 & destination_gecc_id == 1109
replace v2`score'_corr_neigh_ao4 = 8 if randomization_ori == 2010 & destination_gecc_id == 1109
replace v2`score'_corr_neigh_ao5 = 9 if randomization_ori == 2010 & destination_gecc_id == 1109

*else if randomization_ori == 2011 & destination_gecc_id == 1109 {


replace v1`score'_corr_neigh_pre = 2 if randomization_ori == 2011 & destination_gecc_id == 1109
replace v1`score'_corr_neigh_mid = 4 if randomization_ori == 2011 & destination_gecc_id == 1109
replace v1`score'_corr_neigh_post = 5 if randomization_ori == 2011 & destination_gecc_id == 1109
replace v1`score'_corr_neigh_sl = 13 if randomization_ori == 2011 & destination_gecc_id == 1109
replace v1`score'_corr_neigh_ao1 = 22  if randomization_ori == 2011 & destination_gecc_id == 1109
replace v1`score'_corr_neigh_ao2 = 24 if randomization_ori == 2011 & destination_gecc_id == 1109
replace v1`score'_corr_neigh_ao3 = 7 if randomization_ori == 2011 & destination_gecc_id == 1109
replace v1`score'_corr_neigh_ao4 = 8 if randomization_ori == 2011 & destination_gecc_id == 1109
replace v1`score'_corr_neigh_ao5 = 9 if randomization_ori == 2011 & destination_gecc_id == 1109

replace v2`score'_corr_neigh_pre = 3 if randomization_ori == 2011 & destination_gecc_id == 1109
replace v2`score'_corr_neigh_mid = 12 if randomization_ori == 2011 & destination_gecc_id == 1109
replace v2`score'_corr_neigh_post = 13 if randomization_ori == 2011 & destination_gecc_id == 1109
replace v2`score'_corr_neigh_sl = 14 if randomization_ori == 2011 & destination_gecc_id == 1109
replace v2`score'_corr_neigh_ao1 = 6 if randomization_ori == 2011 & destination_gecc_id == 1109
replace v2`score'_corr_neigh_ao2 = 7 if randomization_ori == 2011 & destination_gecc_id == 1109
replace v2`score'_corr_neigh_ao3 = 8 if randomization_ori == 2011 & destination_gecc_id == 1109
replace v2`score'_corr_neigh_ao4 = 9 if randomization_ori == 2011 & destination_gecc_id == 1109
*replace v2`score'_corr_neigh_ao5 = std_`score'_ao_y62010 if randomization_ori == 2011 & destination_gecc_id == 1109

*else if randomization_ori == 2012 & kinderprep_ori == 0 & destination_gecc_id == 1109 {


replace v1`score'_corr_neigh_pre = 5 if randomization_ori == 2012 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v1`score'_corr_neigh_mid = 14 if randomization_ori == 2012 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v1`score'_corr_neigh_post = 6 if randomization_ori == 2012 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v1`score'_corr_neigh_sl = 23 if randomization_ori == 2012 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v1`score'_corr_neigh_ao1 = 24 if randomization_ori == 2012 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v1`score'_corr_neigh_ao2 = 7 if randomization_ori == 2012 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v1`score'_corr_neigh_ao3 = 8 if randomization_ori == 2012 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v1`score'_corr_neigh_ao4 = 9 if randomization_ori == 2012 & kinderprep_ori == 0 & destination_gecc_id == 1109
*replace v1`score'_corr_neigh_ao5 = std_`score'_ao_y62010 if randomization_ori == 2012 & kinderprep_ori == 0 & destination_gecc_id == 1109

replace v2`score'_corr_neigh_pre = 13 if randomization_ori == 2012 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v2`score'_corr_neigh_mid = 22 if randomization_ori == 2012 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v2`score'_corr_neigh_post = 23 if randomization_ori == 2012 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v2`score'_corr_neigh_sl = 24 if randomization_ori == 2012 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v2`score'_corr_neigh_ao1 = 7 if randomization_ori == 2012 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v2`score'_corr_neigh_ao2 = 8 if randomization_ori == 2012 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v2`score'_corr_neigh_ao3 = 9 if randomization_ori == 2012 & kinderprep_ori == 0 & destination_gecc_id == 1109
*replace v2`score'_corr_neigh_ao4 = std_`score'_ao_y62010 if randomization_ori == 2012 & kinderprep_ori == 0 & destination_gecc_id == 1109
*replace v2`score'_corr_neigh_ao5 = std_`score'_ao_y72010 if randomization_ori == 2012 & kinderprep_ori == 0 & destination_gecc_id == 1109



*else if randomization_ori == 2012 & kinderprep_ori == 1 & destination_gecc_id == 1109 {


replace v1`score'_corr_neigh_pre = 6 if randomization_ori == 2012 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v1`score'_corr_neigh_mid = . if randomization_ori == 2012 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v1`score'_corr_neigh_post = 23 if randomization_ori == 2012 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v1`score'_corr_neigh_sl = . if randomization_ori == 2012 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v1`score'_corr_neigh_ao1 = 24 if randomization_ori == 2012 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v1`score'_corr_neigh_ao2 = 7 if randomization_ori == 2012 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v1`score'_corr_neigh_ao3 = 8 if randomization_ori == 2012 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v1`score'_corr_neigh_ao4 = 9 if randomization_ori == 2012 & kinderprep_ori == 1 & destination_gecc_id == 1109
*replace v1`score'_corr_neigh_ao5 = std_`score'_ao_y62010 if randomization_ori == 2012 & kinderprep_ori == 1 & destination_gecc_id == 1109

replace v2`score'_corr_neigh_pre =  23 if randomization_ori == 2012 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v2`score'_corr_neigh_mid = . if randomization_ori == 2012 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v2`score'_corr_neigh_post = 24 if randomization_ori == 2012 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v2`score'_corr_neigh_sl = . if randomization_ori == 2012 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v2`score'_corr_neigh_ao1 = 7 if randomization_ori == 2012 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v2`score'_corr_neigh_ao2 = 8 if randomization_ori == 2012 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v2`score'_corr_neigh_ao3 = 9  if randomization_ori == 2012 & kinderprep_ori == 1 & destination_gecc_id == 1109
*replace v2`score'_corr_neigh_ao4 = std_`score'_ao_y62010 if randomization_ori == 2012 & kinderprep_ori == 1 & destination_gecc_id == 1109
*replace v2`score'_corr_neigh_ao5 = std_`score'_ao_y72010 if randomization_ori == 2012 & kinderprep_ori == 1 & destination_gecc_id == 1109


*else if randomization_ori == 2013 & kinderprep_ori == 0 & destination_gecc_id == 1109 {


replace v1`score'_corr_neigh_pre = 6 if randomization_ori == 2013 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v1`score'_corr_neigh_mid = 24 if randomization_ori == 2013 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v1`score'_corr_neigh_post = 7 if randomization_ori == 2013 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v1`score'_corr_neigh_sl = 7 if randomization_ori == 2013 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v1`score'_corr_neigh_ao1 = 7 if randomization_ori == 2013 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v1`score'_corr_neigh_ao2 = 8 if randomization_ori == 2013 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v1`score'_corr_neigh_ao3 = 9 if randomization_ori == 2013 & kinderprep_ori == 0 & destination_gecc_id == 1109
*replace v1`score'_corr_neigh_ao4 = std_`score'_ao_y62010 if randomization_ori == 2013 & kinderprep_ori == 0 & destination_gecc_id == 1109
*replace v1`score'_corr_neigh_ao5 = std_`score'_ao_y72010 if randomization_ori == 2013 & kinderprep_ori == 0 & destination_gecc_id == 1109

replace v2`score'_corr_neigh_pre = 23 if randomization_ori == 2013 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v2`score'_corr_neigh_mid = 24 if randomization_ori == 2013 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v2`score'_corr_neigh_post = 7 if randomization_ori == 2013 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v2`score'_corr_neigh_sl = 7 if randomization_ori == 2013 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v2`score'_corr_neigh_ao1 = 8 if randomization_ori == 2013 & kinderprep_ori == 0 & destination_gecc_id == 1109
replace v2`score'_corr_neigh_ao2 = 9 if randomization_ori == 2013 & kinderprep_ori == 0 & destination_gecc_id == 1109
*replace v2`score'_corr_neigh_ao3 = std_`score'_ao_y62010 if randomization_ori == 2013 & kinderprep_ori == 0 & destination_gecc_id == 1109
*replace v2`score'_corr_neigh_ao4 = std_`score'_ao_y72010 if randomization_ori == 2013 & kinderprep_ori == 0 & destination_gecc_id == 1109
*replace v2`score'_corr_neigh_ao5 = std_`score'_ao_y82010 if randomization_ori == 2013 & kinderprep_ori == 0 & destination_gecc_id == 1109



*else if randomization_ori == 2013 & kinderprep_ori == 1 & destination_gecc_id == 1109


replace v1`score'_corr_neigh_pre = 7 if randomization_ori == 2013 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v1`score'_corr_neigh_mid= . if randomization_ori == 2013 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v1`score'_corr_neigh_post = 7 if randomization_ori == 2013 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v1`score'_corr_neigh_sl = . if randomization_ori == 2013 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v1`score'_corr_neigh_ao1 = 7 if randomization_ori == 2013 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v1`score'_corr_neigh_ao2 = 8 if randomization_ori == 2013 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v1`score'_corr_neigh_ao3 = 9 if randomization_ori == 2013 & kinderprep_ori == 1 & destination_gecc_id == 1109
*replace v1`score'_corr_neigh_ao4 = std_`score'_ao_y62010 if randomization_ori == 2013 & kinderprep_ori == 1 & destination_gecc_id == 1109
*replace v1`score'_corr_neigh_ao5 = std_`score'_ao_y72010 if randomization_ori == 2013 & kinderprep_ori == 1 & destination_gecc_id == 1109

replace v2`score'_corr_neigh_pre = 7 if randomization_ori == 2013 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v2`score'_corr_neigh_mid = . if randomization_ori == 2013 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v2`score'_corr_neigh_post = 7 if randomization_ori == 2013 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v2`score'_corr_neigh_sl = . if randomization_ori == 2013 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v2`score'_corr_neigh_ao1 = 8 if randomization_ori == 2013 & kinderprep_ori == 1 & destination_gecc_id == 1109
replace v2`score'_corr_neigh_ao2 = 9 if randomization_ori == 2013 & kinderprep_ori == 1 & destination_gecc_id == 1109
*replace v2`score'_corr_neigh_ao3 = std_`score'_ao_y62010 if randomization_ori == 2013 & kinderprep_ori == 1 & destination_gecc_id == 1109
*replace v2`score'_corr_neigh_ao4 = std_`score'_ao_y72010 if randomization_ori == 2013 & kinderprep_ori == 1 & destination_gecc_id == 1109
*replace v2`score'_corr_neigh_ao5 = std_`score'_ao_y82010 if randomization_ori == 2013 & kinderprep_ori == 1 & destination_gecc_id == 1109


}

*save origin_neighbor_score.dta, replace 

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

/*
foreach version  in v1 v2 {
foreach score in cog ncog {


rename   `version'`score'_corr_neigh_ao1 `version'`score'_corr_neigh_aoy1 
rename   `version'`score'_corr_neigh_ao2 `version'`score'_corr_neigh_aoy2  
rename   `version'`score'_corr_neigh_ao3 `version'`score'_corr_neigh_aoy3  
rename   `version'`score'_corr_neigh_ao4 `version'`score'_corr_neigh_aoy4  
rename   `version'`score'_corr_neigh_ao5 `version'`score'_corr_neigh_aoy5 


}
}

*/

*save origin_neighbor_score.dta, replace 
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
*save origin_neighbor_score.dta, replace 

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

*save origin_neighbor_score.dta, replace

*save origin_neighbor_score.dta, replace 

*****************************************************************
*Defining Corresponding Length of Treatment/Control for Neighbors
*****************************************************************

/* This part of the code defines the length of a neighbor being treated at a particular 
assessment date according to version 1 and version 2 rules. It also defines an additional
variable for the length of a neighbor being in control at a particular assessment date. We also 
calculate the lenghth of being treated/being in control for neighbors who do not have a score at 
a particular date. 
*/

/* Notice that we define the lenght variable only for cog as the length is independent on whether we 
focus on cog or noncog scores as they happen at  the same time.
*/

/*Notice that both the length in treatment and length in control variables can have non-zero values
for neighbor kids if that neighbor kid has been randomized multiple times and passed some time in control and osoem time in treatment */


/*
**Initiate the length variables with 0
foreach score in cog /*ncog*/ {

foreach period in pre mid post sl aoy1 aoy2 aoy3 aoy4 aoy5 {

gen mtv1`score'_corr_neigh_`period' = 0
gen mtv2`score'_corr_neigh_`period' = 0
gen mcv1`score'_corr_neigh_`period' = 0
gen mcv2`score'_corr_neigh_`period' = 0
}

}
save origin_neighbor_score.dta, replace 
**Define the length of treatment variable according to different types of neighbors
foreach score in cog /*ncog*/ {

foreach version in v1 v2 {

foreach var of varlist  `version'`score'_corr_neigh_pre `version'`score'_corr_neigh_mid `version'`score'_corr_neigh_post `version'`score'_corr_neigh_sl `version'`score'_corr_neigh_aoy1 `version'`score'_corr_neigh_aoy2 `version'`score'_corr_neigh_aoy3 `version'`score'_corr_neigh_aoy4 `version'`score'_corr_neigh_aoy5 {


*if randomization_dest == 2010 & randomized_twice == 0 & treatment2010 != "control" {

replace mt`var' = 0  if `var' == 1 & randomization_dest == 2010 & randomized_twice == 0 & treatment2010 != "control"
replace mt`var'  = 5  if `var' == 2 & randomization_dest == 2010 & randomized_twice == 0 & treatment2010 != "control"
replace mt`var'  = 9  if `var' == 3 & randomization_dest == 2010 & randomized_twice == 0 & treatment2010 != "control"
replace mt`var'  = 12  if `var' == 4 & randomization_dest == 2010 & randomized_twice == 0 & treatment2010 != "control"
replace mt`var'  = 20  if `var' == 5 & randomization_dest == 2010 & randomized_twice == 0 & treatment2010 != "control"
replace mt`var'  = 32  if `var' == 6 & randomization_dest == 2010 & randomized_twice == 0 & treatment2010 != "control"
replace mt`var'  = 44  if `var' == 7 & randomization_dest == 2010 & randomized_twice == 0 & treatment2010 != "control"
replace mt`var'  = 56  if `var' == 8 & randomization_dest == 2010 & randomized_twice == 0 & treatment2010 != "control"
replace mt`var'  = 68  if `var' == 9 & randomization_dest == 2010 & randomized_twice == 0 & treatment2010 != "control"




*else & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control" {

replace mt`var' = 0  if `var' == 1 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mt`var'  = 0  if `var' == 2 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mt`var'  = 0  if `var' == 3 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mt`var'  = 3  if `var' == 4 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mt`var'  = 11  if `var' == 5 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mt`var'  = 23  if `var' == 6 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mt`var'  = 35  if `var' == 7 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mt`var'  = 47  if `var' == 8 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mt`var'  = 59  if `var' == 9 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"


replace mt`var' = 0  if `var' == 11 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mt`var'  = 8  if `var' == 12 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mt`var'  = 12  if `var' == 13 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mt`var'  = 15  if `var' == 14 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mt`var'  = 23  if `var' == 15 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mt`var'  = 35  if `var' == 16 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mt`var'  = 47  if `var' == 17 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mt`var'  = 59  if `var' == 18 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mt`var'  = 71  if `var' == 19 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"



*else & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 != "control" & treatment2011 != "control" {

replace mt`var' = 0  if `var' == 1 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 != "control" & treatment2011 != "control"
replace mt`var'  = 5  if `var' == 2 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 != "control" & treatment2011 != "control"
replace mt`var'  = 9  if `var' == 3 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 != "control" & treatment2011 != "control"
replace mt`var'  = 12  if `var' == 4 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 != "control" & treatment2011 != "control"
replace mt`var'  = 20  if `var' == 5 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 != "control" & treatment2011 != "control"
replace mt`var'  = 32  if `var' == 6 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 != "control" & treatment2011 != "control"
replace mt`var'  = 44  if `var' == 7 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 != "control" & treatment2011 != "control"
replace mt`var'  = 56  if `var' == 8 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 != "control" & treatment2011 != "control"
replace mt`var'  = 68  if `var' == 9 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 != "control" & treatment2011 != "control"


replace mt`var' = 9  if `var' == 11 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 != "control" & treatment2011 != "control"
replace mt`var'  = 17  if `var' == 12 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 != "control" & treatment2011 != "control"
replace mt`var'  = 21  if `var' == 13 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 != "control" & treatment2011 != "control"
replace mt`var'  = 24  if `var' == 14 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 != "control" & treatment2011 != "control"
replace mt`var'  = 32  if `var' == 15 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 != "control" & treatment2011 != "control"
replace mt`var'  = 44  if `var' == 16 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 != "control" & treatment2011 != "control"
replace mt`var'  = 56  if `var' == 17 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 != "control" & treatment2011 != "control"
replace mt`var'  = 68  if `var' == 18 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 != "control" & treatment2011 != "control"
replace mt`var'  = 80  if `var' == 19 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 != "control" & treatment2011 != "control"



*else & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 != "control" {

replace mt`var' = 0  if `var' == 11 & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 != "control"
replace mt`var'  = 8  if `var' == 12 & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 != "control"
replace mt`var'  = 12  if `var' == 13 & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 != "control"
replace mt`var'  = 15  if `var' == 14 & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 != "control"
replace mt`var'  = 23  if `var' == 15 & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 != "control"
replace mt`var'  = 35  if `var' == 16 & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 != "control"
replace mt`var'  = 47  if `var' == 17 & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 != "control"
replace mt`var'  = 59  if `var' == 18 & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 != "control"
replace mt`var'  = 71  if `var' == 19 & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 != "control"




*else & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep" {

replace mt`var' = 0  if `var' == 11 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt`var'  = 0  if `var' == 12 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt`var'  = 0  if `var' == 13 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt`var'  = 3  if `var' == 14 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt`var'  = 11  if `var' == 15 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt`var'  = 23  if `var' == 16 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt`var'  = 35  if `var' == 17 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt`var'  = 47  if `var' == 18 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt`var'  = 59  if `var' == 19 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"





replace mt`var' = 0  if `var' == 21 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt`var'  = 8  if `var' == 22 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt`var'  = 12  if `var' == 23 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt`var'  = 15  if `var' == 24 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt`var'  = 23  if `var' == 25 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt`var'  = 35  if `var' == 26 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt`var'  = 47  if `var' == 27 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt`var'  = 59  if `var' == 28 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt`var'  = 71  if `var' == 29 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"




*else & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "kinderprep" {

replace mt`var' = 0  if `var' == 11 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "kinderprep"
replace mt`var'  = 0  if `var' == 12 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "kinderprep"
replace mt`var'  = 0  if `var' == 13 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "kinderprep"
replace mt`var'  = 0  if `var' == 14 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "kinderprep"
replace mt`var'  = 0  if `var' == 15 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "kinderprep"
replace mt`var'  = 11  if `var' == 16 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "kinderprep"
replace mt`var'  = 23  if `var' == 17 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "kinderprep"
replace mt`var'  = 35  if `var' == 18 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "kinderprep"
replace mt`var'  = 47  if `var' == 19 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "kinderprep"





replace mt`var' = 0  if `var' == 21 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "kinderprep"
replace mt`var' = . if `var' == 22 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "kinderprep"
replace mt`var'  = 3  if `var' == 23 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "kinderprep"
replace mt`var' = . if `var' == 24 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "kinderprep"
replace mt`var'  = 11  if `var' == 25 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "kinderprep"
replace mt`var'  = 23  if `var' == 26 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "kinderprep"
replace mt`var'  = 35  if `var' == 27 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "kinderprep"
replace mt`var'  = 47  if `var' == 28 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "kinderprep"
replace mt`var'  = 59  if `var' == 29 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "kinderprep"




**NO case of treatment - kinderprep
*else & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 != "control" & treatment2012 != "control" & treatment2012 != "kinderprep" {

replace mt`var' = 0  if `var' == 11 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 != "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt`var'  = 8  if `var' == 12 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 != "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt`var'  = 12  if `var' == 13 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 != "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt`var'  = 15  if `var' == 14 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 != "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt`var'  = 23  if `var' == 15 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 != "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt`var'  = 35  if `var' == 16 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 != "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt`var'  = 47  if `var' == 17 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 != "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt`var'  = 59  if `var' == 18 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 != "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mt`var'  = 71  if `var' == 19 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 != "control" & treatment2012 != "control" & treatment2012 != "kinderprep"




replace mt`var' = 12  if `var' == 21 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 != "control" & treatment2012 != "control" & treatment2012 != "kinderprep" 
replace mt`var'  = 20  if `var' == 22 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 != "control" & treatment2012 != "control" & treatment2012 != "kinderprep" 
replace mt`var'  = 24  if `var' == 23 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 != "control" & treatment2012 != "control" & treatment2012 != "kinderprep" 
replace mt`var'  = 27  if `var' == 24 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 != "control" & treatment2012 != "control" & treatment2012 != "kinderprep" 
replace mt`var'  = 35  if `var' == 25 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 != "control" & treatment2012 != "control" & treatment2012 != "kinderprep" 
replace mt`var'  = 47  if `var' == 26 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 != "control" & treatment2012 != "control" & treatment2012 != "kinderprep" 
replace mt`var'  = 59  if `var' == 27 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 != "control" & treatment2012 != "control" & treatment2012 != "kinderprep" 
replace mt`var'  = 71  if `var' == 28 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 != "control" & treatment2012 != "control" & treatment2012 != "kinderprep" 
replace mt`var'  = 83  if `var' == 29 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 != "control" & treatment2012 != "control" & treatment2012 != "kinderprep" 



*else if  randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "control" & treatment2012 != kinderprep {
replace mt`var' = 0  if `var' == 21 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "control" & treatment2012!= "kinderprep"
replace mt`var'  = 8  if `var' == 22 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "control" & treatment2012!= "kinderprep"
replace mt`var'  = 12  if `var' == 23 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "control" & treatment2012!= "kinderprep"
replace mt`var'  = 15  if `var' == 24 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "control" & treatment2012!= "kinderprep"
replace mt`var'  = 23  if `var' == 25 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "control" & treatment2012!= "kinderprep"
replace mt`var'  = 35  if `var' == 26 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "control" & treatment2012!= "kinderprep"
replace mt`var'  = 47  if `var' == 27 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "control" & treatment2012!= "kinderprep"
replace mt`var'  = 59  if `var' == 28 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "control" & treatment2012!= "kinderprep"
replace mt`var'  = 71  if `var' == 29 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 != "control" & treatment2012!= "kinderprep"





*else & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep" {

replace mt`var' = 0  if `var' == 21 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace mt`var' = .  if `var' == 22 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace mt`var'  = 3  if `var' == 23 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace mt`var' = .  if `var' == 24 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace mt`var'  = 11  if `var' == 25 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace mt`var'  = 23  if `var' == 26 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace mt`var'  = 35  if `var' == 27 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace mt`var'  = 47  if `var' == 28 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"
replace mt`var'  = 59  if `var' == 29 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "kinderprep"





*else & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep" {

replace mt`var' = 0  if `var' == 21 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt`var'  = 0  if `var' == 22 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt`var'  = 0  if `var' == 23 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt`var'  = 3  if `var' == 24 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt`var'  = 11  if `var' == 25 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt`var'  = 23  if `var' == 26 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt`var'  = 35  if `var' == 27 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt`var'  = 47  if `var' == 28 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt`var'  = 59  if `var' == 29 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"


replace mt`var' = 0  if `var' == 31 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt`var'  = 8  if `var' == 32 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt`var'  = 12  if `var' == 33 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt`var'  = 15  if `var' == 34 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt`var'  = 23  if `var' == 35 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt`var'  = 35  if `var' == 36 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt`var'  = 47  if `var' == 37 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt`var'  = 59  if `var' == 38 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt`var'  = 71  if `var' == 39 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"





*else & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "kinderprep" {

replace mt`var' = 0  if `var' == 21 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "kinderprep"
replace mt`var'  = 0  if `var' == 22 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "kinderprep"
replace mt`var'  = 0  if `var' == 23 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "kinderprep"
replace mt`var'  = 0  if `var' == 24 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "kinderprep"
replace mt`var'  = 0  if `var' == 25 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "kinderprep"
replace mt`var'  = 11  if `var' == 26 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "kinderprep"
replace mt`var'  = 23  if `var' == 27 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "kinderprep"
replace mt`var'  = 35  if `var' == 28 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "kinderprep"
replace mt`var'  = 47  if `var' == 29 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "kinderprep"


replace mt`var' = 0  if `var' == 31 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "kinderprep"
replace mt`var' = .  if `var' == 32 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "kinderprep"
replace mt`var'  = 3  if `var' == 33 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "kinderprep"
replace mt`var'  = .  if `var' == 34 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "kinderprep"
replace mt`var'  = 11  if `var' == 35 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "kinderprep"
replace mt`var'  = 23  if `var' == 36 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "kinderprep"
replace mt`var'  = 35  if `var' == 37 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "kinderprep"
replace mt`var'  = 47  if `var' == 37 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "kinderprep"
replace mt`var'  = 59  if `var' == 38 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "kinderprep"
replace mt`var'  = 71  if `var' == 39 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "kinderprep"



*else & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 != "control" & treatment2013 != "control" & treatment2013 != "kinderprep" {

**the only case corresponding to TT since TK, KT and KK do not exist
replace mt`var' = 0  if `var' == 21 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 != "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt`var'  = 8  if `var' == 22 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 != "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt`var'  = 12  if `var' == 23 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 != "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt`var'  = 15  if `var' == 24 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 != "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt`var'  = 23  if `var' == 25 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 != "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt`var'  = 35  if `var' == 26 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 != "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt`var'  = 47  if `var' == 27 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 != "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt`var'  = 59  if `var' == 28 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 != "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt`var'  = 71  if `var' == 29 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 != "control" & treatment2013 != "control" & treatment2013 != "kinderprep"


replace mt`var' = 12  if `var' == 31 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 != "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt`var'  = 20  if `var' == 32 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 != "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt`var'  = 24  if `var' == 33 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 != "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt`var'  = 27  if `var' == 34 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 != "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt`var'  = 35  if `var' == 35 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 != "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt`var'  = 47  if `var' == 36 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 != "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt`var'  = 59  if `var' == 37 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 != "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt`var'  = 71  if `var' == 38 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 != "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt`var'  = 83  if `var' == 39 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 != "control" & treatment2013 != "control" & treatment2013 != "kinderprep"




*else & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "control" & treatment2013 != "kinderprep" {

replace mt`var' = 0  if `var' == 31 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt`var'  = 8  if `var' == 32 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt`var'  = 12  if `var' == 33 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt`var'  = 15  if `var' == 34 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt`var'  = 23  if `var' == 35 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt`var'  = 35  if `var' == 36 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt`var'  = 47  if `var' == 37 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt`var'  = 59  if `var' == 38 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mt`var'  = 71  if `var' == 39 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 != "control" & treatment2013 != "kinderprep"




*else & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep" {

replace mt`var' = 0  if `var' == 31 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace mt`var' = .  if `var' == 32 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace mt`var'  = 3  if `var' == 33 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace mt`var' = .  if `var' == 34 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace mt`var'  = 11  if `var' == 35 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace mt`var'  = 23  if `var' == 36 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace mt`var'  = 35  if `var' == 37 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace mt`var'  = 47  if `var' == 37 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace mt`var'  = 59  if `var' == 38 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"
replace mt`var'  = 71  if `var' == 39 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "kinderprep"



*else if destination_gecc_id == 1109 {

replace mt`var' = 0  if `var' == 1 & destination_gecc_id == 1109
replace mt`var'  = 5  if `var' == 2 & destination_gecc_id == 1109
replace mt`var'  = 9  if `var' == 3 & destination_gecc_id == 1109
replace mt`var'  = 12  if `var' == 4 & destination_gecc_id == 1109
replace mt`var'  = 20  if `var' == 5 & destination_gecc_id == 1109
replace mt`var'  = 32  if `var' == 6 & destination_gecc_id == 1109
replace mt`var'  = 44  if `var' == 7 & destination_gecc_id == 1109
replace mt`var'  = 56  if `var' == 8 & destination_gecc_id == 1109
replace mt`var'  = 68  if `var' == 9 & destination_gecc_id == 1109


replace mt`var' = 9  if `var' == 11 & destination_gecc_id == 1109
replace mt`var'  = 17  if `var' == 12 & destination_gecc_id == 1109
replace mt`var'  = 21  if `var' == 13 & destination_gecc_id == 1109
replace mt`var'  = 24  if `var' == 14 & destination_gecc_id == 1109
replace mt`var'  = 32  if `var' == 15 & destination_gecc_id == 1109
replace mt`var'  = 44  if `var' == 16 & destination_gecc_id == 1109
replace mt`var'  = 56  if `var' == 17 & destination_gecc_id == 1109
replace mt`var'  = 68  if `var' == 18 & destination_gecc_id == 1109
replace mt`var'  = 80  if `var' == 19 & destination_gecc_id == 1109


replace mt`var' = 21  if `var' == 21 & destination_gecc_id == 1109
replace mt`var'  = 29  if `var' == 22 & destination_gecc_id == 1109
replace mt`var'  = 33  if `var' == 23 & destination_gecc_id == 1109
replace mt`var'  = 36  if `var' == 24 & destination_gecc_id == 1109
replace mt`var'  = 44  if `var' == 25 & destination_gecc_id == 1109
replace mt`var'  = 56  if `var' == 26 & destination_gecc_id == 1109
replace mt`var'  = 68  if `var' == 27 & destination_gecc_id == 1109
replace mt`var'  = 80  if `var' == 28 & destination_gecc_id == 1109
replace mt`var'  = 92  if `var' == 29 & destination_gecc_id == 1109




}
}
}
*save origin_neighbor_score.dta, replace 
**Define the length of being in control variable according to different types of neighbors

foreach score in cog /*ncog*/ {

foreach version in v1 v2 {

foreach var of varlist  `version'`score'_corr_neigh_pre `version'`score'_corr_neigh_mid `version'`score'_corr_neigh_post `version'`score'_corr_neigh_sl `version'`score'_corr_neigh_aoy1 `version'`score'_corr_neigh_aoy2 `version'`score'_corr_neigh_aoy3 `version'`score'_corr_neigh_aoy4 `version'`score'_corr_neigh_aoy5 {


*& randomization_dest == 2010 & randomized_twice == 0 & treatment2010 == "control" {

replace mc`var' = 0  if `var' == 1 & randomization_dest == 2010 & randomized_twice == 0 & treatment2010 == "control"
replace mc`var'  = 5  if `var' == 2 & randomization_dest == 2010 & randomized_twice == 0 & treatment2010 == "control"
replace mc`var'  = 9  if `var' == 3 & randomization_dest == 2010 & randomized_twice == 0 & treatment2010 == "control"
replace mc`var'  = 12  if `var' == 4 & randomization_dest == 2010 & randomized_twice == 0 & treatment2010 == "control"
replace mc`var'  = 20  if `var' == 5 & randomization_dest == 2010 & randomized_twice == 0 & treatment2010 == "control"
replace mc`var'  = 32  if `var' == 6 & randomization_dest == 2010 & randomized_twice == 0 & treatment2010 == "control"
replace mc`var'  = 44  if `var' == 7 & randomization_dest == 2010 & randomized_twice == 0 & treatment2010 == "control"
replace mc`var'  = 56  if `var' == 8 & randomization_dest == 2010 & randomized_twice == 0 & treatment2010 == "control"
replace mc`var'  = 68  if `var' == 9 & randomization_dest == 2010 & randomized_twice == 0 & treatment2010 == "control"




*else & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 == "control" {

replace mc`var' = 0  if `var' == 1 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 == "control"
replace mc`var'  = 5  if `var' == 2 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 == "control"
replace mc`var'  = 9  if `var' == 3 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 == "control"
replace mc`var'  = 12  if `var' == 4 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 == "control"
replace mc`var'  = 20  if `var' == 5 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 == "control"
replace mc`var'  = 32  if `var' == 6 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 == "control"
replace mc`var'  = 44  if `var' == 7 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 == "control"
replace mc`var'  = 56  if `var' == 8 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 == "control"
replace mc`var'  = 68  if `var' == 9 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 == "control"


replace mc`var' = 9  if `var' == 11 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 == "control"
replace mc`var'  = 17  if `var' == 12 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 == "control"
replace mc`var'  = 21  if `var' == 13 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 == "control"
replace mc`var'  = 24  if `var' == 14 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 == "control"
replace mc`var'  = 32  if `var' == 15 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 == "control"
replace mc`var'  = 44  if `var' == 16 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 == "control"
replace mc`var'  = 56  if `var' == 17 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 == "control"
replace mc`var'  = 68  if `var' == 18 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 == "control"
replace mc`var'  = 80  if `var' == 19 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 == "control"



*else & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control" {

replace mc`var' = 0  if `var' == 1 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mc`var'  = 5  if `var' == 2 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mc`var'  = 9  if `var' == 3 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mc`var'  = 9  if `var' == 4 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mc`var'  = 9  if `var' == 5 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mc`var'  = 9  if `var' == 6 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mc`var'  = 9  if `var' == 7 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mc`var'  = 9 if `var' == 8 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mc`var'  = 9  if `var' == 9 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"


replace mc`var' = 9  if `var' == 11 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mc`var'  = 9  if `var' == 12 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mc`var'  = 9  if `var' == 13 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mc`var'  = 9  if `var' == 14 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mc`var'  = 9  if `var' == 15 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mc`var'  = 9  if `var' == 16 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mc`var'  = 9  if `var' == 17 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mc`var'  = 9  if `var' == 18 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"
replace mc`var'  = 9  if `var' == 19 & randomization_dest == 2010 & randomized_twice == 1 & treatment2010 == "control" & treatment2011 != "control"



*else & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 == "control" {

replace mc`var' = 0  if `var' == 11 & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 == "control"
replace mc`var'  = 8  if `var' == 12 & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 == "control"
replace mc`var'  = 12  if `var' == 13 & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 == "control"
replace mc`var'  = 15  if `var' == 14 & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 == "control"
replace mc`var'  = 23  if `var' == 15 & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 == "control"
replace mc`var'  = 35  if `var' == 16 & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 == "control"
replace mc`var'  = 47  if `var' == 17 & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 == "control"
replace mc`var'  = 59  if `var' == 18 & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 == "control"
replace mc`var'  = 71  if `var' == 19 & randomization_dest == 2011 & randomized_twice == 0 & treatment2011 == "control"




*else & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "control" {

replace mc`var' = 0  if `var' == 11 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "control"
replace mc`var'  = 8  if `var' == 12 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "control"
replace mc`var'  = 12  if `var' == 13 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "control"
replace mc`var'  = 15  if `var' == 14 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "control"
replace mc`var'  = 23  if `var' == 15 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "control"
replace mc`var'  = 35  if `var' == 16 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "control"
replace mc`var'  = 47  if `var' == 17 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "control"
replace mc`var'  = 59  if `var' == 18 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "control"
replace mc`var'  = 71  if `var' == 19 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "control"


replace mc`var' = 12  if `var' == 21 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "control"
replace mc`var'  = 20  if `var' == 22 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "control"
replace mc`var'  = 24  if `var' == 23 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "control"
replace mc`var'  = 27  if `var' == 24 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "control"
replace mc`var'  = 35  if `var' == 25 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "control"
replace mc`var'  = 47  if `var' == 26 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "control"
replace mc`var'  = 59  if `var' == 27 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "control"
replace mc`var'  = 71  if `var' == 28 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "control"
replace mc`var'  = 83  if `var' == 29 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 == "control"




*else & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep" {

replace mc`var' = 0  if `var' == 11 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mc`var'  = 8  if `var' == 12 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mc`var'  = 12  if `var' == 13 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep" 
replace mc`var'  = 12  if `var' == 14 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mc`var'  = 12  if `var' == 15 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mc`var'  = 12  if `var' == 16 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mc`var'  = 12  if `var' == 17 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mc`var'  = 12  if `var' == 18 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mc`var'  = 12  if `var' == 19 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"


replace mc`var' = 12  if `var' == 21 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mc`var'  = 12  if `var' == 22 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mc`var'  = 12  if `var' == 23 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mc`var'  = 12  if `var' == 24 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mc`var'  = 12  if `var' == 25 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mc`var'  = 12  if `var' == 26 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mc`var'  = 12  if `var' == 27 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mc`var'  = 12  if `var' == 28 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"
replace mc`var'  = 12  if `var' == 29 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 != "kinderprep"




*else & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep" {

replace mc`var' = 0  if `var' == 11 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"
replace mc`var'  = 8  if `var' == 12 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"
replace mc`var'  = 12  if `var' == 13 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"
replace mc`var'  = 15  if `var' == 14 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"
replace mc`var'  = 24  if `var' == 15 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"
replace mc`var'  = 25  if `var' == 16 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"
replace mc`var'  = 25  if `var' == 17 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"
replace mc`var'  = 25  if `var' == 18 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"
replace mc`var'  = 25  if `var' == 19 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"


replace mc`var' = 25  if `var' == 21 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"
replace mc`var'  = .  if `var' == 22 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"
replace mc`var'  = 25  if `var' == 23 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"
replace mc`var'  = .  if `var' == 24 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"
replace mc`var'  = 25  if `var' == 25 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"
replace mc`var'  = 25  if `var' == 26 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"
replace mc`var'  = 25  if `var' == 27 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"
replace mc`var'  = 25  if `var' == 28 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"
replace mc`var'  = 25  if `var' == 29 & randomization_dest == 2011 & randomized_twice == 1 & treatment2011 == "control" & treatment2012 != "control" & treatment2012 == "kinderprep"




*else & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "control" {

replace mc`var' = 0  if `var' == 21 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "control"
replace mc`var'  = 8  if `var' == 22 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "control"
replace mc`var'  = 12  if `var' == 23 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "control"
replace mc`var'  = 15  if `var' == 24 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "control"
replace mc`var'  = 23  if `var' == 25 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "control"
replace mc`var'  = 35  if `var' == 26 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "control"
replace mc`var'  = 47  if `var' == 27 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "control"
replace mc`var'  = 59  if `var' == 28 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "control"
replace mc`var'  = 71  if `var' == 29 & randomization_dest == 2012 & randomized_twice == 0 & treatment2012 == "control"





*else & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "control" {

replace mc`var' = 0  if `var' == 21 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "control"
replace mc`var'  = 8  if `var' == 22 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "control"
replace mc`var'  = 12  if `var' == 23 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "control"
replace mc`var'  = 15  if `var' == 24 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "control"
replace mc`var'  = 23  if `var' == 25 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "control"
replace mc`var'  = 35  if `var' == 26 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "control"
replace mc`var'  = 47  if `var' == 27 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "control"
replace mc`var'  = 59  if `var' == 28 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "control"
replace mc`var'  = 71  if `var' == 29 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "control"


replace mc`var' = 12  if `var' == 31 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "control"
replace mc`var'  = 20  if `var' == 32 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "control"
replace mc`var'  = 24  if `var' == 33 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "control"
replace mc`var'  = 27  if `var' == 34 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "control"
replace mc`var'  = 35  if `var' == 35 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "control"
replace mc`var'  = 47  if `var' == 36 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "control"
replace mc`var'  = 59  if `var' == 37 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "control"
replace mc`var'  = 71  if `var' == 38 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "control"
replace mc`var'  = 83  if `var' == 39 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 == "control"




*else & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep" {

replace mc`var' = 0  if `var' == 21 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mc`var'  = 8  if `var' == 22 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mc`var'  = 12  if `var' == 23 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mc`var'  = 12  if `var' == 24 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mc`var'  = 12  if `var' == 25 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mc`var'  = 12  if `var' == 26 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mc`var'  = 12  if `var' == 27 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mc`var'  = 12  if `var' == 28 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mc`var'  = 12  if `var' == 29 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"


replace mc`var' = 12  if `var' == 31 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mc`var'  = 12  if `var' == 32 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mc`var'  = 12  if `var' == 33 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mc`var'  = 12  if `var' == 34 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mc`var'  = 12  if `var' == 35 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mc`var'  = 12  if `var' == 36 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mc`var'  = 12  if `var' == 37 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mc`var'  = 12  if `var' == 38 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"
replace mc`var'  = 12  if `var' == 39 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 != "kinderprep"




*else & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep" {

replace mc`var' = 0  if `var' == 21 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"
replace mc`var'  = 8  if `var' == 22 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"
replace mc`var'  = 12  if `var' == 23 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"
replace mc`var'  = 15  if `var' == 24 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"
replace mc`var'  = 24  if `var' == 25 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"
replace mc`var'  = 25  if `var' == 26 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"
replace mc`var'  = 25  if `var' == 27 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"
replace mc`var'  = 25  if `var' == 28 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"
replace mc`var'  = 25  if `var' == 29 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"


replace mc`var' = 25  if `var' == 31 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"
replace mc`var'  = .  if `var' == 32 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"
replace mc`var'  = 25  if `var' == 33 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"
replace mc`var'  = .  if `var' == 34 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"
replace mc`var'  = 25  if `var' == 35 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"
replace mc`var'  = 25  if `var' == 36 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"
replace mc`var'  = 25  if `var' == 37 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"
replace mc`var'  = 25  if `var' == 38 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"
replace mc`var'  = 25  if `var' == 39 & randomization_dest == 2012 & randomized_twice == 1 & treatment2012 == "control" & treatment2013 != "control" & treatment2013 == "kinderprep"






*else & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "control" {

replace mc`var' = 0  if `var' == 31 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "control"
replace mc`var'  = 8  if `var' == 32 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "control"
replace mc`var'  = 12  if `var' == 33 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "control"
replace mc`var'  = 15  if `var' == 34 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "control"
replace mc`var'  = 23  if `var' == 35 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "control"
replace mc`var'  = 35  if `var' == 36 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "control"
replace mc`var'  = 47  if `var' == 37 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "control"
replace mc`var'  = 59  if `var' == 38 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "control"
replace mc`var'  = 71  if `var' == 39 & randomization_dest == 2013 & randomized_twice == 0 & treatment2013 == "control"




}
}
}

save origin_neighbor_score.dta, replace 

*/

foreach period in pre mid post sl aoy1 aoy2 aoy3 aoy4 aoy5 {

gen mt_`period' = 0
gen mc_`period' = 0

}



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

 **CONTROL
 
 
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

*save origin_neighbor_score.dta, replace
**
foreach period in pre mid post sl aoy1 aoy2 aoy3 aoy4 aoy5 {
foreach var of varlist mt_`period' mc_`period' {

replace `var' = 0 if `var' < 0 & `var' != .

}
}

**For the length of being in treatment or control, attach the neighbor's treatment status to each assessment date
*In this way, wehave average length by treatment type


foreach period in pre mid post sl aoy1 aoy2 aoy3 aoy4 aoy5 {

foreach treat in cash college control kinderprep pka pkb preschool cogx treated { 

gen `period'_mt_`treat' = mt_`period'*`period'_`treat'
gen `period'_mc_`treat' = mc_`period'*`period'_`treat'
}
}

/*
**For the length of being in treatment or control, attach the neighbor's treatment status to each assessment date
*In this way, wehave average length by treatment type
foreach score in cog /*ncog*/ {

foreach period in pre mid post sl aoy1 aoy2 aoy3 aoy4 aoy5 {

foreach treat in cash college control kinderprep pka pkb preschool cogx treated { 

gen `period'_mtv1_`score'_`treat' = mtv1`score'_corr_neigh_`period'*`period'_`treat'
gen `period'_mtv2_`score'_`treat' = mtv2`score'_corr_neigh_`period'*`period'_`treat'
gen `period'_mcv1_`score'_`treat' = mcv1`score'_corr_neigh_`period'*`period'_`treat'
gen `period'_mcv2_`score'_`treat' = mcv2`score'_corr_neigh_`period'*`period'_`treat'


}
}
}

*/
*save origin_neighbor_score.dta, replace 

save multiple_year_neighbor_number_score.dta, replace 
