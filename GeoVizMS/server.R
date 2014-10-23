source("preproc.r")

shinyServer(
        function(input, output) {

        tab_w <- reactive({
                in_tab <- subset(metsyn, YEAR==input$year & SEX %in% input$sex & AGEG %in% input$agegroup & IMPRACE %in% input$race)
                in_tab <- droplevels(in_tab)
                in_tab <- dcast(aggregate(STDFQ~METSD+STATE, in_tab, sum), STATE~METSD, value.var="STDFQ", na.action=na.omit)
                in_tab <- cbind(in_tab, MS.Proportion=round(in_tab$Yes/(in_tab$Yes+in_tab$No),3))
                in_tab <- cbind(in_tab, MS.Prevalence=in_tab$MS.Proportion*100)
                in_tab <- cbind(in_tab, ABB=fips$Abb[match(in_tab$STATE, fips$FIPS)])
                in_tab <- cbind(in_tab, SNAME=fips$STATE[match(in_tab$STATE, fips$FIPS)])
                in_tab <- cbind(in_tab, REGION= fips$region[match(in_tab$STATE, fips$FIPS)])
                in_tab <- cbind(in_tab, FULLSN = paste(in_tab$SNAME,in_tab$ABB, sep=" - "))      
                return(in_tab)
        })
                
        output$geotab <- renderGvis({
                cast1 <- tab_w()
                Geo <- gvisGeoChart(cast1, colorvar="MS.Prevalence", locationvar="REGION", hovervar="FULLSN",
                        options=list(region="US", 
                                displayMode="regions", 
                                resolution="provinces", 
                                backgroundColor="lightblue",
                                width=720,
                                height=480,
                                colorAxis="{values:[0,5,10,15,22,32,46,68,100], 
                                colors:['#F7FCF5','#E5F5E0','#C7E9C0','#A1D99B','#74C476','#41AB5D','#238B45','#006D2C','#00441B']}", 
                                datalessRegionColor="lightgrey") ) 
                
                recast <- cast1[,c("SNAME","ABB","MS.Prevalence","Yes","No")]
                
                Tab <- gvisTable(recast, options=(list(width=250, height=350)))
                
                GT <- gvisMerge(Geo,Tab, horizontal=TRUE)
                return(GT)
                })

        output$farmers <- renderGvis({
                
                cast1 <- merge(tab_w(), fmf, by.x = "STATE", by.y = "fips")
                colnames(cast1)[grep("capfarmkt", colnames(cast1))] <- "MarketsPerCap"
                cast1$MarketsPerCap <- round(cast1$MarketsPerCap, 2)
                cast1 <- cbind(cast1, Population.Proportion=round((cast1$popfm/sum(cast1$popfm))*100,0))
                
                return(gvisBubbleChart(cast1, idvar="ABB", xvar="MS.Proportion", yvar="MarketsPerCap", 
                                       sizevar="Population.Proportion",
                                       options=list(legend="none", 
                                                     width=800,
                                                     height=400,
                                                     colorAxis="{colors:['#F7FCF5','#006D2C']}",
                                                     title="Farmers' Markets Per Capita*",
                                                     vAxis ="{title:'Markets Per 100,000 State Residents', 
                                                                viewWindowMode:'explicit', viewWindow:{min:0}}",
                                                     hAxis="{title:'Proportion of State Residents with Met. Synd.',
                                                                viewWindowMode:'explicit', viewWindow:{min:0}}"   )))
        })
        
        output$fastfood <- renderGvis({
                
                cast1 <- merge(tab_w(), fmf, by.x = "STATE", by.y = "fips")
                colnames(cast1)[grep("capfstfd", colnames(cast1))] <- "FastFoodPerCap"
                cast1$FastFoodPerCap <- round(cast1$FastFoodPerCap, 2)
                cast1 <- cbind(cast1, Population.Proportion=round((cast1$popff/sum(cast1$popff))*100,2))
                
                return(gvisBubbleChart(cast1, idvar="ABB", xvar="MS.Proportion", yvar="FastFoodPerCap", 
                                       sizevar="Population.Proportion",
                                       options=list(legend="none", 
                                                    width=800,
                                                    height=400,
                                                    colorAxis="{colors:['#FEE0D2', '#A50F15']}",
                                                    title="Fast Food Per Capita*",
                                                    vAxis ="{title:'Fast Food Restaurants per 100,000 State Residents', 
                                                                viewWindowMode:'explicit', viewWindow:{min:0}}",
                                                    hAxis="{title:'Proportion of State Residents with Met. Synd.',
                                                                viewWindowMode:'explicit', viewWindow:{min:0}}"   )))
        })                
})