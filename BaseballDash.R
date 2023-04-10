library(ggplot2)
library(tidyverse)

files <- list.files(pattern = "*.csv")
games <- lapply(files, read.csv, header = TRUE) 

allGames <- bind_rows(games)


pitcher <- allGames$Pitcher


ui = fluidPage(
  titlePanel("UVA Baseball Dashboard 2023"),
  sidebarPanel(h6("Select pitcher below: "), 
               selectInput("pitcher", "Pitcher", choices = pitcher), 
               actionButton("game", "Generate Pitcher Data")),
  tabPanel("Page 1",
           "This is the content for page 1"),
  tabPanel("Page 2",
           "This is the content for page 2"),
  mainPanel(textOutput("text"))
)

ui <- navbarPage(
  "UVA Baseball Dashboard 2023",
  # Add pages
  tabPanel("Page 1",
           "This is the content for page 1"),
  tabPanel("Page 2",
           "This is the content for page 2")
)

ui <- fluidPage(
  titlePanel("UVA Baseball Dashboard 2023"),
  navbarPage(
    "Pages",
    # Page 1
    tabPanel("Page 1",
             fluidRow(
               column(6, h2("Welcome to Page 1!"))
             ),
             fluidRow(
               column(12, p("This is the content for Page 1."))
             ) 
    ),
    # Page 2
    tabPanel("Page 2",
             fluidRow(
               column(6, h2("Welcome to Page 2!"))
             ),
             fluidRow(
               column(12, p("This is the content for Page 2."))
             )
    ),
    # Page 3
    tabPanel("Page 3",
             fluidRow(
               column(6, h2("Welcome to Page 3!")),
               column(6, img(src = "https://placekitten.com/300/300"))
             ),
             fluidRow(
               column(12, p("This is the content for Page 3."))
             )
    )
  )
)

server = function(input, output) {
  
  observeEvent(input$click, {
    output$text = renderPrint(
      allGames[,allGames$Pitcher == 'pitcher']
    )
  })
  
  observeEvent(input$game, {
    output$test = renderPrint(
      #allGames[,allGames$Pitcher == input$pitcher]
      input$pitcher
    )
  })
}

shinyApp(ui, server)
