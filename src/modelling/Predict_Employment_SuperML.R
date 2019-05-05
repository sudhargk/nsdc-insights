##SuperML Modeling
library(data.table)
library(caret)
#install.packages("superml")
library(superml)
library(Metrics)
library("readxl")
#install.packages("FNN") # needed for k-nearest neighbor
library(FNN) # needed for k-nearest neighbor
#install.packages("ranger") # needed for RFTrainer
library(ranger) # needed for RFTrainer

input_file <- "/Users/vambavar/Documents/Vijaya/technical/data-Science/Jigsaw-Academy/capstone-project/NSDC_UChicago_Group1.xlsx"
dat <- read_xlsx(input_file, sheet = "NSDC_UChicago_Group1(1)")
#summary(dat)
#Pre-processing
dat$PlacementStatus[is.na(dat$PlacementStatus)] = 1
dat$PlacementStatus<-as.integer(as.factor(dat$PlacementStatus))
dat$Type.of.partner<-as.integer(as.factor(dat$Type.of.partner))
dat$PreTrainingStatus[is.na(dat$PreTrainingStatus)] = 1
dat$PreTrainingStatus<-as.integer(as.factor(dat$PreTrainingStatus))
dat$EducationLevel<-as.integer(as.factor(dat$EducationLevel))
dat$CandidateState<-as.integer(as.factor(dat$CandidateState))
dat$TechnicalEducation[is.na(dat$TechnicalEducation)] = 1
dat$TechnicalEducation<-as.integer(as.factor(dat$TechnicalEducation))
dat$FundingPartner<-as.integer(as.factor(dat$FundingPartner))
dat$VM1[is.na(dat$VM1)] = 1
dat$VM1<-as.integer(as.factor(dat$VM1))
dat$VM2[is.na(dat$VM2)] = 1
dat$VM2<-as.integer(as.factor(dat$VM2))
dat$Grade[is.na(dat$Grade)] = "O"
dat$Grade<-as.integer(as.factor(dat$Grade))
dat$Certified[is.na(dat$Certified)] = 1
dat$Certified<-as.integer(as.factor(dat$Certified))
dat$Skilling.Category<-as.integer(as.factor(dat$Skilling.Category))
dat$CentreState<-as.integer(as.factor(dat$CentreState))
dat$centre.Status[is.na(dat$centre.Status)] = 1
dat$centre.Status<-as.integer(as.factor(dat$centre.Status))

#summary(dat)

set.seed(200)
index<-sample(nrow(dat),0.70*nrow(dat),replace=F)
train<-dat[index,]
test<-dat[-index,]
#head(train)
# remove features with 80% or more missing values
# we will also remove the Id column because it doesn't contain
# any useful information
train1 = subset(train, select=-c(NewID, Account.ID, batchID, CentreID, DateOfBirth, BatchStartDate, 
                                 BatchEndDate, CandidateDistrict, `Course Fee`,
                             Sector, Certified, Employment.Type, StateOFPlacementorWork, 
                             MonthlyEarningOrCTCbeforeTraining, MonthlyCurrentCTCOrearning,
                             CentreDistrict, CentreType))
#summary(train1)
test1 = subset(test, select=-c(NewID, Account.ID, batchID, CentreID, DateOfBirth, BatchStartDate, 
                                 BatchEndDate, CandidateDistrict, `Course Fee`,
                                 Sector, Certified, Employment.Type, StateOFPlacementorWork, 
                                 MonthlyEarningOrCTCbeforeTraining, MonthlyCurrentCTCOrearning,
                                 CentreDistrict, CentreType))
#KNN Classification
knn <- KNNTrainer$new(k = 1,prob = T,type = 'class')
knn$fit(train = train1, test = test1, y = 'PlacementStatus')
probs <- knn$predict(type = 'prob')
labels <- knn$predict(type='raw')
rmse(actual = test1$PlacementStatus, predicted=labels)
#> [1] 0.2049485

# Grid Search
rf <- RFTrainer$new()
gst <-GridSearchCV$new(trainer = rf,
                       parameters = list(n_estimators = c(10,15), max_depth = c(5,2)),
                       n_folds = 3,
                       scoring = c('accuracy','auc'))
gst$fit(train1, "PlacementStatus")
gst$best_iteration()
#> $auc_avg
#> [1] 0.1179509
#> $auc_sd
#> [1] 0.002505381