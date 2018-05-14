
**15,000, 20, 000


//MERGING NEIGHBORHOOD COUNTS FOR DIFFERENT DISTANCES 
**This use multiple years neighborhood counts generated for radii: 500, 1000, 2000
**3000, 4000, 5000, 6000, 7000, 8000, 9000, 10000, 15000, 20000


clear all

cd "$repository/data_sets/generated"

use all_years_circle_500

foreach x in 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 {
merge 1:1 origin_gecc_id randomization_ori test using all_years_circle_`x'
drop _merge
}

rename origin_gecc_id child
rename randomization_ori year
tostring year, replace

foreach var of varlist cash_500-treated_10000 {
replace `var' = 0 if `var' == .
}

cd "$repository/data_sets/generated"
save merged_neigh_count_incomplete, replace
