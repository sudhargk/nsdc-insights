columns <- c("NewID","Account.ID","Type.of.partner","batchID","CentreID","Course.MAster.ID","Course Fee","VM1","Gender","VM2","DateOfBirth","PreTrainingStatus","EducationLevel","TechnicalEducation","CandidateState","CandidateDistrict","Sector","BatchStartDate","BatchEndDate","FundingPartner","Grade","PlacementStatus","Certified","Employment.Type","StateOFPlacementorWork","Skilling.Category","MonthlyEarningOrCTCbeforeTraining","MonthlyCurrentCTCOrearning","CentreState","CentreDistrict","CentreType","centre.Status")

dataUI <- tabPanel("Data",
                   sidebarLayout(
                     sidebarPanel(
                       fileInput("file", "Choose XL File",
                                 accept = c("text/xlsx",".xlsx")),
                       radioButtons("disp", "Display",
                                    choices = c(Head = "head",
                                                All = "all"),
                                    selected = "head"),
                       selectInput(inputId = "columns",
                                   label = "Choose a Column:",
                                   choices = columns)
                     ),
                     mainPanel(
                       tabsetPanel(
                         tabPanel("Dataset", tableOutput("Data")),
                         tabPanel("Summary Stats", verbatimTextOutput("summary"))))
                   )
)
