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
            tabPanel("Candidates", 
                     sidebarLayout(
                       sidebarPanel(
                         fluidRow(
                           uiOutput("visualizeCandidateStateInputSelect"),
                           valueBoxOutput(width=12,"visualChosenCandidateStates")
                           # box(title="Top 3 Packages", width=12,height=180, status = "primary", 
                           #     background = "black", solidHeader = TRUE,
                           #     tableOutput("visualTop3Packages"))
                         )
                       ),
                       mainPanel(
                         verticalTabsetPanel(id = "CandidatesPanel", menuSide = "right",contentWidth = 10,color = "black",
                                   verticalTabPanel("Grade", box_height =80, rbokehOutput("visualCandidateGrade")),
                                            # verticalTabPanel("Age", box_height=80,rbokehOutput("visualCandidateAge")),
                                   verticalTabPanel("Edu Level", box_height =100,rbokehOutput("visualCanddidateEducationLevel"))
                                            # verticalTabPanel("Emp Type", box_height =80,rbokehOutput("visualCanddidateEmployment")),
                                            # verticalTabPanel("Current CTC", box_height =80,rbokehOutput("visualCanddidateCTC"))
                                      )
                       ),
                       position=c("right")
                     )
                    ),
            tabPanel("Centres",
                     sidebarLayout(
                       sidebarPanel(
                         fluidRow(
                           uiOutput("visualizeCenterStateInputSelect"),
                           valueBoxOutput(width=12,"visualChosenCentreStates"),
                           box(title="Top 3 Centres", width=12,height=180, status = "primary", 
                               background = "black", solidHeader = TRUE,
                               tableOutput("visualTop3Centres"))
                         )
                       ),
                       mainPanel(
                         verticalTabsetPanel(id="CentresPanel",menuSide = "right",contentWidth = 10,color = "black",
                                             verticalTabPanel("Funding Partners", box_height =100, rbokehOutput("visualCenterFundingPartners")),
                                             verticalTabPanel("Status", box_height =100,rbokehOutput("visualCenterStatus")),
                                             verticalTabPanel("Type ", box_height =100,rbokehOutput("visualCenterType"))
                                             
                         )
                       ),
                       position=c("right")
                     )
            ),
            tabPanel("Courses ", "This panel is intentionally left blank")
          )
      )
    )
  )
)
