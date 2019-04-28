modelUI  <- tabPanel("Model", 
  tags$style(HTML("
          .box  {background-color : transparent; }
      ")
  ),
 box( width=3,
  wellPanel(
    pickerInput("modelColumns", "Columns ",choices = c(),
                options = list(`actions-box` = TRUE), multiple = TRUE
    )
  ),
  wellPanel(
    h3("Modelling"),
    selectInput(inputId = "modelOptions",
                label = "Models :",
                choices = c("Simple Decision Tree","Random Forest","Ada Boosting","GBM","XGBoost")
                ),
    uiOutput("modelParameters"),
    actionBttn("modelTrain", label = "Train",  style = "bordered", 
              color = "warning",icon = icon("sliders"))
  )
), mainPanel(
  tabsetPanel(
    tabPanel("Results",
             uiOutput("modelResults")
             ),
    tabPanel("Plots", 
             uiOutput("modelPlots")
             ),
    tabPanel("Accuracy", 
             uiOutput("modelAccuracy")
             )
    )
    
  )
)
