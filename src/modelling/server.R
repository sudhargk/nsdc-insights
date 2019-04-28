


modelServer <- function(input, output,session){
  
  read_data <- reactive({
    read.xlsx('data/processed/pre-processed.xlsx')
  })
  
  train_x<-reactive({
    read_data()%>%select(-PlacementStatus)%>%select(input$modelColumns)
    #%>% mutate_if(sapply(input$modelColumns,isCategorical),as.factor)
  })
  
  train_y<-reactive({
    read_data()$PlacementStatus
  })
  
  decisionTree<-reactive({
    x <- cbind(train_x(),train_y())
    fit <- rpart(train_y() ~ ., data = x,method="class")
    output$modelResults <- renderUI({
      text(summary(fit))
    })
  })
  
  
  runTrain<-reactive({
    switch(input$modelOptions,
           "Simple Decision Tree" = decisionTree(),
           "Random Forest" = decisionTree(),
           "Ada Boosting"= decisionTree(),
           "GBM"= decisionTree(),
           "XGBoost"=decisionTree()
    )
  })
  
  observe({
    colnames <- setdiff(names(read_data()),"PlacementStatus")
    updatePickerInput(session,"modelColumns",choices=colnames,selected = colnames)
  })
  
  observeEvent(input$modelTrain,{
    runTrain()
  })
  
  
}