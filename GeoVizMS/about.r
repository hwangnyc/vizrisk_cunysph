function(){
        tabPanel("About",
                 HTML('<div style="float: right; margin: 5px 5px 5px 10px;"> 
                     <iframe width="560" height="315" src="//www.youtube.com/embed/uHYcDQDbMY8" frameborder="0" allowfullscreen></iframe> 
                      </div>'),
                 h4("About Us"),
                 p("This is the shiny risk visualization web application proudly developed by Professor Levi Waldron, Jasmine Abdelnabi, Marcel Ramos, Finn Schubert, Katarzyna Wyka, Henry Wang, and Cody Boppert."),
                 hr(),
                 h4("Methods"),
                 p("Data were obtained from the Behavioral Risk Factor Surveillance System (BRFSS) survey for the years 2011 and 2013. 
                   The 2012 BRFSS survey did not have information on two of the four risk factors used to define metabolic syndrome for this visualization (cholesterol and high blood pressure). 
                    All survey analyses were done using R version 3.1.1 and the 'survey' package by Thomas Lumley. 
                     After adjusting for the survey design, participants who were older than 18 years of age and within the 50 states were considered for the visualization."
                   ),
                 value="about"
                 )
}
