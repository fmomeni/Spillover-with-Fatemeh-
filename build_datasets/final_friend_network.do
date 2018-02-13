***Final Data Set for Friend Network Analysis****


clear all

cd "$repository/data_sets/pre_made"
use share_survey

keep origin_gecc_id 
rename origin_gecc_id child

cd "$repository/data_sets/generated"



merge 1:m child using table34_unique_data_clean

****6 out of of the 187 kids in the list were not matched to the overall sample of control kids:
	**the most recent status of 3 of the 6 kids (2443, 2768, 3154) was "treated" according to the randomization file list, so they cannot be counted as control
	**the other 3 kids were randomized into control, but possibly did not satisfy some of the criteria used to construct the sample of unique control kids (e.g. they had zero observations beyond pre for both cog and non-cog)

keep if _m == 3


**Calculating average cog and non-cog scores
replace std_cog = . if has_cog == 0
replace std_ncog = . if has_ncog == 0

sort child test
collapse (mean) std_cog std_ncog, by(child)

rename child origin_gecc_id


**Merge with Friend Count
merge 1:1 origin_gecc_id using merged_origin_destination_friend

keep if _m == 3

rename origin_gecc_id child

drop _m

**Merge into Final Dataset
merge 1:1 child using unique_most_recent_treatment

keep if _m == 3

keep child-treatment has_cog_pre has_ncog_pre cog_pre ncog_pre std_cog_pre std_ncog_pre age_pre race gender 

save final_friend_network, replace
