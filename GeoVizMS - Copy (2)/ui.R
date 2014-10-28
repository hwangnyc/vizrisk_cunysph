##ui.R
library(shiny)
library(data.table)
library(reshape2)
library(ggplot2)
library(gridExtra)
suppressPackageStartupMessages(library(googleVis))
source("preproc.r")

shinyUI(
 fluidPage(
    fluidRow(column(8, titlePanel("Metabolic Syndrome: Where Does Your State Stand?")),
              column(4, br(), img(src="cunylogo.png", align="right", height=72, style="margin-left:10px"),
                     img(src="hunterlogo.png", align="right", height=72, style="margin-left:10px"))),

fluidRow(
        column(3,
                wellPanel(
                h3("Data Selection"),
        radioButtons("year", label= h5("Choose a BRFSS Year:"), 
                         choices= list("BRFSS 2013" = 2013, "BRFSS 2011" = 2011), 
                         inline=TRUE), 
        
      helpText(h6("Visualize metabolic syndrome by:")),
                
      checkboxGroupInput("sex", 
                  label = "Sex",
                  choices = c("Male", "Female"),
                  selected = c("Male", "Female")),
      
      checkboxGroupInput("agegroup",
                  label = "Age Group",
                  choices = c("18-24", "25-34", "35-44", "45-54", "55-64", ">65"),
                  selected = c("18-24", "25-34", "35-44", "45-54", "55-64", ">65")),
      
      checkboxGroupInput("race",
                  label = "Racial/Ethnic Group",
                  choices = c("NH White", "NH Black", "NH Asian", "NH Native American/Alaskan Native"="NH NA/AN", "Hispanic", "Other"),
                  selected = c("NH White", "NH Black", "NH Asian", "NH NA/AN", "Hispanic", "Other")) 
                )),
     
      column(6,
        h4("Metabolic Syndrome Prevalence Proportion by State"),
        #htmlOutput(outputId="geotab"),
        div(style="display:inline-block", htmlOutput(outputId="geotab")),
        div(style="display:inline-block", img(src="legend.png")),
        br(),
        helpText("Data are presented in percentages, age-adjusted to the nationwide age distribution from the 2010 Census. 
                 Darker colors indicate a higher prevalence of metabolic syndrome."),
        p("Metabolic Syndrome was defined as having 3 or more of the following risk factors: a Body Mass Index (BMI) greater than 25, 
        having been told by a primary care provider about the presence of high cholesterol, diabetes, or high blood pressure/hypertension."),
        br(),
        h4("Contributing Factor: Availability of Health Food"),
        p("Metabolic syndrome may be associated with certain dietary and lifestyle choices. 
        The bubbleplots below illustrate the relationship between the prevalence of metabolic syndrome and availability
        of farmers' markets and fast food by state."),
        br(),
             htmlOutput(outputId="farmers"),
             htmlOutput(outputId="fastfood"),
             helpText("*Data available only for 43 states.")
        ),
      #column(2, br(), br(), br(), img(src="legend.png", #height=362, width=121,
      #align="left", style="margin-left:10px")),
    
      column(3, br(),
           wellPanel(
                   selectInput("state", label=h3("State Viewer"), 
                         choices= unique(metsyn$SNAME)),
                   plotOutput(outputId="stateview")
                )
             )
    )
  ) 
)

