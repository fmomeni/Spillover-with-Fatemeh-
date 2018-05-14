clear all
clear mata
set more off

//run teacher use

do "$repository/build_datasets/teacherease/code/cleaning_classroom.do"


//run all files in folder 
foreach file in unique_most_recent_treatment  treat_status_destination_friends relevant_variab_distance_census_for_merge relevant_unique_data_clean corrected_distance_treatment multiple_year_distance_treatment multiple_year_neighbors_assessment_dummy average_neighbor_scores_treatment_length multiple_year_neighbor_countby_distance merg_neigh_count_distances extract_gender_race neighbors_gender_race_merged extracting_pre_scores creating_panel merge_unique_data_neighbors neighbor_count_rings final_friend_network {
	cd "$repository/build_datasets/"
	do "`file'".do
}
