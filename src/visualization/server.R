
dataServer <- function(input, output){
  output$dataSummary <- renderText({
    req(input$file)
    data <- read_xlsx(input$file$datapath)
    c( "Summary for ", input$columns,"\n",
           "---------------------------------\n",
           paste("\n",summary(data[input$columns])))
  }) 
}
