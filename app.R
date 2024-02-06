library(shiny)

source('server.R')
source('ui.R')

shinyApp(ui = ui, server = server, options = list(launch.browser = TRUE))
