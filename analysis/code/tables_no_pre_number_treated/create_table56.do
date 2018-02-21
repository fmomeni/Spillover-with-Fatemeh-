**Create Table 5 and Table 6****


clear all

cd "$repository/data_sets/generated"

use table56_unique_data_clean

drop if test == "pre"


***********************************************************************************
**If want to reproduce table restricting sample to control kids, add the code below

/*
keep if (C == 1 & first_random == 1) | (CC == 1 & first_random == 1) | (CT_pretreat == 1) | (CK_prekinder == 1)
*/

***********************************************************************************

**Table 5

file open file2 using "$repository/analysis/tables/tables_no_pre_number_treated/table5.tex", replace write


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
file write file2 _n "\begin{tabular}{l|cc|cc|cc|cc|cc|cc|cc|cc|cc|cc|cc|cc|cc}"
file write file2 _n "\toprule"
file write file2 _n "\midrule"
file write file2 _n "& \multicolumn{2}{c}{d $=$ 500} & \multicolumn{2}{c}{d $=$ 1000} & \multicolumn{2}{c}{d $=$ 2000} & \multicolumn{2}{c}{d $=$ 3000} & \multicolumn{2}{c}{d $=$ 4000} & \multicolumn{2}{c}{d $=$ 5000} & \multicolumn{2}{c}{d $=$ 6000} & \multicolumn{2}{c}{d $=$ 7000} & \multicolumn{2}{c}{d $=$ 8000} & \multicolumn{2}{c}{d $=$ 9000} & \multicolumn{2}{c}{d $=$ 10000} & \multicolumn{2}{c}{d $=$ 15000} & \multicolumn{2}{c}{d $=$ 20000}\\" 
file write file2 _n "Assessment (t) & $ N^{{treated}_{d}}$ & $ N^{{control}_{d}}$ & $ N^{{treated}_{d}}$ & $ N^{{control}_{d}}$ & $ N^{{treated}_{d}}$ & $ N^{{control}_{d}}$ & $ N^{{treated}_{d}}$ & $ N^{{control}_{d}}$ & $ N^{{treated}_{d}}$ & $ N^{{control}_{d}}$ & $ N^{{treated}_{d}}$ & $ N^{{control}_{d}}$ & $ N^{{treated}_{d}}$ & $ N^{{control}_{d}}$ & $ N^{{treated}_{d}}$ & $ N^{{control}_{d}}$ & $ N^{{treated}_{d}}$ & $ N^{{control}_{d}}$ & $ N^{{treated}_{d}}$ & $ N^{{control}_{d}}$ & $ N^{{treated}_{d}}$ & $ N^{{control}_{d}}$ & $ N^{{treated}_{d}}$ & $ N^{{control}_{d}}$\\"
file write file2 _n "\midrule"



local i = 1
local j = 1


