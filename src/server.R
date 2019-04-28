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
  
  dataServer(input,output)
  preprocessServer(input,output,session)
  visualServer(input,output)
  modelServer(input,output,session)
}
