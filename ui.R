require(markdown)
library(litedown)
require(mice)
require(tidyverse)


navbarPage("Clinical Trials IV: Assignment 1",
           tabPanel("Instructions",
                    includeMarkdown('assignment1_instructions.md')
           ),
           tabPanel("Part 1",
                    sidebarLayout(
                      sidebarPanel(
                        numericInput("n_per_arm", "Number of particpants per arm", 1, min=1, max = NA, step=1),
                        radioButtons("disp_p1", "Display",
                                     choices = c(Head = "head",
                                                 All = "all"),
                                     selected = "head"),
                        downloadButton('download',"Download the data")
                        
                        
                      ),
                      mainPanel(
                        includeMarkdown('assignment1_part1a.md'),
                        fluidRow(column(7,tableOutput('dto'))),
                        includeMarkdown('assignment1_part1b.md')
                        
                      )
                    )
           ),
           tabPanel("Part 2",
                    sidebarLayout(
                      sidebarPanel(
                        ## Uploading and displaying the data
                        fileInput("file1", "Upload your participant data with allocations",
                                  multiple = TRUE,
                                  accept = c("text/csv",
                                             "text/comma-separated-values,text/plain",
                                             ".csv")),
                        radioButtons("sep", "Separator",
                                     choices = c(Comma = ",",
                                                 Semicolon = ";",
                                                 Tab = "\t"),
                                     selected = ","),
                        radioButtons("disp", "Display",
                                     choices = c(Head = "head",
                                                 All = "all"),
                                     selected = "head"),
                        
                        # Running the trial - do something to the uploaded data and add column in?
                        # Do I need a separate 'run trial' button? I'm not sure I do
                        
                        downloadButton('download_results',"Download trial results")
                        
                      ),
                      mainPanel(
                        includeMarkdown('assignment1_part2a.md'),
                        fluidRow(column(7,tableOutput('contents'))),
                        includeMarkdown('assignment1_part2b.md'),
                        fluidRow(column(7,tableOutput('results')))
                        
                      )
                    )
           )
)
