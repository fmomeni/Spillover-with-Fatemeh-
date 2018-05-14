# Spillover-with-Fatemeh-


This github project deals with Fatemeh's job market paper that aims at studying spill-over effects of CHECC kids. I inherited the project from Clark in October/November 2017. Here is a brief timeline of the datasets and analyses completed. The main treatment variable is number of treated neighbors.

November 2017:  I and Fatemeh found some errors in the initial code for neighbor count after which Fatemeh has made the necessary adjustments and I have used her code since. 

Novemeber/December 2017: Analyses have been re-done with the updated neighbor count.

January/February 2018: I have created new datasets for neighbors by race and gender. Also, additional specifications have been run:

1)use as treatment variable number of treated neighbors (rather than the initial proportion of treated neighbors) and control for total number of neighbors
2)use as treatment variables number of treated neighbors but exclude pre-assessment period also controlling for total number of neighbors
3)use as treatment variable proportion of treated neighbors, but exclude pre-assessment period

March 2018: I have added data on parental attendance of parent academy sessions and looked at differential rates of attendance between cogX and parent academy kids. 

April 2018: I have created additional variables:

1)length of exposure to treatment/control since entering treatment/control
2)average cog and non-cog performance of neighbors at the closest date of an assessment for an origin kid, but this date cannot coincide with the assessment date of the origin kid (version1)
3)average cog and non-cog performance of neighbors at the closest date of an assessment for an origin kid, this date can coincide with the assessment date of the origin kid (version2)
4) I have added indicators whether children are at kindergarten/school age for each of the assessment at pre, mid, post, etc.

I also updated neighbor counts for origin kids that were randomised into kinderprep.

May 2018: I have created classroom exposure neighbor counts using teacherease data. I have also run additional analyses of the spillover effect of treated geographical neighbors on treated kids.

Each of the subfolders on this github repository contains a "run_directory.do" file that specifies the order in which each of the dofiles in the given subfolder should be executed. Here is a brief description of the files contained in the present master folder. Each subfolder will contain a readme file with further descritpions and each of the dofiles will contain much more details about the content of the specific code  


Here is a description of the files contained in this main folder: 

run_project.do builds the necessary data sets and conducts the analysis in the correct order. It is the one stop button for everything.
IMPORTANT: Before running the "run_project" do file, make sure you change to the directory to which you cloned the repository on your local computer!!

The "data" folder is empty. When cloning the repository to the local computer, the user should include the raw data files in the "pre_made" subfolder of the "data" folder. The raw data files for the "pre_made" subfolder can be found in the shared Spillover DropBox folder! These pre_made files are the data I was given before starting to work on the project by myself. The "generated" subfolder will remain initially empty and it will progressively keep getting filled as new data sets are being generated.

The "analysis" folder contains two subfolders, "code" and "tables". The "code" subfolder contains codes for the different tables contained in the paper. Each dofile contains more information on the content of the table. All sub-sub-folders prefixed with "treat" contain the code for analysing the spillover effect of treated neighbors on treated origin kids. The rest of the subfolders study the spillover effect of treated neighbors on control origin kids. The "tables" subfolder remains initially empty. It gets filled as new tables are being generated. The name of the table corresponds to the name of its associated dofile.

The "build_datasets" folder contains dofiles designed to build the data sets for the final analysis of the paper. It starts by creating overall neighbors counts by distance, race and gender and classroom exposure. It also calculates average performance of neighbors as well as average neighbor exposure to treatment and control. It then takes the aggregate CHECC data set and transforms it into panel format. Then, it merges it to the neighbor counts to create the final data set. The subfolder also creates the data set for the "social network" analysis, i.e. according to the number of treated friends rather than geographical neighbors. This code might need to get updated/modified in case new data is collected.

"Variable_dictionary" contains explanations for the relevant variables used in the analysis.

Finally, "parent_academy_attendance" is a self-contained folder that analyses differential attendance at parent academy sessions between "parent academy" treatment in 2010 and 2011 and "prek" treatment in 2012 and 2013.



