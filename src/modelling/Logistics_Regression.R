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

# Feature Engineering
#summary(dat$PlacementStatus)
# setting the missing value with 1 i.e. not got placed.
dat$PlacementStatus[is.na(dat$PlacementStatus)] = 1
dat$PlacementStatus<-ifelse(dat$PlacementStatus==2,1,0)
dat$Type.of.partner<-as.factor(dat$Type.of.partner)
#summary(dat$PlacementStatus)

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
# summary(dat$CentreDistrict)

# drop unwanted predictors from input data to modeling
dat1 = subset(dat, select=-c(NewID, Account.ID))

# droppping batchID,  Course.Fee, Certified, Employment.Type, StateOFPlacementorWork, 
# MonthlyEarningOrCTCbeforeTraining, MonthlyCurrentCTCOrearning since it has many NA's
dat1 = subset(dat1, select=-c(batchID, Course.Fee, Certified, Employment.Type, StateOFPlacementorWork,
                             MonthlyEarningOrCTCbeforeTraining, MonthlyCurrentCTCOrearning))

#dropping dates related predictors as of now
dat1 = subset(dat1, select=-c(DateOfBirth, BatchStartDate, BatchEndDate))

head(dat1)
summary(dat1)

# Splitting into test and training samples
set.seed(200)
index<-sample(nrow(dat1), 0.70*nrow(dat1), replace=F)
train<-dat1[index,]
test<-dat1[-index,]

#Build the first model using all the selected predictors
mod1<-glm(formula = PlacementStatus ~ ., data=train, family="binomial")
summary(mod1)

# use step function to get the best predictors for the dependent variable
step(mod1,direction="both")

mod2 <- glm(formula = PlacementStatus ~ Type.of.partner + CentreID + 
              Course.MAster.ID + Gender + VM2 + PreTrainingStatus + EducationLevel + 
              TechnicalEducation + CandidateState + CandidateDistrict + 
              Sector + FundingPartner + Grade + Skilling.Category + CentreState + 
              CentreDistrict + CentreType + centre.Status, family = "binomial", 
            data = train)
summary(mod2)

# create dummies, for categories which are significant, in train and test data
train$Gender2<-ifelse(train$Gender==2,1,0)
train$PreTrainingStatus2<-ifelse(train$PreTrainingStatus==2,1,0)
train$TechnicalEducation2<-ifelse(train$TechnicalEducation==2,1,0)
train$GradeA<-ifelse(train$Grade=='A',1,0)
train$GradeB<-ifelse(train$Grade=='B',1,0)
train$GradeB1<-ifelse(train$Grade=='B1',1,0)
train$GradeC1<-ifelse(train$Grade=='C1',1,0)
train$GradeD<-ifelse(train$Grade=='D',1,0)
train$GradeD1<-ifelse(train$Grade=='D1',1,0)
train$GradeO<-ifelse(train$Grade=='O',1,0)

test$Gender2<-ifelse(test$Gender==2,1,0)
test$PreTrainingStatus2<-ifelse(test$PreTrainingStatus==2,1,0)
test$TechnicalEducation2<-ifelse(test$TechnicalEducation==2,1,0)
test$GradeA<-ifelse(test$Grade=='A',1,0)
test$GradeB<-ifelse(test$Grade=='B',1,0)
test$GradeB1<-ifelse(test$Grade=='B1',1,0)
test$GradeC1<-ifelse(test$Grade=='C1',1,0)
test$GradeD<-ifelse(test$Grade=='D',1,0)
test$GradeD1<-ifelse(test$Grade=='D1',1,0)
test$GradeO<-ifelse(test$Grade=='O',1,0)

mod3 <- glm(formula = PlacementStatus ~ Course.MAster.ID + Gender2 + VM2 + PreTrainingStatus2 + 
                       TechnicalEducation2 + CandidateState + CandidateDistrict + 
                       Sector + GradeA + GradeB + GradeB1 + GradeC1 +
                       GradeD, GradeD1 + GradeO + Skilling.Category,
                       family = "binomial", data = train)
summary(mod3)

mod4 <- glm(formula = PlacementStatus ~ Gender2 + VM2 + PreTrainingStatus2 + 
              TechnicalEducation2 + GradeA + GradeB + GradeB1 + GradeC1 +
              GradeD, GradeD1 + GradeO,
            family = "binomial", data = train)
summary(mod4)

pred<-predict(mod4,type="response",newdata=test)
head(pred)

table(dat$PlacementStatus)/nrow(dat)
# the probability of success in full data is 0.516
pred<-ifelse(pred>=0.516,1,0)

kappa2(data.frame(test$PlacementStatus,pred))

confusionMatrix(pred,test$PlacementStatus,positive="1")