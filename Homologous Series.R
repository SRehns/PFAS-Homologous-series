#Created by Svante Rehnstam
#Date: 2023-03-30 (YYYY-MM-DD)
#Before using this, perform at minimum QC of samples such as Peak Rating filtering
#After performing QC filtering, highlight all compounds and export an Excel table
#Import the table into your R workspace.

#Change "Compounds_nodiscredited" to the name of your imported Excel file
df <- Compounds_nodiscredited

#Creating an empty data frame for placing the compounds which have homologous.  
comps <- data.frame(matrix(ncol = 8, nrow= 0)) 
colnames(comps) <- c("mw1", "mz1", "rt1", "mdf1", "mw2", "mz2", "rt2", "mdf2")

#Extract the pertinent information from the Excel file
df1 <- df[c("Calc. MW", "m/z", "RT [min]", "Mass Defect: Kendrick MD [C F2]")] 

#Constants of CF2 and C2F4 monoisotopic masses
CF2 <- 49.99680
C2F4 <- 99.99361

#Renaming the columns for easier writing of the script
colnames(df1) <- c("mw", "mz", "rt", "mdf")

df1$mz <- as.numeric(df1$mz)
df1$rt <- as.numeric(df1$rt)

#Preparation of the for loop
i <- 1
j <- i+1
k <- 1

#The nestled for loops containing an if statement will look through the list of compounds, pick out potential homologous that align with the defined masses within 0.001 Da.
#The for loop also has the following conditions in the if statement: retention time of the homologoue needs to be higher than compound investigated
#Kendrick Mass Defect (CF2-adjusted) also needs to align within 0.001
for (i in 1:nrow(df1)){
  j <- i+1
  for (j in j:nrow(df1)){
    if((abs(df1$mw[i] - df1$mw[j] - CF2) <= 0.001) || (abs(df1$mw[i] - df1$mw[j] - C2F4) <= 0.001) && (abs(df1$mdf[i]-df1$mdf[j]) <= 0.001) && ((df1$rt[j] > df1$rt[i]))){
      comps[k,] <- rbind(c(df1[i,], df1[j,]))
      k <- k+1
    }
  }
}

#Calculating the difference between the homologues to assign which type of homologoue it is (CF2 or C2F4)
comps$mwdiff <- comps$mw1-comps$mw2

#The theoretical homologoue is calculated and compared with the experimental homologue in terms of mass accuracy in ppm
#Keep in mind that two out of three values in this computation are experimental and as such will inflate the ppm value
i <- 1
for (i in i:nrow(comps)){
if ((C2F4 - comps$mwdiff[i]) <= 0.001){
  comps$ppm[i] <- (((comps$mw1[i]-C2F4)-comps$mw2[i])/comps$mw2[i])*1000000
} else {
  comps$ppm[i] <- (((comps$mw1[i]-CF2)-comps$mw2[i])/comps$mw2[i])*1000000
  }
}
