###########################################################################
# ID: 11910062 Rajasekhar Matam                                           #
# ID: 11910073 Piyush Kumar Jain                                          #
# ID: 11910086 Pavan Kumar Battula                                        #
###########################################################################


#---------------------------------------------------------------------#
#        Building a Shiny App around the UDPipe NLP workflow          #
#---------------------------------------------------------------------#

library("shiny")

# Define ui function
ui <- shinyUI(
  fluidPage(
    
    titlePanel("Building a Shiny App around the UDPipe NLP workflow"),
    
    sidebarLayout( 
      
      sidebarPanel(  
        
        fileInput("file", "Upload data (txt file)"),
        
        
        checkboxGroupInput(inputId = 'upos',
                      label = h3('Select Universal Part of speech for Co-occurrances filtering'),
                      choices =list("adjective"= "ADJ",
                                    "Noun" = "NOUN",
                                    "proper noun" = "PROPN",
                                    "adverb"="ADV","verb"= "VERB"),
                      selected = c("ADJ","NOUN","PROPN"))
        
      ),
      
      mainPanel(
        
        tabsetPanel(type = "tabs",
                    
                    tabPanel("Overview",
                             h4(p("Data input")),
                             p("This app supports only text documents (.txt) data file. ",align="justify"),
                             p("Please refer to the link below for sample csv file."),
                             a(href="https://github.com/rmatam/TextAnalytics_Assignment/blob/master/amazon%20nokia%20lumia%20reviews.txt"
                               ,"Sample data input file"),   
                             br(),
                             h4('How to use this App'),
                             p('To use this app, click on', 
                               span(strong("Upload data (Text File)")),
                               'and uppload the  data file. ')),
                    tabPanel("Table of annotated documents", 
                             dataTableOutput('datatableOutput'),
                             downloadButton("downloadData", "Download Annotated Data")),
                    
                    tabPanel("Word Clouds",
                             h3("Nouns"),
                             plotOutput('wcplot1'),
                             h3("Verbs"),
                             plotOutput('wcplot2')),
                    
                    tabPanel("Co-Occurrences",
                             h3("Co-occurrences"),
                             plotOutput('coocplot3'))
                    
        ) # end of tabsetPanel
      )# end of main panel
    ) # end of sidebarLayout
  )  # end if fluidPage
) # end of UI
