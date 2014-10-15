##ui.R
library(shiny)

shinyUI(fluidPage(
  titlePanel("Metabolic Syndrome"),
  
  sidebarLayout(
     sidebarPanel(
        radioButtons("year", label= h3("Choose a BRFSS Year:"), 
                         choices= list("BRFSS 2011" = 2011, "BRFSS 2013" = 2013), 
                         selected=2011, inline=TRUE), 
        
      helpText("Visualize metabolic syndrome by:"),
                
      checkboxGroupInput("sex", 
                  label = "Choose Gender",
                  choices = c("Male", "Female"),
                  selected = c("Male", "Female")),
      
      checkboxGroupInput("agegroup",
                  label = "Choose Age Group(s)",
                  choices = c("18-24", "25-34", "35-44", "45-54", "55-64", ">65"),
                  selected = c("18-24", "25-34", "35-44", "45-54", "55-64", ">65")),
      
      checkboxGroupInput("race",
                  label = "Choose Racial/Ethnic Group(s)",
                  choices = c("NH White", "NH Black", "NH Asian", "NH Native American/Alaskan Native"="NH NA/AN", "Hispanic", "Other"),
                  selected = c("NH White", "NH Black", "NH Asian", "NH NA/AN", "Hispanic", "Other")), 
      submitButton(text="Submit", icon("share"))        ),
     
    mainPanel(
             htmlOutput(outputId="geomap")
             )
              )
))

