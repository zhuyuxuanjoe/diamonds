library(shiny)
library(ggplot2)

# user interface

ui <- fluidPage(
  titlePanel(title = "Diamonds Data", windowTitle = "Diamonds Data"),
  sidebarLayout(
    sidebarPanel(
      helpText("This app is to visualize diamonds dataset"),
      textInput(inputId = "title", 
                label = "Chart title", 
                value = ""),
      selectInput(inputId = "pos",
                  label = "Position",
                  choices = list("stack","dodge"),
                  selected = "stack")
    ),
    mainPanel(
      plotOutput(outputId = "plot")
    )
  )
) # resize the window and content adapt to it

# server

server <- function(input, output){
  output$plot = renderPlot(
    ggplot(diamonds, aes(x = cut, fill = clarity)) +
      geom_bar(position = input$pos) +
      ggtitle(input$title)
  )

}

# run the app

shinyApp(ui, server)