library(shiny)

source('server.R')
source('ui.R')

shinyApp(ui = ui, server = server)
