**Create Neighbor Count Dummies with Gender and Race Identified for Each Origin and Destination Kid


clear all

cd "$repository/data_sets/generated"

use neighbor_count_by_oriassessments_dummies_Fatemeh_all_years

*Identifying race and gender for destination kids
rename destination_gecc_id child

merge  m:1 child using gender_race

*Dropping kids not in our sample 
drop if _m == 2

drop _m

drop year

rename race race_destination
rename gender gender_destination

rename child destination_gecc_id

save neighbor_dummies_race_gender, replace


**Create Neighbors by Distance Male Neighbors 
local distance "500 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 15000 20000"

	foreach d of local distance {
	
		clear all
		cd "$repository/data_sets/generated"
		use neighbor_dummies_race_gender
		keep if gender_destination == "Male"
		
		drop if total_meters > `d'
		
		
		
		

		collapse (sum) pre_cash mid_cash post_cash sl_cash pre_cogx mid_cogx post_cogx ///
		sl_cogx pre_college mid_college post_college sl_college pre_control mid_control ///
		 post_control sl_control pre_kinderprep mid_kinderprep post_kinderprep ///
		 sl_kinderprep pre_pka mid_pka post_pka sl_pka pre_pkb mid_pkb post_pkb ///
		 sl_pkb pre_preschool mid_preschool post_preschool sl_preschool pre_treated ///
		 mid_treated post_treated sl_treated aoy1_cash aoy2_cash aoy3_cash ///
		 aoy4_cash aoy5_cash aoy1_cogx aoy2_cogx aoy3_cogx aoy4_cogx aoy5_cogx ///
		 aoy1_college aoy2_college aoy3_college aoy4_college aoy5_college aoy1_control ///
		 aoy2_control aoy3_control aoy4_control aoy5_control aoy1_kinderprep ///
		 aoy2_kinderprep aoy3_kinderprep aoy4_kinderprep aoy5_kinderprep aoy1_pka ///
		 aoy2_pka aoy3_pka aoy4_pka aoy5_pka aoy1_pkb aoy2_pkb aoy3_pkb aoy4_pkb ///
		 aoy5_pkb aoy1_preschool aoy2_preschool aoy3_preschool aoy4_preschool ///
		 aoy5_preschool aoy1_treated aoy2_treated aoy3_treated aoy4_treated ///
		 aoy5_treated, by(origin_gecc_id randomization_ori )
		 
		reshape long @_cash @_cogx @_college @_control @_kinderprep @_pka @_pkb @_preschool @_treated, i(origin_gecc_id randomization_ori) j(test) s
		rename _* *

		foreach var in cash cogx college control kinderprep pka pkb preschool treated {
			rename `var' `var'_`d'_male
		}
		
		save neighbors_male_circle_`d', replace
		
}

