library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(

  # Application title
  titlePanel("2014 Ironman Lake Placid Bike Times"),

  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      # Add lake placid image
      img(src = "LakePlacid.jpg", height = 144, width = 300),
      sliderInput("bins",
                  "Number of bins:",
                  min = 5,
                  max = 100,
                  value = 5),
      selectInput("var", 
                  label = "Choose a category to display",
                  choices = list("MPRO", "FPRO",
                                 "MALE", "FEMALE"),
                  selected = "MPRO"),
      sliderInput("range", 
                  label = "AGE",
                  min = 18, max = 80, value = c(18, 80))
      
      
      ),

    # Show a plot of the generated distribution
    mainPanel(
      # Add text
      p("This is a histogram of bike times from Ironman Lake Placid 2014", align = "center"),
     
      plotOutput("distPlot")
    )
  )
))
