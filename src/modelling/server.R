
rf<-function(scoring,n_folds){
  GridSearchCV$new(trainer = RFTrainer$new(),
          parameters =list(max_depth = seq(2,10,4),n_estimators=seq(10,100,30)), 
          scoring=scoring,n_folds=n_folds)
}

svm <- function (scoring,n_folds){
  GridSearchCV$new(trainer = SVMTrainer$new(),
                   parameters =list(type="bc"), 
                   scoring=scoring,n_folds=n_folds)
}


xgb <- function(scoring,n_folds){
  GridSearchCV$new(trainer = XGBTrainer$new(),
                   parameters =list(max_depth = seq(2,10,4),
                                    learning_rate = seq(0.01,0.1,1),
                                    n_estimators=seq(10,100,30)), 
                   scoring=scoring,n_folds=n_folds)
  
}

knn <- function(scoring,n_folds){
  GridSearchCV$new(trainer = KNNTrainer$new(),
                   parameters =list(k = seq(3,15,2),
                                    algorithm = c("kd_tree","cover_tree","brute"),
                                    type="class"), 
                   scoring=scoring,n_folds=n_folds)
}


getModels<-function(modelOption,modelFolds,modelScorers)({
  switch(modelOption,
         "Random Forest" = rf(modelFolds,modelScorers),
         "XGBoost"=xgb(modelFolds,modelScorers),
         "KNN" = knn(modelFolds,modelScorers),
         "SVM"=svm(modelFolds,modelScorers)
  )
})

modelServer <- function(input, output,session){
  
  read_data <- reactive({
    read.xlsx('data/processed/pre-processed.xlsx')
  })
  
  read_xfm_data<-reactive({
    cols<- c(input$modelColumns,"PlacementStatus")
    catCols<-names(which(unlist(sapply(cols,isCategorical))))
    read_data()%>%select(cols) %>% mutate_at(catCols,as.factor)
  })

  runTrain <- reactive({
    index=1;
    modelScore <- data.frame()
    progress <- Progress$new(session, min=1, max=length(input$modelOptions))
    on.exit(progress$close())
    data <- read_xfm_data()
    for(modelOption in input$modelOptions){
      modelScore[index,"Model"]<-modelOption
      progress$set(message = 'Building model',
                   detail = paste("Running for ",modelOption,".. This may take a while..."))
      model <-getModels(modelOption,input$modelScorers,strtoi(input$modelfolds))
      
      model$fit(data,"PlacementStatus")
      bestModelParams<-model$best_iteration()
      # for(score in input$modelScorers){
      #   modelScore[index,paste(score,"_avg_score")]<-bestModelParams[paste(score,"_avg")]
      #   modelScore[index,paste(score,"_sd_score")]<-bestModelParams[paste(score,"_sd")]
      # }
      progress$set(message = 'Model Built', detail = paste("For ",modelOption))
      modelScore[index,"ParamsStr"]<-toJSON(bestModelParams)
      index = index+1
      progress$set(value=index)
    }
    output$modelResults <- renderTable(modelScore)
  })
  
  observe({
    colnames <- setdiff(names(read_data()),"PlacementStatus")
    updatePickerInput(session,"modelColumns",choices=colnames,selected = colnames)
  })
  
  observeEvent(input$modelTrain,{
    runTrain()
  })
}