/*
**Create Neighbors by Distance Missing Gender Neighbors = NO SUCH OBSERVATIONS!!!!!!!!!!
local distance "500 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 15000 20000"

	foreach d of local distance {
	
		clear all
		cd "$repository/data_sets/generated"
		use neighbor_dummies_race_gender
		keep if gender_destination == ""
		
		drop if total_meters > `d'
		
		count
		return list
		local num_observations = r(N)
		
		if `num_observations' == 0 {
		
		save neighbors_missing_gender_circle_`d', replace
		}
		
		else if `num_observations' > 0 {

		collapse (sum) pre_cash mid_cash post_cash sl_cash pre_cogx mid_cogx post_cogx ///
		sl_cogx pre_college mid_college post_college sl_college pre_control mid_control ///
		 post_control sl_control pre_kinderprep mid_kinderprep post_kinderprep ///
		 sl_kinderprep pre_pka mid_pka post_pka sl_pka pre_pkb mid_pkb post_pkb ///
		 sl_pkb pre_preschool mid_preschool post_preschool sl_preschool pre_treated ///
		 mid_treated post_treated sl_treated aoy1_cash aoy2_cash aoy3_cash ///
		 aoy4_cash aoy5_cash aoy1_cogx aoy2_cogx aoy3_cogx aoy4_cogx aoy5_cogx ///
		 aoy1_college aoy2_college aoy3_college aoy4_college aoy5_college aoy1_control ///
		 aoy2_control aoy3_control aoy4_control aoy5_control aoy1_kinderprep ///
		 aoy2_kinderprep aoy3_kinderprep aoy4_kinderprep aoy5_kinderprep aoy1_pka ///
		 aoy2_pka aoy3_pka aoy4_pka aoy5_pka aoy1_pkb aoy2_pkb aoy3_pkb aoy4_pkb ///
		 aoy5_pkb aoy1_preschool aoy2_preschool aoy3_preschool aoy4_preschool ///
		 aoy5_preschool aoy1_treated aoy2_treated aoy3_treated aoy4_treated ///
		 aoy5_treated, by(origin_gecc_id randomization_ori )
		 
		reshape long @_cash @_cogx @_college @_control @_kinderprep @_pka @_pkb @_preschool @_treated, i(origin_gecc_id randomization_ori ) j(test) s
		rename _* *

		foreach var in cash cogx college control kinderprep pka pkb preschool treated {
			rename `var' `var'_`d'_missing_gender
		}
		
		save neighbors_missing_gender_circle_`d', replace
		}
}
*/

**Create Neighbors by Distance Female Neighbors
local distance "500 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 15000 20000"

	foreach d of local distance {
	
		clear all
		cd "$repository/data_sets/generated"
		use neighbor_dummies_race_gender
		keep if gender_destination == "Female"
		
		drop if total_meters > `d'

		collapse (sum) pre_cash mid_cash post_cash sl_cash pre_cogx mid_cogx post_cogx ///
		sl_cogx pre_college mid_college post_college sl_college pre_control mid_control ///
		 post_control sl_control pre_kinderprep mid_kinderprep post_kinderprep ///
		 sl_kinderprep pre_pka mid_pka post_pka sl_pka pre_pkb mid_pkb post_pkb ///
		 sl_pkb pre_preschool mid_preschool post_preschool sl_preschool pre_treated ///
		 mid_treated post_treated sl_treated aoy1_cash aoy2_cash aoy3_cash ///
		 aoy4_cash aoy5_cash aoy1_cogx aoy2_cogx aoy3_cogx aoy4_cogx aoy5_cogx ///
		 aoy1_college aoy2_college aoy3_college aoy4_college aoy5_college aoy1_control ///
		 aoy2_control aoy3_control aoy4_control aoy5_control aoy1_kinderprep ///
		 aoy2_kinderprep aoy3_kinderprep aoy4_kinderprep aoy5_kinderprep aoy1_pka ///
		 aoy2_pka aoy3_pka aoy4_pka aoy5_pka aoy1_pkb aoy2_pkb aoy3_pkb aoy4_pkb ///
		 aoy5_pkb aoy1_preschool aoy2_preschool aoy3_preschool aoy4_preschool ///
		 aoy5_preschool aoy1_treated aoy2_treated aoy3_treated aoy4_treated ///
		 aoy5_treated, by(origin_gecc_id randomization_ori )
		 
		reshape long @_cash @_cogx @_college @_control @_kinderprep @_pka @_pkb @_preschool @_treated, i(origin_gecc_id randomization_ori ) j(test) s
		rename _* *

		foreach var in cash cogx college control kinderprep pka pkb preschool treated {
			rename `var' `var'_`d'_female
		}
		
		save neighbors_female_circle_`d', replace
}

**Create Neighbors by Distance Black Neighbors

