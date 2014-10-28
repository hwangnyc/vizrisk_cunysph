function(){
        tabPanel("About",
                 HTML('<div style="float: right; margin: 5px 5px 5px 10px;"> 
                     <iframe width="560" height="315" src="//www.youtube.com/embed/uHYcDQDbMY8" frameborder="0" allowfullscreen></iframe> 
                      </div>'),
                 h4("About Us"),
                 p("Insert Text Here"),
                 hr(),
                 h4("Methods"),
                 p("Data were obtained from the Behavioral Risk Factor Surveillance System (BRFSS) for the years 2013 and 2011. 
                    All survey analyses were done using R version 3.1.1 and the 'survey' package by Thomas Lumley. 
                     After specifying the survey design in R, participants who were older than 18 years of age and within the 50 states were considered for the visualization."
                   ),
                 value="about"
                 )
}
