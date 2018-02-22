******TABLES 3 and 4 **************

clear all

cd "$repository/data_sets/generated"

use table34_unique_data_clean

drop if test =="pre"

merge 1:1 child test year using merged_neigh_count

keep if _merge == 3

drop _merge

***********************************************************************************
**If want to reproduce table restricting sample to control kids, add the code below


keep if (C == 1 & first_random == 1) | (CC == 1 & first_random == 1) | (CT_pretreat == 1) | (CK_prekinder == 1)


***********************************************************************************

**Create Table 3
file open file0 using "$repository/analysis/tables/tables_no_pre_number_treated/table3.tex", replace write


file write file0 "\documentclass[11pt]{article}"
file write file0 _n "\usepackage{booktabs, multicol, multirow}"
file write file0 _n "\usepackage{caption}"
file write file0 _n "\userpackage[flushleft]{threeparttable}"
file write file0 _n	"\begin{document}"

file write file0 _n	"\begin{table}[h]"
file write file0 _n	"\begin{threeparttable}"
file write file0 _n	"\centering"
file write file0 _n	"\caption{Assessments}"

file write file0 _n	"\label{tab:Nassess}"
file write file0 _n	"\begin{tabular}{c|cc|cc}"
file write file0 _n	"Assessment & $N_{Cog}$ & Cog Score &$N_{Noncog}$ &Non-Cog Score \\"
file write file0 _n	"\toprule"
file write file0 _n	"\midrule"

local i = 1
local j = 1

