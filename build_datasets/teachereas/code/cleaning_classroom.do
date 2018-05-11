***********************
**CLASSROOM NEIGHBORS**
***********************

/*This file generates for each origin CHECC kid his or her 
number of neighbors (by subject and trimester) at AOY asessments 
according to the composition of the class he or she is attending. We have chosen
to look at classroom composition in trimesters 1 and 2, as AOY asessments occurs
in April of year year which is the start of trimester 3.
*/

/* To do this I have used several input files from TeacherEase Data provided to me by Reuben
as well as cleaned CHECC data on year of randomisation and type of treatment. */

/* The variable that identifies each single class is CLASSID. Some students have attended the same subject within
a trimester but with different classids. This happens:

a) if a student switches sections within the same school and same semester
b) if a student switches schools within the same semester
c) a combination of both

In such cases (about 3.5% both for trimesters 1 and 2) we take the average number of neighbors whenever
there are multiple entries for students of type a), b) or c)
*/

***********************************
**STEP 1: Create Additional Data Files
***********************************


*1)Last type of treatment

*Each CHECC kid is matched with his last type of treatment as that is ultimately
*the type of treatment that should be considered for AOY assessments. So if a kid
*was randomized twice, their second treatment is considered.

clear all

local input_dir "$repository/build_datasets/teacherease/"
local output_dir "$repository/build_datasets/teacherease/output"

cd "`input_dir'"
use unique_data_clean_for_panel

*Data sorted already by CHECC number and year of randomisation
gen randomised_twice = (child == child[_n+1])
replace randomised_twice = 1 if child == child[_n-1]

*Keep only second treatment for those randomised twice
keep if second_random == 1 | randomised_twice == 0

keep child treatment 

cd "`output_dir'"

save most_recent_treatmennt, replace


*2)First Year of Randomisation

clear all

local input_dir "$repository/build_datasets/teacherease/"
local output_dir "$repository/build_datasets/teacherease/output"


cd "`input_dir'"
use unique_data_clean_for_panel

*Keeps only first randomisation entry
duplicates drop child, force 
keep year child 
rename year random_year

cd "`output_dir'"
save first_random_year, replace

*3)Second Year of Randomisation

clear all

local input_dir "$repository/build_datasets/teacherease/"
local output_dir "$repository/build_datasets/teacherease/output"

cd "`input_dir'"
use unique_data_clean_for_panel

keep if second_random == 1
keep year child 
rename year random_year

cd "`output_dir'"
save second_random_year, replace

*4)Third Year of Randomisation**

clear all

local input_dir "$repository/build_datasets/teacherease/"
local output_dir "$repository/build_datasets/teacherease/output"

cd "`input_dir'"
use unique_data_clean_for_panel

keep if third_random == 1
keep year child 
rename year random_year

cd "`output_dir'"
save third_random_year, replace


*4) Modify Crosswalk by Renaming Student Number

clear all

local input_dir "$repository/build_datasets/teacherease/"
local output_dir "$repository/build_datasets/teacherease/output"

cd "`input_dir'"

use crosswalk_all

rename studentnumber studentnumber2
save crosswalk_all2, replace


*5)Date of Birth in the Correct Format

clear all 

local input_dir "$repository/build_datasets/teacherease/"
local output_dir "$repository/build_datasets/teacherease/output"

cd "`input_dir'"

import delimited "`input_dir'/teacherease_birthdates.csv", varnames(1) clear
drop if mi(studentnumber)
duplicates drop
duplicates drop studentnumber, force //drops three kids whose birthdays are unknown
rename birthdate child_birthday
gen temp = date(child_birthday, "MDY")
drop child_birthday
rename temp child_birthday
format child_birthday %td

cd "`output_dir'"

save birth_dates.dta, replace


*****************************************************
**Step 2: Appending Data from Schools and Trimesters*
*****************************************************

clear all
set more off 


*1)Appending Data from Schools and Trimesters

local input_dir "$repository/build_datasets/teacherease/"
local output_dir "$repository/build_datasets/teacherease/output"

cd "`input_dir'"

local files: dir . files "*.dta"
local not crosswalk_all.dta
local files: list files- not

