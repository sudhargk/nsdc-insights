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
          tags$style(HTML("
                   .well  {border-color:grey;}
                   .nav-pills > li > a {background-color:black; color:white;}
                   .nav-pills > li[class=active] > a {background-color:grey; color:white;}
                   .shiny-html-output {font-size:7;}
                "
          )),        
          navlistPanel(widths = c(2,10),
            tabPanel("Candidates", 
                     sidebarLayout(
                       sidebarPanel(
                         fluidRow(
                           uiOutput("visualizeCandidateStateInputSelect"),
                           valueBoxOutput(width=12,"visualChosenCandidateStates"),
                           box(title="Top 3 Packages", width=12,height=180, status = "primary",
                               background = "black", solidHeader = TRUE,
                               tableOutput("visualTop3Packages"))
                         )
                       ),
                       mainPanel(
                         tabsetPanel(
                                   tabPanel("Grade",  rbokehOutput("visualCandidateGrade")),
                                   tabPanel("Age", rbokehOutput("visualCandidateAge")),
                                   tabPanel("Edu Level", rbokehOutput("visualCanddidateEducationLevel")),
                                   tabPanel("Emp Type", box_height =80,rbokehOutput("visualCanddidateEmployment")),
                                   tabPanel("Current CTC", box_height =80,rbokehOutput("visualCanddidateCTC"))
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
                         tabsetPanel(
                                    tabPanel("Funding Partners", rbokehOutput("visualCenterFundingPartners")),
                                    tabPanel("Status",rbokehOutput("visualCenterStatus")),
                                    tabPanel("Type ",rbokehOutput("visualCenterType"))
                                             
                         )
                       ),
                       position=c("right")
                     )
            ),
            tabPanel("Courses ",
                             "This panel is intentionally left blank")
          )
      )
    )
  )
)
