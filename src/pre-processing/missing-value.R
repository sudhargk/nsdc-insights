
getColumnType <- eventReactive(input$preprocessColumns, {
  switch(input$preprocessColumns,
         "Course Fee" = "Numerical",
         "VM1" = "Categorical",
         "Gender" = "Categorical",
         "VM2" = "Categorical",
         "PreTrainingStatus" = "Categorical",
         "EducationLevel" = "Categorical",
         "TechnicalEducation" = "Categorical",
         "CandidateState" = "Categorical",
         "CandidateDistrict" = "Categorical",
         "FundingPartner" = "Categorical",
         "Grade" = "Categorical",
         "Certified" = "Categorical",
         "Skilling.Category" = "Categorical",
         "MonthlyEarningOrCTCbeforeTraining" = "Numerical",
         "CentreState" = "Categorical",
         "CentreDistrict" = "Categorical",
         "CentreType" = "Categorical",
         "centre.Status" = "Categorical"
         )
  }
)


getMVMethod <- reactive({
  switch(getColumnType(),
         "Numerical"=c("DELETE_ROW","NUM_IMPUTATION"),
         "Categorical"=c("DELETE_ROW","CAT_IMPUTATION")
) })

getMVStrategy <- eventReactive(input$preprocessMVSelect, {
  switch(input$preprocessMVSelect,
         "DELETE_ROW"="--------",
         "NUM_IMPUTATION"=c("mean","median","most-frequent","constant"),
         "CAT_IMPUTATION"=c("most-frequent","constant")
  )})

