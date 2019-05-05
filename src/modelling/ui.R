modelUI  <- tabPanel("Model", 
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
    checkboxGroupButtons(
      inputId = "modelOptions", label = "Models ",
      choices = c("Random Forest", "XGBoost","SVM"),direction = "vertical",
      selected = c("Random Forest", "XGBoost")),
    knobInput(inputId = "modelfolds",
              label = "# Folds", value = 10, min = 1, max = 20,  displayPrevious = TRUE, lineCap = "round",
              fgColor = "#428BCA",inputColor = "#428BCA",width=100,height = 100),
    uiOutput("modelParameters"),
    pickerInput("modelScorers", "Scoring",choices = c("auc","accuracy","mse","rmse","logloss","mae","f1","precision","recall"),
                options = list(`actions-box` = TRUE), multiple = TRUE,selected = c("accuracy","auc")),
    actionBttn("modelTrain", label = "Train",  style = "bordered", 
              color = "warning",icon = icon("sliders"))
  )
), mainPanel(
  tabsetPanel(
    tabPanel("Results",
             tableOutput("modelResults")
             ),
    tabPanel("Plots", 
             plotOutput("modelPlots")
             ),
    tabPanel("Accuracy", 
             uiOutput("modelAccuracy")
             )
    )
    
  )
)
