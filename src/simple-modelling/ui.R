simpleModelUI  <- tabPanel("Model", 
  mainPanel(
  tabsetPanel(
    tabPanel("Tree ",
             imageOutput("simpleModelTree")
             ),
    tabPanel("Feature Importance",
              rbokehOutput("simpleModelFeatImp")
             ),
    tabPanel("ROC",
             plotOutput("simpleModelROC")
     ),
    tabPanel("Validation Result",
          h4("Confusion Matrix"),
          tableOutput("simpleModelCF"),
          br(),
          h4("Scores"),
          tableOutput("simpleModelScore")
    )
    
    )
    
  )
)
