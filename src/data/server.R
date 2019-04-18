dataServer <- function(input,output) {
  
  readData <- reactive({    
    read_xlsx(input$dataInputFile$datapath)
    })
  
  output$dataTable <- renderTable({ 
    req(input$dataInputFile)
    data<-readData()
    
    if(input$dataDisplayOption == "head") {
      return(head(data))
    }
    else {
      return(data)
    }})
  
  output$dataSummary <- renderPrint({
    req(input$dataInputFile)
    data<-readData()
    summary(data[input$dataColumns])
  })
}
