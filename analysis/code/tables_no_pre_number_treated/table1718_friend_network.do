***CREATE TABLES 17 and 18*********


****Table 17: Friend Network Summary Statistics****

clear all

cd "$repository/data_sets/generated"

use final_friend_network

drop if treatment != "control"

foreach x in 1 2 3 4 5 6 7 8 9 10 {
gen same_race`x' = 1 if (race`x' == race & checc_friend`x' == 1 & race != "")
replace same_race`x' = 0 if same_race`x' !=1

gen same_race_control`x' = 1 if (race`x' == race & control`x' == 1 & race != "")
replace same_race_control`x' = 0 if same_race_control`x' != 1

gen same_race_treat`x' = 1 if (race`x' == race & treated`x' == 1 & race != "")
replace same_race_treat`x' = 0 if same_race_treat`x' != 1
 
gen same_gender`x' = 1 if (gender`x' == gender & checc_friend`x' == 1 & gender != "")
replace same_gender`x' = 0 if same_gender`x' != 1

gen same_gender_control`x' = 1 if (gender`x' == gender & control`x' == 1 & gender != "")
replace same_gender_control`x' = 0 if same_gender_control`x' != 1

gen same_gender_treat`x' = 1 if (gender`x' == gender & treated`x' == 1 & gender != "")
replace same_gender_treat`x' = 0 if same_gender_treat`x' != 1
}



**Generating Number of Same Race Checc Friends
egen num_checc_friends_srace = rowtotal(same_race1  same_race2  same_race3  same_race4  same_race5  same_race6 same_race7  same_race8  same_race9  same_race10)

**Generating Number of Same Gender Checc Friends
egen num_checc_friends_sgender = rowtotal(same_gender1  same_gender2  same_gender3  same_gender4  same_gender5  same_gender6 same_gender7  same_gender8  same_gender9  same_gender10)

**Generating Number of Same Race Control Checc Friends
egen num_checc_friends_controlsrace = rowtotal(same_race_control1  same_race_control2  same_race_control3  same_race_control4  same_race_control5  same_race_control6 same_race_control7  same_race_control8  same_race_control9  same_race_control10)

**Generating Number of Same Race Treated Checc Friends
egen num_checc_friends_treatsrace = rowtotal(same_race_treat1  same_race_treat2  same_race_treat3  same_race_treat4  same_race_treat5  same_race_treat6 same_race_treat7  same_race_treat8  same_race_treat9  same_race_treat10)

**Generating Number of Same Gender Control Friends
egen num_checc_friends_controlsgender = rowtotal(same_gender_control1  same_gender_control2  same_gender_control3  same_gender_control4  same_gender_control5  same_gender_control6 same_gender_control7  same_gender_control8  same_gender_control9  same_gender_control10)

**Generating Number of Same Gender Treated Friends
egen num_checc_friends_treatsgender = rowtotal(same_gender_treat1  same_gender_treat2  same_gender_treat3  same_gender_treat4  same_gender_treat5  same_gender_treat6 same_gender_treat7  same_gender_treat8  same_gender_treat9  same_gender_treat10)

gen percent_treated_friends = (num_checc_treated_friends / (num_checc_treated_friends + num_checc_control_friends))*100


**Creating Table 17


file open file14 using "$repository/analysis/tables/table17_friend_network_summary.tex", replace write

file write file14 _n "\documentclass[11pt]{article}"
file write file14 _n "\usepackage{booktabs, multicol, multirow}"
file write file14 _n "\usepackage{caption}"
file write file14 _n "\userpackage[flushleft]{threeparttable}"
file write file14 _n	"\begin{document}"

file write file14 _n "\begin{table}[H]\centering \caption{Summary statistics of surveyed kids \label{sumstat_survey}}"
file write file14 _n "\begin{threeparttable}"
file write file14 _n "\begin{tabular}{l c c  c}\hline\hline"
file write file14 _n "\multicolumn{1}{c}{\textbf{Variable}} & \textbf{Mean}"
file write file14 _n "& \textbf{Std. Dev.} & \textbf{N}\\ \hline"



tab race, m gen(race_gr)

tabstat race_gr1, save stat(mean semean n)
mat a = r(StatTotal)
local a1 = string(round(a[1,1], 0.001), "%13.0gc") //Mean
local a2 = string(round(a[2,1], 0.001), "%13.0gc") //Standard Error
local a3 = string(round(a[3,1], 0.001), "%13.0gc") //N

file write file14 _n "Black & `a1' & `a2'  & `a3'\\"


tabstat race_gr2, save stat(mean semean n)
mat a = r(StatTotal)
local a1 = string(round(a[1,1], 0.001), "%13.0gc") //Mean
local a2 = string(round(a[2,1], 0.001), "%13.0gc") //Standard Error
local a3 = string(round(a[3,1], 0.001), "%13.0gc") //N

