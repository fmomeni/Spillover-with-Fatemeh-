**Create Table 5 and Table 6****


clear all

cd "$repository/data_sets/generated"

use table56_unique_data_clean

drop if test =="pre"

***********************************************************************************
**If want to reproduce table restricting sample to control kids, add the code below


keep if (C == 1 & first_random == 1) | (CC == 1 & first_random == 1) | (CT_pretreat == 1) | (CK_prekinder == 1)


***********************************************************************************

**Table 5

file open file2 using "$repository/analysis/tables/tables_no_pre_percentage_treated/table5.tex", replace write


file write file2 "\documentclass[11pt]{article}"
file write file2 _n "\usepackage{booktabs, multicol, multirow}"
file write file2 _n "\usepackage{caption}"
file write file2 _n "\userpackage[flushleft]{threeparttable}"
file write file2 _n	"\begin{document}"

file write file2 _n "\begin{table}[h]"
file write file2 _n "\begin{threeparttable}"
file write file2 _n "\centering"
file write file2 _n "\caption{Number Neighbors at the Time of Each Assessment}"
file write file2 _n "\label{tab:Nstat}"
file write file2 _n "\begin{tabular}{l|cc|cc|cc|cc}"
file write file2 _n "\toprule"
file write file2 _n "\midrule"
file write file2 _n "& \multicolumn{2}{c}{d $=$ 1000} & \multicolumn{2}{c}{d $=$ 5000} & \multicolumn{2}{c}{d $=$ 10000} & \multicolumn{2}{c}{d $=$ 15000}\\" 
file write file2 _n "Assessment (t) & $ N^{{treated}_{d}} $ & $ N^{{control}_{d}}$ & $ N^{{treated}_{d}}$ & $ N^{{control}_{d}}$ & $ N^{{treated}_{d}}$ & $ N^{{control}_{d}}$ & $ N^{{treated}_{d}}$ & $ N^{{control}_{d}}$ \\"
file write file2 _n "\midrule"



local i = 1
local j = 1