foreach file in `files' {
	di "`file'"
	append using `file', force
}

save `output_dir'/appended_teacherease.dta, replace

*****************************************************
**Step 3: Cleaning***********************************
*****************************************************

clear all 

local input_dir "$repository/build_datasets/teacherease/"
local output_dir "$repository/build_datasets/teacherease/output"


cd "`output_dir'"
use appended_teacherease.dta

*Drop observations with missing first and last name - unidentfiable
drop if lastname == "" & firstname == ""

*Kennedy School - assuming that pe-algebra 7 just another name for math 7 and literature for 7/8 is the same as reading
	replace classdescription = classdescription + " " + regexs(0) if school == "kennedy" & ///
		(classdescription == "PRE-ALGEBRA" | classdescription == "LITERATURE")
	replace classdescription = subinstr(classdescription, "PRE-ALGEBRA", "Mathematics", .) if school == "kennedy"
	replace classdescription = subinstr(classdescription, "LITERATURE", "Reading", .) if school == "kennedy"
	replace classdescription = "Mathematics 8" if classdescription == "ALGEBRA HONORS BLOOM"
	
	
*Drop Non Grade Specific Classes - uninformative composition
	drop if regexm(classdescription, "(Non Grade Specific)")
	drop if regexm(classdescription, "(Non grade-specific)")
	drop if regexm(classdescription, "(Non Grade specific)")


*All class descriptions lower case
replace classdescription = lower(classdescription)

foreach var of varlist classdescription firstname middleinitial lastname {
 
	replace `var' = lower(`var')
}

*Drop any minor classes
keep if regexm(classdescription, "writing") == 1 | ///
	regexm(classdescription, "mathematics") == 1 | ///
	regexm(classdescription, "music") == 1 | ///
	regexm(classdescription, "physical education") == 1 | ///
	regexm(classdescription, "reading") == 1 | ///
	regexm(classdescription, "science/health") == 1 | ///
	regexm(classdescription, "social studies") == 1 | ///
	regexm(classdescription, "handwriting") == 1 | ///
	regexm(classdescription, "social development") == 1 | ///
	regexm(classdescription, "spelling") == 1 |  ///
	regexm(classdescription, "math") == 1 | ///
	regexm(classdescription, "social and emotional learning") == 1 | ///
	regexm(classdescription, "science") == 1 | ///
	regexm(classdescription, "media") == 1 | ///
	regexm(classdescription, "language arts") == 1 | ///
	regexm(classdescription, "general reading") == 1 | ///
	regexm(classdescription, "general math") == 1 | ///
	regexm(classdescription, "foreign language") == 1 | ///
	regexm(classdescription, "advanced reading") == 1 | ///
	regexm(classdescription, "algebra") == 1 | ///
	regexm(classdescription, "advanced mathematics") == 1

	
replace classdescription = "MUS" if strpos(classdescription, "music") > 0
replace classdescription = "PE" if strpos(classdescription, "physical education") > 0
replace classdescription = "ALG" if strpos(classdescription, "algebra") > 0
replace classdescription = "FL" if strpos(classdescription, "foreign language") > 0
replace classdescription = "HW" if strpos(classdescription, "handwriting") > 0
replace classdescription = "LA" if strpos(classdescription, "language arts") > 0
replace classdescription = "MAT" if strpos(classdescription, "mathematics") > 0
replace classdescription = "MAT" if strpos(classdescription, "math") > 0
replace classdescription = "R" if strpos(classdescription, "reading") > 0
replace classdescription = "SH" if strpos(classdescription, "science/health") > 0
replace classdescription = "SEL" if strpos(classdescription, "social and emotional learning") > 0
replace classdescription = "SS" if strpos(classdescription, "social studies") > 0
replace classdescription = "SP" if strpos(classdescription, "spelling") > 0
replace classdescription = "W" if strpos(classdescription, "writing") > 0
replace classdescription = "MED" if strpos(classdescription, "media") > 0
replace classdescription = "SD" if strpos(classdescription, "social development") > 0

save appended_teacherease_temp.dta, replace

cd "`output_dir'"

*Merge on Birthdates
merge m:1 studentnumber using birth_dates

*Drop those kids with birth dates who do not appear in our sample of schools
drop if _m == 2