local distance "500 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 15000 20000"

	foreach d of local distance {
	
		clear all
		cd "$repository/data_sets/generated"
		use neighbor_dummies_race_gender
		keep if race_destination == "African American"
		
		drop if total_meters > `d'

		collapse (sum) pre_cash mid_cash post_cash sl_cash pre_cogx mid_cogx post_cogx ///
		sl_cogx pre_college mid_college post_college sl_college pre_control mid_control ///
		 post_control sl_control pre_kinderprep mid_kinderprep post_kinderprep ///
		 sl_kinderprep pre_pka mid_pka post_pka sl_pka pre_pkb mid_pkb post_pkb ///
		 sl_pkb pre_preschool mid_preschool post_preschool sl_preschool pre_treated ///
		 mid_treated post_treated sl_treated aoy1_cash aoy2_cash aoy3_cash ///
		 aoy4_cash aoy5_cash aoy1_cogx aoy2_cogx aoy3_cogx aoy4_cogx aoy5_cogx ///
		 aoy1_college aoy2_college aoy3_college aoy4_college aoy5_college aoy1_control ///
		 aoy2_control aoy3_control aoy4_control aoy5_control aoy1_kinderprep ///
		 aoy2_kinderprep aoy3_kinderprep aoy4_kinderprep aoy5_kinderprep aoy1_pka ///
		 aoy2_pka aoy3_pka aoy4_pka aoy5_pka aoy1_pkb aoy2_pkb aoy3_pkb aoy4_pkb ///
		 aoy5_pkb aoy1_preschool aoy2_preschool aoy3_preschool aoy4_preschool ///
		 aoy5_preschool aoy1_treated aoy2_treated aoy3_treated aoy4_treated ///
		 aoy5_treated, by(origin_gecc_id randomization_ori )
		 
		reshape long @_cash @_cogx @_college @_control @_kinderprep @_pka @_pkb @_preschool @_treated, i(origin_gecc_id randomization_ori ) j(test) s
		rename _* *

		foreach var in cash cogx college control kinderprep pka pkb preschool treated {
			rename `var' `var'_`d'_black
		}
		
		save neighbors_black_circle_`d', replace
}

**Create Neighbors by Distance Hispanic Neighbors

local distance "500 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 15000 20000"

	foreach d of local distance {
	
		clear all
		cd "$repository/data_sets/generated"
		use neighbor_dummies_race_gender
		keep if race_destination == "Hispanic"
		
		drop if total_meters > `d'

		collapse (sum) pre_cash mid_cash post_cash sl_cash pre_cogx mid_cogx post_cogx ///
		sl_cogx pre_college mid_college post_college sl_college pre_control mid_control ///
		 post_control sl_control pre_kinderprep mid_kinderprep post_kinderprep ///
		 sl_kinderprep pre_pka mid_pka post_pka sl_pka pre_pkb mid_pkb post_pkb ///
		 sl_pkb pre_preschool mid_preschool post_preschool sl_preschool pre_treated ///
		 mid_treated post_treated sl_treated aoy1_cash aoy2_cash aoy3_cash ///
		 aoy4_cash aoy5_cash aoy1_cogx aoy2_cogx aoy3_cogx aoy4_cogx aoy5_cogx ///
		 aoy1_college aoy2_college aoy3_college aoy4_college aoy5_college aoy1_control ///
		 aoy2_control aoy3_control aoy4_control aoy5_control aoy1_kinderprep ///
		 aoy2_kinderprep aoy3_kinderprep aoy4_kinderprep aoy5_kinderprep aoy1_pka ///
		 aoy2_pka aoy3_pka aoy4_pka aoy5_pka aoy1_pkb aoy2_pkb aoy3_pkb aoy4_pkb ///
		 aoy5_pkb aoy1_preschool aoy2_preschool aoy3_preschool aoy4_preschool ///
		 aoy5_preschool aoy1_treated aoy2_treated aoy3_treated aoy4_treated ///
		 aoy5_treated, by(origin_gecc_id randomization_ori )
		 
		reshape long @_cash @_cogx @_college @_control @_kinderprep @_pka @_pkb @_preschool @_treated, i(origin_gecc_id randomization_ori ) j(test) s
		rename _* *

		foreach var in cash cogx college control kinderprep pka pkb preschool treated {
			rename `var' `var'_`d'_hispanic
		}
		
		save neighbors_hispanic_circle_`d', replace
}

