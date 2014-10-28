##ui.R
library(shiny)
library(data.table)
library(reshape2)
library(ggplot2)
library(gridExtra)
suppressPackageStartupMessages(library(googleVis))
source("preproc.r")

tabPanelAbout <- source("about.r")$value

shinyUI(
  fluidPage(
    includeScript("./www/jquery-2.1.1.min.js"),
    includeScript("./www/cunysph.js"),
    fluidRow(
      column(8, titlePanel("Metabolic Syndrome: Where Does Your State Stand?"), helpText("Metabolic syndrome refers to a group of risk factors that can increase a person's risk for heart disease, diabetes and other health problems. 
                The MetSafe interactive tool helps you visualize the distribution of metabolic syndrome across the U.S. population.")),
      column(4, br(), img(src="cunylogo.png", align="right", height=72, style="margin-left:10px"),
             img(src="hunterlogo.png", align="right", height=72, style="margin-left:10px"))
    ),
    
    fluidRow(
      column(2, 
             wellPanel(
               h3("Data Selection"),
               radioButtons("year", label= HTML(paste("Choose a BRFSS",tags$sup(1), "Year:", sep=" ")), 
                            choices= list("BRFSS 2013" = 2013, "BRFSS 2011" = 2011),
               ), 
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
                                  label = "Racial/Ethnic Group*",
                                  choices = c("NH White", "NH Black", "NH Asian", "NH Native American/Alaskan Native"="NH NA/AN", "Hispanic", "Other"),
                                  selected = c("NH White", "NH Black", "NH Asian", "NH NA/AN", "Hispanic", "Other")),
               helpText("*NH - Non-Hispanic")
             )),
      column(9,
             tabsetPanel(
               tabPanel(title="MetSafe",
                        h3("Metabolic Syndrome Prevalence Proportion by State"),
                        htmlOutput(outputId="geotab", inline=TRUE),
                          h3("State Viewer"),
                          selectInput("state", label="Select a state to learn more about the distribution of metabolic syndrome by age, sex, and racial/ethnic group.",
                                      choices= unique(metsyn$SNAME)),
                          plotOutput(outputId="stateview"),
                        
                        helpText(HTML(paste("Data are presented in percentages, age-adjusted to the nationwide age distribution from the 2010 Census.",
                        tags$sup("2 "),"Darker colors indicate a higher prevalence of metabolic syndrome.", sep=""))),
                        p("For this visualization, metabolic syndrome was defined as having 3 or more of the following risk factors: a Body Mass Index (BMI) greater than 25,
                        having been told by a primary care provider about the presence of high cholesterol, diabetes, or high blood pressure/hypertension."),
                        hr(),
                        h4(HTML(paste("Contributing Factors: Availability of Health Food and Fast Food",tags$sup("3,4"), sep=" "))),
                        p("While diet is related to metabolic syndrome and is often considered an individual choice, the food environment
                        in which an individual lives can have an impact on that person's dietary choices and overall health.
                        The bubbleplots below illustrate the relationship between the prevalence of metabolic syndrome and availability
                        of farmers' markets and fast food by state and region."),
                        br(),
                        htmlOutput(outputId="farmers"),
                        htmlOutput(outputId="fastfood"),
                        helpText("*Data available only for 43 states."),
                        value="geoviz"),
               tabPanelAbout(),
               id="tsp")
      ),
      column(1, br(), br(), br(), br(), br(), br(), br(), br(), img(src="colscale2.png", class="legend",
                height=362, width=121, align="left", style="margin-left:10px; float: right"))
      
   ) #fluidRow
  ) #fluidPage
) #shinyUI