**Create Table 14: Summary Statistics By Ring****

clear all

cd "$repository/data_sets/generated"

use table34_unique_data_clean

drop if test == "pre"

***********************************************************************************
**If want to reproduce table restricting sample to control kids, add the code below


keep if (C == 1 & first_random == 1) | (CC == 1 & first_random == 1) | (CT_pretreat == 1) | (CK_prekinder == 1)


***********************************************************************************


**Merging with number of neighbors by rings

merge 1:1 child test year using merged_neigh_count_rings

**Keeping the observations pertaining to our relevant sample
keep if _merge == 3

drop _merge

**Defining Key Explanatory Variable
foreach ring in 0_10000 10000_20000 20000_30000 30000_40000 40000_50000 {
gen percent_treated_`ring' = (treated_`ring' / (treated_`ring' + control_`ring'))*100
}

**Generated Num Total Neighbors
foreach ring in 0_10000 10000_20000 20000_30000 30000_40000 40000_50000 {
gen total_neigh_`ring' = treated_`ring' + control_`ring'
}

file open file11 using "$repository/analysis/tables/tables_no_pre_number_treated/table14_summary_rings.tex", replace write


file write file11 "\documentclass[11pt]{article}"
file write file11 _n "\usepackage{booktabs, multicol, multirow}"
file write file11 _n "\usepackage{caption}"
file write file11 _n "\userpackage[flushleft]{threeparttable}"
file write file11 _n	"\begin{document}"

file write file11 _n "\begin{table}[H]"
file write file11 _n "\centering"
file write file11 _n "\caption{Descriptive Statistics for Rings}"
file write file11 _n "\label{ring_stat}  \begin{threeparttable}"
file write file11 _n "\begin{tabular}{lccc}"
file write file11 _n "$ d_j $ & $ N^{treated}$  & $N^{control}$ & $ N^{total}_{i,t,d_j}$\\" 
file write file11 _n "\toprule"
file write file11 _n "\midrule"


local i = 1

foreach ring in 0_10000 10000_20000 20000_30000 30000_40000 40000_50000 {
		local i = 1
		tabstat treated_`ring', save stat(mean semean n)
		mat a = r(StatTotal)
		mat list a
		local item`i' = string(round(a[1,1], 0.01), "%13.0gc") //Mean
		di `item`i''
		local i = `i' + 1
		local item`i' = string(round(a[2,1], 0.01), "%13.0gc") //Standard Error
		local i = `i' + 1
		tabstat control_`ring', save stat(mean semean n)
		mat a = r(StatTotal)
		mat list a
		local item`i' = string(round(a[1,1], 0.01), "%13.0gc") //Mean
		local i = `i' + 1
		local item`i' = string(round(a[2,1], 0.01), "%13.0gc") //Standard Error
		local i = `i' + 1
		tabstat total_neigh_`ring', save stat(mean semean n)
		mat a = r(StatTotal)
		mat list a
		local item`i' = string(round(a[1,1], 0.01), "%13.0gc") //Mean
		local i = `i' + 1
		local item`i' = string(round(a[2,1], 0.01), "%13.0gc") //Standard Error
		local i = `i' + 1
		
		 file write file11 _n "\multirow{2}{*}{`ring'} & `item1' & `item3' & `item5' \\"
		 file write file11 _n "& (`item2') & (`item4') & (`item6') \\"
		}
		

file write file11 _n "\midrule"
file write file11 _n "\bottomrule"
file write file11 _n "\end{tabular}"
file write file11 _n "\begin{tablenotes}"
file write file11 _n "\footnotesize"

file write file11 _n "\item \textit{Notes:} This table provides a descriptive statistics on the number of treated and control neighbors at various distances from a control child, as well as the percentage of neighbors who have been assigned to one of the treatment groups."
file write file11 _n "\item Standard errors in parenthesis."

file write file11 _n "\end{tablenotes}"
file write file11 _n "\end{threeparttable}"
file write file11 _n "\end{table}"

