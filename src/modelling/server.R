modelServer <- function(input, output,session){
  
  read_data <- reactive({
    read.xlsx('data/processed/pre-processed.xlsx')
  })
  
  observe({
    colnames <- setdiff(names(read_data()),"PlacementStatus")
    updatePickerInput(session,"modelColumns",choices=colnames,selected = colnames)
  })
  
  
  
}