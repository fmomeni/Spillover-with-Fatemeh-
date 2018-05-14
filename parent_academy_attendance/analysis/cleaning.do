*This file cleans parent attendance data for both parent academy (2010,2011) and cogX treatments (2012,2012)
*All data are appended in the end.
*We define three main attendance variables:
*-percentage attendance = proportion of parent sessions attended
*-total number of hours1 = total number of hours spent in sessions (if tardy, do NOT deduct 30 minutes)
*-total number of hours2 = total number of hours spent in sessions (if tardy, deduct 30 minutes)

*Total number of hours2 differs only for years 2012,2013 where tardiness was recorded



clear all
clear mata
set more off

*************IMPORTANT***********************************
*Change the paths to match path on your computer locally*
*********************************************************


//Change to the directory where the "input" and "output" files are located


//Path of Main Folder
global repository_attendance `c(pwd)'

*********************************************************
//set opearating system
*********************************************************
global os `c(os)'


*********************************************************
//Cleaning Parent Academy - NON KP
*********************************************************

clear all
set more off 

*************
// Directory*
*************
local input_dir "$repository_attendance/input/"
local output_dir "$repository_attendance/output/"

******
*2010*
******
cd `input_dir'
import delimited attendance_2010_pa.csv

drop if mi(child)

//generate year variable
gen year = "2010"

//generate percent attended
foreach var of varlist v6-v21 {
	destring `var', replace
	replace `var' = 0 if mi(`var')
	replace `var' = 1 if `var' != 0 //count tardy as attended
	gen attendance_hours`var'1 = 1.5 if `var' == 1
	replace attendance_hours`var'1 = 0 if `var' == 0
}

egen attendance_pa_perc = rowmean(v6-v21)
replace attendance_pa_perc = attendance_pa_perc*100

egen attendance_total_hours1 = rowtotal(attendance_hoursv6-attendance_hoursv21)
gen attendance_total_hours2 = attendance_total_hours1
 


//generate attendance dummy
gen attendance_pa_dummy = 0 
replace attendance_pa_dummy = 1 if attendance_pa_perc != 0

keep child attendance_pa_perc attendance_pa_dummy year attendance_total_hours1 attendance_total_hours2

cd `output_dir'
save 2010_pa.dta, replace

******
*2011*
******
cd `input_dir'
import delimited attendance_2011_pa.csv, clear

//generate year variable
gen year = "2011"

drop v20 v21 //no one attended

//generate percent attended
foreach var of varlist v2-v19 {
	replace `var' = 0 if mi(`var')
	replace `var' = 1 if `var' != 0 //count tardy as attended
	gen attendance_hours`var'1 = 1.5 if `var' == 1
	replace attendance_hours`var'1 = 0 if `var' == 0
}

egen attendance_pa_perc = rowmean(v2-v19)
replace attendance_pa_perc = attendance_pa_perc*100

egen attendance_total_hours1 = rowtotal(attendance_hoursv2-attendance_hoursv19)
gen attendance_total_hours2 = attendance_total_hours1


//generate attendance dummy
gen attendance_pa_dummy = 0
replace attendance_pa_dummy = 1 if attendance_pa_perc != 0

keep child attendance_pa_perc attendance_pa_dummy year attendance_total_hours1 attendance_total_hours2

cd `output_dir'
save 2011_pa.dta, replace

******
*2012*
******
cd `input_dir'
import delimited attendance_2012_pa.csv, clear

//generate year variable
gen year = "2012"

//generate percent attended
foreach var of varlist v3-v16 {


	gen attendance_hours`var'1 = "1.5" if `var' == "Present" | `var' == "Tardy"
	replace attendance_hours`var'1 = "0" if attendance_hours`var'1 != "1.5"
	gen attendance_hours`var'2 = "1.5" if `var' == "Present"
	replace attendance_hours`var'2 = "1" if `var' == "Tardy"
	replace attendance_hours`var'2 = "0" if attendance_hours`var'2 != "1.5" & attendance_hours`var'2 != "1" 	
	replace `var' = "1" if `var' == "Present" | `var' == "Tardy"
	replace `var' = "0" if `var' != "1"

	destring `var' attendance_hours`var'1 attendance_hours`var'2, replace
}

egen attendance_pa_perc = rowmean(v3-v16)
replace attendance_pa_perc = attendance_pa_perc*100

egen attendance_total_hours1 = rowtotal(attendance_hoursv31-attendance_hoursv161)
egen attendance_total_hours2 = rowtotal(attendance_hoursv32-attendance_hoursv162)

//generate attendance dummy
gen attendance_pa_dummy = 0
replace attendance_pa_dummy = 1 if attendance_pa_perc !=0

