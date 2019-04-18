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
                   .well  {border-color:grey; }
                   .nav-pills > li > a {background-color:black; color:white;}
                   .nav-pills > li[class=active] > a {background-color:grey; color:white;}
                   .shiny-html-output {font-size:7;}
                "
          )),        
          navlistPanel(widths = c(2,10),
            tabPanel("Students", 
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
                                   tabPanel("Fund Partner", rbokehOutput("visualCandidateFundingPartner")),
                                   tabPanel("Edu Level", rbokehOutput("visualCandidateEducationLevel")),
                                   tabPanel("Emp Type", box_height =80,rbokehOutput("visualCandidateEmployment")),
                                   tabPanel("Tech Edu", box_height =80,rbokehOutput("visualCandidateTechEdu")),
                                   tabPanel("VM1", box_height =80,rbokehOutput("visualCandidateVM1")),
                                   tabPanel("VM2", box_height =80,rbokehOutput("visualCandidateVM2"))
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
                                    tabPanel("Status",rbokehOutput("visualCenterStatus")),
                                    tabPanel("Type ",rbokehOutput("visualCenterType")),
                                    tabPanel("Age ",rbokehOutput("visualCenterAge")),
                                    tabPanel("Placement ",rbokehOutput("visualCenterPlacement")),
                                    tabPanel("Package ",rbokehOutput("visualCenterPackage"))
                         )
                       ),
                       position=c("right")
                     )
            ),
            tabPanel("Courses ",
                     sidebarLayout(
                       sidebarPanel(
                         fluidRow(
                           uiOutput("visualizeCoursesSkillInputSelect"),
                           valueBoxOutput(width=12,"visualChosenCentreCourseSkills"),
                           box(title="Top 3 Courses", width=12,height=180, status = "primary", 
                               background = "black", solidHeader = TRUE,
                               tableOutput("visualTop3Courses"))
                         )
                       ),
                       mainPanel(
                         tabsetPanel(
                           tabPanel("Duration", rbokehOutput("visualCoursesDuration")),
                           tabPanel("Fee", rbokehOutput("visualCoursesFee")),
                           tabPanel("Age ",rbokehOutput("visualCourseAge")),
                           tabPanel("Placement ",rbokehOutput("visualCoursePlacement")),
                           tabPanel("Package ",rbokehOutput("visualCoursePackage"))
                         )
                       ),
                       position=c("right")
                     )
            )
          )
      )
    )
  )
)
