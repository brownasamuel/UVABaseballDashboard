library(ggplot2)
library(tidyverse)
library(shiny)
library(DT)

files <- list.files(pattern = "*.csv")
games <- lapply(files, read.csv, header = TRUE) 
allGames <- bind_rows(games)


#pitcher <- allGames[allGames$PitcherTeam=='Virginia 2023',]$Pitcher
pitcher <- allGames$Pitcher

ui <- fluidPage(
  titlePanel("UVA Baseball Pitching Dashboard"),
  tags$head(
    tags$style(
      HTML(
        "
        
        /* Change the background color of the navbar */
        .navbar {
          background-color: #E57200;
        }
        
        /* Change the color of the text in the navbar */
        .navbar-default .navbar-nav > li > a {
          color: white;
        }
        
        /* Change the color of the active tab */
        .navbar-default .navbar-nav > .active > a,
        .navbar-default .navbar-nav > .active > a:focus,
        .navbar-default .navbar-nav > .active > a:hover {
          background-color: #232D4B;
          color: white;
        }
        "
      )
    )
  ),
  navbarPage(
    title = " ",
    # Page 1
    tabPanel(title = "Summaries",
             mainPanel(h6("Select pitcher below: "), 
                          selectInput("pitcher", "Pitcher", choices = pitcher, selected = "Brian Edgington")),
             fluidRow(
               verbatimTextOutput("myoutput")
             ),
             fluidRow(
               column(12, p("This is the content for Page 1."))
             ), 
             splitLayout(
               plotOutput("plot1"), 
               plotOutput("plot2")
             )
    ),
    # Page 2
    tabPanel("Full Season",
             mainPanel(
               DT::dataTableOutput("mytable")
             )
    ),
    # Page 3
    tabPanel("Other Data",
             fluidRow(
               column(6, h2("Welcome to Page 3!"))
             ),
             fluidRow(
               column(12, p("This is the content for Page 3."))
             )
    )
  )
)

server = function(input, output) {
  
  files <- list.files(pattern = "*.csv")
  games <- lapply(files, read.csv, header = TRUE) 
  allGames <- bind_rows(games)
  
  mydata <- read.csv("/Users/tylergorecki/Desktop/SASL/Borderline Pitches Project/NYY_data.csv")
  
  output$mytable <- DT::renderDataTable({
    DT::datatable(allGames[allGames$PitcherTeam=='Virginia 2023', ])
  })
  
  output$myoutput <- renderPrint({
    input$pitcher
  })
  
  output$plot1 <- renderPlot({
    plot(1,2)
  })
  
  output$plot2 <- renderPlot({
    plot(2,1)
  })
}

shinyApp(ui, server)
