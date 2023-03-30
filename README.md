# PFAS Homologous series
A quick and dirty script for making a list of PFAS homologous series from processed LC-HRMS data

# Installation and setup
The code uses only base R so no additional packages are necessary to run this code. Simply download the R-file and open it in R-studio

# Intended use
The code is customized to look for CF2 and C2F4 homologues in a data frame which contains at minimum retention time, kendrick mass defect, m/z or molecular weights.
More homologous may be added in the future, such as CF2O-homologues. 

# Preparation
In any software which has processed LC-HRMS data, perform QC of sample data to ensure that only high quality peaks are included. Export the remaining compounds and then import them into R.

The line 'df <- Compounds_nodiscredited' will need to be modified so that df only takes in whatever you named the excel file that is being imported. 

The line 'df1 <- df[c("Calc. MW", "m/z", "RT [min]", "Mass Defect: Kendrick MD [C F2]")]' will also need to be modified so that the column names align with your imported document.

# Created by
Svante Rehnstam - Swedish University of Agricultural Sciences (SLU), Department of Aquatic Sciences and Assessment. 
