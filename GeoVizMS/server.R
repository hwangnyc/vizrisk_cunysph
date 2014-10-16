source("preproc.r")

shinyServer(
        function(input, output) {

        tab_w <- reactive({
                in_tab <- subset(metsyn, YEAR==input$year & SEX %in% input$sex & AGEG %in% input$agegroup & IMPRACE %in% input$race)
                in_tab <- droplevels(in_tab)
                return(in_tab)
        })
                
                
        output$geomap <- renderGvis({
                
                tab <- melt(round(with(tab_w(), xtabs(STDFQ~METSD+STATE))*100,3))
                cast1 <- dcast(tab, STATE~METSD)
                cast1 <- cbind(cast1, total=cast1$No + cast1$Yes)
                cast1 <- cbind(cast1, prop=cast1$Yes/cast1$total)
                cast1 <- cbind(cast1, Prevalence=cast1$prop*100)
                cast1 <- cbind(cast1, SNAME=fips$STATE[match(cast1$STATE, fips$FIPS)])
                cast1 <- cbind(cast1, REGION= fips$region[match(cast1$STATE, fips$FIPS)])
                
                return(gvisGeoChart(cast1, colorvar="Prevalence", locationvar="REGION", hovervar="SNAME",
                                options=list(region="US", dataMode="region", resolution="provinces", 
                                title="Metabolic Syndrome Prevalence Proportions") ) ) 
                                
                })

})