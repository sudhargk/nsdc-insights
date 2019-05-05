
SEED=71093
source("src/simple-modelling/graph.R")

dt<-function(data,label,nfolds){
  dt_params <- list( max_depth = c(3, 5))

  h2o.grid("randomForest", y = label,
                        training_frame = data,
                        nfolds=nfolds,
                        ntrees = 1,
                        seed=SEED,
                        hyper_params = dt_params)
}


getSimpleBestModel <- function(modelGrid,modelScore){
  sortedGrid <- h2o.getGrid(modelGrid@grid_id,sort_by="accuracy",decreasing = TRUE)
  summary_param_length<-length(sortedGrid@summary_table)-2
  bestModel<-h2o.getModel(sortedGrid@summary_table[1,"model_ids"])
}



GetEdgeLabel <- function(node) {return (node$edgeLabel)}
GetNodeShape <- function(node) {switch(node$type,
                                       split = "diamond", leaf = "oval")}
GetFontName <- function(node) {switch(node$type,
                                      split = 'Palatino-bold',
                                      leaf = 'Palatino')}
prepareTree <- function(tree){
  SetEdgeStyle(tree, fontname = 'Palatino-italic',
               label = GetEdgeLabel, labelfloat = TRUE,
               fontsize = "26", fontcolor='royalblue4')
  SetNodeStyle(tree, fontname = GetFontName, shape = GetNodeShape,
               fontsize = "26", fontcolor='royalblue4',
               height="0.75", width="1")

  SetGraphStyle(tree, rankdir = "LR", dpi=70.)
  print(plot(tree))
}


prepareSimpleROC<- function(modelName,testScore){
  data<-testScore@metrics$thresholds_and_metric_scores[c('tpr','fpr')] %>% 
    add_row(tpr=0,fpr=0,.before=T)
  fig<-ggplot(aes(fpr,tpr,col=modelName),data=data)+ geom_line()+
    geom_segment(aes(x=0,y=0,xend = 1, yend = 1),linetype = 2,col='grey')+
    xlab('False Positive Rate')+
    ylab('True Positive Rate')+
    ggtitle(paste('ROC Curve for',modelName))
  fig
}

buildSimpleModel <- function(modelName,split,session){
  h2o.init()
  progress <- Progress$new(session)
  on.exit(progress$close())

  progress$set(message = 'Building model',
               detail = paste("Running for ",modelName,".. This may take a while..."))
  modelGrid <-dt(split[[1]],"PlacementStatus",5)
  progress$set(message = 'Model Built', detail = paste("For ",modelName))

  bestModel<-getSimpleBestModel(modelGrid,"accuracy")
  testScore<-h2o.performance(bestModel,split[[2]])
  roc<-prepareSimpleROC(modelName,testScore)
  varimp<-h2o.varimp(bestModel)%>%arrange(desc(scaled_importance))
  
  modelTree<-h2o.getModelTree(model=bestModel,tree_number = 1)
  tree = createDataTree(modelTree)
  prepareTree(tree)
  
  list(tree=tree,featImp=varimp,roc=roc,conf=testScore@metrics$cm$table,
       scores=testScore@metrics$max_criteria_and_metric_scores)
}

simpleModelServer <- function(input, output,session){
  read_data <- reactive({
    read.xlsx('data/processed/pre-processed.xlsx')
  })
  
  read_split_data<-reactive({
    cols<- c(preferedColumns(),"PlacementStatus")
    catCols<-names(which(unlist(sapply(cols,isCategorical))))
    data<-read_data()%>%select(cols) %>% mutate_at(catCols,as.factor)
    h2o.splitFrame(as.h2o(data), seed = SEED)
  })
  
  observe({
    result<-buildSimpleModel("Decision Tree",read_split_data(),session)
    
    output$simpleModelFeatImp <- renderRbokeh({
      figure(xlab = "Variable Imporatnce", ylab = "Features",legend_location=NULL, tools=NULL) %>% 
        ly_bar(x=scaled_importance,y=variable,data = head(result$featImp,10),
               alpha = 0.5,hover=FALSE,width = 0.9)
      
    })
    
    
    output$simpleModelTree<- renderImage(
      {
        
        filename <- normalizePath(file.path('output',
                                            paste('simpleModelTree','.png',sep="")))
        list(src = filename)
      }, deleteFile = FALSE
     )
    
    output$simpleModelROC<- renderPlot({result$roc})
    
    output$simpleModelCF<- renderTable({result$conf})
    
    output$simpleModelScore<- renderTable({result$scores})
  })
  
}