library(shiny)
library(ggplot2)
library(dplyr)
ui <- fluidPage(
  
  titlePanel("USA Census Visualization", 
             windowTitle = "CensusVis"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Create demographic maps with information from the 2010 census"),
      
      selectInput(inputId = "var", 
                  label = "Choose a variable to display",
                  choices = list ("Percent White", 
                                  "Percent Black", 
                                  "Percent Latino", 
                                  "Percent Asian"), 
                  selected = "Percent White")
                  
    ), 
    mainPanel(
     # textOutput(outputId = "selected_var")
      plotOutput(outputId = "plot")
    )
  )
  
)

server <- function(input, output) {
  

  output$plot = renderPlot({
    counties <- reactive({
      race = readRDS("data/counties.rds")
      
      counties_map = map_data("county")
      
      ### In order to join both tables, we need to 
      ### make sure that we are combing them by both 
      ### state and county as a unique identifer.. so,
      ### we can combine region and subregion in the 
      ### counties_map into a new variable called "name"
      
      counties_map = counties_map %>%
        mutate(name = paste(region, subregion, sep = ","))
      
      left_join(counties_map, race, 
                by = "name")
    })
    
    
    race = switch(input$var, 
                  "Percent White" = counties()$white,
                  "Percent Black" = counties()$black, 
                  "Percent Latino" = counties()$hispanic,
                  "Percent Asian" = counties()$asian
    )
    
    
    ggplot(counties(), 
           aes(x = long, y = lat, 
               group = group, 
               fill = race)) + 
      geom_polygon(color = "black") +
      scale_fill_gradient(low = "white", high = "red")
    
  })
    
    
  
  
}

shinyApp(ui, server)