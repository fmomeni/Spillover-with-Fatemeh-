**TABLE 8: SPILL OVER BY GENDER*****



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

drop if test == "pre"
**SPILLOVER BOYS

local distance "500 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 15000 20000"
local num : list sizeof local(distance)
local i = 1


file open file5 using "$repository/analysis/tables/tables_no_pre_number_treated/table8spillover_gender.tex", replace write


file write file5 "\documentclass[11pt]{article}"
file write file5 _n "\usepackage{booktabs, multicol, multirow}"
file write file5 _n "\usepackage{caption}"
file write file5 _n "\userpackage[flushleft]{threeparttable}"
file write file5 _n	"\begin{document}"

file write file5 _n "\begin{table}[H]\centering \caption{\small Spillover Effects by Gender  }  \scalebox{1}{\label{tab:results_gender} \begin{threeparttable}" 
file write file5 _n "\begin{tabular}{lccc|ccc}"
file write file5 _n "\toprule"
file write file5 _n "\midrule"
file write file5 _n "& \multicolumn{1}{c}{Cognitive Scores} & \multicolumn{1}{c}{Non-cognitive Scores}\\ \cline{2-7}"
file write file5 _n "& Fixed Effect & Fixed Effect \\"
file write file5 _n "$ d $ (meters) & (1) & (2) \\"
file write file5 _n "\midrule"
file write file5 _n "& \multicolumn{2}{c}{Control Boys}\\ \cline{2-7}"

**Running Regressions for Boys	

foreach d of local distance  {	
	local j = 1
	foreach assess in cog ncog {

	***FIXED EFFECTS
	quietly xtreg std_`assess' treated_`d' total_neigh_`d' i.test_num if (has_`assess' == 1 & gender_num == 2), fe cluster(child) 
	
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

	file write file5 _n "\multirow{2}{*}{`d'} & `item_1_`d'' & `item_2_`d'' \\"
	file write file5 _n "& (`se_1_`d'') & (`se_2_`d'') \\"

	if `i' < `num' {
		file write file5 _n "& & \\"	
	}
	local i = `i' + 1
}

file write file5 _n "& \multicolumn{2}{c}{}\\"
file write file5 _n "& \multicolumn{2}{c}{Control Girls}\\ \cline{2-7}"


** SPILL-OVER GIRLS


local distance "500 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 15000 20000"
local num : list sizeof local(distance)
local i = 1

**Running Regressions for Girls	

foreach d of local distance  {	
	local j = 1
	foreach assess in cog ncog {

	***FIXED EFFECTS
	quietly xtreg std_`assess' treated_`d' total_neigh_`d' i.test_num if (has_`assess' == 1 & gender_num == 1), fe cluster(child) 
	
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

	file write file5 _n "\multirow{2}{*}{`d'} & `item_1_`d'' & `item_2_`d'' \\"
	file write file5 _n "& (`se_1_`d'') & (`se_2_`d'') "

	if `i' < `num' {
		file write file5 _n "& & \\"	
	}
	local i = `i' + 1
}
	

	
file write file5 _n "\midrule"
file write file5 _n "\bottomrule"
file write file5 _n "\end{tabular}"
file write file5 _n "\begin{tablenotes}"
file write file5 _n "\footnotesize"

file write file5 _n "\item \textit{Notes:} Columns 1-3 (4-6) display the effect of a 1 percentage point increase in the share of treated neighbors of a control child on his/her standardized cognitive (non-cognitive) score. The upper panel shows the effects on control boys and the lower panel shows the effects on control girls." 
file write file5 _n "\item Robust standard errors, clustered at the individual level in parentheses"
file write file5 _n "\item *** p$<$0.01, ** p$<$0.05, * p$<$0.1"
file write file5 _n "\end{tablenotes}"
file write file5 _n "\end{threeparttable}"

file write file5 _n "} \end{table}"

file write file5 _n "\end{document}"

file close file5
