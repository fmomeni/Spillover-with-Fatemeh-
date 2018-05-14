*Purpose: create variables that indicate when a destination kid receives their 
*treatment relative to the origin kid and the time of the origin kids' 
*various assessments

set more off
clear all

cd "$repository/data_sets/generated"
use distance_treatment_all_years



** #####################################################################################
* #################		Dummies for when a destinantion kid enters the data			#################
** #####################################################################################

** Dummies for when a destinantion kid enters the data [ and remians in the data] if a neighbor is randomized in 2010 
** all the following variables [besides pre-1] are 1 for him.
** if a neighbor is randomized in 2012, all variables starting mid2 ==1; but pre1, mid1, ...pre2 are zero, etc!
**2010 calendar dates:
gen pre2010 = 0 // Late Summer Sep 2010

**2011 calendar dates:
gen mid2011 = rando2010 == 1 // Jan/Feb 2011
gen post2011 = rando2010 == 1 // May 2011
gen pre2011 = rando2010 == 1 // May 2011 2012
gen sl2011 = rando2010 == 1 // Late Summet 2011

**2012 calendar dates:
gen mid2012 = (rando2011 == 1 | rando2010 == 1) // Jan/Feb 2012
gen ao2012 = (rando2011 == 1 | rando2010 == 1) // Apr 2012
gen post2012 =(rando2011 == 1 | rando2010 == 1) // May 2012
gen pre2012 =(rando2011 == 1 | rando2010 == 1) //May 2012
gen sl2012 =(rando2011 == 1 | rando2010 == 1 ) // Late Summet 2012

**2013 calendar dates:
gen mid2013 =((rando2012 == 1 | rando2011 == 1 | rando2010 == 1) )  // Jan/Feb 2013
replace mid2013= 0 if kinderprep2012==1 & (rando2011 == 0 & rando2010 == 0) // if the dest kid was randomized in 2012 into kinderprep, he will not appear until SL2013

gen ao2013 =((rando2012 == 1 | rando2011 == 1 | rando2010 == 1) ) // April 2013
replace ao2013= 0 if kinderprep2012==1 & (rando2011 == 0 & rando2010 == 0) // if the dest kid was randomized in 2012 into kinderprep, he will not appear until SL2013

gen post2013 =((rando2012 == 1 | rando2011 == 1 | rando2010 == 1)  ) // May 2013
replace post2013=0 if kinderprep2012==1 & (rando2011 == 0 & rando2010 == 0) // if the dest kid was randomized in 2012 into kinderprep, he will not appear until SL2013

gen pre2013 =((rando2012 == 1 | rando2011 == 1 | rando2010 == 1) ) // May 2013
replace pre2013= 0 if kinderprep2012==1 & (rando2011 == 0 & rando2010 == 0) // if the dest kid was randomized in 2012 into kinderprep, he will not appear until SL2013

gen sl2013 =(rando2012 == 1 | rando2011 == 1 | rando2010 == 1 | kinderprep2012 == 1)  // Late Summer 2013

**2014 calendar dates:
gen mid2014 =((rando2013 == 1 | rando2012 == 1 | rando2011 == 1 | rando2010 == 1) ) // Jan/Feb 2014
replace mid2014=0 if kinderprep2013==1 & (rando2012==0 & rando2011 == 0 & rando2010 == 0) 

gen ao2014 =((rando2013 == 1 | rando2012 == 1 | rando2011 == 1 | rando2010 == 1) ) // April 2014
replace ao2014=0 if kinderprep2013==1 & (rando2012==0 & rando2011 == 0 & rando2010 == 0) 

gen post2014 =((rando2013 == 1 | rando2012 == 1 | rando2011 == 1 | rando2010 == 1) ) // May 2014
replace post2014=0 if kinderprep2013==1 & (rando2012==0 & rando2011 == 0 & rando2010 == 0) 

