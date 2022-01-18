
# Importing and preparation of data
    # collision_LA.csv file is prepared from master csv file for 2018 collision incidents. 
    # Only four columns (Area_Name, HR[time of day in hour], longitude, and latitude) are considered for this assignment based on the questions asked.
    # data are processed in csv file, rows with NA value were deleted.

# Install Packages if not present
if(!require("shiny")) install.packages("shiny")
if(!require("tidyverse")) install.packages("tidyverse")
if(!require("ggplot2")) install.packages("ggplot2")
if(!require("dplyr")) install.packages("dplyr")
if(!require("SnowballC")) install.packages("SnowballC")
if(!require("leaflet")) install.packages("leaflet")

collision <- read.csv("collision_LA.csv")

collision$lon <- as.numeric(collision$lon)
collision$lat <- as.numeric(collision$lat)
collision$HR <- as.numeric(collision$HR)

sum(is.na(collision$HR))
sum(is.na(collision$lon))
sum(is.na(collision$lat))

# Importing libraries useful for the assignment
library(shiny)
library(leaflet)
library(tidyverse)
library(ggplot2)
library(SnowballC)

# codes for shiny app

ui <- fluidPage(skin="black",
  titlePanel(title = "2018 Traffic Collision Incidents in Los Angeles "),
  sidebarLayout(
    sidebarPanel("Bharat Banjade"),
    
    mainPanel(
      tabsetPanel(type = "tabs",
                  tabPanel("bar", icon = icon("hourglass"), plotOutput("bar")),
                  tabPanel("map", icon = icon("map-pin"), leafletOutput("map")),
                  tabPanel("heatmap", icon = icon("fire-extinguisher"), plotOutput("heatmap")))
                  )
  )
)
     
server <- function(input, output){
  output$bar <- renderPlot({
    ggplot(collision, aes(x=factor(collision$HR))) + geom_bar() + xlab("Time of day in Hour") + ylab("Frequency of collision")
    
  })
  output$map <- renderLeaflet({
    leaflet(collision) %>% addTiles() %>%
      setView(-118.3004, 34.0777, zoom = 8) %>%
      addCircles(~lon, ~lat, popup = "accidents", weight = 3, radius = 40,
                 color = "#ffa500", stroke = TRUE, fillOpacity = 0.8)
  })
  
  output$heatmap <- renderPlot({
    AreaHourCount <- as.data.frame(table(collision$Area_Name, collision$HR))
    #str(AreaHourCount)
    AreaHourCount$HR <- as.numeric(as.character(AreaHourCount$Var2))
    ggplot(AreaHourCount, aes(x = HR, y = Var1)) + geom_tile(aes(fill=Freq)) + 
      scale_fill_gradient(name = "Total collision", low = "light blue", high = "dark blue") + 
      theme(axis.title.y = element_blank()) + xlab("Time of Day in Hour")
  })
  
}

shinyApp(ui = ui, server = server)

# bar chart shows the 5 pm is time for the dominant number of accidents, followed by 3 pm, 4pm, and 6 pm.
# heat map shows willshire, 77th street, southwest, pacific, newton, and denonshire are more accident prone
  # than other area. 5 pm is the most accident prone time.
