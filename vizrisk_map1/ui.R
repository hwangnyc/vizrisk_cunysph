# ui.R

shinyUI(fluidPage(
  titlePanel("Metabolic Syndrome"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Visualize metabolic syndrome by:"),
      
      checkboxGroupInput("sex", 
                  label = "Choose which sex to display",
                  choices = c("Male", "Female"),
                  selected = c("Male", "Female")),
      
      checkboxGroupInput("agegroup",
                  label = "Choose which age categories to display",
                  choices = c("18-24", "25-34", "35-44", "45-54", "55-64", ">65"),
                  selected = c("18-24", "25-34", "35-44", "45-54", "55-64", ">65")),
      
      checkboxGroupInput("race",
                  label = "Choose which races to display",
                  choices = c("NH White", "NH Black", "NH Asian", "NH NA/AN", "Hispanic", "Other"),
                  selected = c("NH White", "NH Black", "NH Asian", "NH NA/AN", "Hispanic", "Other")),
      
      sliderInput("range", 
                  label = "Range of interest:",
                  min = 0, max = 100, value = c(0, 32))
                  
    ),
    
    
    mainPanel(
      plotOutput("map")#,
      #tableOutput("table")
    )
  )
))
