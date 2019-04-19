# install.packages("gains")
library(gains)
library(dplyr)
# install.packages("irr")
library(irr)
# install.packages("caret")
library(caret)

input_file <- "/Users/vambavar/Documents/Vijaya/technical/Data-Science/Jigsaw-Academy/capstone-project/NSDC_UChicago_Group1(1).csv"
employment_predict_dat <- read.csv(input_file,stringsAsFactor=F)
colnames(employment_predict_dat)[colnames(employment_predict_dat)=="X...NewID"] <- "NewID"
#display first 10 rows of data
head(employment_predict_dat, n=10)
# get the dimensions of the data
dim(employment_predict_dat)
# display the type of every attribute
sapply(employment_predict_dat, class)

# EDA
attr1 <- employment_predict_dat$Type.of.partner
print(paste0("Frequency of Type.of.partner:"))
print(cbind(freq=table(attr1), percentage=prop.table(table(attr1))*100))
# So, 2 is the most frequent Type.of.partner with frequency of 95450 times and 1 is the least frequent with
# frequency of 2 times.

summary(employment_predict_dat$Course.Fee)
# Maximum course fee is Rs. 6, 93, 000/-

summary(employment_predict_dat$VM1)
summary(employment_predict_dat$VM2)

attr1 <- employment_predict_dat$Gender
print(paste0("Frequency of Gender:"))
print(cbind(freq=table(attr1), percentage=prop.table(table(attr1))*100))
# Male students's ratio is 59.45% where as that of females is 40.54%

attr1 <- employment_predict_dat$PreTrainingStatus
print(paste0("Frequency of PreTrainingStatus:"))
print(cbind(freq=table(attr1), percentage=prop.table(table(attr1))*100))
# PreTrainingStatus of 2 has 91.8% as highest ratio where as 1 has 8.13% as lowest ratio.

attr1 <- employment_predict_dat$EducationLevel
print(paste0("Frequency of EducationLevel:"))
print(cbind(freq=table(attr1), percentage=prop.table(table(attr1))*100))
# EducationLevel of 3 has 34.1% as highest ratio where as 7 has 0.016% as lowest ratio.

attr1 <- employment_predict_dat$TechnicalEducation
print(paste0("Frequency of TechnicalEducation:"))
print(cbind(freq=table(attr1), percentage=prop.table(table(attr1))*100))
# TechnicalEducation of 1 has 91.9% as highest ratio where as 1 has 8.09% as lowest ratio.

attr1 <- employment_predict_dat$FundingPartner
print(paste0("Frequency of FundingPartner:"))
print(cbind(freq=table(attr1), percentage=prop.table(table(attr1))*100))
# FundingPartner of 3 has 45.89% as highest ratio where as 1 has 5.01% as lowest ratio.

attr1 <- employment_predict_dat$Grade
print(paste0("Frequency of Grade:"))
print(cbind(freq=table(attr1), percentage=prop.table(table(attr1))*100))
# Ignoring the missing grades, Grade of A has 15.2% as highest ratio where as D has 0.07% as lowest ratio.

attr1 <- employment_predict_dat$PlacementStatus
print(paste0("Frequency of PlacementStatus:"))
print(cbind(freq=table(attr1), percentage=prop.table(table(attr1))*100))
# PlacementStatus of 1 has 91.9% as highest ratio where as 1 has 8.09% as lowest ratio.

attr1 <- employment_predict_dat$Certified
print(paste0("Frequency of Certified:"))
print(cbind(freq=table(attr1), percentage=prop.table(table(attr1))*100))
#  51.55% of the sample are certified where as 48.45% are not.

attr1 <- employment_predict_dat$Employment.Type
print(paste0("Frequency of Employment.Type:"))
print(cbind(freq=table(attr1), percentage=prop.table(table(attr1))*100))
# Employment.Type of 3 has 36.77% as highest ratio where as 2 has 0.007% as lowest ratio.

attr1 <- employment_predict_dat$Skilling.Category
print(paste0("Frequency of Skilling.Category:"))
print(cbind(freq=table(attr1), percentage=prop.table(table(attr1))*100))
# Skilling.Category of 29 has 77.49% as highest ratio where as 1 and 18 has 0.001% as lowest ratio.

summary(employment_predict_dat$MonthlyEarningOrCTCbeforeTraining)
# Mininum CTC before Training is Rs. 1000/- where as maximum is Rs. 4,20,000/-

summary(employment_predict_dat$MonthlyCurrentCTCOrearning)
# Mininum CTC before Training is Rs. 1/- where as maximum is Rs. 6,80,000/-

attr1 <- employment_predict_dat$CentreType
print(paste0("Frequency of CentreType:"))
print(cbind(freq=table(attr1), percentage=prop.table(table(attr1))*100))
# CentreType of 1 has 76.42% as highest ratio where as 2 has 23.58% as lowest ratio.

attr1 <- employment_predict_dat$centre.Status
print(paste0("Frequency of centre.Status:"))
print(cbind(freq=table(attr1), percentage=prop.table(table(attr1))*100))
# centre.Status of 1 has 80.17% as highest ratio where as 2 has 4.36% as lowest ratio.

# Data pre-processing
employment_predict_dat$Course.Fee[is.na(employment_predict_dat$Course.Fee)] <- 0