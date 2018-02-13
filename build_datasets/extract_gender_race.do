**Create File contains Kids' Gender Race (Unique IDs)*

clear all

cd "$repository/data_sets/pre_made"

use updated_unique_data_clean

duplicates drop child, force

keep child year gender race

cd "$repository/data_sets/generated"

save gender_race, replace
