****Extracting Pre-scores to Merge Later*******
clear all

cd "$repository/data_sets/generated"

use unique_data_clean_for_panel

keep year child treatment has_wjl_pre has_wjs_pre has_wja_pre has_wjq_pre has_card_pre has_ppvt_pre has_psra_pre has_ospan_pre has_same_pre has_spatial_pre has_cog_pre has_ncog_pre wjl_pre wjs_pre wja_pre wjq_pre card_pre ppvt_pre psra_pre ospan_pre same_pre cog_pre ncog_pre spatial_pre std_wjl_pre std_wjs_pre std_wja_pre std_wjq_pre std_card_pre std_ppvt_pre std_psra_pre std_ospan_pre std_same_pre std_spatial_pre std_cog_pre std_ncog_pre

save pre_scores, replace	

