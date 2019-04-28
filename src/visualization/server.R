
visualServer <- function(input, output,read_data){
 
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
      select(CentreType,centre.Status,CentreID,MonthlyCurrentCTCOrearning,PlacementStatus,DateOfBirth) %>%
      mutate(Age=time_length(difftime(Sys.Date(),mdy(substring(DateOfBirth,0,11))),"years")) %>%
      group_by(CentreType,centre.Status,CentreID)%>%
      summarize(AvereageCTC=mean(MonthlyCurrentCTCOrearning),AverageAge=mean(Age),Placement=(sum(PlacementStatus==2)/sum(!is.na(CentreID))))
  });
  
  candidateSelected <- reactive({
      read_data() %>% filter(CandidateState %in% input$visualCandidateStateSelect) %>% 
      select(NewID,Grade,DateOfBirth,EducationLevel,`Employment.Type`,PlacementStatus,FundingPartner,VM1,VM2,TechnicalEducation,MonthlyEarningOrCTCbeforeTraining,
             MonthlyCurrentCTCOrearning,PreTrainingStatus)%>%
      mutate(Age=time_length(difftime(Sys.Date(),mdy(substring(DateOfBirth,0,11))),"years"))
     
  });
  
  coursesSelected <- reactive({
    read_data() %>% filter(Skilling.Category %in% input$visualCourseSkillSelect) %>% 
      select(Course.MAster.ID,`Course Fee`,DateOfBirth,PlacementStatus,MonthlyCurrentCTCOrearning,BatchEndDate,BatchStartDate)%>%
      mutate(Age=time_length(difftime(Sys.Date(),mdy(substring(DateOfBirth,0,11))),"years")) %>%
      mutate(Duration=time_length(difftime(mdy(substring(BatchEndDate,0,11)),mdy(substring(BatchStartDate,0,11))),"days"))%>%
      group_by(Course.MAster.ID)%>%
      summarize(AvereageCTC=mean(MonthlyCurrentCTCOrearning),AverageFee=mean(`Course Fee`),
                AverageDuration=mean(Duration),AverageAge=mean(Age),
                Placement=(sum(PlacementStatus==2)/sum(!is.na(Course.MAster.ID))))
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
  
  output$visualCenterStatus <- renderRbokeh({
    figure(xlab = "Center Status", ylab = "# of Centers",legend_location=NULL, tools=NULL) %>% 
      ly_bar(x=as.factor(centre.Status),data = centersSelected(),alpha = 0.5,hover=FALSE,width = 0.9)
  });
  
  output$visualCenterType <- renderRbokeh({
    figure(xlab = "Center Type", ylab = "# of Centers",legend_location=NULL, tools=NULL) %>% 
      ly_bar(x=as.factor(CentreType),data = centersSelected(),alpha = 0.5,hover=FALSE,width = 0.9)
  });
  
  output$visualCenterAge <- renderRbokeh({
    data <- centersSelected()%>%filter(!is.na(AverageAge))
    figure(xlab = "Age", ylab = "# of Centers",legend_location=NULL, tools=NULL) %>%
      ly_hist(AverageAge,data=data,alpha = 0.5, breaks = 20,freq = TRUE)  
  })
  
  output$visualCenterPlacement <- renderRbokeh({
    data <- centersSelected()%>%filter(!is.na(Placement)) #%>% arrange(desc(Placement)) %>% head(7)
    # ggplot(data, aes(x=as.factor(CentreID), y=Placement, label=Placement)) + 
    # geom_point(stat='identity', fill="black", size=10)  + xlab("Centres") + ylab("Placements") +
    # geom_segment(aes(y = 0,  x = as.factor(CentreID), yend = Placement, xend = as.factor(CentreID)), alpha=0.2,color="black") +
    # geom_text(color="white", size=4)  + coord_flip()  + 
    # theme(legend.position="none",axis.text.x=element_blank(),axis.ticks.x=element_blank(),axis.title.x=element_blank(),
    #         panel.grid.major = element_blank(),panel.grid.minor = element_blank())
    figure(xlab = "Placement Ratio", ylab = "# of Centers",legend_location=NULL, tools=NULL) %>%
    ly_hist(Placement,data=data,alpha = 0.5, breaks = 20,freq = TRUE)
      #%>% ly_density(Placement,data=data) 
  })
  
 
  output$visualCenterPackage <- renderRbokeh({
    data <- centersSelected()%>%filter(!is.na(AvereageCTC))
    figure(xlab = "Package", ylab = "# of Centers",legend_location=NULL, tools=NULL) %>%
      ly_hist(AvereageCTC,data=data,alpha = 0.5, breaks = 20,freq = TRUE)  
      #%>% ly_density(AvereageCTC,data=data) 
  })
  
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
      "Students in States",
      color="aqua",
      value = nrow(candidateSelected()),
      icon = icon("user","fa-user-alt")
    )
  })
  
  output$visualCandidateGrade <- renderRbokeh({
    data <- candidateSelected()%>%group_by(Grade,PlacementStatus)%>%filter(!is.na(Grade)&!is.na(PlacementStatus))%>%count()
    figure(xlab = "Grades", ylab = "# of Candidates", legend_location=NULL,tools=NULL) %>%
      ly_bar(x=as.factor(Grade),y=n,data=data,color=as.factor(PlacementStatus),alpha = 0.5,hover=FALSE, width = 0.9,position = "dodge")
  })
  
  output$visualCandidateFundingPartner <- renderRbokeh({
    data <- candidateSelected()%>%group_by(FundingPartner,PlacementStatus)%>%filter(!is.na(FundingPartner)&!is.na(PlacementStatus))%>%count()
    figure(xlab = "Funding Partner", ylab = "# of Candidates",legend_location=NULL, tools=NULL) %>%
      ly_bar(x=as.factor(FundingPartner),y=n,data=data,color=as.factor(PlacementStatus),alpha = 0.5,hover=FALSE, width = 0.9,position = "dodge")
  })
  
  output$visualCandidateVM1 <- renderRbokeh({
    data <- candidateSelected()%>%group_by(VM1,PlacementStatus)%>%filter(!is.na(VM1)&!is.na(PlacementStatus))%>%count()
    figure(xlab = "VM1", ylab = "# of Candidates", legend_location=NULL,tools=NULL) %>%
      ly_bar(x=as.factor(VM1),y=n,data=data,color=as.factor(PlacementStatus),alpha = 0.5,hover=FALSE, width = 0.9,position = "dodge")
  })
  
  output$visualCandidateVM2 <- renderRbokeh({
    data <- candidateSelected()%>%group_by(VM2,PlacementStatus)%>%filter(!is.na(VM2)&!is.na(PlacementStatus))%>%count()
    figure(xlab = "VM2", ylab = "# of Candidates", legend_location=NULL,tools=NULL) %>%
      ly_bar(x=as.factor(VM2),y=n,data=data,color=as.factor(PlacementStatus),alpha = 0.5,hover=FALSE, width = 0.9,position = "dodge")
  })
  
  output$visualCandidateTechEdu <- renderRbokeh({
    data <- candidateSelected()%>%group_by(TechnicalEducation,PlacementStatus)%>%filter(!is.na(TechnicalEducation)&!is.na(PlacementStatus))%>%count()
    figure(xlab = "Technical Education ", ylab = "# of Candidates", legend_location=NULL, tools=NULL) %>%
      ly_bar(x=as.factor(TechnicalEducation),y=n,data=data,color=as.factor(PlacementStatus),alpha = 0.5,hover=FALSE, width = 0.9,position = "dodge")
  })
  
  output$visualCandidateEducationLevel <- renderRbokeh({
    data <- candidateSelected()%>%group_by(EducationLevel,PlacementStatus)%>%filter(!is.na(EducationLevel)&!is.na(PlacementStatus))%>%count()
    figure(xlab = "Education Level", ylab = "# of Candidates", legend_location=NULL,tools=NULL) %>% 
      ly_bar(x=as.factor(EducationLevel),y=n,data=data,color=as.factor(PlacementStatus),alpha = 0.5,hover=FALSE, width = 0.9,position = "dodge")
  })
  
 
  output$visualCandidateEmployment <- renderRbokeh({
    data <- candidateSelected()%>%group_by(`Employment.Type`,PlacementStatus)%>%filter(!is.na(`Employment.Type`)&!is.na(PlacementStatus))%>%count()
    figure(xlab = "Employment Type", ylab = "# of Candidates",legend_location=NULL, tools=NULL) %>%
      ly_bar(x=as.factor(`Employment.Type`),y=n,data = data,color=as.factor(PlacementStatus),alpha = 0.5,hover=FALSE, width = 0.9,position = "dodge")
  })
  
  # output$visualCanddidateCTC <- renderRbokeh({
  #   data <- candidateSelected()%>%filter(!is.na(MonthlyEarningOrCTCbeforeTraining))
  #   figure(xlab = "CTC", ylab = "# of Candidates",legend_location=NULL, tools=NULL) %>%
  #     ly_hist(MonthlyEarningOrCTCbeforeTraining,data = data,alpha = 0.5, breaks = 20,freq = TRUE)  %>%
  #     ly_density(MonthlyEarningOrCTCbeforeTraining,data=data) 
  # })

  output$visualCandidateAge <- renderRbokeh({
    data <- candidateSelected()%>%filter(!is.na(Age))
    figure(xlab = "Age", ylab = "# of Candidates",legend_location=NULL, tools=NULL) %>%
      ly_hist(Age,data=data,alpha = 0.5, breaks = 20,freq = TRUE)  
      #%>% ly_density(Age,data=data) 
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
      ly_hist(AverageDuration,data=data,alpha = 0.5, breaks = 20,freq = TRUE)  
      #%>% ly_density(AverageDuration,data=data) 
  });
  
  output$visualCoursesFee <- renderRbokeh({
    data <- coursesSelected()%>%filter(!is.na(AverageFee))
    figure(xlab = "Course Fee", ylab = "# of Courses",legend_location=NULL, tools=NULL) %>% 
      ly_hist(AverageFee,data=data,alpha = 0.5, breaks = 20,freq = TRUE)  
    #%>% ly_density(AverageDuration,data=data) 
  });
  
  
  output$visualCourseAge <- renderRbokeh({
    data <- coursesSelected()%>%filter(!is.na(AverageAge))
    figure(xlab = "Age", ylab = "# of Courses",legend_location=NULL, tools=NULL) %>%
      ly_hist(AverageAge,data=data,alpha = 0.5, breaks = 20,freq = TRUE)  
  })
  
  output$visualCoursePlacement <- renderRbokeh({
    data <- coursesSelected()%>%filter(!is.na(Placement)) #%>% arrange(desc(Placement)) %>% head(7)
    figure(xlab = "Placement Ratio", ylab = "# of Courses",legend_location=NULL, tools=NULL) %>%
      ly_hist(Placement,data=data,alpha = 0.5, breaks = 20,freq = TRUE)
    #%>% ly_density(Placement,data=data) 
  })
  
  
  output$visualCoursePackage <- renderRbokeh({
    data <- coursesSelected()%>%filter(!is.na(AvereageCTC))
    figure(xlab = "Package", ylab = "# of Courses",legend_location=NULL, tools=NULL) %>%
      ly_hist(AvereageCTC,data=data,alpha = 0.5, breaks = 20,freq = TRUE)  
    #%>% ly_density(AvereageCTC,data=data) 
  })
  
  
  
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
