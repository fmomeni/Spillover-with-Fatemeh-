*This file conducts the naalysis to compare attendance between different treatments.
*We look both at percentage attendance (a continuous variable, proportion of sessions attended)
*and attendance indicator (equal to 1 when at least one session has been attended) 


clear all

set more off

local output_dir "$repository_attendance/output/"

cd `output_dir'

use attendance_pa.dta


***************************************
**Get Mean Attendance by Treatment*****
***************************************

bysort treatment: sum attendance_pa_perc //parent vs. cogX vs. KP


/*--------------------------------------------------------------------------------
-> treatment = cogX

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
attendance~c |        261    67.94563    32.12466          0        100

--------------------------------------------------------------------------------
-> treatment = kinderprep

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
attendance~c |        143    63.54312    37.57771          0        120

--------------------------------------------------------------------------------
-> treatment = parent

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
attendance~c |        370    72.71396    37.77128          0        100

*/

oneway attendance_pa_perc treatment

/*
                        Analysis of Variance
    Source              SS         df      MS            F     Prob > F
------------------------------------------------------------------------
Between groups      9520.75858      2   4760.37929      3.69     0.0255
 Within groups      995275.542    771   1290.88916
------------------------------------------------------------------------
    Total            1004796.3    773   1299.86585

Bartlett's test for equal variances:  chi2(2) =   8.5338  Prob>chi2 = 0.014

*/




bysort treatment: sum attendance_pa_dummy

/*
--------------------------------------------------------------------------------
-> treatment = cogX

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
attendance~y |        261    .9310345    .2538823          0          1

--------------------------------------------------------------------------------
-> treatment = kinderprep

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
attendance~y |        143    .8111888    .3927342          0          1

--------------------------------------------------------------------------------
-> treatment = parent

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
attendance~y |        370    .8513514    .3562235          0          1
*/

oneway attendance_pa_dummy treatment

/*

                        Analysis of Variance
    Source              SS         df      MS            F     Prob > F
------------------------------------------------------------------------
Between groups      1.59506044      2   .797530222      7.19     0.0008
 Within groups      85.4850429    771   .110875542
------------------------------------------------------------------------
    Total           87.0801034    773   .112652139

Bartlett's test for equal variances:  chi2(2) =  44.2667  Prob>chi2 = 0.000

*/

bysort parent: sum attendance_pa_perc  //parent vs. cogx+KP

/*
--------------------------------------------------------------------------------
-> parent = 0

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
attendance~c |        404    66.38732    34.17314          0        120

--------------------------------------------------------------------------------
-> parent = 1

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
attendance~c |        370    72.71396    37.77128          0        100

*/


oneway attendance_pa_perc parent

/*
                        Analysis of Variance
    Source              SS         df      MS            F     Prob > F
------------------------------------------------------------------------
Between groups      7730.17298      1   7730.17298      5.99     0.0146
 Within groups      997066.128    772   1291.53643
------------------------------------------------------------------------
    Total            1004796.3    773   1299.86585

Bartlett's test for equal variances:  chi2(1) =   3.8608  Prob>chi2 = 0.049

*/


bysort parent: sum attendance_pa_dummy

/*

--------------------------------------------------------------------------------
-> parent = 0

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
attendance~y |        404    .8886139    .3149998          0          1

--------------------------------------------------------------------------------
-> parent = 1

    Variable |        Obs        Mean    Std. Dev.       Min        Max
-------------+---------------------------------------------------------
attendance~y |        370    .8513514    .3562235          0          1


*/

oneway attendance_pa_dummy parent

/*


                        Analysis of Variance
    Source              SS         df      MS            F     Prob > F
------------------------------------------------------------------------
Between groups      .268155272      1   .268155272      2.38     0.1229
 Within groups      86.8119481    772    .11245071
------------------------------------------------------------------------
    Total           87.0801034    773   .112652139

Bartlett's test for equal variances:  chi2(1) =   5.8260  Prob>chi2 = 0.016

*/
