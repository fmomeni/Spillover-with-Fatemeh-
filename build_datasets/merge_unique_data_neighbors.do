** FILE FOR REGRESSIONS

clear all

cd "$repository/data_sets/generated"

use table34_unique_data_clean

**Merging with number of neighbours

merge 1:1 child test year using merged_neigh_count

**Dropping observations not pertaining to our analytical sample
drop if _merge == 2

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

save table56_unique_data_clean, replace
