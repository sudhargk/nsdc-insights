irrelevant_cols <- c("NewID","Account.ID","batchID","CentreID","Course.MAster.ID","StateOFPlacementorWork","CentreState","CentreDistrict","BatchEndDate","BatchStartDate","DateOfBirth","MonthlyCurrentCTCOrearning")

getColumnType <- function(column){
  switch(column,
         "NewID" = "Categorical",
         "Account.ID" = "Categorical",
         "Type.of.partner" = "Categorical",
         "batchID" = "Categorical",
         "CentreID" = "Categorical",
         "Course.MAster.ID" = "Categorical",
         "Course Fee" = "Numerical",
         "VM1" = "Categorical",
         "Gender" = "Categorical",
         "VM2" = "Categorical",
         "DateOfBirth" = "Categorical",
         "PreTrainingStatus" = "Categorical",
         "EducationLevel" = "Categorical",
         "TechnicalEducation" = "Categorical",
         "CandidateState" = "Categorical",
         "CandidateDistrict" = "Categorical",
         "Sector" = "Categorical",
         "BatchStartDate" = "Date",
         "BatchEndDate" = "Date",
         "FundingPartner" = "Categorical",
         "Grade" = "Categorical",
         "PlacementStatus" = "Categorical",
         "Certified" = "Categorical",
         "Employment.Type" = "Categorical",
         "StateOFPlacementorWork" = "Categorical",
         "Skilling.Category" = "Categorical",
         "MonthlyEarningOrCTCbeforeTraining" = "Numerical",
         "MonthlyCurrentCTCOrearning" = "Numerical",
         "CentreState" = "Categorical",
         "CentreDistrict" = "Categorical",
         "CentreType" = "Categorical",
         "centre.Status" = "Categorical",
         "Age" ="Numerical",
         "CourseDuration"="Numerical"
  )
}
  isCategorical<-function(colname){
    getColumnType(colname)=="Categorical"
  }
  
  toType <- function(column,value){
    if(column=="Grade"){
      return(value)
    }
    switch(getColumnType(column),
           "Categorical" = as.integer(value),
           "Numerical" = as.double(value),
           "Date" =as.Date(value)
    )
}