**Create Neighbors by Distance Other Race Neighbors

local distance "500 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 15000 20000"

	foreach d of local distance {
	
		clear all
		cd "$repository/data_sets/generated"
		use neighbor_dummies_race_gender
		keep if race_destination == "Other"
		
		drop if total_meters > `d'

		collapse (sum) pre_cash mid_cash post_cash sl_cash pre_cogx mid_cogx post_cogx ///
		sl_cogx pre_college mid_college post_college sl_college pre_control mid_control ///
		 post_control sl_control pre_kinderprep mid_kinderprep post_kinderprep ///
		 sl_kinderprep pre_pka mid_pka post_pka sl_pka pre_pkb mid_pkb post_pkb ///
		 sl_pkb pre_preschool mid_preschool post_preschool sl_preschool pre_treated ///
		 mid_treated post_treated sl_treated aoy1_cash aoy2_cash aoy3_cash ///
		 aoy4_cash aoy5_cash aoy1_cogx aoy2_cogx aoy3_cogx aoy4_cogx aoy5_cogx ///
		 aoy1_college aoy2_college aoy3_college aoy4_college aoy5_college aoy1_control ///
		 aoy2_control aoy3_control aoy4_control aoy5_control aoy1_kinderprep ///
		 aoy2_kinderprep aoy3_kinderprep aoy4_kinderprep aoy5_kinderprep aoy1_pka ///
		 aoy2_pka aoy3_pka aoy4_pka aoy5_pka aoy1_pkb aoy2_pkb aoy3_pkb aoy4_pkb ///
		 aoy5_pkb aoy1_preschool aoy2_preschool aoy3_preschool aoy4_preschool ///
		 aoy5_preschool aoy1_treated aoy2_treated aoy3_treated aoy4_treated ///
		 aoy5_treated, by(origin_gecc_id randomization_ori )
		 
		reshape long @_cash @_cogx @_college @_control @_kinderprep @_pka @_pkb @_preschool @_treated, i(origin_gecc_id randomization_ori ) j(test) s
		rename _* *

		foreach var in cash cogx college control kinderprep pka pkb preschool treated {
			rename `var' `var'_`d'_other_race
		}
		
		save neighbors_other_race_circle_`d', replace
}

**Create Neighbors by Distance Missing Race Neighbors

