

MV_MAP<-hash()


default_method<-function(type){
  switch(type,
         "Categorical"="CAT_IMPUTATION",
         "Numerical"="NUM_IMPUTATION",
         "Date"="NONE")
}

default_strategy<-function(type){
  switch(type,
         "Categorical"="constant",
         "Numerical"="median",
         "Date"="median")
}

default_constants<-function(type){
  return(0)
}

get_mode <- function(data){
  min(data[which.max(tabulate(match(data,data%>%unique())))])
}

update_mv_map<-function(column){
  MV_MAP[paste(column,"METHOD",sep=".")]=default_method(getColumnType(column))
  MV_MAP[paste(column,"STRATEGY",sep=".")]=default_strategy(getColumnType(column))
  MV_MAP[paste(column,"CONSTANT",sep=".")]=default_constants(getColumnType(column))
}

initialize_map <- function(columns){
  for(column in columns)
    update_mv_map(column)
}

getSelectedMethod<- function(column){
  MV_MAP[[paste(column,"METHOD",sep=".")]];
}

getSelectedStrategy<- function(column){
 MV_MAP[[paste(column,"STRATEGY",sep=".")]];
}

getSelectedConstant<- function(column){
  MV_MAP[[paste(column,"CONSTANT",sep=".")]]
}

replace_na_in_col<- function(data,colname,value){
  col_val <- list(toType(colname,value))
  names(col_val) <- list(colname)
  data%>%replace_na(col_val)
}


apply_mv_strategy<- function(data,column,mv_strategy,mv_constant){
  switch(mv_strategy,
         "mean"= replace_na_in_col(data,column,apply(data[column],2,mean,na.rm=TRUE)),
         "median"=replace_na_in_col(data,column,apply(data[column],2,median,na.rm=TRUE)),
         "most-frequent" = replace_na_in_col(data,column,apply(data[column],2,get_mode)),
         "constant" = replace_na_in_col(data,column,mv_constant)
  )
}
apply_mv_rule <- function(data,column,mv_method,mv_strategy,mv_constant){
  switch(mv_method,
         "NONE" = data,
         "DELETE_ROW" = data%>%filter(!is.na(data[column])),
         "NUM_IMPUTATION" = apply_mv_strategy(data,column,mv_strategy,mv_constant),
         "CAT_IMPUTATION" = apply_mv_strategy(data,column,mv_strategy,mv_constant)
  )
}
preprocessServer <- function(input, output,session){
  
  input_data <- reactive({
    req(input$preprocessFile)
    read_xlsx(input$preprocessFile$datapath)%>%
      mutate(Age=time_length(difftime(Sys.Date(),mdy(substring(DateOfBirth,0,11))),"years"))%>%
      mutate(CourseDuration=time_length(difftime(mdy(substring(BatchEndDate,0,11)),mdy(substring(BatchStartDate,0,11))),"days"))
  })
  
  read_data <-reactive({
    data<-input_data()
    data[,!names(data) %in% input$preprocessIrrelevantCols]
  })
  
  apply_all_transform <- reactive ({
    data<-read_data()
    for(col in cols_with_missing_val()){
      data <- data %>% apply_mv_rule(col,getSelectedMethod(col),
                                     getSelectedStrategy(col),getSelectedConstant(col))
    }
    data
  })
  
  
  select_col_data<-reactive({
    read_data() %>% select(input$preprocessColumns)
  });
  
  
  cols_with_missing_val <- reactive({
    names(which(colSums(is.na(read_data()))>0))
  })
    
  
  data_after_mv<-reactive({
    apply_mv_rule(read_data(),input$preprocessColumns,input$preprocessMVMethodA,
                  input$preprocessMVStrategyA,input$preprocessMVConstantA)%>%
      select(input$preprocessColumns)%>%
      mutate_if(sapply(input$preprocessColumns,isCategorical),as.factor)
  })
  
  
  
  missing_value_rows <- reactive({
    length(which(is.na(data_after_mv())))
  });
  
  
  observeEvent(input$preprocessFile,{
      initialize_map(cols_with_missing_val())
      updatePickerInput(session,"preprocessIrrelevantCols",choices=names(input_data()));
      
  })
  
  observeEvent(input$preprocessIrrelevantCols,{
    updateSelectInput(session,"preprocessColumns",choices=cols_with_missing_val())
  })
  
  
  getMVMethod <- reactive({
    switch(getColumnType(input$preprocessColumns),
           "Numerical"=c("NONE","DELETE_ROW","NUM_IMPUTATION"),
           "Categorical"=c("NONE","DELETE_ROW","CAT_IMPUTATION")
    ) })
  
  getMVStrategy <- reactive( {
    switch(input$preprocessMVMethodA,
           "NONE"=c("--------"),
           "DELETE_ROW"=c("--------"),
           "NUM_IMPUTATION"=c("mean","median","constant"),
           "CAT_IMPUTATION"=c("most-frequent","constant")
    )})
  
  output$preprocessMVMethod <- renderUI({
      req(input$preprocessColumns)
      radioButtons("preprocessMVMethodA", label = "METHOD",
                  choices = getMVMethod(),
                  selected = c(getSelectedMethod(input$preprocessColumns)))
  })
  
  output$preprocessMVStrategy <- renderUI({
    req(input$preprocessMVMethodA)
    radioButtons("preprocessMVStrategyA", label = "STRATEGY",
                choices = getMVStrategy(),
                selected = c(getSelectedStrategy(input$preprocessColumns)))
  })
  
  output$preprocessMVConstant <- renderUI({
    req(input$preprocessColumns)
    textInput("preprocessMVConstantA", label = "CONSTANT",value = getSelectedConstant(input$preprocessColumns))
  })
  

  observeEvent(input$preprocesSave, {
    MV_MAP[paste(input$preprocessColumns,"METHOD",sep=".")]=input$preprocessMVMethodA
    MV_MAP[paste(input$preprocessColumns,"STRATEGY",sep=".")]=input$preprocessMVStrategyA
    MV_MAP[paste(input$preprocessColumns,"CONSTANT",sep=".")]=input$preprocessMVConstantA
  })
  
  
  
  observeEvent(input$preprocessDownload,{
    write.xlsx(apply_all_transform(),'data/processed/pre-processed.xlsx');
    output$preprocessDownloadStatus <- renderText({
      paste("[",Sys.time(),"] : donloaded file and rules @ [data/processed/]");
    }
    )
  })
  
    
  
  observeEvent(input$preprocesView, {
    output$preprocessNumMissingValues<-renderText({ paste("# Missing Values : ", toString(missing_value_rows()))})
    output$preprocessNumRows<-renderText({ paste("# Total Rows",toString(data_after_mv()%>%count()))})
     output$preprocessDistribution<-renderRbokeh({
       myPlot <- figure(xlab = input$preprocessColumns , ylab = "Frequency",legend_location=NULL, tools=NULL);
       if(!isCategorical(input$preprocessColumns)){
          myPlot%>%ly_hist(input$preprocessColumns,data=data_after_mv(),alpha = 0.5, breaks = 20,freq = TRUE)
       }else{
          gData<-table(data_after_mv())
          myPlot%>%ly_bar(x=names(gData),y=gData,alpha = 0.5)
       }
    })
    
  })

}

