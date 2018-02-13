**Expanding the "distance_treatment" file to include neighbors for all
**years of randomisation

**Adding Second Year of Randomisation
clear all

cd "$repository/data_sets/generated"

use unique_data_clean_for_panel

keep if second_random == 1

rename child origin_gecc_id
keep origin_gecc_id year

cd "$repository/data_sets/pre_made"

merge 1:m origin_gecc_id using distance_treatment 
drop randomization_ori
rename year randomization_ori
keep if _m == 3
drop _merge

cd "$repository/data_sets/generated"
save distance_treatment_second_random_year, replace 

**Adding Third Year of Randomisation
clear all

cd "$repository/data_sets/generated"

use unique_data_clean_for_panel

keep if third_random == 1

rename child origin_gecc_id
keep origin_gecc_id year treatment

cd "$repository/data_sets/pre_made"
merge 1:m origin_gecc_id using distance_treatment 
drop randomization_ori
rename year randomization_ori
keep if _m == 3
drop _merge


cd "$repository/data_sets/generated"
save distance_treatment_third_random_year, replace 


cd "$repository/data_sets/pre_made"
**Creating the complete file
use distance_treatment

cd "$repository/data_sets/generated"

append using distance_treatment_second_random_year
append using distance_treatment_third_random_year 

cd "$repository/data_sets/generated"
save distance_treatment_all_years, replace
