library(shiny)
library(shinythemes)

source('src/ui.R')
source('src/server.R')

shinyApp(
ui = ui,
server = server
)