keep child year attendance_pa_perc attendance_pa_dummy attendance_total_hours1 attendance_total_hours2 

cd `output_dir'
save 2012_pa.dta, replace

******
*2013*
******
cd `input_dir'
import delimited attendance_2013_pa.csv, clear

//generate year variable
gen year = "2013"

//generate percent attended
foreach var of varlist v4-v18 {

	gen attendance_hours`var'1 = "1.5" if regexm(`var', "[Pp]") | regexm(`var', "[Ll]")
	replace attendance_hours`var'1 = "0" if attendance_hours`var'1 != "1.5"
	gen attendance_hours`var'2 = "1.5" if regexm(`var', "[Pp]")
	replace attendance_hours`var'2 = "1" if regexm(`var', "[Ll]")
	replace attendance_hours`var'2 = "0" if attendance_hours`var'2 != "1.5" & attendance_hours`var'2 != "1" 	


	replace `var' = "1" if regexm(`var', "[Pp]") | regexm(`var', "[Ll]") 
	replace `var' = "0" if `var' != "1"
	
	destring `var' attendance_hours`var'1 attendance_hours`var'2, replace
}

egen attendance_pa_perc = rowmean(v4-v18)
replace attendance_pa_perc = attendance_pa_perc*100

egen attendance_total_hours1 = rowtotal(attendance_hoursv41-attendance_hoursv181)
egen attendance_total_hours2 = rowtotal(attendance_hoursv42-attendance_hoursv182)

//generate attendance dummy 
gen attendance_pa_dummy = 0
replace attendance_pa_dummy = 1 if attendance_pa_perc != 0

rename checc_id child
keep child year attendance_pa_perc attendance_pa_dummy attendance_total_hours1 attendance_total_hours2

cd `output_dir'
save 2013_pa.dta, replace


*********************************************************
//Cleaning Parent Academy - KP
*********************************************************

clear all 

******
*2012*
******
cd `input_dir'
import delimited attendance_2012_kp_pa.csv

gen year = "2012_KP"

//generate percent attended
egen set1 = rowtotal(jun-v4) //group in sets because parents have to only attend 1 of every 3 sessions
egen set2 = rowtotal(v5-v7)
egen set3 = rowtotal(jul-v10)
egen set4 = rowtotal(v11-v13)
egen set5 = rowtotal(v14-aug)

egen attendance_pa_perc = rowmean(set1-set5)
replace attendance_pa_perc = attendance_pa_perc*100
rename checc_id child

foreach num in 1 2 3 4 5 {
gen set_`num'hour = 1.5 if set`num' == 1
replace set_`num'hour = 0 if set`num' != 1
}

egen attendance_total_hours1 = rowtotal(set_1hour-set_5hour)
gen attendance_total_hours2 = attendance_total_hours1


//generate attendance dummy
gen attendance_pa_dummy = 0
replace attendance_pa_dummy = 1 if attendance_pa_perc != 0

keep child year attendance_pa_perc attendance_pa_dummy attendance_total_hours1 attendance_total_hours2

cd `output_dir'
save 2012_kp_pa.dta, replace

******
*2013*
******
cd `input_dir' 
import delimited attendance_2013_kp_pa.csv, clear

gen year = "2013_KP"

//generate attendance
egen set1 = rowtotal(v2-v3)
egen set2 = rowtotal(v4-v5)
egen set3 = rowtotal(v6-v7)

egen attendance_pa_perc = rowmean(set1-set3)
replace attendance_pa_perc = attendance_pa_perc*100

foreach num in 1 2 3 {
gen set_`num'hour = 1.5 if set`num' == 1
replace set_`num'hour = 0 if set`num' != 1
}

egen attendance_total_hours1 = rowtotal(set_1hour-set_3hour)
gen attendance_total_hours2 = attendance_total_hours1

//generate attendance dummy
gen attendance_pa_dummy = 0
replace attendance_pa_dummy = 1 if attendance_pa_perc != 0

rename checc_id child
keep child year attendance_pa_perc attendance_pa_dummy attendance_total_hours1 attendance_total_hours2

cd `output_dir'
save 2013_kp_pa.dta, replace

*********************************************************
//Appending All Data
*********************************************************


cd `output_dir'
use 2010_pa.dta

foreach yr in 2011 2012 2013 {
	append using `yr'_pa.dta
}

foreach yr in 2012 2013 {
	append using `yr'_kp_pa.dta
}


gen treatment = "parent" if year == "2010" | year == "2011"
replace treatment = "cogX" if year == "2012" | year == "2013"
replace treatment = "kinderprep" if year == "2012_KP" | year == "2013_KP"

gen parent = (treatment == "parent")

save attendance_pa.dta, replace
