***Creating Unique Data Clean by Most Recent Treatment Status

clear all

cd "$repository/data_sets/pre_made"

use updated_unique_data_clean



sort child year
quietly by child:  gen dup = cond(_N==1,0,_n)


**Keeping most recent treatment status
** For those randomised once, their variable is coded as dup == 0, For those randomised twice, their most recent status is coded as dup == 2, finally for kid 1109
** randomised 3 times, his most recent status is coded as dup == 3
keep if (dup == 0 | dup == 2 | dup == 3)  

drop if child ==1109 & dup == 2


cd "$repository/data_sets/generated"

save unique_most_recent_treatment, replace 

