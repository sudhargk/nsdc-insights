options(shiny.maxRequestSize=30*1024^2) 
source("src/overview/server.R")
source("src/data/server.R")
source("src/visualization/server.R")
source("src/modelling/server.R")
source("src/testing/server.R")
source("src/conclusion/server.R")
source("src/pre-processing/server.R")
source("src/fields.R")


server <- function(input, output,session){
  
  read_data <- reactive({
     read.xlsx('data/raw/NSDC_UChicago_Group1.xlsx')
   })
  
  dataServer(input,output)
  preprocessServer(input,output,session)
  visualServer(input,output,read_data)
  
}