foreach distance in 500 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 15000 20000 {
		tabstat treated_`distance', by(test) save stat(mean semean n)
		local i = 1
		local j = 1
		foreach stat in Stat7 Stat5 Stat6 Stat8 Stat1 Stat2 Stat3 Stat4 {
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
		foreach stat in Stat7 Stat5 Stat6 Stat8 Stat1 Stat2 Stat3 Stat4 {
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

file write file2 _n "\multirow{2}{*}{Pre} & `item500_1' & `item500_17' & `item1000_1' & `item1000_17' & `item2000_1' & `item2000_17' &  `item3000_1' & `item3000_17' & `item4000_1' & `item4000_17' & `item5000_1' & `item5000_17' & `item6000_1' & `item6000_17' & `item7000_1' & `item7000_17' & `item8000_1' & `item8000_17' & `item9000_1' & `item9000_17' & `item10000_1' & `item10000_17' & `item15000_1' & `item15000_17' & `item20000_1' & `item20000_17' \\"
file write file2 _n "& (`item500_2') & (`item500_18') & (`item1000_2') & (`item1000_18') & (`item2000_2') & (`item2000_18') & (`item3000_2') & (`item3000_18') & (`item4000_2') & (`item4000_18') & (`item5000_2') & (`item5000_18')& (`item6000_2') & (`item6000_18') & (`item7000_2') & (`item7000_18') & (`item8000_2') & (`item8000_18') & (`item9000_2') & (`item9000_18') & (`item10000_2') & (`item10000_18') & (`item15000_2') & (`item15000_18') & (`item20000_2') & (`item20000_18')\\"
file write file2 _n "& & & & & & & & & & & & & & & & & & & & & & & & & &  \\"
file write file2 _n "\multirow{2}{*}{Mid} & `item500_3' & `item500_19' & `item1000_3' & `item1000_19' & `item2000_3' & `item2000_19' &  `item3000_3' & `item3000_19' & `item4000_3' & `item4000_19' & `item5000_3' & `item5000_19' & `item6000_3' & `item6000_19' & `item7000_3' & `item7000_19' & `item8000_3' & `item8000_19' & `item9000_3' & `item9000_19' & `item10000_3' & `item10000_19' & `item15000_3' & `item15000_19' & `item20000_3' & `item20000_19' \\"
file write file2 _n "& (`item500_4') & (`item500_20') & (`item1000_4') & (`item1000_20') & (`item2000_4') & (`item2000_20') & (`item3000_4') & (`item3000_20') & (`item4000_4') & (`item4000_20') & (`item5000_4') & (`item5000_20')& (`item6000_4') & (`item6000_20') & (`item7000_4') & (`item7000_20') & (`item8000_4') & (`item8000_20') & (`item9000_4') & (`item9000_20') & (`item10000_4') & (`item10000_20') & (`item15000_4') & (`item15000_20') & (`item20000_4') & (`item20000_20')\\"
file write file2 _n "& & & & & & & & & & & & & & & & & & & & & & & & & &  \\"
file write file2 _n "\multirow{2}{*}{Post} & `item500_5' & `item500_21' & `item1000_5' & `item1000_21' & `item2000_5' & `item2000_21' &  `item3000_5' & `item3000_21' & `item4000_5' & `item4000_21' & `item5000_5' & `item5000_21' & `item6000_5' & `item6000_21' & `item7000_5' & `item7000_21' & `item8000_5' & `item8000_21' & `item9000_5' & `item9000_21' & `item10000_5' & `item10000_21' & `item15000_5' & `item15000_21' & `item20000_5' & `item20000_21' \\"
file write file2 _n "& (`item500_6') & (`item500_22') & (`item1000_6') & (`item1000_22') & (`item2000_6') & (`item2000_22') & (`item3000_6') & (`item3000_22') & (`item4000_6') & (`item4000_22') & (`item5000_6') & (`item5000_22')& (`item6000_6') & (`item6000_22') & (`item7000_6') & (`item7000_22') & (`item8000_6') & (`item8000_22') & (`item9000_6') & (`item9000_22') & (`item10000_6') & (`item10000_22') & (`item15000_6') & (`item15000_22') & (`item20000_6') & (`item20000_22')\\"
file write file2 _n "& & & & & & & & & & & & & & & & & & & & & & & & & &  \\"
file write file2 _n "\multirow{2}{*}{Summer Loss} & `item500_7' & `item500_23' & `item1000_7' & `item1000_23' & `item2000_7' & `item2000_23' &  `item3000_7' & `item3000_23' & `item4000_7' & `item4000_23' & `item5000_7' & `item5000_23' & `item6000_7' & `item6000_23' & `item7000_7' & `item7000_23' & `item8000_7' & `item8000_23' & `item9000_7' & `item9000_23' & `item10000_7' & `item10000_23' & `item15000_7' & `item15000_23' & `item20000_7' & `item20000_23' \\"
file write file2 _n "& (`item500_8') & (`item500_24') & (`item1000_8') & (`item1000_24') & (`item2000_8') & (`item2000_24') & (`item3000_8') & (`item3000_24') & (`item4000_8') & (`item4000_24') & (`item5000_8') & (`item5000_24')& (`item6000_8') & (`item6000_24') & (`item7000_8') & (`item7000_24') & (`item8000_8') & (`item8000_24') & (`item9000_8') & (`item9000_24') & (`item10000_8') & (`item10000_24') & (`item15000_8') & (`item15000_24') & (`item20000_8') & (`item20000_24')\\"
file write file2 _n "& & & & & & & & & & & & & & & & & & & & & & & & & &  \\"
file write file2 _n "\multirow{2}{*}{Aged-Out Year 1} & `item500_9' & `item500_25' & `item1000_9' & `item1000_25' & `item2000_9' & `item2000_25' &  `item3000_9' & `item3000_25' & `item4000_9' & `item4000_25' & `item5000_9' & `item5000_25' & `item6000_9' & `item6000_25' & `item7000_9' & `item7000_25' & `item8000_9' & `item8000_25' & `item9000_9' & `item9000_25' & `item10000_9' & `item10000_25' & `item15000_9' & `item15000_25' & `item20000_9' & `item20000_25' \\"
file write file2 _n "& (`item500_10') & (`item500_26') & (`item1000_10') & (`item1000_26') & (`item2000_10') & (`item2000_26') & (`item3000_10') & (`item3000_26') & (`item4000_10') & (`item4000_26') & (`item5000_10') & (`item5000_26')& (`item6000_10') & (`item6000_26') & (`item7000_10') & (`item7000_26') & (`item8000_10') & (`item8000_26') & (`item9000_10') & (`item9000_26') & (`item10000_10') & (`item10000_26') & (`item15000_10') & (`item15000_26') & (`item20000_10') & (`item20000_26')\\"
file write file2 _n "& & & & & & & & & & & & & & & & & & & & & & & & & &  \\"
file write file2 _n "\multirow{2}{*}{Aged-Out Year 2} & `item500_11' & `item500_27' & `item1000_11' & `item1000_27' & `item2000_11' & `item2000_27' &  `item3000_11' & `item3000_27' & `item4000_11' & `item4000_27' & `item5000_11' & `item5000_27' & `item6000_11' & `item6000_27' & `item7000_11' & `item7000_27' & `item8000_11' & `item8000_27' & `item9000_11' & `item9000_27' & `item10000_11' & `item10000_27' & `item15000_11' & `item15000_27' & `item20000_11' & `item20000_27' \\"
file write file2 _n "& (`item500_12') & (`item500_28') & (`item1000_12') & (`item1000_28') & (`item2000_12') & (`item2000_28') & (`item3000_12') & (`item3000_28') & (`item4000_12') & (`item4000_28') & (`item5000_12') & (`item5000_28')& (`item6000_12') & (`item6000_28') & (`item7000_12') & (`item7000_28') & (`item8000_12') & (`item8000_28') & (`item9000_12') & (`item9000_28') & (`item10000_12') & (`item10000_28') & (`item15000_12') & (`item15000_28') & (`item20000_12') & (`item20000_28')\\"
file write file2 _n "& & & & & & & & & & & & & & & & & & & & & & & & & &  \\"
file write file2 _n "\multirow{2}{*}{Aged-Out Year 3} & `item500_13' & `item500_29' & `item1000_13' & `item1000_29' & `item2000_13' & `item2000_29' &  `item3000_13' & `item3000_29' & `item4000_13' & `item4000_29' & `item5000_13' & `item5000_29' & `item6000_13' & `item6000_29' & `item7000_13' & `item7000_29' & `item8000_13' & `item8000_29' & `item9000_13' & `item9000_29' & `item10000_13' & `item10000_29' & `item15000_13' & `item15000_29' & `item20000_13' & `item20000_29' \\"
file write file2 _n "& (`item500_14') & (`item500_30') & (`item1000_14') & (`item1000_30') & (`item2000_14') & (`item2000_30') & (`item3000_14') & (`item3000_30') & (`item4000_14') & (`item4000_30') & (`item5000_14') & (`item5000_30')& (`item6000_14') & (`item6000_30') & (`item7000_14') & (`item7000_30') & (`item8000_14') & (`item8000_30') & (`item9000_14') & (`item9000_30') & (`item10000_14') & (`item10000_30') & (`item15000_14') & (`item15000_30') & (`item20000_14') & (`item20000_30')\\"
file write file2 _n "& & & & & & & & & & & & & & & & & & & & & & & & & &  \\"
file write file2 _n "\multirow{2}{*}{Aged-Out Year 4} & `item500_15' & `item500_31' & `item1000_15' & `item1000_31' & `item2000_15' & `item2000_31' &  `item3000_15' & `item3000_31' & `item4000_15' & `item4000_31' & `item5000_15' & `item5000_31' & `item6000_15' & `item6000_31' & `item7000_15' & `item7000_31' & `item8000_15' & `item8000_31' & `item9000_15' & `item9000_31' & `item10000_15' & `item10000_31' & `item15000_15' & `item15000_31' & `item20000_15' & `item20000_31' \\"
file write file2 _n "& (`item500_16') & (`item500_32') & (`item1000_16') & (`item1000_32') & (`item2000_16') & (`item2000_32') & (`item3000_16') & (`item3000_32') & (`item4000_16') & (`item4000_32') & (`item5000_16') & (`item5000_32')& (`item6000_16') & (`item6000_32') & (`item7000_16') & (`item7000_32') & (`item8000_16') & (`item8000_32') & (`item9000_16') & (`item9000_32') & (`item10000_16') & (`item10000_32') & (`item15000_16') & (`item15000_32') & (`item20000_16') & (`item20000_32')\\"
file write file2 _n "\midrule"
file write file2 _n "\multirow{2}{*}{All} & `itemtotal500_1' & `itemtotal500_4' & `itemtotal1000_1' & `itemtotal1000_4' & `itemtotal2000_1' & `itemtotal2000_4' & `itemtotal13000_1' & `itemtotal3000_4' & `itemtotal14000_1' & `itemtotal4000_4' & `itemtotal15000_1' & `itemtotal5000_4'& `itemtotal16000_1' & `itemtotal6000_4'& `itemtotal7000_1' & `itemtotal7000_4' & `itemtotal8000_1' & `itemtotal8000_4' & `itemtotal9000_1' & `itemtotal9000_4' & `itemtotal10000_1' & `itemtotal10000_4' & `itemtotal15000_1' & `itemtotal15000_4' & `itemtotal20000_1' & `itemtotal20000_4'\\"
file write file2 _n "& (`itemtotal500_2') & (`itemtotal500_5') & (`itemtotal1000_2') & (`itemtotal1000_5') & (`itemtotal2000_2') & (`itemtotal2000_5') & (`itemtotal3000_2') & (`itemtotal3000_5') & (`itemtotal4000_2') & (`itemtotal4000_5') & (`itemtotal5000_2') & (`itemtotal5000_5') & (`itemtotal6000_2') & (`itemtotal6000_5') & (`itemtotal7000_2') & (`itemtotal7000_5') & (`itemtotal8000_2') & (`itemtotal8000_5') & (`itemtotal9000_2') & (`itemtotal9000_5') & (`itemtotal10000_2') & (`itemtotal10000_5') & (`itemtotal15000_2') & (`itemtotal15000_5') & (`itemtotal20000_2') & (`itemtotal20000_5')\\"
file write file2 _n "\midrule"
file write file2 _n "Obs. & `itemtotal500_3' &`itemtotal500_6' & `itemtotal1000_3' & `itemtotal1000_6' &`itemtotal2000_3' & `itemtotal2000_6' & `itemtotal3000_3' & `itemtotal3000_6' & `itemtotal4000_3' & `itemtotal4000_6' & `itemtotal5000_3' & `itemtotal5000_6' & `itemtotal6000_3' & `itemtotal6000_6' & `itemtotal7000_3' & `itemtotal7000_6' & `itemtotal8000_3' & `itemtotal8000_6' & `itemtotal9000_3' & `itemtotal9000_6' & `itemtotal10000_3' & `itemtotal10000_6' & `itemtotal15000_3' & `itemtotal15000_6' & `itemtotal20000_3' & `itemtotal20000_6'\\"
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

drop if test == "pre"

***********************************************************************************
**If want to reproduce table restricting sample to control kids, add the code below

/*
keep if (C == 1 & first_random == 1) | (CC == 1 & first_random == 1) | (CT_pretreat == 1) | (CK_prekinder == 1)
*/


***********************************************************************************

file open file3 using "$repository/analysis/tables/tables_no_pre_number_treated/table6.tex", replace write


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
file write file3 _n	"\begin{tabular}{l|lllllllllllll}"
file write file3 _n	"Assessment         & 0.5K meters & 1K meters & 2K meters & 3K meters & 4K meters  & 5K meters & 6K meters & 7K meters & 8K meters & 9K meters & 10K meters & 15K meters & 20K meters \\ \hline \hline"


local i = 1
local j = 1

foreach distance in 500 1000 2000 3000 4000 5000 6000 7000 8000 9000 10000 15000 20000 {
		tabstat percent_treated_`distance', by(test) save stat(mean semean n)
		local i = 1
		foreach stat in Stat7 Stat5 Stat6 Stat8 Stat1 Stat2 Stat3 Stat4 StatTotal{
		mat a = r(`stat')
		mat list a
		local item`distance'_`i' = string(round(a[1,1], 0.01), "%13.0gc") //Mean
		di `item`distance'_`i''
		local i = `i' + 1
		local item`distance'_`i' = string(round(a[2,1], 0.01), "%13.0gc") //Standard Error
		local i = `i' + 1
		}
}


file write file3 _n	"Pre     & `item500_1' & `item1000_1' & `item2000_1'  &    `item3000_1'      &    `item4000_1' & `item5000_1' & `item6000_1' & `item7000_1' & `item8000_1' & `item9000_1' & `item10000_1' & `item15000_1' & `item20000_1'        \\"
file write file3 _n	"& (`item500_2')  & (`item1000_2')  & (`item2000_2')  &    (`item3000_2' )    &  (`item4000_2') & (`item5000_2')  & (`item6000_2')  & (`item7000_2')  &    (`item8000_2' )    &  (`item9000_2') & (`item10000_2')  &    (`item15000_2' )    &  (`item20000_2')    \\"
file write file3 _n	"Mid     & `item500_3' & `item1000_3' & `item2000_3'  &    `item3000_3'      &    `item4000_3' & `item5000_3' & `item6000_3' & `item7000_3' & `item8000_3' & `item9000_3' & `item10000_3' & `item15000_3' & `item20000_3'        \\"
file write file3 _n	"& (`item500_4')  & (`item1000_4')  & (`item2000_4')  &    (`item3000_4' )    &  (`item4000_4') & (`item5000_4')  & (`item6000_4')  & (`item7000_4')  &    (`item8000_4' )    &  (`item9000_4') & (`item10000_4')  &    (`item15000_4' )    &  (`item20000_4')    \\"
file write file3 _n	"Post     & `item500_5' & `item1000_5' & `item2000_5'  &    `item3000_5'      &    `item4000_5' & `item5000_5' & `item6000_5' & `item7000_5' & `item8000_5' & `item9000_5' & `item10000_5' & `item15000_5' & `item20000_5'        \\"
file write file3 _n	"& (`item500_6')  & (`item1000_6')  & (`item2000_6')  &    (`item3000_6' )    &  (`item4000_6') & (`item5000_6')  & (`item6000_6')  & (`item7000_6')  &    (`item8000_6' )    &  (`item9000_6') & (`item10000_6')  &    (`item15000_6' )    &  (`item20000_6')    \\"
file write file3 _n	"Summer Loss     & `item500_7' & `item1000_7' & `item2000_7'  &    `item3000_7'      &    `item4000_7' & `item5000_7' & `item6000_7' & `item7000_7' & `item8000_7' & `item9000_7' & `item10000_7' & `item15000_7' & `item20000_7'        \\"
file write file3 _n	"& (`item500_8')  & (`item1000_8')  & (`item2000_8')  &    (`item3000_8' )    &  (`item4000_8') & (`item5000_8')  & (`item6000_8')  & (`item7000_8')  &    (`item8000_8' )    &  (`item9000_8') & (`item10000_8')  &    (`item15000_8' )    &  (`item20000_8')    \\"
file write file3 _n	"Aged-Out Year 1     & `item500_9' & `item1000_9' & `item2000_9'  &    `item3000_9'      &    `item4000_9' & `item5000_9' & `item6000_9' & `item7000_9' & `item8000_9' & `item9000_9' & `item10000_9' & `item15000_9' & `item20000_9'        \\"
file write file3 _n	"& (`item500_10')  & (`item1000_10')  & (`item2000_10')  &    (`item3000_10' )    &  (`item4000_10') & (`item5000_10')  & (`item6000_10')  & (`item7000_10')  &    (`item8000_10' )    &  (`item9000_10') & (`item10000_10')  &    (`item15000_10' )    &  (`item20000_10')    \\"
file write file3 _n	"Aged-Out Year 2     & `item500_11' & `item1000_11' & `item2000_11'  &    `item3000_11'      &    `item4000_11' & `item5000_11' & `item6000_11' & `item7000_11' & `item8000_11' & `item9000_11' & `item10000_11' & `item15000_11' & `item20000_11'        \\"
file write file3 _n	"& (`item500_12')  & (`item1000_12')  & (`item2000_12')  &    (`item3000_12' )    &  (`item4000_12') & (`item5000_12')  & (`item6000_12')  & (`item7000_12')  &    (`item8000_12' )    &  (`item9000_12') & (`item10000_12')  &    (`item15000_12' )    &  (`item20000_12')    \\"
file write file3 _n	"Aged-Out Year 3     & `item500_13' & `item1000_13' & `item2000_13'  &    `item3000_13'      &    `item4000_13' & `item5000_13' & `item6000_13' & `item7000_13' & `item8000_13' & `item9000_13' & `item10000_13' & `item15000_13' & `item20000_13'        \\"
file write file3 _n	"& (`item500_14')  & (`item1000_14')  & (`item2000_14')  &    (`item3000_14' )    &  (`item4000_14') & (`item5000_14')  & (`item6000_14')  & (`item7000_14')  &    (`item8000_14' )    &  (`item9000_14') & (`item10000_14')  &    (`item15000_14' )    &  (`item20000_14')    \\"
file write file3 _n	"Aged-Out Year 4     & `item500_15' & `item1000_15' & `item2000_15'  &    `item3000_15'      &    `item4000_15' & `item5000_15' & `item6000_15' & `item7000_15' & `item8000_15' & `item9000_15' & `item10000_15' & `item15000_15' & `item20000_15'        \\"
file write file3 _n	"& (`item500_16')  & (`item1000_16')  & (`item2000_16')  &    (`item3000_16' )    &  (`item4000_16') & (`item5000_16')  & (`item6000_16')  & (`item7000_16')  &    (`item8000_16' )    &  (`item9000_16') & (`item10000_16')  &    (`item15000_16' )    &  (`item20000_16')    \\"
file write file3 _n	"Overall     & `item500_17' & `item1000_17' & `item2000_17'  &    `item3000_17'      &    `item4000_17' & `item5000_17' & `item6000_17' & `item7000_17' & `item8000_17' & `item9000_17' & `item10000_17' & `item15000_17' & `item20000_17'        \\"
file write file3 _n	"& (`item500_18')  & (`item1000_18')  & (`item2000_18')  &    (`item3000_18' )    &  (`item4000_18') & (`item5000_18')  & (`item6000_18')  & (`item7000_18')  &    (`item8000_18' )    &  (`item9000_18') & (`item10000_18')  &    (`item15000_18' )    &  (`item20000_18')    \\ \hline"
file write file3 _n	"\end{tabular}"

file write file3 _n	"\begin{tablenotes}"
file write file3 _n	"\footnotesize"

file write file3 _n	"\item \textit{Notes:} Mean percentage of treated neighbors $P_{i,t,d}^{treated}$, (of the final sample) at the time of each assessment is presented for $d=\{1000; 5000; 10000; 15000; 20000\}$ meters. Standard errors are reported in parentheses."

file write file3 _n	"\end{tablenotes}"
file write file3 _n	"\end{threeparttable}"
file write file3 _n	"\end{table}" 

file write file3 _n "\end{document}"

file close file3


