columns <- c("NewID","Account.ID","Type.of.partner","batchID","CentreID","Course.MAster.ID","Course Fee","VM1","Gender","VM2","DateOfBirth","PreTrainingStatus","EducationLevel","TechnicalEducation","CandidateState","CandidateDistrict","Sector","BatchStartDate","BatchEndDate","FundingPartner","Grade","PlacementStatus","Certified","Employment.Type","StateOFPlacementorWork","Skilling.Category","MonthlyEarningOrCTCbeforeTraining","MonthlyCurrentCTCOrearning","CentreState","CentreDistrict","CentreType","centre.Status")

dataUI <- tabPanel("Data",
                   sidebarLayout(
                     sidebarPanel(
                       fileInput("dataInputFile", "Choose XL File",
                                 accept = c("text/xlsx",".xlsx")),
                       selectizeInput(inputId = "dataColumns",
                                   label = "Choose a Column:",
                                   multiple = TRUE,
                                   choices = columns)
                     ),
                     mainPanel(
                       tabsetPanel(
                         tabPanel("Dataset", tableOutput("dataTable")),
                         tabPanel("Summary Stats", verbatimTextOutput("dataSummary"))))
                   )
)
