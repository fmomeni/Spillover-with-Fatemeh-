**Correct treatment assignments according to most recent randomization file


cd "$repository/data_sets/pre_made"


use distance_treatment

*Kid 1204 now with id 1355
replace origin_gecc_id = 1355 if origin_gecc_id == 1204 & randomization_ori == "2010"
replace destination_gecc_id = 1355 if destination_gecc_id == 1204

*Kids 2145 and 2608 same kid but recorded as randomized in two different treatment in the same year - Drop!
drop if origin_gecc_id == 2145
drop if destination_gecc_id == 2145

drop if origin_gecc_id == 2608
drop if destination_gecc_id == 2608

*Kid 2468 now with id 2674
replace origin_gecc_id = 2674 if origin_gecc_id == 2468 & randomization_ori == "2011"
replace destination_gecc_id = 2674 if destination_gecc_id == 2468

*Kid 3764 is the second randomization of kid 2764
replace control2011 = 1 if destination_gecc_id == 2764
replace control2012 = 0 if destination_gecc_id == 2764
replace control2013 = 0 if destination_gecc_id == 2764

replace kinderprep2012 = 1 if destination_gecc_id == 2764
replace kinderprep2013 = 1 if destination_gecc_id == 2764
replace treated2012 = 1 if destination_gecc_id == 2764
replace treated2013 = 1 if destination_gecc_id == 2764

drop if origin_gecc_id == 3764
drop if destination_gecc_id == 3764


*Kid 4340 is the second randomization of kid 3288
replace control2012 = 1 if destination_gecc_id == 3288
replace control2013 = 0 if destination_gecc_id == 3288


replace kinderprep2013 = 1 if destination_gecc_id == 3288
replace treated2013 = 1 if destination_gecc_id == 3288


drop if origin_gecc_id == 4340
drop if destination_gecc_id == 4340

**Deleting Kids randomized only once in kinderprep in 2011

drop if origin_gecc_id == 2133 | origin_gecc_id == 2669 | origin_gecc_id == 2585 | origin_gecc_id == 2391 | origin_gecc_id == 2346 | origin_gecc_id == 2253 | origin_gecc_id == 2462 | origin_gecc_id == 2856 | origin_gecc_id == 2857 | ///
origin_gecc_id == 2732 | origin_gecc_id == 2493 | origin_gecc_id == 2757 | origin_gecc_id == 2755 | origin_gecc_id == 2073 | origin_gecc_id == 2189 | origin_gecc_id == 2516 | origin_gecc_id == 2107 | origin_gecc_id == 2633 | origin_gecc_id == 2408 | ///
origin_gecc_id == 2441 | origin_gecc_id == 2156 | origin_gecc_id == 2762 | origin_gecc_id == 2175

drop if destination_gecc_id == 2133 | destination_gecc_id == 2669 | destination_gecc_id == 2585 | destination_gecc_id == 2391 | destination_gecc_id == 2346 | destination_gecc_id == 2253 | destination_gecc_id == 2462 | destination_gecc_id == 2856 | destination_gecc_id == 2857 | ///
destination_gecc_id == 2732 | destination_gecc_id == 2493 | destination_gecc_id == 2757 | destination_gecc_id == 2755 | destination_gecc_id == 2073 | destination_gecc_id == 2189 | destination_gecc_id == 2516 | destination_gecc_id == 2107 | destination_gecc_id == 2633 | destination_gecc_id == 2408 | ///
destination_gecc_id == 2441 | destination_gecc_id == 2156 | destination_gecc_id == 2762 | destination_gecc_id == 2175

**There are kids randomized in control in 2010 and then into kinderprep in 2011 - exclude those from the analysis starting year 2011

foreach kid in 1622 1348 1624 1672 1299 1102 1289 1337 1633 {

replace control2011 = 0 if destination_gecc_id == `kid'
replace control2012 = 0 if destination_gecc_id == `kid'
replace control2013 = 0 if destination_gecc_id == `kid'

}

cd "$repository/data_sets/generated"

save corrected_distance_treatment.dta, replace

