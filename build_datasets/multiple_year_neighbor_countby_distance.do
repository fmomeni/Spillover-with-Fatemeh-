*Purpose: count the neighbors by treatment within different distances

clear all

cd "$repository/data_sets/generated"

use neighbor_count_by_oriassessments_dummies_Fatemeh_all_years

*set radii
local distance " 500 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 15000 20000" 

foreach d of local distance {

	clear all 
	cd "$repository/data_sets/generated"
	use neighbor_count_by_oriassessments_dummies_Fatemeh_all_years

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
	 aoy5_treated, by(origin_gecc_id randomization_ori)
	 
	reshape long @_cash @_cogx @_college @_control @_kinderprep @_pka @_pkb @_preschool @_treated, i(origin_gecc_id randomization_ori) j(test) s
	rename _* *
	
	foreach var in cash cogx college control kinderprep pka pkb preschool treated {
		rename `var' `var'_`d'
	}
	
	cd "$repository/data_sets/generated"
	save all_years_circle_`d', replace
		
}
