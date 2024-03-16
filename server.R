library(lgr)

server <- function(input, output, session) {
  
  log<-tempfile(tmpdir=tempdir(), pattern = 'logtest', fileext = '.log')
  lgr$add_appender(AppenderFile$new(log), name = 'testlog')
  
  lgr$info('testing logging 1')
  server<-Sys.getenv('SERVER')
  lgr$info('testing logging 2')
  
  database<-Sys.getenv('DB')
  username<-Sys.getenv('DB_USERNAME')
  password<-Sys.getenv('DB_PW')
  
  output$env<-renderText({
    paste(server, database, username, password)
  })
}