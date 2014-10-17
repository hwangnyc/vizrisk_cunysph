##ui.R
library(shiny)

shinyUI(fluidPage(
  titlePanel("Metabolic Syndrome: Where does your state stand?"),
  helpText("Metabolic syndrome refers to a group of risk factors that
              can increase a person's risk for heart disease and diabetes,
              among other health problems.", br(), 
            "This interactive tool helps you visualize the distribution
               of metabolic syndrome risk factors across the U.S. population."),
  
  sidebarLayout(
    sidebarPanel(
      helpText(h4("Select the data of interest to you:")),
      radioButtons("year", label= "Choose a BRFSS Year:", 
                   choices= list("BRFSS 2011" = 2011, "BRFSS 2013" = 2013), 
                   inline=TRUE), 
      
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
      htmlOutput(outputId="geomap"),
      br(),
      helpText("It is known that metabolic syndrome can be associated with certain dietary and lifestyle choices. 
               The below scatterplots illustrate the relationship between prevalence of metabolic syndrome and availability
                of farmers' markets and fast food, respectively, by state."),
      div(style="display:inline-block", htmlOutput("scatter_fm")),
      div(style="display:inline-block", htmlOutput("scatter_ff"))
    )
  )
))
