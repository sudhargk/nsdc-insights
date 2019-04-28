library(shiny)
library(shinythemes)
library(flexdashboard)
library(shinydashboard)
library(shinyWidgets)
library(readxl)
library(openxlsx)
library(dplyr)
library(ggplot2)
library(rbokeh)
library(lubridate)
library(hash)
library(tidyr)


##modeling
library(rpart)
library(rattle)

source('src/ui.R')
source('src/server.R')

shinyApp(
ui = ui,
server = server
)
