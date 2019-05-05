
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


getBestModel <- function(modelGrid,modelScore){
  summary_param_length<-length(grid@summary_table)-2
  sortedGrid <- h2o.getGrid(modelGrid@grid_id,sort_by="accuracy",decreasing = TRUE)
  bestModel<-h2o.getModel(sortedGrid@summary_table[1,"model_ids"])
  bestModelSummary<-toJSON(sortedGrid@summary_table[1,1:summary_param_length])
  list("model"=bestModel,"summary"=bestModelSummary)
}



buildModel <- function(modelName,split,session,modelfolds){
  
  progress <- Progress$new(session)
  on.exit(progress$close())
 
  progress$set(message = 'Building model',
               detail = paste("Running for ",modelName,".. This may take a while..."))
  modelGrid <-getModelGrid(split[[1]],"PlacementStatus",modelName,strtoi(modelfolds))
  progress$set(message = 'Model Built', detail = paste("For ",modelName))
  
  bestModel<-getBestModel(modelGrid,"accuracy")

}

simpleModelServer <- function(input, output,session){
  
}