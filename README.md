# Spillover-with-Fatemeh-


This github project deals with Fatemeh's job market paper that aims at studying spill-over effects of CHECC kids. I inherited the project from Clark on October/November 2017. Here is a brief timeline of the datasets analyses created. The main treatment variable is proportion of treated neighbors.

November 2017:  I and Fatemeh found some errors in the initial code for neighbor count after which Fatemeh has made the necessary adjustments and have used her code since. 

Novemeber/December 2017: Analyses have been re-done with the updated neighbor count

January/February 2018: I have created new datasets for neighbors by race and gender. Also additional specifications have been run:

-use as treatment variable number of treated neighbors (rather than the initial proportion of treated neighbors) and control for total number of neighbors
-use as treatment variables number of treated neighbors but exclude pre-assessment periodm also controlling for total number of neighbors
-use as treatment variable proportion of treated neighbors, but exclude pre-assessment period

March 2018: I have added data on parental attendance of parent academy sessions and looked at differential rates of attendance between cogX and parent academy kids. 

April 2018: I have created additional variables:

-length of exposure to treatment/control since entering treatment/control
-average cog and non-cog performance of neighbors at the closest date of an assessment for an origin kid, but this date cannot coincide with the assessment date of the origin kid (version1)
-average cog and non-cog performance of neighbors at the closest date of an assessment for an origin kid, this date can coincide with the assessment date of the origin kid (version2)

I also updated neighbor counts for origin kids that were randomised into kinderprep.

May 2018: I have created classroom exposure neighbor counts using teacherease data

Here is a description of the files contained in this folder: 

run_project.do builds the necessary data sets and conducts the analysis. It is the one stop button for everything.
Before running the "run_project" do file, make sure you change to the directory to which you cloned the repository on your local computer. 

The "data" folder is empty. When cloning the repository to the local computer, the user should include the raw data files in the "pre_made" subfolder of the "data" folder.

"Variable_dictionary" contains explanations for the treatment assignment variables used in the analysis.



