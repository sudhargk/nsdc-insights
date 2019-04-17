server <- function(input,output) {
  
  output$Data <- renderTable({ 
  
      if(is.null(input$file)){return()}
    read.table(input$file[['datapath']],sep=",",header=TRUE)
    
    if(input$disp == "head") {
      return(head(read.table(input$file[['datapath']],sep=",",header=TRUE)))
    }
    else {
      return(read.table(input$file[['datapath']],sep=",",header=TRUE))
    }})
  
  output$summary <- renderPrint({
    if(is.null(input$file)){return()}
    summary(read.table(input$file[['datapath']],sep=",",header=TRUE))
  })
}
