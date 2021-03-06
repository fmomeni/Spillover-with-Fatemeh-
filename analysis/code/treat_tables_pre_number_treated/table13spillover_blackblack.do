**Table 11: Spillover from Black to Black


clear all

cd "$repository/data_sets/generated"

use table34_unique_data_clean


***********************************************************************************
**If want to reproduce table restricting sample to control kids, add the code below


keep  if (T == 1 & first_random == 1) | (CT== 1 & second_random == 1) | (TT == 1&  first_random == 1) | (TTT == 1&  first_random == 1) |(K==1 & first_random  ==1)| (CK==1& second_random ==1)


***********************************************************************************

**Merging with number of Black neighbors

merge 1:1 child test year using merged_black_neigh_count

**Keeping the observations pertaining to the "Black neighbors within distance of 20,000" subsample
keep if _merge == 3

drop _merge

**Defining Key Explanatory Variable
foreach distance in 500 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 15000 20000 {
gen percent_treated_`distance' = (treated_`distance'_black / (treated_`distance'_black + control_`distance'_black))*100
}

**Generated Num Total Neighbors
foreach distance in 500 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 15000 20000 {
gen total_neigh_`distance' = treated_`distance'_black + control_`distance'_black
}

**Merging with distance to school and block group variable
foreach file in Relevant_DistToSchool_1 Relevant_DistToSchool_2 Relevant_censusblock_checc {
merge m:1 child using `file'
*drop if _merge == 2
drop _merge
} 

	
replace age_pre = . if age_pre == 0	

**Creating factor variables
egen gender_num = group(gender)
egen race_num = group(race)
egen blockgroup_num = group(blockgroup)
destring year, replace

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
	
local distance "500 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 15000 20000"
local num : list sizeof local(distance)
local i = 1


file open file10 using "$repository/analysis/tables/treat_tables_pre_number_treated/table13spillover_blackblack.tex", replace write


file write file10 "\documentclass[11pt]{article}"
file write file10 _n "\usepackage{booktabs, multicol, multirow}"
file write file10 _n "\usepackage{caption}"
file write file10 _n "\userpackage[flushleft]{threeparttable}"
file write file10 _n	"\begin{document}"

file write file10 _n "\begin{table}[h]\centering" 

file write file10 _n "\caption{Spillover From Black to Black} \scalebox{0.92} {\label{tab:results_blacks} \begin{threeparttable}"
file write file10 _n "\begin{tabular}{lc|c}"
file write file10 _n "\toprule"
file write file10 _n "\midrule"
file write file10 _n "& \multicolumn{1}{c}{Cognitive Scores} & \multicolumn{1}{c}{Non-cognitive Scores}\\ \cline{2-7}"
file write file10 _n "& Fixed Effect & Fixed Effect \\"
file write file10 _n " $ d $ (meters)& (1) & (2) \\"
file write file10 _n "\midrule"

**Running main regressions	

foreach d of local distance  {	
	local j = 1
	foreach assess in cog ncog {

	***FIXED EFFECTS
	quietly xtreg std_`assess' treated_`d'_black total_neigh_`d' i.test_num  if has_`assess' == 1 & race == "African American", fe cluster(child) 
	
	matrix d = r(table) 

	*adding stars
		if d[4,1] < 0.01 {
			local item_`j'_`d' = string(round(_b[treated_`d'_black], .0001), "%13.0gc") + "***"
		}
		else if d[4,1] < 0.05 & d[4,1] >= 0.01 {
			local item_`j'_`d' = string(round(_b[treated_`d'_black], .0001), "%13.0gc") + "**"
		}	
		else if d[4,1] < 0.1 & d[4,1] >= 0.05 {
			local item_`j'_`d' = string(round(_b[treated_`d'_black], .0001), "%13.0gc") + "*"
		}
		else {
			local item_`j'_`d' = string(round(_b[treated_`d'_black], .0001), "%13.0gc")
		}		
		
		local se_`j'_`d' = string(round(_se[treated_`d'_black], .0001), "%13.0gc")
		
		local j = `j' + 1

	}

	file write file10 _n "\multirow{2}{*}{`d'} & `item_1_`d'' & `item_2_`d'' \\"
	file write file10 _n "& (`se_1_`d'') & (`se_2_`d'') \\"

	if `i' < `num' {
		file write file10 _n "& & \\"	
	}
	local i = `i' + 1
}	
	
file write file10 _n "\midrule"
file write file10 _n "\bottomrule"
file write file10 _n "\end{tabular}"
file write file10 _n "\begin{tablenotes}"
file write file10 _n "\footnotesize"

file write file10 _n "\item \textit{Notes:} Columns 1-3 (4-6) display the effect of a 1 percentage point increase in the share of treated Black neighbors of a Black control child ($\frac{N^{treated}_{black}}{N^{treated}_{black}+N^{control}_{black}}$) on his standardized cognitive (non-cognitive) score." 
file write file10 _n "\item Robust standard errors, clustered at the individual level in parentheses"
file write file10 _n "\item *** p$<$0.01, ** p$<$0.05, * p$<$0.1"
file write file10 _n "\end{tablenotes}"
file write file10 _n "\end{threeparttable}"
file write file10 _n "} \end{table}"

file write file10 _n "\end{document}"

file close file10
