clear all
clear mata
set more off

*************IMPORTANT***********************************
*Change the paths to match path on your computer locally*
*********************************************************


//Change to the directory where the file "run_project.do" is located
cd "C:\Users\fatemeh\Documents\GitHub\Spillover"

//Path of Main Folder
global repository `c(pwd)'

*********************************************************
//set opearating system
*********************************************************
global os `c(os)'

*********************************************************
//Run all code in all folders in correct order

foreach folder in build_datasets analysis {
	cd "$repository/`folder'
	do "run_directory".do
}

di "KLAAR"
