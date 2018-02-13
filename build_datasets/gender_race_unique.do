**Create File contains Kids' Gender Race (Unique IDs)*

clear all

cd "$repository/data_sets/pre_made"

use updated_unique_data_clean

unique child 

duplicates report child

duplicates drop child, force
unique child
keep child gender race

cd "$repository/data_sets/generated"

save unique_gender_race, replace
