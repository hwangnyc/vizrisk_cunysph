##ui.R
library(shiny)

shinyUI(fluidPage(
  titlePanel("Metabolic Syndrome"),
  
  sidebarLayout(
     sidebarPanel(
        radioButtons("year", label= h3("Choose a BRFSS Year:"), 
                         choices= list("BRFSS 2011" = 2011, "BRFSS 2013" = 2013), 
                         selected=2011), 
        
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
      submitButton(text="Submit")),
     
    mainPanel(
             htmlOutput("geomap")
             )
              )
))

