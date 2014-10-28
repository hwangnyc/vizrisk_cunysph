function(){
        tabPanel("About",
                 HTML('<div style="float: right; margin: 5px 5px 5px 10px;"> 
                     <iframe width="560" height="315" src="//www.youtube.com/embed/uHYcDQDbMY8" frameborder="0" allowfullscreen></iframe> 
                      </div>'),
                 h4("About Us"),
                 p("Insert Text Here"),
                 hr(),
                 h4("Methods"),
                 p("Data were obtained from the Behavioral Risk Factor Surveillance System (BRFSS) survey for the years 2011 and 2013. 
                   The 2012 BRFSS survey did not have information on two of the four risk factors used to define metabolic syndrome (cholesterol and high blood pressure) for this visualization; therefore, it was not included. 
                    All survey analyses were done using R version 3.1.1 and the 'survey' package by Thomas Lumley. 
                     After adjusting for the survey design, participants who were older than 18 years of age and within the 50 states were considered for the visualization."
                   ),
                 h4("Data Sources"),
                 p("1) Centers for Disease Control and Prevention (CDC). Behavioral Risk Factor Surveillance System Survey Data. Atlanta, Georgia: 
                    U.S. Department of Health and Human Services, Centers for Disease Control and Prevention, [2011, 2013]",
                   a(href="http://www.cdc.gov/brfss/", "http://www.cdc.gov/brfss/")),
                 p("2) Ian Spiro, Phil Dhingra. Fast Food Locations Geographic Distribution Project [2007]; Retrieved from:", 
                   a(href="http://www.fastfoodmaps.com/", "http://www.fastfoodmaps.com/")),
                 p("3) Department of Agriculture, Agricultural Marketing Service. USDA Farmer Market Geographic Data; Retrieved from:", 
                   a(href="http://www.ams.usda.gov/farmersmarkets", "http://www.ams.usda.gov/farmersmarkets")),
                 p("4) U.S. Census Bureau, 2010 Census Summary File 1, Retrieved from:",
                   a(href="http://www.census.gov/2010census/", "http://www.census.gov/2010census/")),
                 
                 value="about"
                 )
}