local distance "500 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 15000 20000"

	foreach d of local distance {
	
		clear all
		cd "$repository/data_sets/generated"
		use neighbor_dummies_race_gender
		keep if race_destination == ""
		
		drop if total_meters > `d'
		
		count
		return list
		local num_observations = r(N)
		
		if `num_observations' == 0 {
		
		save neighbors_missing_race_circle_`d', replace
		
		}
		
		else if `num_observations' > 0 {
	
		collapse (sum) pre_cash mid_cash post_cash sl_cash pre_cogx mid_cogx post_cogx ///
		sl_cogx pre_college mid_college post_college sl_college pre_control mid_control ///
		 post_control sl_control pre_kinderprep mid_kinderprep post_kinderprep ///
		 sl_kinderprep pre_pka mid_pka post_pka sl_pka pre_pkb mid_pkb post_pkb ///
		 sl_pkb pre_preschool mid_preschool post_preschool sl_preschool pre_treated ///
		 mid_treated post_treated sl_treated aoy1_cash aoy2_cash aoy3_cash ///
		 aoy4_cash aoy5_cash aoy1_cogx aoy2_cogx aoy3_cogx aoy4_cogx aoy5_cogx ///
		 aoy1_college aoy2_college aoy3_college aoy4_college aoy5_college aoy1_control ///
		 aoy2_control aoy3_control aoy4_control aoy5_control aoy1_kinderprep ///
		 aoy2_kinderprep aoy3_kinderprep aoy4_kinderprep aoy5_kinderprep aoy1_pka ///
		 aoy2_pka aoy3_pka aoy4_pka aoy5_pka aoy1_pkb aoy2_pkb aoy3_pkb aoy4_pkb ///
		 aoy5_pkb aoy1_preschool aoy2_preschool aoy3_preschool aoy4_preschool ///
		 aoy5_preschool aoy1_treated aoy2_treated aoy3_treated aoy4_treated ///
		 aoy5_treated, by(origin_gecc_id randomization_ori )
		 
		reshape long @_cash @_cogx @_college @_control @_kinderprep @_pka @_pkb @_preschool @_treated, i(origin_gecc_id randomization_ori ) j(test) s
		rename _* *

		foreach var in cash cogx college control kinderprep pka pkb preschool treated {
			rename `var' `var'_`d'_missing_race
		}
		
		save neighbors_missing_race_circle_`d', replace
		}
}

**Create Neighbors by Distance White Non-Hispanic Race Neighbors

local distance "500 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 15000 20000"

	foreach d of local distance {
	
		clear all
		cd "$repository/data_sets/generated"
		use neighbor_dummies_race_gender
		keep if race_destination == "White Non-Hispanic"
		
		drop if total_meters > `d'

		collapse (sum) pre_cash mid_cash post_cash sl_cash pre_cogx mid_cogx post_cogx ///
		sl_cogx pre_college mid_college post_college sl_college pre_control mid_control ///
		 post_control sl_control pre_kinderprep mid_kinderprep post_kinderprep ///
		 sl_kinderprep pre_pka mid_pka post_pka sl_pka pre_pkb mid_pkb post_pkb ///
		 sl_pkb pre_preschool mid_preschool post_preschool sl_preschool pre_treated ///
		 mid_treated post_treated sl_treated aoy1_cash aoy2_cash aoy3_cash ///
		 aoy4_cash aoy5_cash aoy1_cogx aoy2_cogx aoy3_cogx aoy4_cogx aoy5_cogx ///
		 aoy1_college aoy2_college aoy3_college aoy4_college aoy5_college aoy1_control ///
		 aoy2_control aoy3_control aoy4_control aoy5_control aoy1_kinderprep ///
		 aoy2_kinderprep aoy3_kinderprep aoy4_kinderprep aoy5_kinderprep aoy1_pka ///
		 aoy2_pka aoy3_pka aoy4_pka aoy5_pka aoy1_pkb aoy2_pkb aoy3_pkb aoy4_pkb ///
		 aoy5_pkb aoy1_preschool aoy2_preschool aoy3_preschool aoy4_preschool ///
		 aoy5_preschool aoy1_treated aoy2_treated aoy3_treated aoy4_treated ///
		 aoy5_treated, by(origin_gecc_id randomization_ori )
		 
		reshape long @_cash @_cogx @_college @_control @_kinderprep @_pka @_pkb @_preschool @_treated, i(origin_gecc_id randomization_ori ) j(test) s
		rename _* *

		foreach var in cash cogx college control kinderprep pka pkb preschool treated {
			rename `var' `var'_`d'_white
		}
		
		save neighbors_white_circle_`d', replace
}

**Merging all distances

clear all
cd "$repository/data_sets/generated"

foreach name in male female black hispanic white other_race missing_race {
clear all
cd "$repository/data_sets/generated"
use neighbors_`name'_circle_500

foreach x in 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 15000 20000 {
merge 1:1 origin_gecc_id test randomization_ori using neighbors_`name'_circle_`x'
drop _merge
}

rename origin_gecc_id child
rename randomization_ori year
tostring year, replace

foreach var of varlist cash_500_`name'-treated_20000_`name' {
replace `var' = 0 if `var' == .
}

save merged_`name'_neigh_count, replace

}



