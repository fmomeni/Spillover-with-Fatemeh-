//KEEP VARIABLES FROM THE DISTANCE AND CENSUS BLOCK FILES THAT WILL BE RELEVANT
//FOR THE REGRESSION ANALYSIS

clear all

cd "$repository/data_sets/pre_made"

use DistToSchool_1
*We will be using the variable child as identifier 
drop gecc_id

cd "$repository/data_sets/generated"
save Relevant_DistToSchool_1, replace

clear

cd "$repository/data_sets/pre_made"
use DistToSchool_2
*We will be using the variable child as identifier
drop gecc_id

cd "$repository/data_sets/generated"
save Relevant_DistToSchool_2, replace

clear 

cd "$repository/data_sets/pre_made"
use censusblock_checc

rename gecc_id child
*Only blockgroup variable is relevant
keep child blockgroup

cd "$repository/data_sets/generated"
save Relevant_censusblock_checc, replace
