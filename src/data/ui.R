columns <- c("NewID","Account.ID","Type.of.partner","batchID","CentreID","Course.MAster.ID","Course Fee","VM1","Gender","VM2","DateOfBirth","PreTrainingStatus","EducationLevel","TechnicalEducation","CandidateState","CandidateDistrict","Sector","BatchStartDate","BatchEndDate","FundingPartner","Grade","PlacementStatus","Certified","Employment.Type","StateOFPlacementorWork","Skilling.Category","MonthlyEarningOrCTCbeforeTraining","MonthlyCurrentCTCOrearning","CentreState","CentreDistrict","CentreType","centre.Status")
dataUI  <- tabPanel("Data", sidebarPanel(
  fileInput("file", "Choose XL File",
            multiple = FALSE,
            accept = c("text/xlsx",".xlsx")),
  tags$hr(),
  selectInput(inputId = "columns",
              label = "Choose a Column:",
              choices = columns)
), mainPanel(
  tabsetPanel(
    tabPanel("Summary",
             verbatimTextOutput("dataSummary",placeholder = FALSE)
             ),
    tabPanel("Distribution", "Purposely empty")
  )
)
)
