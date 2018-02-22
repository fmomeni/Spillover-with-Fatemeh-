**TABLE 7: MAIN REGRESSIONS*****

clear all

cd "$repository/data_sets/generated"

use table56_unique_data_clean


***********************************************************************************
**If want to reproduce table restricting sample to control kids, add the code below


keep if (C == 1 & first_random == 1) | (CC == 1 & first_random == 1) | (CT_pretreat == 1) | (CK_prekinder == 1)


***********************************************************************************


	
replace age_pre = . if age_pre == 0	

**Creating factor variables
egen gender_num = group(gender)
egen race_num = group(race)
egen blockgroup_num = group(blockgroup)
destring year, replace

**Generated Num Total Neighbors
foreach distance in 500 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 15000 20000 {
gen total_neigh_`distance' = treated_`distance' + control_`distance'
}


**Setting up Time Dimension
gen test_num = 0 if test == "pre"
replace test_num = 1 if test == "mid"
replace test_num = 2 if test == "post"
replace test_num = 3 if test == "sl"
replace test_num = 4 if test == "aoy1"
replace test_num = 5 if test == "aoy2"
replace test_num = 6 if test == "aoy3"
replace test_num = 7 if test == "aoy4"

sort child test_num
xtset child test_num	
	

local distance "500 1000 2000 3000 5000 6000 7000 8000 9000 10000 15000 20000"
local num : list sizeof local(distance)
local i = 1


file open file4 using "$repository/analysis/tables/tables_pre_number_treated/table7.tex", replace write

file write file4 _n "\documentclass[11pt]{article}"
file write file4 _n "\usepackage{booktabs, multicol, multirow}"
file write file4 _n "\usepackage{caption}"
file write file4 _n "\userpackage[flushleft]{threeparttable}"
file write file4 _n	"\begin{document}"

file write file4 _n "\begin{table}[h]\centering" 

file write file4 _n "\begin{threeparttable}"
file write file4 _n "\caption{Spillover on Cognitive and Non-cognitive Scores} \label{tab:results_all}"
file write file4 _n "\begin{tabular}{lccc|ccc}"
file write file4 _n "\toprule"
file write file4 _n "\midrule"
file write file4 _n "& \multicolumn{1}{c}{Cognitive Scores} & \multicolumn{1}{c}{Non-cognitive Scores}\\ \cline{2-7}"
file write file4 _n "& Fixed Effect & Fixed Effect \\"
file write file4 _n " $ d $ (meters)& (1) & (2) \\"
file write file4 _n "\midrule"

**Running main regressions	

foreach d of local distance  {	
	local j = 1
	foreach assess in cog ncog {

	***FIXED EFFECTS
	quietly xtreg std_`assess' treated_`d' total_neigh_`d' i.test_num if has_`assess' == 1, fe cluster(child) 
	
	matrix d = r(table) 

	*adding stars
		if d[4,1] < 0.01 {
			local item_`j'_`d' = string(round(_b[treated_`d'], .0001), "%13.0gc") + "***"
		}
		else if d[4,1] < 0.05 & d[4,1] >= 0.01 {
			local item_`j'_`d' = string(round(_b[treated_`d'], .0001), "%13.0gc") + "**"
		}	
		else if d[4,1] < 0.1 & d[4,1] >= 0.05 {
			local item_`j'_`d' = string(round(_b[treated_`d'], .0001), "%13.0gc") + "*"
		}
		else {
			local item_`j'_`d' = string(round(_b[treated_`d'], .0001), "%13.0gc")
		}		
		
		local se_`j'_`d' = string(round(_se[treated_`d'], .0001), "%13.0gc")
		
		local j = `j' + 1

	}

	file write file4 _n "\multirow{2}{*}{`d'} & `item_1_`d'' & `item_2_`d'' \\"
	file write file4 _n "& (`se_1_`d'') & (`se_2_`d'') \\"

	if `i' < `num' {
		file write file4 _n "& & \\"	
	}
	local i = `i' + 1
}	
	
file write file4 _n "\midrule"
file write file4 _n "\bottomrule"
file write file4 _n "\end{tabular}"
file write file4 _n "\begin{tablenotes}"
file write file4 _n "\footnotesize"

file write file4 _n "\item \textit{Notes:} Columns 1-3 (4-6) display the effect of a 1 percentage point increase in the share of treated neighbors of a control child on his/her standardized cognitive (non-cognitive) score." 
file write file4 _n "\item Robust standard errors, clustered at the individual level in parentheses"
file write file4 _n "\item *** p$<$0.01, ** p$<$0.05, * p$<$0.1"
file write file4 _n "\end{tablenotes}"
file write file4 _n "\end{threeparttable}"
file write file4 _n "\end{table}"

file write file4 _n "\end{document}"

file close file4
