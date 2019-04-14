testUI  <- tabPanel("Testing", sidebarPanel(
  sliderInput("Slider", "Slider input:", 1, 100, 30)
), mainPanel(
  tabsetPanel(
    tabPanel("Tab 1","This panel is intentionally left blank"),
    tabPanel("Tab 2", "This panel is intentionally left blank"),
    tabPanel("Tab 3", "This panel is intentionally left blank")
  )
))