file write file11 _n	"\end{document}"

file close file11

*******************************************
**Create Table 15: Fade-Out Regressions****
*******************************************

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
gen test_num = 1 if test == "mid"
replace test_num = 2 if test == "post"
replace test_num = 3 if test == "sl"
replace test_num = 4 if test == "aoy1"
replace test_num = 5 if test == "aoy2"
replace test_num = 6 if test == "aoy3"
replace test_num = 7 if test == "aoy4"

sort child test_num
xtset child test_num	
	

local ring "0_10000 10000_20000 20000_30000 30000_40000 40000_50000"
local num : list sizeof local(ring)
local i = 1


file open file12 using "$repository/analysis/tables/tables_no_pre_number_treated/table15_fadeout.tex", replace write



*file open file4 using "$repository/analysis/tables/table7.tex", replace write

file write file12 _n "\documentclass[11pt]{article}"
file write file12 _n "\usepackage{booktabs, multicol, multirow}"
file write file12 _n "\usepackage{caption}"
file write file12 _n "\userpackage[flushleft]{threeparttable}"
file write file12 _n	"\begin{document}"


file write file12 _n "\begin{table}[H]\centering \caption{Spatial Fade-out of Spillover Effects}  \scalebox{1}{ \label{tab:donuts}  \begin{threeparttable}"
file write file12 _n "\begin{tabular}{lccc|ccc}"
file write file12 _n "\toprule"
file write file12 _n "\midrule"
file write file12 _n "& \multicolumn{3}{c}{Cognitive Scores} & \multicolumn{3}{c}{Non-cognitive Scores}\\ \cline{2-7}"
file write file12 _n "Step Size & Pooled OLS & Fixed Effect & Random Effect & Pooled OLS & Fixed Effect & Random Effect\\"
file write file12 _n "10000 & (1) & (2) & (3) & (4) & (5) & (6)\\"
file write file12 _n "\midrule"

**Running main regressions	

foreach d of local ring  {	
	local j = 1
	foreach assess in cog ncog {
	***POOLED OLS
	quietly reg std_`assess' treated_`d' total_neigh_`d' std_cog_pre std_ncog_pre distto1 distto2 i.gender_num i.race_num i.year i.blockgroup_num i.test_num age_pre if has_`assess' == 1, cluster(child)
	
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


	***RANDOM EFFECTS
	quietly xtreg std_`assess' treated_`d' total_neigh_`d' std_cog_pre std_ncog_pre distto1 distto2 i.gender_num i.race_num i.year i.blockgroup_num i.test_num age_pre if has_`assess' == 1, re cluster(child) 
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

	file write file12 _n "\multirow{2}{*}{`d'} & `item_1_`d'' & `item_2_`d'' & `item_3_`d''  & `item_4_`d'' & `item_5_`d'' & `item_6_`d''\\"
	file write file12 _n "& (`se_1_`d'') & (`se_2_`d'') & (`se_3_`d'') & (`se_4_`d'') & (`se_5_`d'') & (`se_6_`d'')\\"

	if `i' < `num' {
		file write file12 _n "& & & & & &\\"	
	}
	local i = `i' + 1
}	
	
file write file12 _n "\midrule"
file write file12 _n "\bottomrule"
file write file12 _n "\end{tabular}"
file write file12 _n "\begin{tablenotes}"
file write file12 _n "\footnotesize"

file write file12 _n "\item \textit{Notes:} This table shows the impact of a 1\% increase in the share of treated neighbors  living at various distances away from a control child on his/her cognitive and non-cognitive performance."
file write file12 _n "\item Robust standard errors, clustered at the individual level in parentheses."
file write file12 _n "\item *** p$<$0.01, ** p$<$0.05, * p$<$0.1"
file write file12 _n "\end{tablenotes}"
file write file12 _n "\end{threeparttable}"
file write file12 _n "} \end{table}"


file write file12 _n "\end{document}"

file close file12