drop _m

*Drop kids that have duplicate observations on the same classid year and trimester: this is a duplicate entry
duplicates drop year gradingperioddescription firstname lastname classid child_birthday, force

*Tag kids that switch between sections/schools for the same subject and same grading period (year & trimester)
duplicates tag year gradingperioddescription firstname lastname classdescription child_birthday, gen(dup_same_subj) 

*Drop class composition for 3rd Trimester as AOY occurs at the beginning of third trimester; hence 
*what matters is class composition in the previous two semesters 

drop if gradingperioddescription == "T3"

keep year gradingperioddescription studentnumber lastname firstname middleinitial classdescription classid school dup_same_subj classsection child_birthday

rename middleinitial studentmiddlename

cd "`input_dir'"

*Merge on CHECC ID 
merge m:1 lastname firstname studentmiddlename child_birthday using crosswalk_all2.dta

*Drop those CHECC kids that do not appear in our teacher ease data
drop if _m == 2
drop _m

*Assign a number of 0 for non-CHECC kids
replace child = 0 if mi(child)

cd "`output_dir'"

save appended_teacherease_temp2.dta, replace

*****************************************************
**Step 4: Counting Neighbors*************************
*****************************************************

clear all 

local input_dir "$repository/build_datasets/teacherease/"
local output_dir "$repository/build_datasets/teacherease/output"

cd "`output_dir'"

use appended_teacherease_temp2

*Merge on assignment 
merge m:1 child using most_recent_treatmennt

*Drop CHECC kids not in teacher ease data
drop if _m == 2
drop _m

*Generate Dummies for Type of Treatment 
gen non_checc = (treatment == "")

foreach treat in cash cogx college control kinderprep pka pkb preschool  {

gen `treat' = (treatment == "`treat'")

}

replace cogx = 1 if treatment == "prek"

*Gen Number of Neighbors by ClassID

foreach treat in cash cogx college control kinderprep pka pkb preschool non_checc  {

bysort year gradingperioddescription classid school: egen n_`treat' = sum(`treat')

}

bysort year gradingperioddescription classid school: gen n_students = _N

*Gen Number of Neighbors for each kid by ClassID

foreach treat in cash cogx college control kinderprep pka pkb preschool non_checc  {

gen n_`treat'_kid = n_`treat'
replace n_`treat'_kid = n_`treat' - 1 if `treat' == 1

}

*If kid attended the same subjects within the same year and semester, take the average number of neighbors

foreach treat in cash cogx college control kinderprep pka pkb preschool non_checc  {

bysort year gradingperioddescription firstname lastname classdescription child_birthday: egen mean_n_`treat'_kid = mean(n_`treat'_kid)

}

*For these kids, replace n_treat_kid with the average

foreach treat in cash cogx college control kinderprep pka pkb preschool non_checc  {

replace n_`treat'_kid =  mean_n_`treat'_kid if n_`treat'_kid !=  mean_n_`treat'_kid

}

*Rename the neighbor variables to reduce number of characters
drop n_cash-n_non_checc
foreach treat in cash cogx college control kinderprep pka pkb preschool non_checc  {
	rename n_`treat'_kid n_`treat'
	
}

*Keep only the first observation
duplicates drop year gradingperioddescription firstname lastname classdescription child_birthday, force

*Keep the relevant variables
keep year gradingperioddescription lastname firstname studentmiddlename studentnumber classdescription classsection classid school child_birthday child treatment n_non_checc n_preschool n_pkb n_pka n_kinderprep n_control n_college n_cogx n_cash n_students dup_same_subj

cd "`output_dir'"

save appended_teacherease_temp3.dta, replace

*****************************************************
**Step 5: Defining AOY Asessments********************
*****************************************************

//A)When AOY occurs according to first year of randomisation

clear all 

local input_dir "$repository/build_datasets/teacherease/"
local output_dir "$repository/build_datasets/teacherease/output"

cd "`output_dir'"

use appended_teacherease_temp3

*Merge on First Year of Randomization to determine when AOY assessments occur
merge m:1 child using first_random_year
 
keep if _m == 3
drop _m

destring random_year, replace

