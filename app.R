###########################################################################
# ID: 11910062 Rajasekhar Matam                                           #
# ID: 11910073 Piyush Kumar Jain                                          #
# ID: 11910086 Pavan Kumar Battula                                        #
###########################################################################


#---------------------------------------------------------------------#
#        Building a Shiny App around the UDPipe NLP workflow          #
#---------------------------------------------------------------------#

library("shiny")

#shinyApp(ui = ui, server = server)
source('https://raw.githubusercontent.com/rmatam/UDPipe-ShinyApp/master/dependency-UDPipe-shinyApp.R')
runGitHub('UDPipe-ShinyApp','rmatam')
