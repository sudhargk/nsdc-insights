
columns<-c("Course Fee",
           "VM1",
           "VM2",
           "TechnicalEducation",
           "Grade",
           "Certified",
           "Employment.Type",
           "Skilling.Category",
           "MonthlyEarningOrCTCbeforeTraining",
           "centre.Status")

preprocessUI  <- tabPanel("Preprocessing", sidebarPanel(
  fileInput("preprocessFile", "Choose XL File",
            multiple = FALSE,
            accept = c("text/xlsx",".xlsx")),
  
  selectInput(inputId = "preprocessColumns",
              label = "Columns with Missing Values :",
              choices = c()),
  width = 3
), mainPanel(
  sidebarLayout(
  sidebarPanel(
    h4("Missing Value Analysis"),
    hr(),
    uiOutput("preprocessMVMethod"),
    hr(),
    uiOutput("preprocessMVStrategy"),
    hr(),
    uiOutput("preprocessMVConstant"),
    actionButton("preprocesSave",label="Save"),
    actionButton("preprocesView",label="View"),
    width = 4
  ),mainPanel(
    wellPanel(
        h4("View"),
        rbokehOutput("preprocessDistribution"),
        textOutput("preprocessNumMissingValues"),
        textOutput("preprocessNumRows")
      )
  ))
))


