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
    fluidRow(
      column(8, titlePanel("Metabolic Syndrome: Where Does Your State Stand?")),
      column(4, img(src="cunylogo.png", align="right", height=72, style="margin-left:10px"),
             img(src="hunterlogo.png", align="right", height=72, style="margin-left:10px"))
    ),
    
    fluidRow(
      column(2, 
             wellPanel(
               h3("Data Selection"),
               radioButtons("year", label= HTML(paste("Choose a BRFSS",tags$sup("1,2"), "Year:", sep=" ")), 
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
             tabsetPanel(
<<<<<<< HEAD
                     tabPanel(title="Metabolic Syndrome Map",
                              h4("Metabolic Syndrome Prevalence Proportion by State"),
                              div(style={'display:inline-block'}, htmlOutput(outputId="geotab", inline=TRUE)),
                              div(style={'display:inline-block'}, img(src="legend.png", height=362, width=121,align="right", style="margin-left:10px")),
                              helpText("Data are presented in percentages, age-adjusted to the nationwide age distribution from the 2010 Census.
=======
               tabPanel(title="Metabolic Syndrome Map",
                        h4("Metabolic Syndrome Prevalence Proportion by State"),
                        htmlOutput(outputId="geotab", inline=TRUE),
                        helpText("Data are presented in percentages, age-adjusted to the nationwide age distribution from the 2010 Census.
>>>>>>> FETCH_HEAD
Darker colors indicate a higher prevalence of metabolic syndrome."),
                        p("Metabolic Syndrome was defined as having 3 or more of the following risk factors: a Body Mass Index (BMI) greater than 25,
having been told by a primary care provider about the presence of high cholesterol, diabetes, or high blood pressure/hypertension."),
                        hr(),
                        h4(HTML(paste("Contributing Factors: Availability of Health Food and Fast Food",tags$sup("3,4"), sep=" "))),
                        p("Metabolic syndrome may be associated with certain dietary and lifestyle choices.
The bubbleplots below illustrate the relationship between the prevalence of metabolic syndrome and availability
of farmers' markets and fast food by state and region."),
<<<<<<< HEAD
                              br(),
                              htmlOutput(outputId="farmers"),
                              htmlOutput(outputId="fastfood"),
                              helpText("*Data available only for 43 states."),
        
                              value="geoviz"),
                     tabPanelAbout(),
                     id="tsp")
=======
                        br(),
                        htmlOutput(outputId="farmers"),
                        htmlOutput(outputId="fastfood"),
                        helpText("*Data available only for 43 states."),
                        value="geoviz"),
               tabPanelAbout(),
               id="tsp")
>>>>>>> FETCH_HEAD
      ),
      column(1, br(), br(), br(), br(), br(), img(src="legend.png", height=362, width=121,align="left", style="margin-left:10px; float: right")),
      column(3, br(),
             wellPanel(
               selectInput("state", label=h3("State Viewer"), 
                           choices= unique(metsyn$SNAME)),
               plotOutput(outputId="stateview")
             )
      )
    ) #fluidRow
  ) #fluidPage
) #shinyUI