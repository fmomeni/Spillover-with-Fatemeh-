clear all

cd "$repository/data_sets/generated"

use unique_data_clean_for_panel
///Creating a panel

keep year child treatment has_wjl_* has_wjs_* has_wja_* has_wjq_* has_card_* has_ppvt_* has_psra_* has_ospan_* has_same_* has_spatial_* has_cog_* has_ncog_* wjl_* wjs_* wja_* wjq_* card_* ppvt_* psra_* ospan_* same_* spatial_* cog_* ncog_* std_wjl_* std_wjs_* std_wja_* std_wjq_* std_card_* std_ppvt_* std_psra_* std_ospan_* std_same_* std_spatial_* std_cog_* std_ncog_* gender aid_unemployment_pre race age_pre hh_income_pre mother_education_pre father_education_pre no_cog_pre no_ncog_pre num_cog_beyond_pre num_ncog_beyond_pre first_random second_random third_random CC CT CK T K TT TTT TK C 

drop  *ao_5yo *ao_6yo *ao_7yo *maximum* *or_tvip* *y12 *y34

order has_wjl_* has_wjs_* has_wja_* has_wjq_* has_card_* has_ppvt_* has_psra_* has_ospan_* has_same_* has_spatial_* has_cog_* has_ncog_* wjl_* wjs_* wja_* wjq_* card_* ppvt_* psra_* ospan_* same_* spatial_* cog_* ncog_* std_wjl_* std_wjs_* std_wja_* std_wjq_* std_card_* std_ppvt_* std_psra_* std_ospan_* std_same_* std_spatial_* std_cog_* std_ncog_*

reshape long has_wjl_@ has_wjs_@ has_wja_@ has_wjq_@ wjl_@ wjs_@ wja_@ wjq_@ has_card_@ card_@ has_ppvt_@ ppvt_@ has_psra_@ psra_@ has_ospan_@ ospan_@ has_same_@ same_@ has_spatial_@ spatial_@ std_ppvt_@ std_wjl_@ std_wja_@ std_wjs_@ std_wjq_@ std_psra_@ std_card_@ std_spatial_@ std_ospan_@ std_same_@  has_cog_@ cog_@ std_cog_@ has_ncog_@ ncog_@ std_ncog_@, i(child year) j(test) s
	
**Dropping those kids that have no pre cog/ncog scores or do not have any other
**observation beyond pre	
drop if (num_cog_beyond_pre == 0 & num_ncog_beyond_pre == 0)

**Dropping all observations for ao_y5, ao_y6
drop if (test == "ao_y5" | test == "ao_y6")

**Dropping observations without std cog and std_ncog
drop if has_cog_==0 & has_ncog_ ==0
 
**Saving file for Tables 3 and 4
merge m:1 child year using pre_scores

**Drop those kids that have not been mathced on-prescores (these are kids that had num_cog_beyond_pre or num_ncog_beyond_pre greater than 0)
drop if _merge==2

drop _merge

rename *_ *
replace test = subinstr(test, "_", "", .)

**We don't need Basicopposite so drop
foreach x in pre mid post sl aoy1 aoy2 aoy3 aoy4 aoy5 aoy6 {

drop if test == "basicopposite`x'"

}

unique child

**6154 observations and 1660 unique control kids

**Create CT_pretreatment which is only defined for those who have been randomised twice: first into control and than into treatment (other than kinderprep). 
**"1" means that the kid has taken this test before undergoing treatment 
gen CT_pretreat = .
replace CT_pretreat = 1 if CT == 1 & first_random == 1 & (test == "mid" | test == "post" | test == "sl")
replace CT_pretreat = 0 if CT == 1 & first_random == 1 & (test == "aoy1" | test == "aoy2" | test == "aoy3" | test == "aoy4")
replace CT_pretreat = 0 if CT == 1 & second_random == 1

**Create CK_prekinder which is only defined for those who have been randomised twice: first into control and than into kinderprep
**"1" means that the kid has taken this test before undergoing kinderprep 
gen CK_prekinder = .
replace CK_prekinder = 1 if CK == 1 & first_random == 1 & (test == "mid" | test == "post" | test == "sl" | test == "aoy1")
replace CK_prekinder = 0 if CK == 1 & first_random == 1 & (test == "aoy2" | test == "aoy3" | test == "aoy4")
replace CK_prekinder = 0 if CK == 1 & second_random == 1

save table34_unique_data_clean, replace
