**Create Neighbor Count Dummies by Rings


clear all


cd "$repository/data_sets/generated"
use neighbor_count_by_oriassessments_dummies_Fatemeh_all_years

**Create Neighbors by Distance Boys_Boys
local distance "0 10000 20000 30000 40000"


	foreach d of local distance {
	
		clear
		cd "$repository/data_sets/generated"
		use neighbor_count_by_oriassessments_dummies_Fatemeh_all_years
		local upper_dist = `d' + 10000
		
		keep if (total_meters >= `d' & total_meters < `upper_dist')

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
		 aoy5_treated, by(origin_gecc_id randomization_ori)
		 
		reshape long @_cash @_cogx @_college @_control @_kinderprep @_pka @_pkb @_preschool @_treated, i(origin_gecc_id randomization_ori) j(test) s
		rename _* *

		foreach var in cash cogx college control kinderprep pka pkb preschool treated {
			rename `var' `var'_`d'_`upper_dist'
		}
		
		cd "$repository/data_sets/generated"
		save circle_`d'_`upper_dist', replace
}



**Merging neighbour count by rings

clear all

cd "$repository/data_sets/generated"
use circle_0_10000

foreach x in 10000_20000 20000_30000 30000_40000 40000_50000 {
merge 1:1 origin_gecc_id test randomization_ori using circle_`x'
drop _merge
}

rename origin_gecc_id child
rename randomization_ori year
tostring year, replace

foreach var of varlist cash_0_10000-treated_40000_50000 {
replace `var' = 0 if `var' == .
}

save merged_neigh_count_rings, replace
