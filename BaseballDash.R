library(ggplot2)
library(tidyverse)
library(shiny)
library(DT)

files <- list.files(pattern = "*.csv")
games <- lapply(files, read.csv, header = TRUE) 
allGames <- bind_rows(games)

virginia <-  allGames[allGames$PitcherTeam=='Virginia 2023',]
pitcher <- virginia$Pitcher
opponent <- virginia$BatterTeam
type <- virginia$TaggedPitchType

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
                          selectInput("pitcher", "Pitcher", choices = pitcher, selected = "Brian Edgington"),
                          selectInput("opponent", "Opponent", choices = opponent, selected = "Navy"),
                          selectInput("type", "Pitch Type", choices = type, selected = "Fastball")),
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
  
  
  output$mytable <- DT::renderDataTable({
    DT::datatable(allGames[allGames$PitcherTeam=='Virginia 2023' & 
                             allGames$Pitcher==input$pitcher & allGames$BatterTeam == input$opponent, 1:15])
  })
  
  output$myoutput <- renderPrint({
    input$pitcher
  })
  
  output$plot1 <- renderPlot({
    data_subset = allGames[allGames$PitcherTeam=='Virginia 2023' & 
                             allGames$Pitcher==input$pitcher & allGames$BatterTeam == input$opponent &
                             allGames$TaggedPitchType==input$type, ]
    
    ggplot(data_subset, aes(x=PitchNo, y=RelSpeed )) + geom_point(size = 3)
  })
  
  output$plot2 <- renderPlot({
    data_subset = allGames[allGames$PitcherTeam=='Virginia 2023' & 
                             allGames$Pitcher==input$pitcher & allGames$BatterTeam == input$opponent, ]
    ggplot(data_subset, aes(x=x0, y=z0, color = TaggedPitchType, )) + geom_point()
  })
}

shinyApp(ui, server)
