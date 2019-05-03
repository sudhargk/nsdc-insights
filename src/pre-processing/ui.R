

preprocessUI  <- tabPanel("Data Preparation", #sidebarPanel(
  tags$style(HTML("
        .box  {background-color : transparent; }
        .center-div {float:center;}
    ")
  ),
  box( width=3, 
  wellPanel(
    fileInput("preprocessFile", "Choose XL File",
            multiple = FALSE,
            accept = c("text/xlsx",".xlsx"))),
  wellPanel(
    pickerInput("preprocessIrrelevantCols", "Irrelevant Columns ",choices = c(),
                options = list(`actions-box` = TRUE), multiple = TRUE
    )
  ),
  wellPanel(
  selectInput(inputId = "preprocessColumns",
              label = "Columns with Missing Values :",
              choices = c())),
  actionBttn(inputId = "preprocessDownload",label = "Download", 
             style = "gradient", color = "primary",icon = icon("fas","fa-download")),
  hr(),
  textOutput("preprocessDownloadStatus")), 
  mainPanel(
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


