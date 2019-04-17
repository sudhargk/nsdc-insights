
visualServer <- function(input, output,read_data){
 
  uniqueCentreStates <- reactive({
    unique(read_data()["CentreState"])
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
    read_data() %>% filter(CentreState  %in%  input$visualCenterStateSelect) %>% select(CentreType,centre.Status,CentreID,FundingPartner) %>% unique()
  });
  
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
  
  output$visualizeCenterStateInputSelect <- renderUI({
    pickerInput("visualCenterStateSelect", "Chose States ",
                choices = uniqueCentreStates(),
                options = list(`actions-box` = TRUE), multiple = TRUE
    )
  });
  
  output$visualCenterFundingPartners <- renderRbokeh({
    figure(xlab = "Funding Partner", ylab = "# of Centers",legend_location=NULL, tools=NULL) %>% ly_bar(x=as.factor(FundingPartner),
                        data = centersSelected(),alpha = 0.5,hover=FALSE)
  });
  
  output$visualCenterStatus <- renderRbokeh({
    figure(xlab = "Center Status", ylab = "# of Centers",legend_location=NULL, tools=NULL) %>% ly_bar(x=as.factor(centre.Status),
                                                                                                        data = centersSelected(),alpha = 0.5,hover=FALSE)
  });
  
  output$visualCenterType <- renderRbokeh({
    figure(xlab = "Center Type", ylab = "# of Centers",legend_location=NULL, tools=NULL) %>% ly_bar(x=as.factor(CentreType),
                                                                                                        data = centersSelected(),alpha = 0.5,hover=FALSE)
  });
  
  output$visualChosenCentres <- renderValueBox({
    valueBox(
      "Centres in States",
      color="teal",
      value = nrow(centersSelected()),
      icon = icon("center","fa-building")
    )
  });
  
}
