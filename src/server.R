options(shiny.maxRequestSize=30*1024^2) 
source("src/overview/server.R")
source("src/data/server.R")
source("src/visualization/server.R")
source("src/modelling/server.R")
source("src/testing/server.R")
source("src/conclusion/server.R")

server <- function(input, output){
  read_data <- reactive({
    read_xlsx('data/raw/NSDC_UChicago_Group1.xlsx')
  })
  dataServer(input,output)
  visualServer(input,output,read_data)
}