gen sl2014 =(rando2013 == 1 | rando2012 == 1 | rando2011 == 1 | rando2010 == 1| kinderprep2013 == 1) // Late Summer 2014

**2015 calendar dates:
gen ao2015 =(rando2013 == 1 | rando2012 == 1 | rando2011 == 1 | rando2010 == 1) // April 2015

**2016 calendar dates:
gen ao2016 =(rando2013 == 1 | rando2012 == 1 | rando2011 == 1 | rando2010 == 1) // April 2016

**2017 calendar dates:
gen ao2017 =(rando2013 == 1 | rando2012 == 1 | rando2011 == 1 | rando2010 == 1) // April 2017
 
** #####################################################################################
* #################		treated assessment for destination kids			#################
** #####################################################################################

** the folllowing will create dummies for whether a destination child was treated at the time of an assessment or not.

**2010 calendar dates:
gen pre2010_treated = 0 

**2011 calendar dates:
gen mid2011_treated = mid2011*treated2010 // treated2010==1 iff the child was treated [one of treatment groups] in 2010; Note: if treated2010==1 then treated2011 is also ==1 because that destination child will forever remains treated!
gen post2011_treated = post2011*treated2010 
gen pre2011_treated = pre2011*treated2010
gen sl2011_treated = sl2011*treated2010

**2012 calendar dates:
gen mid2012_treated = mid2012*treated2011
gen ao2012_treated = ao2012*treated2011
gen post2012_treated = post2012*treated2011
gen pre2012_treated = pre2012*treated2011
gen sl2012_treated = sl2012 * treated2011
**replace sl2_treated = 1 if kinderprep2012 == 1 // this has to be changed as well!

**2013 calendar dates:
gen mid2013_treated = mid2013 * treated2012 
replace mid2013_treated = 0 if kinderprep2012==1 & treated2011==0

gen ao2013_treated = ao2013 * treated2012
replace ao2013_treated = 0 if kinderprep2012==1 & treated2011==0

gen post2013_treated = post2013 * treated2012
replace post2013_treated = 0 if kinderprep2012==1 & treated2011==0


gen pre2013_treated = pre2013 * treated2012
replace pre2013_treated = 0 if kinderprep2012==1 & treated2011==0

gen sl2013_treated = sl2013 * treated2012
** replace sl2013_treated = 1 if kinderprep2012 == 1 // this has to be changed as well!

**2014 calendar dates:
gen mid2014_treated = mid2014*treated2013
replace mid2014_treated = 0 if kinderprep2013==1 & treated2012==0

gen ao2014_treated = ao2014*treated2013
replace ao2014_treated = 0 if kinderprep2013==1 & treated2012==0

gen post2014_treated = post2014*treated2013
replace post2014_treated = 0 if kinderprep2013==1 & treated2012==0

gen sl2014_treated = sl2014*treated2013
** replace s20l4_treated = 1 if kinderprep2013 == 1 

**2015 calendar dates:
gen ao2015_treated = ao2015*treated2013

**2016 calendar dates
gen ao2016_treated = ao2016*treated2013

**2017 calendar dates
gen ao2017_treated = ao2017*treated2013


** #####################################################################################
* #################		kinderprep by assessment for destination kids		#################
** #####################################################################################
** note: if a destination child is randomized into kinderprep in 2012, kinderprep2012 and kinderprep2013 are both==1

**2010 calendar dates:
gen pre2010_kinderprep = 0

**2011 calendar dates:
gen mid2011_kinderprep = mid2011*kinderprep2010
gen post2011_kinderprep = post2011*kinderprep2010
gen sl2011_kinderprep = sl2011*kinderprep2010
gen pre2011_kinderprep = pre2011*kinderprep2010

**2012 calendar dates:
gen mid2012_kinderprep = mid2012*kinderprep2011
gen ao2012_kinderprep = ao2012*kinderprep2011
gen post2012_kinderprep = post2012*kinderprep2011
gen pre2012_kinderprep = pre2012*kinderprep2011 
gen sl2012_kinderprep = sl2012*kinderprep2011

