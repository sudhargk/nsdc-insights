visualUI  <- tabPanel("Visualization", 
                      mainPanel(
    useShinydashboard(),
    fluidRow(
      box(title="Placement Percentage", height=180, status = "primary", background = "black", solidHeader = TRUE, gaugeOutput("visualPlacementPercentage")),
      box(title="Male vs Female Placement Ratio", height=180, status = "primary", background = "black", solidHeader = TRUE,  gaugeOutput("visualGenderRatio"))
    ),
    fluidRow(
      box(status = "primary", background = "black", width = 12,height=125,
                valueBoxOutput("visualEnrolledStudents"),
                valueBoxOutput("visualTotalCentres"),
                valueBoxOutput("visualTotalCourses")
      )
    ),
    fluidRow(
      box(status = "primary", background = "black", width = 12,
          tabsetPanel(
            tabPanel("Centres",
                     sidebarLayout(
                         sidebarPanel(
                           fluidRow(
                                uiOutput("visualizeCenterStateInputSelect"),
                                valueBoxOutput(width=12,"visualChosenCentres")
                           )
                         ),
                         mainPanel(
                           verticalTabsetPanel(menuSide = "right",contentWidth = 10,color = "black",
                             verticalTabPanel("Funding Partners", box_height =100, rbokehOutput("visualCenterFundingPartners")),
                             verticalTabPanel("Status", box_height =100,rbokehOutput("visualCenterStatus")),
                             verticalTabPanel("Type ", box_height =100,rbokehOutput("visualCenterType"))
                             
                           )
                         ),
                         position=c("right")
                        )
                     ),
            tabPanel("Candidates", "This panel is intentionally left blank"),
            tabPanel("Courses ", "This panel is intentionally left blank")
          )
      )
    )
  )
)
