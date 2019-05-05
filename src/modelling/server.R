
SEED=71093

rf<-function(data,label,nfolds){
  rf_params <- list( max_depth = c(3, 5, 9),
                     ntrees = seq(10, 100, 20))
  
  h2o.grid("randomForest", y = label,
                        training_frame = data,
                        nfolds=nfolds,
                        seed=SEED,
                        hyper_params = rf_params)
}


xgb <- function(data,label,nfolds){
  xgb_params <- list(learn_rate = c(0.01, 0.1,1),
                     max_depth = c(3, 5, 9),
                     col_sample_rate = c(0.2, 0.5, 1.0),
                     ntrees = seq(10, 100, 20))
  
  h2o.grid("gbm", y = label,
                      training_frame = data,
                      nfolds=nfolds,
                      seed=SEED,
                      hyper_params = xgb_params)
}



getModelGrid<-function(data,label,modelOption,modelFolds)({
  switch(modelOption,
         "RandomForest" = rf(data,label,modelFolds),
         "XGBoost"=xgb(data,label,modelFolds)
  #       "KNN" = knn(modelFolds,modelScorers),
  #       "SVM"=svm(modelFolds,modelScorers)
  )
})



getBestModel <- function(modelGrid,modelScore){
  sortedGrid <- h2o.getGrid(modelGrid@grid_id,sort_by="accuracy",decreasing = TRUE)
  summary_param_length<-length(sortedGrid@summary_table)-2
  bestModel<-h2o.getModel(sortedGrid@summary_table[1,"model_ids"])
  bestModelSummary<-toJSON(sortedGrid@summary_table[1,1:summary_param_length])
  list("model"=bestModel,"summary"=bestModelSummary)
}

updateModelScore<-function(name,testScore,summary){
  modelScore <- data.frame()
  modelScore[1,"Model"]<-name
  modelScore[1,"Test Accuracy"] <- testScore@metrics$max_criteria_and_metric_scores[4,3]
  modelScore[1,"Test AUC"] <- testScore@metrics$AUC
  modelScore[1,"Test LogLoss"] <-testScore@metrics$logloss
  modelScore[1,"Model Summary"] <-summary
  modelScore
}

updatePlot<- function(modelName,testScore){
  data<-testScore@metrics$thresholds_and_metric_scores[c('tpr','fpr')] %>% 
    add_row(tpr=0,fpr=0,.before=T)
  fig<-ggplot(aes(fpr,tpr,col=modelName),data=data)+ geom_line()+
    geom_segment(aes(x=0,y=0,xend = 1, yend = 1),linetype = 2,col='grey')+
    xlab('False Positive Rate')+
    ylab('True Positive Rate')+
    ggtitle(paste('ROC Curve for',modelName))
  fig
}


buildModel <- function(modelName,split,session,modelfolds){
  
  progress <- Progress$new(session)
  on.exit(progress$close())
 
  progress$set(message = 'Building model',
               detail = paste("Running for ",modelName,".. This may take a while..."))
  modelGrid <-getModelGrid(split[[1]],"PlacementStatus",modelName,strtoi(modelfolds))
  progress$set(message = 'Model Built', detail = paste("For ",modelName))
  
  bestModel<-getBestModel(modelGrid,"accuracy")
  testScore<-h2o.performance(bestModel$model,split[[2]])
  
  modelScore<-updateModelScore(modelName,testScore,bestModel$summary)
  
  fig<-updatePlot(modelName,testScore)
  
  list(model=modelScore,plot=fig,confusion=testScore@metrics$cm$table)
}

modelServer <- function(input, output,session){
  read_data <- reactive({
    read.xlsx('data/processed/pre-processed.xlsx')
  })
  
  read_split_data<-reactive({
    cols<- c(input$modelColumns,"PlacementStatus")
    catCols<-names(which(unlist(sapply(cols,isCategorical))))
    data<-read_data()%>%select(cols) %>% mutate_at(catCols,as.factor)
    h2o.splitFrame(as.h2o(data), seed = SEED)
  })
  
  observe({
    colnames <- setdiff(names(read_data()),"PlacementStatus")
    updatePickerInput(session,"modelColumns",choices=colnames,selected = colnames)
  })
  
  observeEvent(input$modelTrainRandomForest,{
    result<-buildModel("RandomForest", read_split_data(),session,input$modelfolds)
    output$modelResultsRandomForest <- renderTable(result$model)
    output$modelPlotRandomForest <- renderPlot({result$plot})
    output$modelAccuracyRandomForest <- renderTable(result$confusion)
  })
  
  observeEvent(input$modelTrainXGBoost,{
    result<-buildModel("XGBoost",read_split_data(),session,input$modelfolds)
    output$modelResultsXGBoost <- renderTable(result$model)
    output$modelPlotXGBoost <- renderPlot({result$plot})
    output$modelAccuracyXGBoost <- renderTable(result$confusion)
  })
}