**2013 calendar dates:
gen mid2013_kinderprep = mid2013*kinderprep2012 //incorrect?!
replace mid2013_kinderprep=0 if kinderprep2012==1

gen ao2013_kinderprep = ao2013*kinderprep2012 //incorrect?!
replace ao2013_kinderprep=0 if kinderprep2012==1

gen post2013_kinderprep = post2013*kinderprep2012 //incorrect?!
replace post2013_kinderprep=0 if kinderprep2012==1

gen pre2013_kinderprep = pre2013*kinderprep2012
replace pre2013_kinderprep=0 if kinderprep2012==1

gen sl2013_kinderprep = sl2013*kinderprep2012

**2014 calendar dates:
gen mid2014_kinderprep = mid2014*kinderprep2013 //incorrect?!
replace mid2014_kinderprep=0 if kinderprep2013==1 & kinderprep2012==0

gen ao2014_kinderprep = ao2014*kinderprep2013 //incorrect?!
replace ao2014_kinderprep=0 if kinderprep2013==1 & kinderprep2012==0

gen post2014_kinderprep = post2014*kinderprep2013 //incorrect?!
replace post2014_kinderprep=0 if kinderprep2013==1 & kinderprep2012==0

gen sl2014_kinderprep = sl2014*kinderprep2013

**2015 calendar dates:
gen ao2015_kinderprep = ao2015*kinderprep2013

**2016 calendar dates:
gen ao2016_kinderprep = ao2016*kinderprep2013

**2017 calendar dates:
gen ao2017_kinderprep = ao2017*kinderprep2013


*treatments by assessment for destination kids
foreach treatment in cash cogx college control pka pkb preschool {
	**2010 Calendar
	gen pre2010_`treatment' = 0
	
	**2011 Calendar
	gen mid2011_`treatment' = mid2011*`treatment'2010
	gen post2011_`treatment' = post2011*`treatment'2010
	gen sl2011_`treatment' = sl2011*`treatment'2010
	gen pre2011_`treatment'= pre2011*`treatment'2010
	
	**2012 Calendar
	gen mid2012_`treatment' = mid2012*`treatment'2011
	gen ao2012_`treatment' = ao2012*`treatment'2011
	gen post2012_`treatment' = post2012*`treatment'2011
	gen pre2012_`treatment' = pre2012*`treatment'2011
	gen sl2012_`treatment' = sl2012*`treatment'2011
*	replace sl2012_`treatment' = 0 if sl2_kinderprep == 1 // has to change!
	
	**2013 Calendar
	gen mid2013_`treatment' = mid2013*`treatment'2012
	replace mid2013_`treatment'= 1 if `treatment'2011==1 & kinderprep2012==1 // added for those who are randomized before 2012 into another treatnment and in 2012 they are randomized into kinderprep.
	
	gen ao2013_`treatment' = ao2013*`treatment'2012
	replace ao2013_`treatment'= 1 if `treatment'2011==1 & kinderprep2012==1 // added for those who are randomized before 2012 into another treatnment and in 2012 they are randomized into kinderprep.
	
	gen post2013_`treatment' = post2013*`treatment'2012
	replace post2013_`treatment'= 1 if `treatment'2011==1 & kinderprep2012==1 // added for those who are randomized before 2012 into another treatnment and in 2012 they are randomized into kinderprep.
	
	gen pre2013_`treatment' = pre2013*`treatment'2012
	replace pre2013_`treatment'= 1 if `treatment'2011==1 & kinderprep2012==1 // added for those who are randomized before 2012 into another treatnment and in 2012 they are randomized into kinderprep.
	
	gen sl2013_`treatment' = sl2013*`treatment'2012
*	replace sl2013_`treatment' = 0 if sl3_kinderprep == 1  // has to change!
	
	**2014 Calendar
	gen mid2014_`treatment' = mid2014*`treatment'2013
	replace mid2014_`treatment'= 1 if `treatment'2012==1 & kinderprep2013==1 // added for those who are randomized before 2013 into another treatnment and in 2013 they are randomized into kinderprep.
	
	gen ao2014_`treatment' = ao2014*`treatment'2013
	replace ao2014_`treatment'= 1 if `treatment'2012==1 & kinderprep2013==1 // added for those who are randomized before 2013 into another treatnment and in 2013 they are randomized into kinderprep.

	gen post2014_`treatment' = post2014*`treatment'2013
	replace post2014_`treatment'= 1 if `treatment'2012==1 & kinderprep2013==1 // added for those who are randomized before 2013 into another treatnment and in 2013 they are randomized into kinderprep.

	gen sl2014_`treatment' = sl2014*`treatment'2013  // has to change!

	**2015 Calendar
	gen ao2015_`treatment' = ao2015*`treatment'2013
	
	**2016 Calendar
	gen ao2016_`treatment' = ao2016*`treatment'2013
	
	**2017 Calendar
	gen ao2017_`treatment' = ao2017*`treatment'2013

}

