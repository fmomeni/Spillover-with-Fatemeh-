**Expanding the "distance_treatment" file to include neighbors for all
**years of randomisation

**Adding Second Year of Randomisation
clear all

cd "$repository/data_sets/generated"

use unique_data_clean_for_panel

keep if second_random == 1

rename child origin_gecc_id
keep origin_gecc_id year treatment


merge 1:m origin_gecc_id using corrected_distance_treatment 
drop randomization_ori
rename year randomization_ori
keep if _m == 3
drop _merge

drop cash_ori-treated_ori

foreach treat in cash college control kinderprep pka pkb preschool cogx treated {

gen `treat'_ori = 0
replace `treat'_ori = 1 if treatment == "`treat'"

}

**Prek is going to be considered as CogX
replace cogx_ori = 1 if treatment == "prek"
replace treated_ori = 1 if cash_ori == 1 | college_ori == 1 |  kinderprep_ori == 1 | pka_ori == 1 | pkb_ori == 1 | preschool_ori == 1 | cogx_ori == 1

order total_meters origin_gecc_id destination_gecc_id switched_to_treatment_ori randomization_ori cash_ori  college_ori control_ori kinderprep_ori pka_ori pkb_ori preschool_ori cogx_ori treated_ori

drop treatment




cd "$repository/data_sets/generated"
save distance_treatment_second_random_year, replace 

**Adding Third Year of Randomisation
clear all

cd "$repository/data_sets/generated"

use unique_data_clean_for_panel

keep if third_random == 1

rename child origin_gecc_id
keep origin_gecc_id year treatment


merge 1:m origin_gecc_id using corrected_distance_treatment 
drop randomization_ori
rename year randomization_ori
keep if _m == 3
drop _merge

drop cash_ori-treated_ori

foreach treat in cash college control kinderprep pka pkb preschool cogx treated {

gen `treat'_ori = 0
replace `treat'_ori = 1 if treatment == "`treat'"

}

**Prek is going to be considered as CogX
replace cogx_ori = 1 if treatment == "prek"
replace treated_ori = 1 if cash_ori == 1 | college_ori == 1 |  kinderprep_ori == 1 | pka_ori == 1 | pkb_ori == 1 | preschool_ori == 1 | cogx_ori == 1

order total_meters origin_gecc_id destination_gecc_id switched_to_treatment_ori randomization_ori cash_ori  college_ori control_ori kinderprep_ori pka_ori pkb_ori preschool_ori cogx_ori treated_ori

drop treatment


cd "$repository/data_sets/generated"
save distance_treatment_third_random_year, replace 


**Creating the complete file
use corrected_distance_treatment

cd "$repository/data_sets/generated"

append using distance_treatment_second_random_year
append using distance_treatment_third_random_year 

cd "$repository/data_sets/generated"
save distance_treatment_all_years, replace
