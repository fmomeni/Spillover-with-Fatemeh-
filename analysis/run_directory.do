clear all
clear mata
set more off

//run all files in folder 
foreach folder in tables_pre_number_treated tables_no_pre_number_treated tables_pre_percentage_treated tables_no_pre_percentage_treated {
foreach file in create_table34 create_table56 create_main_table7 table8spillover_gender table9spillover_boyboy table10spillover_girlgirl table11spillover_race table11a table12spillover_hisphisp table13spillover_blackblack table1415 table16_mechanism tables_appendix tables_newversion {
	cd "$repository/analysis/code/`folder'"
	do "`file'".do
}
}
