function(){
        tabPanel("About",
                 HTML('<div style="float: right; margin: 5px 5px 5px 10px;"> 
                     <iframe width="560" height="315" src="//www.youtube.com/embed/uHYcDQDbMY8" frameborder="0" allowfullscreen></iframe> 
                      </div>'),
                 h4("About Us"),
                 p("This is the shiny risk visualization web application proudly developed by Dr. Levi Waldron, Jasmine Abdelnabi, Marcel Ramos, Finn Schubert, Dr. Katarzyna Wyka, Dr. Ashish Joshi, Henry Wang, and Cody Boppert."),
                 hr(),
                 h4("Methods"),
                 p("Data were obtained from the Behavioral Risk Factor Surveillance System (BRFSS) survey for the years 2011 and 2013. 
                   The 2012 BRFSS survey did not have information on two of the four risk factors used to define metabolic syndrome for this visualization (cholesterol and high blood pressure). 
                    All survey analyses were done using R version 3.1.1 and the 'survey' package by Thomas Lumley. 
                     After adjusting for the survey design, participants who were older than 18 years of age and within the 50 states or District of Columbia were considered for the visualization."
                   ),
                 h4("Data Sources"),
                 p("1) Centers for Disease Control and Prevention (CDC).",
                 span(a("Behavioral Risk Factor Surveillance System Survey Data.", href="http://www.cdc.gov/brfss/")),
                 "Atlanta, Georgia: U.S. Department of Health and Human Services, Centers for Disease Control and Prevention [2011]"),
                 p("2) Centers for Disease Control and Prevention (CDC).",
                   span(a("Behavioral Risk Factor Surveillance System Survey Data.", href="http://www.cdc.gov/brfss/")),
                   "Atlanta, Georgia: U.S. Department of Health and Human Services, Centers for Disease Control and Prevention [2013]"),
                 p("3) Ian Spiro, Phil Dhingra. ",
                  span(a("Fast Food Locations Geographic Distribution Project.", href="http://www.fastfoodmaps.com/")),
                  "[2007]"),
                 p("4) Department of Agriculture, Agricultural Marketing Service. ", 
                   span(a("USDA Farmer Market Geographic Data.", href="http://www.ams.usda.gov/farmersmarkets"))),
                 p("5) U.S. Census Bureau, ",
                   span(a("2010 Census of Population.", href="http://www.census.gov/2010census/"))),       
                 value="about"
                 )
}
