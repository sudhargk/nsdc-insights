library(gains)
library(dplyr)
library(irr)
library(caret)

input_file <- "/Users/vambavar/Documents/Vijaya/technical/Data-Science/Jigsaw-Academy/capstone-project/NSDC_UChicago_Group1(1).csv"
dat <- read.csv(input_file, stringsAsFactor=F, header=T)
colnames(dat)[colnames(dat)=="X...NewID"] <- "NewID"
#display first 10 rows of data
head(dat, n=10)
# get the dimensions of the data
dim(dat)
# display the type of every attribute
sapply(dat, class)
# look at the summary
summary(dat)

# Data pre-processing
dat$MonthlyEarningOrCTCbeforeTraining[is.na(dat$MonthlyEarningOrCTCbeforeTraining)] = 0

# summary(dat$PlacementStatus)
dat$PlacementStatus[is.na(dat$PlacementStatus)] = 1
dat$PlacementStatus<-ifelse(dat$PlacementStatus==2,1,0)
# summary(dat$PlacementStatus)

# summary(dat$VM1)
# setting the missing value with most frequent value
dat$VM1[is.na(dat$VM1)] = 1
# summary(dat$VM1)

# summary(dat$VM2)
# setting the missing value with most frequent value
dat$VM2[is.na(dat$VM2)] = 1
# summary(dat$VM2)

# summary(dat$Type.of.partner)
dat$Type.of.partner<-as.factor(dat$Type.of.partner)
# summary(dat$Type.of.partner)

# summary(dat$Gender)
dat$Gender<-as.factor(dat$Gender)
# summary(dat$Gender)

# summary(dat$PreTrainingStatus)
attr1 <- dat$PreTrainingStatus
# setting the missing value with most frequent value
dat$PreTrainingStatus[is.na(dat$PreTrainingStatus)] = 1
dat$PreTrainingStatus<-as.factor(dat$PreTrainingStatus)
# summary(dat$PreTrainingStatus)

# summary(dat$TechnicalEducation)
attr1 <- dat$TechnicalEducation
# setting the missing value with most frequent value
dat$TechnicalEducation[is.na(dat$TechnicalEducation)] = 1
dat$TechnicalEducation<-as.factor(dat$TechnicalEducation)
# summary(dat$TechnicalEducation)

# summary(dat$FundingPartner)
dat$FundingPartner<-as.factor(dat$FundingPartner)
# summary(dat$FundingPartner)

# summary(dat$CentreType)
dat$CentreType<-as.factor(dat$CentreType)
# summary(dat$CentreType)

# summary(dat$centre.Status)
# setting the missing value with most frequent status
dat$centre.Status[is.na(dat$centre.Status)] = 1
dat$centre.Status<-as.factor(dat$centre.Status)
# summary(dat$centre.Status)

# summary(dat$CentreDistrict)
# setting the missing value with most frequent value
dat$CentreDistrict[is.na(dat$CentreDistrict)] = 1
# summary(dat$centre.Status)

# drop unwanted predictors from input data to modeling
dat1 = subset(dat, select=-c(NewID, Account.ID))

# droppping batchID,  Course.Fee, Certified, Employment.Type, StateOFPlacementorWork, 
# MonthlyEarningOrCTCbeforeTraining, MonthlyCurrentCTCOrearning since it has many NA's
dat1 = subset(dat, select=-c(batchID, Course.Fee, Certified, Employment.Type, StateOFPlacementorWork,
                             MonthlyEarningOrCTCbeforeTraining, MonthlyCurrentCTCOrearning))
head(dat1)
summary(dat1)

# Splitting into test and training samples
set.seed(200)
index<-sample(nrow(dat1), 0.70*nrow(dat1), replace=F)
train<-dat1[index,]
test<-dat1[-index,]

#Build the first model using all the variables
mod<-glm(formula = PlacementStatus ~ ., data=train, family="binomial")
summary(mod)