foreach x in cog ncog {
	tabstat std_`x' if has_`x' == 1, by(test) save stat(mean semean n)
	foreach stat in Stat5 Stat6 Stat7 Stat1 Stat2 Stat3 Stat4 {
		mat a = r(`stat')
		local item`i' = string(a[3,1], "%13.0gc") //Num of observations
		local i = `i' + 1
		local item`i' = string(round(a[1,1], 0.0001), "%13.0gc") //Mean
		local i = `i' + 1
		local item`i' = string(round(a[2,1], 0.0001), "%13.0gc") //Standard Error
		local i = `i' + 1
		mat b = r(StatTotal)
		local itemtotal`j' = string(b[3,1], "%13.0gc")
		local j = `j' + 1
		}
}

file write file0 _n	"\multirow{2}{*}{Mid } & \multirow{2}{*}{`item1'} & `item2' & \multirow{2}{*}{`item22'} & `item23'\\"
file write file0 _n	"& & (`item3') & & (`item24')\\"
file write file0 _n	"& & & & \\"
file write file0 _n	"\multirow{2}{*}{Post } & \multirow{2}{*}{`item4'} & `item5' & \multirow{2}{*}{`item25'} & `item26'\\"
file write file0 _n	"& & (`item6') & & (`item27')\\"
file write file0 _n	"& & & & \\"
file write file0 _n	"Summer Loss & \multirow{2}{*}{`item7'} & `item8' & \multirow{2}{*}{`item28'} & `item29'\\"
file write file0 _n	"& & (`item9') & & (`item30')\\"
file write file0 _n	"& & & & \\"
file write file0 _n	"Aged-Out Year 1 & \multirow{2}{*}{`item10'} & `item11' & \multirow{2}{*}{`item31'} & `item32' \\"
file write file0 _n	"& & (`item12') & & (`item33')\\"
file write file0 _n	"& & & &\\"
file write file0 _n	"Aged-Out Year 2  & \multirow{2}{*}{`item13'} & `item14' & \multirow{2}{*}{`item34'} & `item35'\\"
file write file0 _n	"& & (`item15') & & (`item36')\\"
file write file0 _n	"& & & & \\"
file write file0 _n	"Aged-Out Year 3  & \multirow{2}{*}{`item16'} & `item17' & \multirow{2}{*}{`item37'} & `item38'\\"
file write file0 _n	"& & (`item18') & & (`item39')\\"
file write file0 _n	"& & & & \\"
file write file0 _n	"Aged-Out Year 4 & \multirow{2}{*}{`item19'} & `item20' & \multirow{2}{*}{`item40'} & `item41'\\"
file write file0 _n	"& & (`item21') & & (`item42')\\"
file write file0 _n	"& & & & \\"
file write file0 _n	"N Total  & `itemtotal1' &  & `itemtotal8' & \\"
file write file0 _n	"\bottomrule"
file write file0 _n	"\end{tabular}"
file write file0 _n	"\begin{tablenotes}"
file write file0 _n	"\footnotesize"

file write file0 _n	"\item \textit{Notes:} This table presents the summary statistics on each assessment from the control kids in our sample. The first and the third columns represent the number of observations for which we have the corresponding assessment, the second and the fourth columns present the means of scores on each assessment. Standard errors are reported in parentheses." 

file write file0 _n	"\end{tablenotes}"
file write file0 _n	"\end{threeparttable}"
file write file0 _n	"\end{table}"

file write file0 _n "\end{document}"
 
file close file0


**Create Table 4


clear all

cd "$repository/data_sets/generated"

use table34_unique_data_clean

drop if test =="pre"

***********************************************************************************
**If want to reproduce table restricting sample to control kids, add the code below


keep if (C == 1 & first_random == 1) | (CC == 1 & first_random == 1) | (CT_pretreat == 1) | (CK_prekinder == 1)


***********************************************************************************

replace std_cog_pre = . if has_cog_pre == 0
replace std_ncog_pre = . if has_ncog_pre == 0

file open file1 using "$repository/analysis/tables/tables_no_pre_number_treated/table4.tex", replace write

file write file1 "\documentclass[11pt]{article}"
file write file1 _n "\usepackage{booktabs, multicol, multirow}"
file write file1 _n "\usepackage{caption}"
file write file1 _n "\userpackage[flushleft]{threeparttable}"
file write file1 _n	"\begin{document}"

file write file1 _n "\setcounter{table}{0}"
file write file1 _n "\begin{table}[]"
file write file1 _n "\begin{threeparttable}"
file write file1 _n "\centering"
file write file1 _n "\caption{Baseline Summary Statistics for Final Sample}"
file write file1 _n "\label{tab:sum_stat_demog}"
file write file1 _n "\scriptsize"
file write file1 _n "\begin{tabular}{ll}"
file write file1 _n "Variable & Share \\ \hline \hline"

**Completing Gender Line
tab gender, m gen(gender_gr)
tabstat gender_gr2, save stat(mean)
mat a = r(StatTotal)
local a1 = string(round(a[1,1], 0.01), "%13.0gc") 

file write file1 _n "Male     & `a1'                  \\ \hline"
file write file1 _n "\multicolumn{2}{c}{Race} \\ \cline{1-2}"

**Completing Race Line
tab race, m gen(race_gr)
tabstat race_gr1, save stat(mean) 
mat b = r(StatTotal)
local b1 = string(round(b[1,1], 0.01), "%13.0gc") //Missing Race
tabstat race_gr2, save stat(mean) 
mat b = r(StatTotal)
local b2 = string(round(b[1,1], 0.01), "%13.0gc") //Black
tabstat race_gr3, save stat(mean) 
mat b = r(StatTotal)
local b3 = string(round(b[1,1], 0.01), "%13.0gc") //Hispanic
tabstat race_gr4, save stat(mean) 
mat b = r(StatTotal)
local b4 = string(round(b[1,1], 0.01), "%13.0gc") //Other
tabstat race_gr5, save stat(mean) 
mat b = r(StatTotal)
local b5 = string(round(b[1,1], 0.01), "%13.0gc") //White

file write file1 _n "Black      & `b2'         \\"
file write file1 _n "Hispanic   & `b3'    \\"
file write file1 _n "White         & `b5'     \\"
file write file1 _n "Other Race      & `b4' \\"
file write file1 _n "Missing Race &  `b1' \\ \hline"
file write file1 _n "\multicolumn{2}{c}{HH Income at Pre-assessment } \\ \cline{1-2}"

**Completing Household Income 
tab hh_income_pre, m gen(hh_income_gr)
tabstat hh_income_gr1, save stat(mean) 
mat c = r(StatTotal)
local c1 = c[1,1] //0-5
tabstat hh_income_gr2, save stat(mean) 
mat c = r(StatTotal)
local c2 = c[1,1] //16-25
tabstat hh_income_gr3, save stat(mean) 
mat c = r(StatTotal)
local c3 = c[1,1] //26-35
tabstat hh_income_gr4, save stat(mean) 
mat c = r(StatTotal)
local c4 = c[1,1] //36-45
tabstat hh_income_gr5, save stat(mean) 
mat c = r(StatTotal)
local c5 = c[1,1] //46-60
tabstat hh_income_gr6, save stat(mean) 
mat c = r(StatTotal)
local c6 = c[1,1] //6-15
tabstat hh_income_gr7, save stat(mean) 
mat c = r(StatTotal)
local c7 = c[1,1] //60-75
tabstat hh_income_gr8, save stat(mean) 
mat c = r(StatTotal)
local c8 = c[1,1] //61-75
tabstat hh_income_gr9, save stat(mean) 
mat c = r(StatTotal)
local c9 = string(round(c[1,1], 0.01), "%13.0gc") //75+
tabstat hh_income_gr10, save stat(mean) 
mat c = r(StatTotal)
local c10 = string(round(c[1,1], 0.01), "%13.0gc") //Missing

//below 35
local c1c2c3c6 = `c1' + `c2' + `c3' + `c6'
local below_35 = string(round(`c1c2c3c6', 0.01), "%13.0gc")

file write file1 _n "below 35K       & `below_35'                   \\"

//36K-75K
local c4c5c7c8 = `c4' + `c5' + `c7' + `c8'
local k36_75 = string(round(`c4c5c7c8', 0.01),"%13.0gc") 

file write file1 _n "36K-75K       & `k36_75'                  \\"

//75+, Missing
file write file1 _n "75K+      & `c9'                 \\"
file write file1 _n "Income Missing  &       `c10'                   \\ \hline"
file write file1 _n "\multicolumn{2}{c}{Mother's Education } \\ \cline{1-2}"

**Completing Mother Education
tab mother_education_pre, m gen(mother_education_gr)
tabstat mother_education_gr1, save stat(mean)
mat m =r(StatTotal)
local m1 = m[1,1] //Associates
tabstat mother_education_gr2, save stat(mean)
mat m =r(StatTotal)
local m2 = m[1,1] //Bachelor
tabstat mother_education_gr3, save stat(mean)
mat m =r(StatTotal)
local m3 = m[1,1] //Ged
tabstat mother_education_gr4, save stat(mean)
mat m =r(StatTotal)
local m4 = string(round(m[1,1], 0.01), "%13.0gc") //High School Diploma
tabstat mother_education_gr5, save stat(mean)
mat m =r(StatTotal)
local m5 = m[1,1] //Less than 9th Gr
tabstat mother_education_gr6, save stat(mean)
mat m =r(StatTotal)
local m6 = m[1,1] //Master
tabstat mother_education_gr7, save stat(mean)
mat m =r(StatTotal)
local m7 = m[1,1] //No formal
tabstat mother_education_gr8, save stat(mean)
mat m =r(StatTotal)
local m8 = m[1,1] //Other
tabstat mother_education_gr9, save stat(mean)
mat m =r(StatTotal)
local m9 = string(round(m[1,1], 0.01), "%13.0gc")  //Some college no degree
tabstat mother_education_gr10, save stat(mean)
mat m =r(StatTotal)
local m10 = m[1,1] //Some High School no diploma
tabstat mother_education_gr11, save stat(mean)
mat m =r(StatTotal)
local m11 = m[1,1] //Vocational/Technical
tabstat mother_education_gr12, save stat(mean)
mat m =r(StatTotal)
local m12 = string(round(m[1,1], 0.01), "%13.0gc") //Missing

//less than high school =  less than 9th grade + no formal schooling 
local m5m7= `m5' + `m7'
local less_high = string(round(`m5m7', 0.01), "%13.0gc")
file write file1 _n "Less than high school   & `less_high'                 \\"

//some high school but no diploma = ged + some highschool no diploma
local m3m10 = `m3' + `m10'
local high_no_dipl = string(round(`m3m10', 0.01), "%13.0gc")
file write file1 _n "Some high school but no diploma      & `high_no_dipl'     \\"

//high school diploma = high school diploma
file write file1 _n "High school diploma           & `m4'  \\"

//some college = some college no degree
file write file1 _n "Some college but no degree     & `m9'             \\"

//college degree =  associates degree + bachelors degree + master graduate professional
local m1m2m6 = `m1' + `m2' + `m6'
local college = string(round(`m1m2m6', 0.01), "%13.0gc")
file write file1 _n "College degree        & `college'                 \\"

//other = other + vocational/technical program
local m8m11 = `m8' + `m11'
local other = string(round(`m8m11', 0.01), "%13.0gc")
file write file1 _n "Other	& `other'	\\"

//Missing
file write file1 _n "Missing Mother's Education        &              `m12'            \\ \hline" 
file write file1 _n "\multicolumn{2}{c}{Father's Education }    \\  \cline{1-2}"

**Completing Father Education
tab father_education_pre, m gen(father_education_gr)
tabstat father_education_gr1, save stat(mean)
mat m =r(StatTotal)
local m1 = m[1,1] //Associates
tabstat father_education_gr2, save stat(mean)
mat m =r(StatTotal)
local m2 = m[1,1] //Bachelor
tabstat father_education_gr3, save stat(mean)
mat m =r(StatTotal)
local m3 = m[1,1] //Ged
tabstat father_education_gr4, save stat(mean)
mat m =r(StatTotal)
local m4 = string(round(m[1,1], 0.01), "%13.0gc") //High School Diploma
tabstat father_education_gr5, save stat(mean)
mat m =r(StatTotal)
local m5 = m[1,1] //Less than 9th Gr
tabstat father_education_gr6, save stat(mean)
mat m =r(StatTotal)
local m6 = m[1,1] //Master
tabstat father_education_gr7, save stat(mean)
mat m =r(StatTotal)
local m7 = m[1,1] //No formal
tabstat father_education_gr8, save stat(mean)
mat m =r(StatTotal)
local m8 = m[1,1] //Other
tabstat father_education_gr9, save stat(mean)
mat m =r(StatTotal)
local m9 = string(round(m[1,1], 0.01), "%13.0gc")  //Some college no degree
tabstat father_education_gr10, save stat(mean)
mat m =r(StatTotal)
local m10 = m[1,1] //Some High School no diploma
tabstat father_education_gr11, save stat(mean)
mat m =r(StatTotal)
local m11 = m[1,1] //Vocational/Technical
tabstat father_education_gr12, save stat(mean)
mat m =r(StatTotal)
local m12 = string(round(m[1,1], 0.01), "%13.0gc") //Missing

//less than high school =  less than 9th grade + no formal schooling 
local m5m7= `m5' + `m7'
local less_high = string(round(`m5m7', 0.01), "%13.0gc")
file write file1 _n "Less than high school   & `less_high'                 \\"

//some high school but no diploma = ged + some highschool no diploma
local m3m10 = `m3' + `m10'
local high_no_dipl = string(round(`m3m10', 0.01), "%13.0gc")
file write file1 _n "Some high school but no diploma      & `high_no_dipl'     \\"

//high school diploma = high school diploma
file write file1 _n "High school diploma           & `m4'  \\"

//some college = some college no degree
file write file1 _n "Some college but no degree     & `m9'             \\"

//college degree =  associates degree + bachelors degree + master graduate professional
local m1m2m6 = `m1' + `m2' + `m6'
local college = string(round(`m1m2m6', 0.01), "%13.0gc")
file write file1 _n "College degree        & `college'                 \\"

//other = other + vocational/technical program
local m8m11 = `m8' + `m11'
local other = string(round(`m8m11', 0.01), "%13.0gc")
file write file1 _n "Other	& `other'	\\"

//Missing
file write file1 _n "Missing Father's Education        &              `m12'            \\ \hline" 

**Completing Unemployment
tab aid_unemployment_pre, m gen (aid_unemp_gr)
tabstat aid_unemp_gr2, save stat(mean)
mat b = r(StatTotal)
local b2= string(round(b[1,1], 0.01), "%13.0gc")
tabstat aid_unemp_gr3, save stat(mean)
mat b = r(StatTotal)
local b3 = string(round(b[1,1], 0.01), "%13.0gc")

file write file1 _n "\begin{tabular}[c]{@{}l@{}}Receive unemployment benefit\end{tabular} &  `b2'    \\"
file write file1 _n "\begin{tabular}[c]{@{}l@{}} Missing unemployment benefit \end{tabular} &    `b3'             \\ \hline"

tabstat age_pre if age_pre != 0, save stat(mean semean n) 
mat a = r(StatTotal)
local a1 = string(round(a[1,1], 0.01), "%13.0gc")
local a2 = string(round(a[2,1], 0.001), "%13.0gc")

file write file1 _n "Pre-assessment Age (months) & \begin{tabular}[c]{@{}l@{}}`a1'\\ (`a2')\end{tabular}                        \\"


local i = 1

foreach x in cog ncog {
	tabstat std_`x'_pre if has_`x'_pre == 1, save stat(mean semean n)
	mat a = r(StatTotal)
	local item`i' = string(round(a[1,1], 0.001), "%13.0gc")
	local i = `i' + 1
	local item`i' = string(round(a[2,1], 0.0001), "%13.0gc")
	local i = `i' + 1
	}

file write file1 _n "Pre-assessment Cognitive Score   & \begin{tabular}[c]{@{}l@{}} `item1'\\ (`item2')\end{tabular}                        \\"
file write file1 _n "Pre-assessment Non-cognitive Score      & \begin{tabular}[c]{@{}l@{}} `item3' \\ (`item4')\end{tabular}              \\ \hline"
    
file write file1 _n "\end{tabular}"

file write file1 _n "\begin{tablenotes}"
file write file1 _n "     \footnotesize"

file write file1 _n "\item \textit{Notes:} This table presents the summary statistics for baseline demographic variables as well as baseline cognitive and non-cognitive performance. For the education levels, \textit{Some high school but not diploma} includes parents with GED or high school attendance without diploma, \textit{College degree} includes associate's, bachelor and master degrees, \textit{Less than high school} includes education below 9th grade or no formal schooling, and \textit{Other} includes vocational/technical or other unclassified programs."  
file write file1 _n "\item Standard errors in parentheses" 

file write file1 _n "\end{tablenotes}"
file write file1 _n "\end{threeparttable}"
file write file1 _n "\end{table}"
file write file1 _n "\end{document}"
 
file close file1


 