file write file14 _n "Hispanic & `a1' & `a2'  & `a3'\\"

tabstat race_gr3, save stat(mean semean n)
mat a = r(StatTotal)
local a1 = string(round(a[1,1], 0.001), "%13.0gc") //Mean
local a2 = string(round(a[2,1], 0.001), "%13.0gc") //Standard Error
local a3 = string(round(a[3,1], 0.001), "%13.0gc") //N

file write file14 _n "White & `a1' & `a2'  & `a3'\\"

tab gender, m gen(gender_gr)

tabstat gender_gr1, save stat(mean semean n)
mat a = r(StatTotal)
local a1 = string(round(a[1,1], 0.001), "%13.0gc") //Mean
local a2 = string(round(a[2,1], 0.001), "%13.0gc") //Standard Error
local a3 = string(round(a[3,1], 0.001), "%13.0gc") //N

file write file14 _n "Female & `a1' & `a2'  & `a3'\\"

tabstat age_pre if age_pre != 0, save stat(mean semean n)
mat a = r(StatTotal)
local a1 = string(round(a[1,1], 0.001), "%13.0gc") //Mean
local a2 = string(round(a[2,1], 0.001), "%13.0gc") //Standard Error
local a3 = string(round(a[3,1], 0.001), "%13.0gc") //N

file write file14 _n "Baseline Age (months) & `a1' & `a2'  & `a3'\\"

tabstat num_friends, save stat(mean semean n)
mat a = r(StatTotal)
local a1 = string(round(a[1,1], 0.001), "%13.0gc") //Mean
local a2 = string(round(a[2,1], 0.001), "%13.0gc") //Standard Error
local a3 = string(round(a[3,1], 0.001), "%13.0gc") //N

file write file14 _n "$ F_{i,total} $ & `a1' & `a2'  & `a3'\\"

tabstat num_checc_friends, save stat(mean semean n)
mat a = r(StatTotal)
local a1 = string(round(a[1,1], 0.001), "%13.0gc") //Mean
local a2 = string(round(a[2,1], 0.001), "%13.0gc") //Standard Error
local a3 = string(round(a[3,1], 0.001), "%13.0gc") //N

file write file14 _n "$ F_{i,checc} $ & `a1' & `a2'  & `a3'\\"

tabstat num_checc_control_friends, save stat(mean semean n)
mat a = r(StatTotal)
local a1 = string(round(a[1,1], 0.001), "%13.0gc") //Mean
local a2 = string(round(a[2,1], 0.001), "%13.0gc") //Standard Error
local a3 = string(round(a[3,1], 0.001), "%13.0gc") //N


file write file14 _n "$ F_{i, survey}^{control} $ & `a1' & `a2'  & `a3'\\"

tabstat num_checc_treated_friends, save stat(mean semean n)

mat a = r(StatTotal)
local a1 = string(round(a[1,1], 0.001), "%13.0gc") //Mean
local a2 = string(round(a[2,1], 0.001), "%13.0gc") //Standard Error
local a3 = string(round(a[3,1], 0.001), "%13.0gc") //N


file write file14 _n "$ F_{i,survey}^{treated} $ & `a1' & `a2'  & `a3'\\"

tabstat num_checc_friends_srace, save stat(mean semean n)

mat a = r(StatTotal)
local a1 = string(round(a[1,1], 0.001), "%13.0gc") //Mean
local a2 = string(round(a[2,1], 0.001), "%13.0gc") //Standard Error
local a3 = string(round(a[3,1], 0.001), "%13.0gc") //N

file write file14 _n "$ F_{i,checc, samerace} $ & `a1' & `a2'  & `a3'\\"


tabstat num_checc_friends_treatsrace, save stat(mean semean n)

mat a = r(StatTotal)
local a1 = string(round(a[1,1], 0.001), "%13.0gc") //Mean
local a2 = string(round(a[2,1], 0.001), "%13.0gc") //Standard Error
local a3 = string(round(a[3,1], 0.001), "%13.0gc") //N

file write file14 _n "$ F_{i,checc, samerace}^{treated} $ & `a1' & `a2'  & `a3'\\"

tabstat num_checc_friends_controlsrace, save stat(mean semean n)

mat a = r(StatTotal)
local a1 = string(round(a[1,1], 0.001), "%13.0gc") //Mean
local a2 = string(round(a[2,1], 0.001), "%13.0gc") //Standard Error
local a3 = string(round(a[3,1], 0.001), "%13.0gc") //N

file write file14 _n "$ F_{i,checc, samerace}^{control} $ & `a1' & `a2'  & `a3'\\"

tabstat num_checc_friends_sgender, save stat(mean semean n)

