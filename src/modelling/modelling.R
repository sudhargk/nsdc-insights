library(superml)
library(ranger)
library(openxlsx)
library(dplyr)


data<-read.xlsx('data/processed/pre-processed.xlsx')

data<-data%>%select(-c("NewID","batchID","Account.ID","Course.MAster.ID","Sector"))
rf <- RFTrainer$new()
gst <-GridSearchCV$new(trainer = rf,
                       parameters = list(n_estimators = c(100),
                                         max_depth = c(5,2,10)),
                       n_folds = 3,
                       scoring = c('accuracy','auc'))
gst$fit(data, "PlacementStatus")
gst$best_iteration()