gen quarter_subject = gradingperiod + "_" + classdescription

drop gradingperioddescription  classdescription  classsection classid school dup_same_subj 

*Create unique entries per CHECC ID by year, trimester and class
reshape wide n_students n_cash n_cogx n_college n_control n_kinderprep n_pka n_pkb n_preschool n_non_checc, i(lastname firstname studentmiddlename child_birthday random_year treatment child year) j(quarter_subject) s


**Gen AOY variables

gen test = "."

replace test = "aoy1" if year == random_year + 1
replace test = "aoy2" if year == random_year + 2
replace test = "aoy3" if year == random_year + 3
replace test = "aoy4" if year == random_year + 4
replace test = "aoy5" if year == random_year + 5
replace test = "aoy6" if year == random_year + 6
replace test = "aoy7" if year == random_year + 7

drop year lastname firstname studentmiddlename child_birthday treatment studentnumber
rename random_year year

cd "`output_dir'"

save neighbor_class_first.dta, replace 

//B)When AOY occurs according to second year of randomisation

clear all 

local input_dir "$repository/build_datasets/teacherease/"
local output_dir "$repository/build_datasets/teacherease/output"

cd "`output_dir'"

use appended_teacherease_temp3

**Merge on Second Year of Randomization to determine when AOY assessments occur
merge m:1 child using second_random_year
 
keep if _m == 3
drop _m

destring random_year, replace

gen quarter_subject = gradingperiod + "_" + classdescription

drop gradingperioddescription  classdescription  classsection classid school dup_same_subj 

*Create unique entries per CHECC ID by year, trimester and class
reshape wide n_students n_cash n_cogx n_college n_control n_kinderprep n_pka n_pkb n_preschool n_non_checc, i(lastname firstname studentmiddlename child_birthday random_year treatment child year) j(quarter_subject) s

*Gen AOY variables

gen test = "."

replace test = "aoy1" if year == random_year + 1
replace test = "aoy2" if year == random_year + 2
replace test = "aoy3" if year == random_year + 3
replace test = "aoy4" if year == random_year + 4
replace test = "aoy5" if year == random_year + 5
replace test = "aoy6" if year == random_year + 6
replace test = "aoy7" if year == random_year + 7

drop year lastname firstname studentmiddlename child_birthday treatment studentnumber
rename random_year year

cd "`output_dir'"

save neighbor_class_second.dta, replace


//B)When AOY occurs according to third year of randomisation

clear all 

local input_dir "$repository/build_datasets/teacherease/"
local output_dir "$repository/build_datasets/teacherease/output"

cd "`output_dir'"

use appended_teacherease_temp3

**Merge on Third Year of Randomization to determine when AOY assessments occur
merge m:1 child using third_random_year
 
keep if _m == 3
drop _m

destring random_year, replace

gen quarter_subject = gradingperiod + "_" + classdescription

drop gradingperioddescription  classdescription  classsection classid school dup_same_subj 

*Create unique entries per CHECC ID by year, trimester and class
reshape wide n_students n_cash n_cogx n_college n_control n_kinderprep n_pka n_pkb n_preschool n_non_checc, i(lastname firstname studentmiddlename child_birthday random_year treatment child year) j(quarter_subject) s

*Gen AOY variables

gen test = "."

replace test = "aoy1" if year == random_year + 1
replace test = "aoy2" if year == random_year + 2
replace test = "aoy3" if year == random_year + 3
replace test = "aoy4" if year == random_year + 4
replace test = "aoy5" if year == random_year + 5
replace test = "aoy6" if year == random_year + 6
replace test = "aoy7" if year == random_year + 7

drop year lastname firstname studentmiddlename child_birthday treatment studentnumber
rename random_year year

cd "`output_dir'"

save neighbor_class_third.dta, replace

*Append all

clear all

local input_dir "$repository/build_datasets/teacherease/"
local output_dir "$repository/build_datasets/teacherease/output"

cd "`output_dir'"

use neighbor_class_first
append using neighbor_class_second
append using neighbor_class_third

sort child year
order child year test

drop if (test == "aoy5" | test == "aoy6" | test == ".")

cd "$repository/data_sets/generated"

save neighbor_class_multiple_years, replace
