overviewUI  <-  tabPanel("Overview",
                         
                         
                         # Main panel for displaying outputs ----
                         mainPanel(
                           
                           # Output: Tabset w/ plot, summary, and table ----
                           tabsetPanel(type = "tabs",
                                       tabPanel("About NSDC", 
                                                tags$head(tags$script(src="ExpContr.js")),
                                                tags$button("About US" ,class="collapsible"),
                                                withTags({
                                                  div(class="content", checked = NA,
                                                      p("National Skill Development Corporation (NSDC) is a not-for-profit public limited company incorporated on July 31, 2008 under section 25 of the Companies Act, 1956 (corresponding to section 8 of the Companies Act, 2013). NSDC was set up by Ministry of Finance as Public Private Partnership (PPP) model. The Government of India through Ministry of Skill Development & Entrepreneurship (MSDE) holds 49% of the share capital of NSDC, while the private sector has the balance 51% of the share capital."),
                                                      p("NSDC aims to promote skill development by catalyzing creation of large, quality and for-profit vocational institutions. Further, the organisation provides funding to build scalable and profitable vocational training initiatives. Its mandate is also to enable support system which focuses on quality assurance, information systems and train the trainer academies either directly or through partnerships. NSDC acts as a catalyst in skill development by providing funding to enterprises, companies and organizations that provide skill training. It also develops appropriate models to enhance, support and coordinate private sector initiatives. The differentiated focus on 21 sectors under NSDC's purview and its understanding of their viability will make every sector attractive to private investment."),
                                                      img(src = "NSDCImg.PNG")
                                                  )
                                                }),
                                                tags$button("Vision", class = "collapsible"),
                                                withTags({
                                                  div(class="content", checked = NA,
                                                      p("NSDC was set up as part of a national skill development mission to fulfil the growing need in India for skilled manpower across sectors and narrow the existing gap between the demand and supply of skills. The then Union Finance Minister Shri P. Chidambaram announced the formation of the NSDC in his 2008-09 Budget Speech. There is a compelling need to launch a world-class skill development programme in a mission mode that will address the challenge of imparting the skills required by a growing economy. Both the structure and the leadership of the mission must be such that the programme can be scaled up quickly to cover the whole country. ")
                                                  )
                                                }),
                                                tags$button("Mission", class="collapsible"), 
                                                withTags({
                                                  div(class="content", checked = NA,
                                                      p(
                                                        ul(
                                                          li("Upgrade skills to international standards through significant industry involvement and develop necessary frameworks for standards, curriculum and quality assurance."),
                                                          li("Enhance, support and coordinate private sector initiatives for skill development through appropriate Public-Private Partnership ( PPP ) models; strive for significant operational and financial involvement from private sector."),
                                                          li("Play the role of a ‘market-maker’ by bringing funds, particularly in sectors where market mechanisms are ineffective or missing."),
                                                          li("Prioritise initiatives that can have a multiplier or catalytic effect as opposed to one-off impact.")
                                                        )
                                                      )
                                                  )
                                                }),
                                                tags$button("Objective", class="collapsible"), 
                                                div(class="content", checked = NA,
                                                    p("To contribute significantly to the overall target of skilling up of people in India, mainly by fostering private sector initiatives in skill development programmes and to provide funding."
                                                    )),
                                                withTags({
                                                  div(class="header", checked=NA,
                                                      a(href="https://www.nsdcindia.org", "NSDC Website" ),
                                                      a(href="https://twitter.com/nsdcindia", img(src="twit-icon.jpg")),
                                                      a(href="https://www.youtube.com/user/NSDCIndiaOfficial", img(src="you-tube-icon.jpg")),
                                                      a(href="https://www.facebook.com/NSDCIndiaOfficial", img(src="face-icon.jpg"))
                                                  )
                                                })
                                       ),
                                       tabPanel("Problem Statement",
                                                tags$button("R shiny dynamic Dashboard", class="collapsible"),
                                                withTags({
                                                  div(class="content", checked = NA,
                                                      p(
                                                        ul(
                                                          li("Dynamic Dashboard to be built for NSDC top management to give them quick look at Key factors for success of training efforts undertaken by NSDC."),
                                                          li("It will help them to take important decisions like which center/courses/packages are more helpful for higher placement success."),
                                                          li("It will give insight into important parameters for people enrolled and their performance so that courses/counselling can be designed accordingly.")
                                                        )
                                                      )
                                                  )
                                                }),
                                                tags$button("Employment Prediction", class="collapsible"),
                                                withTags({
                                                  div(class="content", checked = NA,
                                                      p(
                                                        
                                                        ul(
                                                          li("To predict employment of a person based on important factors like Age, Education level, state, Employment type, Centre enrolled to."),
                                                          li("This will help to ensure the person takes right course to ensure the maximum success chances for placement of the candidate.")
                                                        )
                                                      )
                                                  )
                                                })
                                       ),
                                       tabPanel("Solution", 
                                                tags$button("Data Preparation Tab", class="collapsible"), 
                                                withTags({
                                                  div(class="content", checked = NA,
                                                      p(
                                                        ul(
                                                          li("User can browse and select any XLS for data pre-processing."),
                                                          li("User can remove any unwanted columns to create relevant scope for data analysis."),
                                                          li("User can perform missing value analysis and data imputation."),
                                                          li("User can download the XLS file after pre-processing.")
                                                        )
                                                      )
                                                  )
                                                })
                                       )
                           )
                           
                         )
)


