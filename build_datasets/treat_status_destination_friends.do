***Rematching Destination Friends***

clear all





foreach x in 1 2 3 4 5 6 7 8 9 10 {
	
	clear all

	cd "$repository/data_sets/pre_made"
	use share_survey	
	keep origin_gecc_id destination_gecc_id`x' name`x'

	rename destination_gecc_id`x' child

	cd "$repository/data_sets/generated"	

	merge m:1 child using unique_most_recent_treatment

	keep origin_gecc_id child treatment name`x' race gender _merge
	rename child destination_gecc_id`x'
	rename treatment treatment`x'
	rename race race`x'
	rename gender gender`x'
	drop if _m == 2
	gen checc_kid_friend`x' = 1 if destination_gecc_id`x'	!= . & _m == 3
	replace checc_kid_friend`x' = 0 if (destination_gecc_id`x'	!= . | name`x' != "") & _m == 1
	gen friend`x' = 1 if (checc_kid_friend`x' == 1 | checc_kid_friend`x' == 0) 
	replace friend`x' = 0 if friend`x' != 1
	gen checc_friend`x'= 1 if checc_kid_friend`x' == 1
	replace checc_friend`x' = 0 if checc_friend`x' !=1
	gen treated`x' = 1 if (treatment`x' == "cash" | treatment`x' == "college" | treatment`x' == "kinderprep" | treatment`x' == "pka" | treatment`x' == "pkb" | treatment`x' == "prek")
	replace treated`x' = 0 if treated`x' != 1
	gen control`x' = 1 if treatment`x' == "control"
	replace control`x' = 0 if control`x' != 1
	drop _m
	save destination_friend_`x', replace
}

**Merging Destination Friends

cd "$repository/data_sets/generated"

use destination_friend_1

foreach x in 2 3 4 5 6 7 8 9 10 {

merge 1:1 origin_gecc_id using destination_friend_`x'
keep if _m == 3
drop _m

}


egen num_friends = rowtotal(friend1 friend2 friend3 friend4 friend5 friend6 friend7 friend8 friend9 friend10)

egen num_checc_friends = rowtotal(checc_friend1 checc_friend2 checc_friend3 checc_friend4 checc_friend5 checc_friend6 checc_friend7 checc_friend8 checc_friend9 checc_friend10)

egen num_checc_control_friends = rowtotal(control1 control2 control3 control4 control5 control6 control7 control8 control9 control10)

egen num_checc_treated_friends = rowtotal(treated1 treated2 treated3 treated4 treated5 treated6 treated7 treated8 treated9 treated10)

save merged_origin_destination_friend, replace
