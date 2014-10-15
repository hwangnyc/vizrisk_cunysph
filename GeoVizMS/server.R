source("preproc.r")

shinyServer(
        function(input, output) {

        met <- reactive({ 
          subset(metsyn, YEAR==input$year)
        })
        in_sex <- reactive({input$sex})
        in_agegroup <- reactive({input$agegroup})
        in_race <- reactive({input$race})
        
        tab_w <- reactive({
                in_tab <- met()[met()$SEX %in% as.character(in_sex()),]
                in_tab <- in_tab[in_tab$AGEG %in% as.character(in_agegroup()),]
                in_tab <- in_tab[in_tab$IMPRACE %in% as.character(in_race()),]
                
                tab <- round(with(in_tab, xtabs(STDFQ~METSD+STATE))*100,3)
        
                tab_l <- melt(tab)
                tab_w <- dcast(tab_l, STATE~METSD)
                tab_w$sum <- tab_w$No + tab_w$Yes
                tab_w$prop <- tab_w$Yes/ tab_w$sum
                tab_w$percent <- tab_w$prop*100
                tab_w$SNAME <- fips$STATE[match(tab_w$STATE, fips$FIPS)]
                tab_w$REGION <- fips$region[match(tab_w$STATE, fips$FIPS)]
                        })
                

        output$geomap <- renderGvis({
                gvisGeoChart(data=as.data.frame(tab_w()), colorvar="percent", locationvar="REGION", hovervar="SNAME",
                                options=list(region="US", dataMode="region", resolution="provinces", 
                                title="Metabolic Syndrome Prevalence Proportions") 
                                )
                })

})