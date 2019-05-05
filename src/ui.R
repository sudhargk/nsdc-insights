source("src/overview/ui.R")
source("src/visualization/ui.R")
source("src/simple-modelling/ui.R")
source("src/modelling/ui.R")
source("src/conclusion/ui.R")
source("src/pre-processing/ui.R")



ui <- navbarPage(
  theme = shinytheme("slate"),
   title = div(img(src='nsdc.png',
                 style="margin-top: -10px; padding-right:3px;padding-bottom:5px",
                   height = 55)),
  #title =  tags$img(src='icon.png'),
  windowTitle="National Skills Development Corporation",
  overviewUI,
  preprocessUI,
  visualUI,
  simpleModelUI,
  modelUI,
  conclusionUI
)
