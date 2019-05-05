modelUI  <- tabPanel("Advanced Model", 
  tags$style(HTML("
          .box  {background-color : transparent; }
      ")
  ),
 box( width=3,
  wellPanel(
    pickerInput("modelColumns", "Columns ",choices = c(),
                options = list(`actions-box` = TRUE), multiple = TRUE)
  ),
  wellPanel(
    h3("Modelling"),
    knobInput(inputId = "modelfolds",
              label = "# Folds", value = 5, min = 1, max = 10,  displayPrevious = TRUE, lineCap = "round",
              fgColor = "#428BCA",inputColor = "#428BCA",width=100,height = 100),
    uiOutput("modelParameters"),
    pickerInput("modelScorers", "Scoring",choices = c("auc","accuracy","mse","rmse","logloss","mae","f1","precision","recall"),
                options = list(`actions-box` = TRUE), multiple = TRUE,selected = c("accuracy","auc")),
    actionBttn("modelTrainRandomForest", label = "Train Random Forest",  style = "bordered", 
              color = "warning",icon = icon("sliders")),
    actionBttn("modelTrainXGBoost", label = "Train XG Boost",  style = "bordered", 
               color = "warning",icon = icon("sliders"))
  )
), mainPanel(
  tabsetPanel(
    tabPanel("Results",
             fluidRow(
                  tableOutput("modelResultsRandomForest"),
                  tableOutput("modelResultsXGBoost")
             )
             ),
    tabPanel("Plots", 
             fluidRow(
                  plotOutput("modelPlotRandomForest"),
                  plotOutput("modelPlotXGBoost")
             )
             ),
    tabPanel("Accuracy", 
             fluidRow(
                h3("Random Forest"),
                tableOutput("modelAccuracyRandomForest"),
                br(),
                h3("XGBoost"),
                tableOutput("modelAccuracyXGBoost")
             )
        )
    )
    
  )
)
