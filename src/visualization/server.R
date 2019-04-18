
visualServer <- function(input, output,session,read_data){
 
  uniqueCentreStates <- reactive({
    unique(read_data()["CentreState"])
  });
  
  uniqueCandidateStates <- reactive({
    unique(read_data()["CandidateState"])
  });
  
  uniqueCourseSkills <- reactive({
    unique(read_data()["Skilling.Category"])
  });
  
  
  uniqueCenters <- reactive({
    nrow(unique(read_data()["CentreID"]))
  });
  
  totalEnrolledStudents <- reactive({
     nrow(read_data())
  });
  
  placedStudents <- reactive({
     nrow(read_data() %>% filter(PlacementStatus==2))
  });
  
  placedMaleStudents <- reactive({
      nrow(read_data() %>% filter(Gender==2 &PlacementStatus==2))
  });
  
  centersSelected <- reactive({
      read_data() %>%filter(CentreState %in% input$visualCenterStateSelect) %>% 
      select(CentreType,centre.Status,CentreID,FundingPartner,MonthlyCurrentCTCOrearning)%>%
      group_by(CentreType,centre.Status,CentreID,FundingPartner)%>%
      summarize(AvereageCTC=mean(MonthlyCurrentCTCOrearning))
  });
  
  candidateSelected <- reactive({
      read_data() %>% filter(CandidateState %in% input$visualCandidateStateSelect) %>% 
      select(NewID,Grade,DateOfBirth,EducationLevel,`Employment.Type`,PlacementStatus,MonthlyEarningOrCTCbeforeTraining,
             MonthlyCurrentCTCOrearning,PreTrainingStatus)%>%
      mutate(Age=time_length(difftime(Sys.Date(),mdy(substring(DateOfBirth,0,11))),"years"))
     
  });
  
  coursesSelected <- reactive({
    read_data() %>% filter(Skilling.Category %in% input$visualCourseSkillSelect) %>% 
      select(Course.MAster.ID,`Course Fee`,PreTrainingStatus,TechnicalEducation,MonthlyCurrentCTCOrearning,BatchEndDate,BatchStartDate)%>%
      mutate(Duration=time_length(difftime(mdy(substring(BatchEndDate,0,11)),mdy(substring(BatchStartDate,0,11))),"days"))%>%
      group_by(Course.MAster.ID,PreTrainingStatus,TechnicalEducation)%>%
      summarize(AvereageCTC=mean(MonthlyCurrentCTCOrearning),AverageFee=mean(`Course Fee`),AverageDuration=mean(Duration))
  });
  
  ### ---------------------                 Dashboarding          
  #################################################################################
  
  output$visualEnrolledStudents <- renderValueBox({
    valueBox(
      "Enrolled Students",
      color = "aqua",
      value = totalEnrolledStudents(),
      icon = icon("user","fa-user-alt")
    )
  });
  output$visualTotalCentres <- renderValueBox({
    valueBox(
      "Total Centres",
      color="teal",
      value = uniqueCenters(),
      icon = icon("center","fa-building")
    )
  });
  
  output$visualTotalCourses <- renderValueBox({
    valueBox(
      "Total Courses",
      color="yellow",
      value = nrow((unique(read_data()["Course.MAster.ID"]))),
      icon = icon("course","fa-book")
    )
  });
  
  output$visualPlacementPercentage <- renderGauge({
    gauge(round(placedStudents()/totalEnrolledStudents(),2), 
          min = 0, 
          max = 1, 
          sectors = gaugeSectors(success = c(0.5, 1), 
                                 warning = c(0.3, 0.5),
                                 danger = c(0, 0.3)))
  });
  
  output$visualGenderRatio <- renderGauge({
    gauge(round(placedMaleStudents()/placedStudents(),2), 
          min = 0, 
          max = 1, 
          sectors = gaugeSectors(success = c(0.5, 1), 
                                 warning = c(0, 0.5))
    )
  });
  
  ### ---------------------                 Center          
  #################################################################################
  
  
  
  output$visualizeCenterStateInputSelect <- renderUI({
    pickerInput("visualCenterStateSelect", "STATES ",
                choices = uniqueCentreStates(),
                options = list(`actions-box` = TRUE), multiple = TRUE
    )
  });
  
  output$visualCenterFundingPartners <- renderRbokeh({
    figure(xlab = "Funding Partner", ylab = "# of Centers",legend_location=NULL, tools=NULL) %>% 
      ly_bar(x=as.factor(FundingPartner),data = centersSelected(),alpha = 0.5,hover=FALSE, width = 0.9)
  });
  
  output$visualCenterStatus <- renderRbokeh({
    figure(xlab = "Center Status", ylab = "# of Centers",legend_location=NULL, tools=NULL) %>% 
      ly_bar(x=as.factor(centre.Status),data = centersSelected(),alpha = 0.5,hover=FALSE,width = 0.9)
  });
  
  output$visualCenterType <- renderRbokeh({
    figure(xlab = "Center Type", ylab = "# of Centers",legend_location=NULL, tools=NULL) %>% 
      ly_bar(x=as.factor(CentreType),data = centersSelected(),alpha = 0.5,hover=FALSE,width = 0.9)
  });
  
  output$visualChosenCentreStates <- renderValueBox({
    valueBox(
      "Centres in States",
      color="teal",
      value = nrow(centersSelected()),
      icon = icon("center","fa-building")
    )
  });
  
  output$visualTop3Centres <- renderTable({
    centersSelected() %>% arrange(desc(AvereageCTC)) %>% 
      head(3) %>% ungroup() %>% select(CentreID,CTC=AvereageCTC) %>%
      mutate(CentreID=as.factor(CentreID),CTC=round(CTC,2))
    },spacing =c("xs"),align = 'c'
  )
  
 
  
  ### ---------------------                 Candidate        
  #################################################################################
  
  
  output$visualizeCandidateStateInputSelect <- renderUI({
    pickerInput("visualCandidateStateSelect", "STATES ",
                choices = uniqueCandidateStates(),
                options = list(`actions-box` = TRUE), multiple = TRUE
    )
  });
  
  output$visualChosenCandidateStates <- renderValueBox({
    valueBox(
      "Candidates in States",
      color="aqua",
      value = nrow(candidateSelected()),
      icon = icon("user","fa-user-alt")
    )
  })
  output$visualCandidateGrade <- renderRbokeh({
    data <- candidateSelected()%>%group_by(Grade,PlacementStatus)%>%filter(!is.na(Grade)&!is.na(PlacementStatus))%>%count()
    figure(xlab = "Grades", ylab = "# of Candidates",legend_location="bottom", tools=NULL) %>%
      ly_bar(x=as.factor(Grade),y=n,data=data,color=as.factor(PlacementStatus),alpha = 0.5,hover=FALSE, width = 0.9,position = "dodge")
  })
  output$visualCanddidateEducationLevel <- renderRbokeh({
    data <- candidateSelected()%>%group_by(EducationLevel,PlacementStatus)%>%filter(!is.na(EducationLevel)&!is.na(PlacementStatus))%>%count()
    figure(xlab = "Education Level", ylab = "# of Candidates",legend_location="bottom", tools=NULL) %>% 
      ly_bar(x=as.factor(EducationLevel),y=n,data=data,color=as.factor(PlacementStatus),alpha = 0.5,hover=FALSE, width = 0.9,position = "dodge")
  })
  
 
  output$visualCanddidateEmployment <- renderRbokeh({
    data <- candidateSelected()%>%group_by(`Employment.Type`,PlacementStatus)%>%filter(!is.na(`Employment.Type`)&!is.na(PlacementStatus))%>%count()
    figure(xlab = "Employment Type", ylab = "# of Candidates",legend_location=NULL, tools=NULL) %>%
      ly_bar(x=as.factor(`Employment.Type`),y=n,data = data,color=as.factor(PlacementStatus),alpha = 0.5,hover=FALSE, width = 0.9,position = "dodge")
  })
  
  output$visualCanddidateCTC <- renderRbokeh({
    data <- candidateSelected()%>%filter(!is.na(MonthlyEarningOrCTCbeforeTraining))
    figure(xlab = "CTC", ylab = "# of Candidates",legend_location=NULL, tools=NULL) %>%
      ly_hist(MonthlyEarningOrCTCbeforeTraining,data = data,alpha = 0.5, breaks = 20,freq = FALSE)  %>%
      ly_density(MonthlyEarningOrCTCbeforeTraining,data=data) 
  })

  output$visualCandidateAge <- renderRbokeh({
    data <- candidateSelected()%>%filter(!is.na(Age))
    figure(xlab = "Age", ylab = "# of Candidates",legend_location=NULL, tools=NULL) %>%
      ly_hist(Age,data=data,alpha = 0.5, breaks = 20,freq = FALSE)  %>%
      ly_density(Age,data=data) 
  })
  
  output$visualTop3Packages <- renderTable({
    candidateSelected() %>% arrange(desc(MonthlyCurrentCTCOrearning)) %>% 
      head(3) %>% ungroup() %>% select(NewID,CTC=MonthlyCurrentCTCOrearning) %>%
      mutate(NewID=as.factor(NewID),CTC=round(CTC,2))
  },spacing =c("xs"),align = 'c'
  )
  
  ### ---------------------                 Courses        
  #################################################################################
  
  
  output$visualizeCoursesSkillInputSelect <- renderUI({
    pickerInput("visualCourseSkillSelect", "SKILLS ",
                choices = uniqueCourseSkills(),
                options = list(`actions-box` = TRUE), multiple = TRUE
    )
  });
  
  output$visualCoursesDuration <- renderRbokeh({
    data <- coursesSelected()%>%filter(!is.na(AverageDuration))
    figure(xlab = "Course Duration", ylab = "# of Courses",legend_location=NULL, tools=NULL) %>% 
      ly_hist(AverageDuration,data=data,alpha = 0.5, breaks = 20,freq = FALSE)  %>%
      ly_density(AverageDuration,data=data) 
  });
  
  output$visualCoursePreTraining <- renderRbokeh({
    figure(xlab = "Pre Training Status", ylab = "# of Courses",legend_location=NULL, tools=NULL) %>% 
      ly_bar(x=as.factor(PreTrainingStatus),data = coursesSelected(),alpha = 0.5,hover=FALSE,width = 0.9)
  });
  
  output$visualCourseTechEdu <- renderRbokeh({
    figure(xlab = "Tech Edu", ylab = "# of Courses",legend_location=NULL, tools=NULL) %>% 
      ly_bar(x=as.factor(TechnicalEducation),data = coursesSelected(),alpha = 0.5,hover=FALSE,width = 0.9)
  });
  
  output$visualChosenCentreCourseSkills <- renderValueBox({
    valueBox(
      "Courses in Skills",
      color="yellow",
      icon = icon("course","fa-book"),
      value = nrow(coursesSelected())
    )
  });
  
  output$visualTop3Courses <- renderTable({
    coursesSelected() %>% arrange(desc(AvereageCTC)) %>% 
      head(3) %>% ungroup() %>% select(CourseID=Course.MAster.ID,CTC=AvereageCTC) %>%
      mutate(CourseID=as.factor(CourseID),CTC=round(CTC,2))
  },spacing =c("xs"),align = 'c'
  )
}
