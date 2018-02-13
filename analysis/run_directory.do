clear all
clear mata
set more off

//run all files in folder 
foreach file in create_table34 create_table56 create_main_table7 table8spillover_gender table9spillover_boyboy table10spillover_girlgirl table11spillover_race table12spillover_hisphisp table13spillover_blackblack table1415 table16_mechanism table1718_friend_network tables_appendix tables_newversion {
	cd "$repository/analysis/code/"
	do "`file'".do
}
