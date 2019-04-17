library(shiny)
library(shinythemes)
library(flexdashboard)
library(shinydashboard)
library(shinyWidgets)
library(readxl)
library(dplyr)
library(ggplot2)
library(rbokeh)

source('src/ui.R')
source('src/server.R')

shinyApp(
ui = ui,
server = server
)