mat a = r(StatTotal)
local a1 = string(round(a[1,1], 0.001), "%13.0gc") //Mean
local a2 = string(round(a[2,1], 0.001), "%13.0gc") //Standard Error
local a3 = string(round(a[3,1], 0.001), "%13.0gc") //N

file write file14 _n "$ F_{i,checc, samegender} $ & `a1' & `a2'  & `a3'\\"

tabstat num_checc_friends_treatsgender, save stat(mean semean n)

mat a = r(StatTotal)
local a1 = string(round(a[1,1], 0.001), "%13.0gc") //Mean
local a2 = string(round(a[2,1], 0.001), "%13.0gc") //Standard Error
local a3 = string(round(a[3,1], 0.001), "%13.0gc") //N

file write file14 _n "$ F_{i,checc, samegender}^{treated} $ & `a1' & `a2'  & `a3'\\"

tabstat num_checc_friends_controlsgender, save stat(mean semean n)

mat a = r(StatTotal)
local a1 = string(round(a[1,1], 0.001), "%13.0gc") //Mean
local a2 = string(round(a[2,1], 0.001), "%13.0gc") //Standard Error
local a3 = string(round(a[3,1], 0.001), "%13.0gc") //N

file write file14 _n "$ F_{i,checc, samegender}^{control} $  & `a1' & `a2'  & `a3'\\"

tabstat percent_treated_friends, save stat(mean semean n)

mat a = r(StatTotal)
local a1 = string(round(a[1,1], 0.001), "%13.0gc") //Mean
local a2 = string(round(a[2,1], 0.001), "%13.0gc") //Standard Error
local a3 = string(round(a[3,1], 0.001), "%13.0gc") //N


file write file14 _n "$ P^{treated}_{i,survey} $ & `a1' & `a2'  & `a3'\\"

file write file14 _n "\hline"
file write file14 _n "\end{tabular}"
file write file14 _n "\begin{tablenotes}"
file write file14 _n "\footnotesize"

file write file14 _n "\item \textit{Notes:} Descriptive statistics on key demographic and social network variables in our surveyed sample."
file write file14 _n "\end{tablenotes}"
file write file14 _n "\end{threeparttable}"
file write file14 _n "\end{table}"

file write file14 _n "\end{document}"
 
file close file14

****Table 18: Friend Network Summary Statistics****

xtile std_cog_quintile = std_cog, n(5)
xtile std_ncog_quintile = std_ncog, n(5)

file open file15 using "$repository/analysis/tables/table18_friend_network_quantiles.tex", replace write

file write file15 _n "\documentclass[11pt]{article}"
file write file15 _n "\usepackage{booktabs, multicol, multirow}"
file write file15 _n "\usepackage{caption}"
file write file15 _n "\userpackage[flushleft]{threeparttable}"
file write file15 _n	"\begin{document}"


file write file15 _n "\begin{table}[H]"
file write file15 _n "\centering"
file write file15 _n "\caption{Social Network and Cognitive and Non-cognitive Scores}"
file write file15 _n "\label{tab:quantiles}"
file write file15 _n "\begin{threeparttable}"
file write file15 _n "\begin{tabular}{ll|ll}"
file write file15 _n "\hline \hline"
file write file15 _n "Score Quantiles & $ P^{treated}_{i,survey} $ & Non-Cognitive Score Quantiles & $ P^{treated}_{i,survey} $ \\ \hline"


foreach x in 1 2 3 4 5 {
	local j = 1
	foreach var of varlist std_cog_quintile  std_ncog_quintile {

	tabstat percent_treated_friends, by(`var') save stat(mean semean)
	mat a = r(Stat`x')
	local a`j' = string(round(a[1,1], 0.001), "%13.0gc") //Mean
    local j = `j' + 1
	local a`j' = string(round(a[2,1], 0.001), "%13.0gc") //Standard Error
	local j = `j' + 1
	}
	if `x' != 5 { 
	file write file15 _n "`x'st Quantile              & `a1'\%                     & `x'st Quantile                  & `a3'\%                     \\"
    file write file15 _n "                      & (`a2')                    &                               & (`a4')                    \\"
	}

	else if `x' == 5 {

	file write file15 _n "`x'st Quantile              & `a1'\%                     & `x'st Quantile                  & `a3'\%                     \\"
    file write file15 _n "                      & (`a2')                    &                               & (`a4')                    \\ \hline"
	}

}



file write file15 _n "\end{tabular}"
file write file15 _n "\begin{tablenotes}"
file write file15 _n "\footnotesize"

file write file15 _n "\item \textit{Notes:} This table presents the percentage of treated friends (among all CHECC friends) for different quantiles of cognitive and non-cognitive performances."

file write file15 _n "\item  Standard errors  are reported in parentheses."


file write file15 _n "\end{tablenotes}"
file write file15 _n "\end{threeparttable}"
file write file15 _n "\end{table}"

file write file15 _n "\end{document}"
 
file close file15








