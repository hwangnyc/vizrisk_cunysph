##ui.R
library(shiny)

shinyUI(fluidPage(
        h2("Metabolic Syndrome: Where does your state stand?"),
  helpText("Metabolic syndrome refers to a group of risk factors that
              can increase a person's risk for heart disease and
           other health problems.", br(), 
           "This interactive tool helps you visualize the distribution
           of the prevalence proportion of metabolic syndrome across the U.S. population." ),
  
  sidebarLayout(
     sidebarPanel(
             helpText(h3("Data Selection")),
        radioButtons("year", label= h4("Choose a BRFSS Year:"), 
                         choices= list("BRFSS 2013" = 2013, "BRFSS 2011" = 2011), 
                         inline=TRUE), 
        
      helpText("Visualize metabolic syndrome by:"),
                
      checkboxGroupInput("sex", 
                  label = "Choose Gender:",
                  choices = c("Male", "Female"),
                  selected = c("Male", "Female")),
      
      checkboxGroupInput("agegroup",
                  label = "Choose Age Group(s):",
                  choices = c("18-24", "25-34", "35-44", "45-54", "55-64", ">65"),
                  selected = c("18-24", "25-34", "35-44", "45-54", "55-64", ">65")),
      
      checkboxGroupInput("race",
                  label = "Choose Racial/Ethnic Group(s):",
                  choices = c("NH White", "NH Black", "NH Asian", "NH Native American/Alaskan Native"="NH NA/AN", "Hispanic", "Other"),
                  selected = c("NH White", "NH Black", "NH Asian", "NH NA/AN", "Hispanic", "Other")) ),
     
    mainPanel(
             htmlOutput(outputId="geomap"),
             helpText("Metabolic Syndrome was defined as having 3 or more of the following risk factors: a Body Mass Index (BMI) greater than 25, 
               having been told by a primary care provider about the presence of high cholesterol, diabetes, or high blood pressure/hypertension."),
             br(),
             helpText("Metabolic syndrome may be associated with certain dietary and lifestyle choices. 
               The bubbleplots below illustrate the relationship between the prevalence of metabolic syndrome and availability
                of farmers' markets and fast food by state."),
             div(style="display:inline-block", htmlOutput(outputId="farmers")),
             div(style="display:inline-block", htmlOutput(outputId="fastfood")),
             helpText("*Data available only for 43 states. Darker shades indicate greater state population proportions.")
             )
              )
))

