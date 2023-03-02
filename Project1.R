#A.

#Calculate monthly mortgage rate at a 2.8% fixed mortgage rate.
p = 650000
z = 0.028
y = 30
d = 0.1

m = (p*(1-d)) * ((z/12)*(1+(z/12))^(y*12)) / ((1+(z/12))^(y*12) - 1)
m = round(m, digits = 2)
m #The monthly repayment will be $2403.73.

#Calculate monthly mortgage rate at a 6.1% fixed mortgage rate.
z1 = 0.061

m1 = (p*(1-d)) * ((z1/12)*(1+(z1/12))^(y*12)) / ((1+(z1/12))^(y*12) - 1)
m1 = round(m1, digits = 2)
m1 #The monthly repayment will be $3545.07.

#B.

#Set working directory.
setwd("C:/Users/alexm/OneDrive/Desktop/UCLA Data Science Certification/Projects/Project 1")
getwd()

#Import PO1_LA zip code payroll data set and convert it into a data frame. 

library(readxl)
zipcode_payroll_df = data.frame(read_excel("P01_LA zipcode payroll.xlsx", sheet = "2021"))
str(zipcode_payroll_df)

#Data cleaning.

#Replace NAs in NAICS column with 0s.
zipcode_payroll_df["NAICS"][is.na(zipcode_payroll_df["NAICS"])] = 0

#Replace ***** in Employment and Wages columns with 0s.
zipcode_payroll_df$Employment = gsub("\\*\\*\\*\\*\\*", 0, zipcode_payroll_df$Employment)
zipcode_payroll_df$Wages = gsub("\\*\\*\\*\\*\\*", 0, zipcode_payroll_df$Wages)

#Convert the Employment and Wages columns from character to numeric.
zipcode_payroll_df$Employment = as.numeric(zipcode_payroll_df$Employment)
zipcode_payroll_df$Wages = as.numeric(zipcode_payroll_df$Wages)
str(zipcode_payroll_df)

#Payroll employment for total industry.
tot_employment = subset(zipcode_payroll_df, NAICS == 0)
tot_employment = tot_employment[, c(1,5)]
tot_employment

#Payroll employment for Information sector.
info_sector = subset(zipcode_payroll_df, Industry == "Information")
info_sector = info_sector[, c(1,5)]
info_sector

#Payroll employment for Professional, Scientific, & Technical skills sector.
pst_sector = subset(zipcode_payroll_df, NAICS == 54)
pst_sector = pst_sector[, c(1,5)]
pst_sector

#Left join the tot_employment, info_sector, and pst_sector data frames with key value "Zip.code" to create new data frame. 
newdata = merge(tot_employment, info_sector, "Zip.Code", all.x = T)
newdata = merge(newdata, pst_sector, "Zip.Code", all.x = T)
colnames(newdata) = c("Zip Code", "Total", "Information", "Professional")

#Add Percent variable column to data frame.
newdata$Percent = (newdata$Information + newdata$Professional) / newdata$Total

#Alternative (but over complicated way): Create for loop to create vector of percentage data (percentage of tech jobs out of total jobs).
 
#Percent1 = c()
#for (i in 1:nrow(newdata)) {new_val = (newdata$Information[i] + newdata$Professional)[i] / newdata$Total[i]
  #Percent1 = c(Percent1, new_val)
#}
#newdata = cbind(newdata, Percent1)

#Export completed data frame to a .csv file.
write.csv(newdata, file = "C:/Users/alexm/OneDrive/Desktop/UCLA Data Science Certification/Projects/Project 1/2021_tech_data.csv", row.names = T)
