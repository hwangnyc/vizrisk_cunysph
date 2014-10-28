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
                in_tab <- cbind(in_tab, SubRegion = fips$subregion[match(in_tab$STATE, fips$FIPS)])
                return(in_tab)
        })
                
        output$geotab <- renderGvis({
                cast1 <- tab_w()
                Geo <- gvisGeoChart(cast1, colorvar="MS.Prevalence", locationvar="REGION", hovervar="FULLSN",
                        options=list(region="US",
                                     legend="none",
                                displayMode="regions", 
                                resolution="provinces", 
                                backgroundColor="lightblue",
                                keepAspectRatio = TRUE,
                                width = "85%", height="100%",
                                colorAxis="{values:[0,1,5,10,15,22,32,46,68,100], 
                                colors:['#FFF5EE', '#E1FCDE', '#C7E9C0', '#A1D99B', '#74C476', '#41AB5D', '#238B45', '#006D2C', '#1B5833' ,'#00441B']}", 
                                datalessRegionColor="lightgrey") ) 
                
                return(Geo)
                })

        output$farmers <- renderGvis({
                
                cast1 <- merge(tab_w(), fmf, by.x = "STATE", by.y = "fips")
                colnames(cast1)[grep("capfarmkt", colnames(cast1))] <- "MarketsPerCap"
                cast1$MarketsPerCap <- round(cast1$MarketsPerCap, 2)
                cast1 <- cbind(cast1, Population.Proportion=round((cast1$popfm/sum(cast1$popfm))*100,2))
                
                return(gvisBubbleChart(cast1, idvar="ABB", xvar="MS.Proportion", yvar="MarketsPerCap", 
                                       sizevar="Population.Proportion",colorvar="SubRegion",
                                       options=list(width=800,
                                                     height=400,
                                                    chartArea="{left:35,top:35,width:'75%',height:'80%'}",
                                                     title="Farmers' Markets Per Capita*", 
                                                        titleTextStyle="{fontSize:18}",
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
                                       sizevar="Population.Proportion",colorvar="SubRegion",
                                       options=list(width=800,
                                                    height=400,
                                                    chartArea="{left:35,top:35,width:'75%',height:'80%'}",
                                                    title="Fast Food Per Capita*",
                                                    titleTextStyle="{fontSize:18}",
                                                    vAxis ="{title:'Fast Food Restaurants per 100,000 State Residents', 
                                                                viewWindowMode:'explicit', viewWindow:{min:0}}",
                                                    hAxis="{title:'Proportion of State Residents with Met. Synd.',
                                                                viewWindowMode:'explicit', viewWindow:{min:0}}"   )))
        })
        
        side_tab <-  reactive({
                side <- subset(metsyn, YEAR==input$year & SNAME == input$state)
                side <- dcast(aggregate(STDFQ~METSD+AGEG+IMPRACE, side, sum), AGEG+IMPRACE~METSD, value.var="STDFQ", na.action=na.omit)
                grptot <- aggregate(Yes+No~AGEG, side, sum)
                colnames(grptot)[2] <- "TotFQ"
                side$GTOT <- grptot$TotFQ[match(side$AGEG, grptot$AGEG)]
                side$Prop <- side$Yes/side$GTOT
                return(side)
        })
        
        side_tab2 <-  reactive({
                side <- subset(metsyn, YEAR==input$year & SNAME == input$state)
                side <- dcast(aggregate(STDFQ~METSD+AGEG+SEX, side, sum), AGEG+SEX~METSD, value.var="STDFQ", na.action=na.omit)
                grptot <- aggregate(Yes+No~AGEG, side, sum)
                colnames(grptot)[2] <- "TotFQ"
                side$GTOT <- grptot$TotFQ[match(side$AGEG, grptot$AGEG)]
                side$Prop <- side$Yes/side$GTOT
                return(side)
        })
        
        output$stateview <- renderPlot({
                             
              a <- ggplot(side_tab(), aes(x=AGEG, y=Prop, fill=IMPRACE)) + geom_bar(stat="Identity") + scale_fill_brewer(type="qual", palette="Accent")
              k <- a + ylab("Prevalence Proportion") + labs(fill="Racial/Ethnic \n Group") + theme(axis.title.x = element_blank(),text=element_text(size=16, family="serif"))
              b <- ggplot(side_tab2(), aes(x=AGEG, y=Prop, fill=SEX)) + geom_bar(stat="identity") + scale_fill_manual(values=c("#B3CDE3","#FBB4AE"))
              j <- b + ylab("Prevalence Proportion") + xlab("Age Group") + labs(fill="Gender") + theme(text=element_text(size=16,family="serif"))
              grid.arrange(k,j, ncol=1)
              
        })
}) #shinysever