server <- function(input, output, session) {
  server<-Sys.getenv('SERVER')
  database<-Sys.getenv('DB')
  username<-Sys.getenv('DB_USERNAME')
  password<-Sys.getenv('DB_PW')
  
  output$env<-renderText({
    paste(server, database, username, password)
  })
}