foreach distance in 1000 5000 10000 15000 {
		tabstat treated_`distance', by(test) save stat(mean semean n)
		local i = 1
		local j = 1
		foreach stat in Stat5 Stat6 Stat7 Stat1 Stat2 Stat3 Stat4 {
		mat a = r(`stat')
		mat list a
		local item`distance'_`i' = string(round(a[1,1], 0.01), "%13.0gc") //Mean
		di `item`distance'_`i''
		local i = `i' + 1
		local item`distance'_`i' = string(round(a[2,1], 0.01), "%13.0gc") //Standard Error
		local i = `i' + 1
		}
		mat b = r(StatTotal)
		local itemtotal`distance'_`j' = string(round(b[1,1], 0.01), "%13.0gc")
		local j = `j' + 1
		local itemtotal`distance'_`j' = string(round(b[2,1], 0.01), "%13.0gc")
		local j = `j' + 1
		local itemtotal`distance'_`j' = string(b[3,1], "%13.0gc")
		local j = `j' + 1
		
		tabstat control_`distance', by(test) save stat(mean semean n)
		foreach stat in Stat5 Stat6 Stat7 Stat1 Stat2 Stat3 Stat4 {
		mat a = r(`stat')
		local item`distance'_`i' = string(round(a[1,1], 0.01), "%13.0gc") //Mean
		local i = `i' + 1
		local item`distance'_`i' = string(round(a[2,1], 0.01), "%13.0gc") //Standard Error
		local i = `i' + 1
		}
		mat b = r(StatTotal)
		local itemtotal`distance'_`j' = string(round(b[1,1], 0.01), "%13.0gc")
		local j = `j' + 1
		local itemtotal`distance'_`j' = string(round(b[2,1], 0.01), "%13.0gc")
		local j = `j' + 1
		local itemtotal`distance'_`j' = string(b[3,1], "%13.0gc")
		local j = `j' + 1
		
}


file write file2 _n "\multirow{2}{*}{Mid} & `item1000_1' & `item1000_15' & `item5000_1' & `item5000_15' & `item10000_1' & `item10000_15' &  `item15000_1' & `item15000_15' \\"
file write file2 _n "& (`item1000_2') & (`item1000_16') & (`item5000_2') & (`item5000_16') & (`item10000_2') & (`item10000_16') & (`item15000_2') & (`item15000_16')\\"
file write file2 _n "& & & & & & & & \\"
file write file2 _n "\multirow{2}{*}{Post} & `item1000_3' & `item1000_17' & `item5000_3' & `item5000_17'  &`item10000_3' & `item10000_17'  & `item15000_3'   & `item15000_17'\\"
file write file2 _n "& (`item1000_4') & (`item1000_18') & (`item5000_4') & (`item5000_18') & (`item10000_4') & (`item10000_18') & (`item15000_4') & (`item15000_18')\\"
file write file2 _n "& & & & & & & &\\"
file write file2 _n "\multirow{2}{*}{Summer Loss} & `item1000_5' & `item1000_19' & `item5000_5' & `item5000_19' & `item10000_5' & `item10000_19' & `item15000_5' & `item15000_19'\\"
file write file2 _n "& (`item1000_6') & (`item1000_20') & (`item5000_6') & (`item5000_20') & (`item10000_6') & (`item10000_20') & (`item15000_6') & (`item15000_20')\\"
file write file2 _n "& & & & & & & &\\"
file write file2 _n "\multirow{2}{*}{Aged-Out Year 1} & `item1000_7' & `item1000_21' & `item5000_7' & `item5000_21' & `item10000_7' & `item10000_21' & `item15000_7' & `item15000_21'\\"
file write file2 _n "& (`item1000_8') & (`item1000_22') & (`item5000_8') & (`item5000_22') & (`item10000_8') & (`item10000_22') & (`item15000_8') & (`item15000_22')\\"
file write file2 _n "& & & & & & & & \\"
file write file2 _n "\multirow{2}{*}{Aged-Out Year 2} & `item1000_9' & `item1000_23' & `item5000_9' & `item5000_23' & `item10000_9' & `item10000_23' & `item15000_9' & `item15000_23'\\"
file write file2 _n "& (`item1000_10') & (`item1000_24') & (`item5000_10') & (`item5000_24') & (`item10000_10') & (`item10000_24') & (`item15000_10') & (`item15000_24')\\"
file write file2 _n "& & & & & & & & \\"
file write file2 _n "\multirow{2}{*}{Aged-Out Year 3} & `item1000_11' & `item1000_25' & `item5000_11' & `item5000_25' & `item10000_11' & `item10000_25' & `item15000_11' & `item15000_25'\\"
file write file2 _n "& (`item1000_12') & (`item1000_26') & (`item5000_12') & (`item5000_26') & (`item10000_12') & (`item10000_26') & (`item15000_12') & (`item15000_26')\\"
file write file2 _n "& & & & & & & & \\"
file write file2 _n "\multirow{2}{*}{Aged-Out Year 4} & `item1000_13' & `item1000_27' & `item5000_13' & `item5000_27' & `item10000_13' & `item10000_27' & `item15000_13' & `item15000_27'\\"
file write file2 _n "& (`item1000_14') & (`item1000_28') & (`item5000_14') & (`item5000_28') & (`item10000_14') & (`item10000_28') & (`item15000_14') & (`item15000_28')\\"
file write file2 _n "\midrule"
file write file2 _n "\multirow{2}{*}{All} & `itemtotal1000_1' & `itemtotal1000_4' & `itemtotal5000_1' & `itemtotal5000_4' & `itemtotal10000_1' & `itemtotal10000_4' & `itemtotal15000_1' & `itemtotal15000_4'\\"
file write file2 _n "& (`itemtotal1000_2') & (`itemtotal1000_5') & (`itemtotal5000_2') & (`itemtotal5000_5') & (`itemtotal10000_2') & (`itemtotal10000_5') & (`itemtotal15000_2') & (`itemtotal15000_5')\\"
file write file2 _n "\midrule"
file write file2 _n "Obs. & `itemtotal1000_3' &`itemtotal1000_6' & `itemtotal5000_3' & `itemtotal5000_6' &`itemtotal10000_3' & `itemtotal10000_6' & `itemtotal15000_3' & `itemtotal15000_6'\\"
file write file2 _n "\midrule"
file write file2 _n "\bottomrule"
file write file2 _n "\end{tabular}"


file write file2 _n "\begin{tablenotes}"
file write file2 _n "\footnotesize"

file write file2 _n "\item \textit{Notes:} This table shows the average number of treated and control neighbors at the time of different assessments in our final sample of control kids, for different definitions  of  neighborhood radii.  It only included those observations for which we have child's assessment outcome. The last column shows average number of treated and control neighbors, across all assessments."
file write file2 _n "\item Standard errors are reported in parentheses." 

file write file2 _n "\end{tablenotes}"
file write file2 _n "\end{threeparttable}"

file write file2 _n "\end{table}"

file write file2 _n "\end{document}"

file close file2



	

**Table 6

clear all

cd "$repository/data_sets/generated"

use table56_unique_data_clean

drop if test =="pre"

***********************************************************************************
**If want to reproduce table restricting sample to control kids, add the code below


keep if (C == 1 & first_random == 1) | (CC == 1 & first_random == 1) | (CT_pretreat == 1) | (CK_prekinder == 1)


***********************************************************************************

file open file3 using "$repository/analysis/tables/tables_no_pre_percentage_treated/table6.tex", replace write


file write file3 "\documentclass[11pt]{article}"
file write file3 _n "\usepackage{booktabs, multicol, multirow}"
file write file3 _n "\usepackage{caption}"
file write file3 _n "\userpackage[flushleft]{threeparttable}"
file write file3 _n	"\begin{document}"

file write file3 _n	"\begin{table}[]"
file write file3 _n	"\begin{threeparttable}"
file write file3 _n	"\centering"
file write file3 _n	"\caption{Average Percentage of Treated Neighbors in Our Final Sample}"
file write file3 _n	"\label{tab:p_sum_stat}"
file write file3 _n	"\begin{tabular}{l|lllll}"
file write file3 _n	"Assessment         & 1K meters  & 5K meters & 10K meters & 15K meters & 20K meters \\ \hline \hline"


local i = 1
local j = 1

foreach distance in 1000 5000 10000 15000 20000 {
		tabstat percent_treated_`distance', by(test) save stat(mean semean n)
		local i = 1
		foreach stat in Stat5 Stat6 Stat7 Stat1 Stat2 Stat3 Stat4 StatTotal{
		mat a = r(`stat')
		mat list a
		local item`distance'_`i' = string(round(a[1,1], 0.01), "%13.0gc") //Mean
		di `item`distance'_`i''
		local i = `i' + 1
		local item`distance'_`i' = string(round(a[2,1], 0.01), "%13.0gc") //Standard Error
		local i = `i' + 1
		}
}

file write file3 _n	"Mid     & `item1000_1' & `item5000_1' & `item10000_1'  &    `item15000_1'      &    `item20000_1'       \\"
file write file3 _n	"& (`item1000_2')  & (`item5000_2')  & (`item10000_2')  &    (`item15000_2' )    &  (`item20000_2')     \\"
file write file3 _n	"Post    & `item1000_3' & `item5000_3' & `item10000_3' &    `item15000_3'       &  `item20000_3'     \\"
file write file3 _n	"& (`item1000_4')  & (`item5000_4')  & (`item10000_4')  &   (`item15000_4' )     &     (`item20000_4')       \\"
file write file3 _n	"Summer Loss     & `item1000_5' & `item5000_5' & `item10000_5' &   `item15000_5'      &  `item20000_5'        \\"
file write file3 _n	"& (`item1000_6')  & (`item5000_6') & (`item10000_6')  &    (`item15000_6' )    &    (`item20000_6')    \\"
file write file3 _n	"Aged-Out Year 1    & `item1000_7' & `item5000_7' & `item10000_7'  &     `item15000_7'     &   `item20000_7'       \\"
file write file3 _n	"& (`item1000_8')  & (`item5000_8')  & (`item10000_8')  &      (`item15000_8' )   &   (`item20000_8')     \\"
file write file3 _n	"Aged-Out Year 2    & `item1000_9' & `item5000_9' & `item10000_9' &    `item15000_9'      &     `item20000_9'     \\"
file write file3 _n	"& (`item1000_10')  & (`item5000_10')  & (`item10000_10')  &  (`item15000_10' )      &     (`item20000_10')   \\"
file write file3 _n	"Aged-Out Year 3    & `item1000_11' & `item5000_11' & `item10000_11' &     `item15000_11'      &  `item20000_11'       \\"
file write file3 _n	"& (`item1000_12')  & (`item5000_12')  & (`item10000_12')  &    (`item15000_12' )    &     (`item20000_12')  \\"
file write file3 _n	"Aged-Out Year 4    & `item1000_13' & `item5000_13' & `item10000_13' & `item15000_13'        &   `item20000_13'       \\"
file write file3 _n	"& (`item1000_14')  & (`item5000_14')  & (`item10000_14')  &    (`item15000_14' )   &   (`item20000_14')     \\"
file write file3 _n	"Overall & `item1000_15' & `item5000_15' & `item10000_15' &    `item15000_15'     &    `item20000_15'       \\"
file write file3 _n	"& (`item1000_16')  & (`item5000_16')  & (`item10000_16')  &   (`item15000_16' )      &      (`item20000_16') \\ \hline"
file write file3 _n	"\end{tabular}"

file write file3 _n	"\begin{tablenotes}"
file write file3 _n	"\footnotesize"

file write file3 _n	"\item \textit{Notes:} Mean percentage of treated neighbors $P_{i,t,d}^{treated}$, (of the final sample) at the time of each assessment is presented for $d=\{1000; 5000; 10000; 15000; 20000\}$ meters. Standard errors are reported in parentheses."

file write file3 _n	"\end{tablenotes}"
file write file3 _n	"\end{threeparttable}"
file write file3 _n	"\end{table}" 

file write file3 _n "\end{document}"

file close file3