destring randomization_ori, replace

** Added by Fatemeh: Renaming variables to allign them with the year of randomization
foreach treatment in cash cogx college control kinderprep pka pkb preschool treated {
rename (pre2010_`treatment' mid2011_`treatment' post2011_`treatment' pre2011_`treatment' sl2011_`treatment' mid2012_`treatment' ///
ao2012_`treatment' post2012_`treatment' pre2012_`treatment' sl2012_`treatment' mid2013_`treatment' ao2013_`treatment' ///
post2013_`treatment' pre2013_`treatment' sl2013_`treatment' mid2014_`treatment' ao2014_`treatment' post2014_`treatment' ///
sl2014_`treatment' ao2015_`treatment' ao2016_`treatment' ao2017_`treatment') (pre1_`treatment' mid1_`treatment' ///
post1_`treatment' pre2_`treatment' sl1_`treatment' mid2_`treatment' ao1_`treatment' post2_`treatment' pre3_`treatment' sl2_`treatment' ///
 mid3_`treatment' ao2_`treatment' post3_`treatment' pre4_`treatment' sl3_`treatment' mid4_`treatment' ao3_`treatment' post4_`treatment' ///
 sl4_`treatment' ao4_`treatment' ao5_`treatment' ao6_`treatment')
 
 }

** now seeing if the destination kid was around at the time of the different assessments
** relative to origin kid
foreach treatment in cash cogx college control kinderprep pka pkb preschool treated {
	foreach test in pre mid post sl {
		gen `test'_`treatment' = `test'1_`treatment' if randomization_ori == 2010
		replace `test'_`treatment' = `test'2_`treatment' if randomization_ori == 2011
**		replace `test'_`treatment' = `test'3_`treatment' if randomization_ori == 2012  & kinderprep_ori == 1  // has to change!
		replace `test'_`treatment' = `test'3_`treatment' if randomization_ori == 2012
**		replace `test'_`treatment' = `test'4_`treatment' if randomization_ori == 2013  & kinderprep_ori == 1  // has to change!
		replace `test'_`treatment' = `test'4_`treatment' if randomization_ori == 2013 
	}
}




foreach treatment in cash cogx college control kinderprep pka pkb preschool treated {
	gen aoy1_`treatment' = ao1_`treatment' if randomization_ori == 2010
	replace aoy1_`treatment' = ao2_`treatment' if randomization_ori == 2011
**	replace aoy1_`treatment' = ao3_`treatment' if randomization_ori == 2012  & kinderprep_ori == 1
	replace aoy1_`treatment' = ao3_`treatment' if randomization_ori == 2012
**	replace aoy1_`treatment' = ao4_`treatment' if randomization_ori == 2013 & kinderprep_ori == 1
	replace aoy1_`treatment' = ao4_`treatment' if randomization_ori == 2013

	gen aoy2_`treatment' = ao2_`treatment' if randomization_ori == 2010
	replace aoy2_`treatment' = ao3_`treatment' if randomization_ori == 2011
**	replace aoy2_`treatment' = ao4_`treatment' if randomization_ori == 2012 & kinderprep_ori == 1
	replace aoy2_`treatment' = ao4_`treatment' if randomization_ori == 2012
**	replace aoy2_`treatment' = ao5_`treatment' if randomization_ori == 2013 & kinderprep_ori == 1
	replace aoy2_`treatment' = ao5_`treatment' if randomization_ori == 2013

	gen aoy3_`treatment' = ao3_`treatment' if randomization_ori == 2010
	replace aoy3_`treatment' = ao4_`treatment' if randomization_ori == 2011
**	replace aoy3_`treatment' = ao5_`treatment' if randomization_ori == 2012 & kinderprep_ori == 1
	replace aoy3_`treatment' = ao5_`treatment' if randomization_ori == 2012
**	replace aoy3_`treatment' = ao5_`treatment' if randomization_ori == 2013 & kinderprep_ori == 1
	replace aoy3_`treatment' = ao6_`treatment' if randomization_ori == 2013

	gen aoy4_`treatment' = ao4_`treatment' if randomization_ori == 2010
	replace aoy4_`treatment' = ao5_`treatment' if randomization_ori == 2011
**	replace aoy4_`treatment' = ao5_`treatment' if randomization_ori == 2012 & kinderprep_ori == 1
	replace aoy4_`treatment' = ao6_`treatment' if randomization_ori == 2012
**	replace aoy4_`treatment' = 0 if randomization_ori == 2013 & kinderprep_ori == 1
	replace aoy4_`treatment' = 0 if randomization_ori == 2013  // we do not have this data yet!

	gen aoy5_`treatment' = ao5_`treatment' if randomization_ori == 2010
	replace aoy5_`treatment' = ao5_`treatment' if randomization_ori == 2011
**	replace aoy5_`treatment' = 0 if randomization_ori == 2012 & kinderprep_ori == 1
	replace aoy5_`treatment' = 0 if randomization_ori == 2012
**	replace aoy5_`treatment' = 0 if randomization_ori == 2013 & kinderprep_ori == 1
	replace aoy5_`treatment' = 0 if randomization_ori == 2013
	
	gen aoy6_`treatment' = ao6_`treatment' if randomization_ori == 2010
	replace aoy6_`treatment' = 0 if randomization_ori == 2011 | randomization_ori == 2012 |randomization_ori == 2013 

	
}

**ALEX ADDED
**Defining proper dates for origin kinderprep kids!
foreach treat in cash college control kinderprep pka pkb preschool cogx treated { 
replace pre_`treat' = post_`treat' if kinderprep_ori == 1   
* because, for instance, for non-kinderprep kids randomized in 2012, post occurs in May 2013; but that is exactly the same calendar date the pre occurs for kinderprep kidos!

replace post_`treat' = sl_`treat' if kinderprep_ori == 1  
* because, for instance, for non-kinderprep kids randomized in 2012, post occurs in August 2013; but that is exactly the same calendar date the post occurs for kinderprep kidos!

replace mid_`treat' = post_`treat' if kinderprep_ori == 1  
* mid assessment does not occur for the kinder preps but we take it to equal the post treated
replace sl_`treat' = post_`treat' if kinderprep_ori == 1 
* sl assessment does not occur for the kinder preps but we take it to equal the post treated

}

**tidying
drop cash2010 college2010 control2010 kinderprep2010 pka2010 pkb2010 preschool2010 cogx2010 treated2010 rando2010 
drop cash2011 college2011 control2011 kinderprep2011 pka2011 pkb2011 preschool2011 cogx2011 treated2011 rando2011 cash2012 ///
college2012 control2012 kinderprep2012 pka2012 pkb2012 preschool2012 cogx2012 treated2012 rando2012 cash2013 college2013 

drop control2013 kinderprep2013 pka2013 pkb2013 preschool2013 cogx2013 treated2013 rando2013 
drop pre2010 mid2011 post2011 pre2011 sl2011 mid2012 ao2012 post2012 pre2012 sl2012 mid2013 ao2013 post2013 pre2013 sl2013 mid2014 ao2014 post2014 sl2014 ao2015 ao2016 ao2017

drop  pre1_treated mid1_treated post1_treated sl1_treated ///
pre2_treated mid2_treated ao1_treated post2_treated pre3_treated sl2_treated mid3_treated ao2_treated post3_treated pre4_treated ///
sl3_treated mid4_treated ao3_treated post4_treated sl4_treated ao4_treated ao5_treated pre1_kinderprep mid1_kinderprep post1_kinderprep 


drop sl1_kinderprep pre2_kinderprep mid2_kinderprep ao1_kinderprep post2_kinderprep pre3_kinderprep sl2_kinderprep mid3_kinderprep 

drop ao2_kinderprep post3_kinderprep pre4_kinderprep sl3_kinderprep mid4_kinderprep ao3_kinderprep post4_kinderprep sl4_kinderprep ///
ao4_kinderprep ao5_kinderprep pre1_cash mid1_cash post1_cash sl1_cash pre2_cash mid2_cash ao1_cash post2_cash pre3_cash sl2_cash ///
mid3_cash ao2_cash post3_cash pre4_cash sl3_cash mid4_cash ao3_cash post4_cash sl4_cash ao4_cash ao5_cash pre1_cogx mid1_cogx ///
post1_cogx sl1_cogx pre2_cogx mid2_cogx ao1_cogx post2_cogx pre3_cogx sl2_cogx mid3_cogx ao2_cogx post3_cogx pre4_cogx sl3_cogx ///
mid4_cogx ao3_cogx post4_cogx sl4_cogx ao4_cogx ao5_cogx pre1_college mid1_college post1_college sl1_college pre2_college mid2_college ///
ao1_college post2_college pre3_college sl2_college mid3_college ao2_college post3_college pre4_college sl3_college mid4_college ao3_college ///
post4_college sl4_college ao4_college ao5_college pre1_control mid1_control post1_control sl1_control pre2_control mid2_control ao1_control ///
post2_control pre3_control sl2_control mid3_control ao2_control post3_control pre4_control sl3_control mid4_control ao3_control post4_control ///
sl4_control ao4_control ao5_control pre1_pka mid1_pka post1_pka sl1_pka pre2_pka mid2_pka ao1_pka post2_pka pre3_pka sl2_pka mid3_pka ao2_pka ///
post3_pka pre4_pka sl3_pka mid4_pka ao3_pka post4_pka sl4_pka ao4_pka ao5_pka pre1_pkb mid1_pkb post1_pkb sl1_pkb pre2_pkb mid2_pkb ao1_pkb ///
post2_pkb pre3_pkb sl2_pkb mid3_pkb ao2_pkb post3_pkb pre4_pkb sl3_pkb mid4_pkb ao3_pkb post4_pkb sl4_pkb ao4_pkb ao5_pkb pre1_preschool ///
mid1_preschool post1_preschool sl1_preschool pre2_preschool mid2_preschool ao1_preschool post2_preschool pre3_preschool sl2_preschool ///
mid3_preschool ao2_preschool post3_preschool pre4_preschool sl3_preschool mid4_preschool ao3_preschool post4_preschool sl4_preschool ///
ao4_preschool ao5_preschool



cd "$repository/data_sets/generated"
save neighbor_count_by_oriassessments_dummies_Fatemeh_all_years, replace
