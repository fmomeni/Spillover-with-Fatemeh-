**Table 11: Spillover from Black to Black


clear all

cd "$repository/data_sets/generated"

use table34_unique_data_clean

drop if test =="pre"

***********************************************************************************
**If want to reproduce table restricting sample to control kids, add the code below

/*
keep if (C == 1 & first_random == 1) | (CC == 1 & first_random == 1) | (CT_pretreat == 1) | (CK_prekinder == 1)
*/

***********************************************************************************

**Merging with number of Black neighbors

merge 1:1 child test year using merged_black_neigh_count

**Keeping the observations pertaining to the "Black neighbors within distance of 20,000" subsample
keep if _merge == 3

drop _merge

**Defining Key Explanatory Variable
foreach distance in 500 1000 5000 10000 15000 20000 {
gen percent_treated_`distance' = (treated_`distance'_black / (treated_`distance'_black + control_`distance'_black))*100
}

**Merging with distance to school and block group variable
foreach file in Relevant_DistToSchool_1 Relevant_DistToSchool_2 Relevant_censusblock_checc {
merge m:1 child using `file'
drop if _merge == 2
drop _merge
} 


**For the regression, drop observations that had no pre scores 
drop if (no_cog_pre == 1 | no_ncog_pre == 1)
	
replace age_pre = . if age_pre == 0	

**Creating factor variables
egen gender_num = group(gender)
egen race_num = group(race)
egen blockgroup_num = group(blockgroup)
destring year, replace

**Setting up Time Dimension
gen test_num = 1 if test == "mid"
replace test_num = 2 if test == "post"
replace test_num = 3 if test == "sl"
replace test_num = 4 if test == "aoy1"
replace test_num = 5 if test == "aoy2"
replace test_num = 6 if test == "aoy3"
replace test_num = 7 if test == "aoy4"

sort child test_num
xtset child test_num	
	
local distance "1000 5000 10000 15000 20000"
local num : list sizeof local(distance)
local i = 1


file open file10 using "$repository/analysis/tables/tables_no_pre_percentage_treated/table13spillover_blackblack.tex", replace write


file write file10 "\documentclass[11pt]{article}"
file write file10 _n "\usepackage{booktabs, multicol, multirow}"
file write file10 _n "\usepackage{caption}"
file write file10 _n "\userpackage[flushleft]{threeparttable}"
file write file10 _n	"\begin{document}"

file write file10 _n "\begin{table}[h]\centering" 

file write file10 _n "\caption{Spillover From Black to Black} \scalebox{0.92} {\label{tab:results_blacks} \begin{threeparttable}"
file write file10 _n "\begin{tabular}{lccc|ccc}"
file write file10 _n "\toprule"
file write file10 _n "\midrule"
file write file10 _n "& \multicolumn{3}{c}{Cognitive Scores} & \multicolumn{3}{c}{Non-cognitive Scores}\\ \cline{2-7}"
file write file10 _n "& Pooled OLS & Fixed Effect & Random Effect & Pooled OLS & Fixed Effect & Random Effect\\"
file write file10 _n " $ d $ (meters)& (1) & (2) & (3) & (4) & (5) & (6)\\"
file write file10 _n "\midrule"

**Running main regressions	

foreach d of local distance  {	
	local j = 1
	foreach assess in cog ncog {
	***POOLED OLS
	quietly reg std_`assess' percent_treated_`d' std_cog_pre std_ncog_pre distto1 distto2 i.gender_num i.year i.blockgroup_num i.test_num age_pre if has_`assess' == 1 & race == "African American", cluster(child)
	
	matrix d = r(table) 

	*adding stars
		if d[4,1] < 0.01 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "***"
		}
		else if d[4,1] < 0.05 & d[4,1] >= 0.01 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "**"
		}
		else if d[4,1] < 0.1 & d[4,1] >= 0.05 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "*"
		}
		else {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc")
		}		
		
		local se_`j'_`d' = string(round(_se[percent_treated_`d'], .0001), "%13.0gc")
		
		local j = `j' + 1 

	***FIXED EFFECTS
	quietly xtreg std_`assess' percent_treated_`d' std_cog_pre std_ncog_pre distto1 distto2 i.gender_num i.year i.blockgroup_num i.test_num age_pre  if has_`assess' == 1 & race == "African American", fe cluster(child) 
	
	matrix d = r(table) 

	*adding stars
		if d[4,1] < 0.01 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "***"
		}
		else if d[4,1] < 0.05 & d[4,1] >= 0.01 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "**"
		}	
		else if d[4,1] < 0.1 & d[4,1] >= 0.05 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "*"
		}
		else {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc")
		}		
		
		local se_`j'_`d' = string(round(_se[percent_treated_`d'], .0001), "%13.0gc")
		
		local j = `j' + 1


	***RANDOM EFFECTS
	quietly xtreg std_`assess' percent_treated_`d' std_cog_pre std_ncog_pre distto1 distto2 i.gender_num i.year i.blockgroup_num i.test_num age_pre if has_`assess' == 1 & race == "African American", re cluster(child) 
	matrix d = r(table) 

	*adding stars
		if d[4,1] < 0.01 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "***"
		}
		else if d[4,1] < 0.05 & d[4,1] >= 0.01 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "**"
		}
		else if d[4,1] < 0.1 & d[4,1] >= 0.05 {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc") + "*"
		}
		else {
			local item_`j'_`d' = string(round(_b[percent_treated_`d'], .0001), "%13.0gc")
		}		
		
		local se_`j'_`d' = string(round(_se[percent_treated_`d'], .0001), "%13.0gc")
		
		local j = `j' + 1
	}

	file write file10 _n "\multirow{2}{*}{`d'} & `item_1_`d'' & `item_2_`d'' & `item_3_`d''  & `item_4_`d'' & `item_5_`d'' & `item_6_`d''\\"
	file write file10 _n "& (`se_1_`d'') & (`se_2_`d'') & (`se_3_`d'') & (`se_4_`d'') & (`se_5_`d'') & (`se_6_`d'')\\"

	if `i' < `num' {
		file write file10 _n "& & & & & &\\"	
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
