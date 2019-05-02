##Classification Trees using rpart()##
library(dplyr)
library(irr)
library(rpart)
library(caret)
#Tree plotting
library(rattle)
library(rpart.plot)
library(RColorBrewer)
library("readxl")

input_file <- "/Users/vambavar/Documents/Vijaya/technical/data-Science/Jigsaw-Academy/capstone-project/NSDC_UChicago_Group1.xlsx"
dat <- read_xlsx(input_file, sheet = "NSDC_UChicago_Group1(1)")
summary(dat)

#pre-processing
dat$PlacementStatus[is.na(dat$PlacementStatus)] = 1
dat$PlacementStatus<-as.factor(dat$PlacementStatus)
dat$Gender<-as.factor(dat$Gender)
dat$PreTrainingStatus[is.na(dat$PreTrainingStatus)] = 1
dat$PreTrainingStatus<-as.factor(dat$PreTrainingStatus)
dat$TechnicalEducation[is.na(dat$TechnicalEducation)] = 2
dat$TechnicalEducation<-as.factor(dat$TechnicalEducation)
dat$FundingPartner<-as.factor(dat$FundingPartner)

# build the first model with many of the predictors since we don't know which has more co-efficient
# drop unwanted predictors from input data
dat1 = subset(dat, select=-c(NewID, Account.ID))
# droppping batchID,  Course.Fee, Certified, Employment.Type, StateOFPlacementorWork, 
# MonthlyEarningOrCTCbeforeTraining, MonthlyCurrentCTCOrearning since it has many NA's
dat1 = subset(dat1, select=-c(batchID, `Course Fee`, Certified, Employment.Type, StateOFPlacementorWork,
                              MonthlyEarningOrCTCbeforeTraining, MonthlyCurrentCTCOrearning))
#dropping dates related predictors as of now
dat1 = subset(dat1, select=-c(DateOfBirth, BatchStartDate, BatchEndDate))

summary(dat1)
# build the model with rpart()
mod1<-rpart(PlacementStatus~.,data=dat1,
            control=rpart.control(cp=0.01,maxdepth=10),method="class",parms=list(split="gini"))
plot(mod1, margin=0.1, main="Classification Tree for NSDC Training and Employment Data")
text(mod1, use.n=TRUE, all=TRUE, cex=.7)

fancyRpartPlot(mod1)

printcp(mod1)
plotcp(mod1, minline = TRUE)

#Confusion Matrix
actual1<-dat1$PlacementStatus
predicted1<-predict(mod1,type = "class")
confusionMatrix(predicted1,actual1,positive="1")
#Accuracy : 0.7544
#kappa metric
kappa2(data.frame(actual1,predicted1))
#Kappa = 0.507

# data skewness is high. so, select some predictors only based on its mode, others are as is.
dat%>%mutate(VM1_1=ifelse(VM1==1,1,0))->dat
dat$VM1_1[is.na(dat$VM1_1)] = 0
dat$VM1_1<-as.factor(dat$VM1_1)
dat%>%mutate(VM2_8=ifelse(VM2==8,1,0))->dat
dat$VM2_8[is.na(dat$VM2_8)] = 0
dat$VM2_8<-as.factor(dat$VM2_8)
dat%>%mutate(Grade_A=ifelse(Grade=='A',1,0))->dat
dat$Grade_A[is.na(dat$Grade_A)] = 0
dat$Grade_A<-as.factor(dat$Grade_A)
dat%>%mutate(Skilling.Category_29=ifelse(Skilling.Category==29,1,0))->dat
dat$Skilling.Category_29<-as.factor(dat$Skilling.Category_29)

dat2 = subset(dat, select=c(PlacementStatus, Gender, VM1_1,VM2_8, PreTrainingStatus, TechnicalEducation,
                            FundingPartner, Grade_A, Skilling.Category_29, CentreID,
                            Course.MAster.ID, CandidateState))
mod2<-rpart(PlacementStatus~.,data=dat2,
           control=rpart.control(cp=0.01,maxdepth=10),method="class",parms=list(split="gini"))

actual2<-dat2$PlacementStatus
predicted2<-predict(mod2,type = "class")
confusionMatrix(predicted2,actual2,positive="1")
kappa2(data.frame(actual2,predicted2))
#Accuracy : 0.7464
#Kappa = 0.4895

# since the first model has better accuracy, we'll consider it as final model.
library(ROCR)
pred1<-prediction(as.numeric(actual1),as.numeric(predicted1))
perf1<-performance(pred1,"tpr","fpr")
plot(perf1,col="red")
abline(0,1, lty = 8, col = "grey")
auc1<-performance(pred1,"auc")
# auc is an s4 object, we are interested in "y.values" in this output
auc1@y.values
# y.values is of type list, so unlist it to get the value. y.values of value above 0.6 means it's a 
# decent classification model.
unlist(auc1@y.values)
# 0.7558017