library(shiny)
library(shinythemes)
library(readxl)

source('src/ui.R')
source('src/server.R')

shinyApp(
ui = ui,
server = server
)
