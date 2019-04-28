##Classification Trees using rpart()##
library(dplyr)
library(irr)
library(rpart)
library(caret)
#Tree plotting
library(rattle)
library(rpart.plot)
library(RColorBrewer)
###nsdc <- read.csv("D:/INDESXD1 dat11A/Praxair/PG/Capstone Project/NSDC/NSDC_UChicago_Group1(1).csv",stringsAsFactors = F,header=T)
#nsdc <-
#  read_xlsx(
#    "D:/INDESXD1 datA/Praxair/PG/Capstone Project/NSDC/NSDC_UChicago_Group1(1).xlsx",
#    sheet = "NSDC_UChicago_Group1(1)"
#  )
input_file <- "/Users/vambavar/Documents/Vijaya/technical/data-Science/Jigsaw-Academy/capstone-project/NSDC_UChicago_Group1(1).csv"
dat1 <- read.csv(input_file, stringsAsFactor=F, header=T)
colnames(dat1)[colnames(dat1)=="X...NewID"] <- "NewID"

#View(dat1)
dat1$PlacementStatus[is.na(dat1$PlacementStatus)] = 0
dat1$PlacementStatus<-ifelse(dat1$PlacementStatus==2,1,0)
summary(dat1)

dat1$Type.of.partner<-as.factor(dat1$Type.of.partner)
#summary(dat1$PlacementStatus)

# summary(dat1$VM1)
# setting the missing value with most frequent value
dat1$VM1[is.na(dat1$VM1)] = 1
# summary(dat1$VM1)

# summary(dat1$VM2)
# setting the missing value with most frequent value
dat1$VM2[is.na(dat1$VM2)] = 1
# summary(dat1$VM2)

# summary(dat1$Type.of.partner)
dat1$Type.of.partner<-as.factor(dat1$Type.of.partner)
# summary(dat1$Type.of.partner)

# summary(dat1$Gender)
dat1$Gender<-as.factor(dat1$Gender)
# summary(dat1$Gender)

# summary(dat1$PreTrainingStatus)
attr1 <- dat1$PreTrainingStatus
# setting the missing value with most frequent value
dat1$PreTrainingStatus[is.na(dat1$PreTrainingStatus)] = 1
dat1$PreTrainingStatus<-as.factor(dat1$PreTrainingStatus)
# summary(dat1$PreTrainingStatus)

# summary(dat1$TechnicalEducation)
attr1 <- dat1$TechnicalEducation
# setting the missing value with most frequent value
dat1$TechnicalEducation[is.na(dat1$TechnicalEducation)] = 1
dat1$TechnicalEducation<-as.factor(dat1$TechnicalEducation)
# summary(dat1$TechnicalEducation)

# summary(dat1$FundingPartner)
dat1$FundingPartner<-as.factor(dat1$FundingPartner)
# summary(dat1$FundingPartner)

# summary(dat1$CentreType)
dat1$CentreType<-as.factor(dat1$CentreType)
# summary(dat1$CentreType)

# summary(dat1$centre.Status)
# setting the missing value with most frequent status
dat1$centre.Status[is.na(dat1$centre.Status)] = 1
dat1$centre.Status<-as.factor(dat1$centre.Status)
# summary(dat1$centre.Status)

# summary(dat1$CentreDistrict)
# setting the missing value with most frequent value
dat1$CentreDistrict[is.na(dat1$CentreDistrict)] = 1
# summary(dat1$CentreDistrict)

# drop unwanted predictors from input dat1a to modeling
dat2 = subset(dat1, select=-c(NewID, Account.ID))

# droppping batchID,  Course.Fee, Certified, Employment.Type, StateOFPlacementorWork, 
# MonthlyEarningOrCTCbeforeTraining, MonthlyCurrentCTCOrearning since it has many NA's
dat2 = subset(dat2, select=-c(batchID, Course.Fee, Certified, Employment.Type, StateOFPlacementorWork,
                              MonthlyEarningOrCTCbeforeTraining, MonthlyCurrentCTCOrearning))

#dropping dates related predictors as of now
dat2 = subset(dat2, select=-c(DateOfBirth, BatchStartDate, BatchEndDate))
summary(dat2)

mod1<-rpart(PlacementStatus~.,data=dat2,
           control=rpart.control(cp=0.01,maxdepth=10),method="class",parms=list(split="gini"))
plot(mod1, margin=0.1, main="Classification Tree for NSDC Training and Employment Data")
text(mod1, use.n=TRUE, all=TRUE, cex=.7)

fancyRpartPlot(mod1)

printcp(mod1)
plotcp(mod1, minline = TRUE)

mod2<-prune(mod1,cp= 0.05)
fancyRpartPlot(mod2)

#Rules derivation
mod2

#Confusion Matrix
actual<-dat2$PlacementStatus
actual<-as.factor(actual)

predicted<-predict(mod2,type = "class")
head(predicted)
head(as.numeric(predicted))
predicted<-as.factor(predicted)
predicted<-ifelse(predicted==2,1,0)

summary(predicted)
summary(actual)
class(predicted)
class(actual)
str(predicted)
str(actual)
confusionMatrix(factor(predicted, levels = 0:1),
                factor(predicted, levels = 0:1),
                positive="1")

#kappa metric
kappa2(data.frame(actual,predicted))

#ROC curve analysis
library(ROCR)
#pred<-prediction(actual,predicted)
#perf<-performance(pred,"tpr","fpr")
#plot(perf,col="red")
#abline(0,1, lty = 8, col = "grey")

#auc<-performance(pred,"auc")
#unlist(auc@y.values)