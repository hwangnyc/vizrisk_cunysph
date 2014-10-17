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
    
    output$table1 <- renderTable({ 
      
      tab <- melt(round(with(tab_w(), xtabs(STDFQ~METSD+STATE))*100,3))
      cast1 <- dcast(tab, STATE~METSD)
      cast1 <- cbind(cast1, total=cast1$No + cast1$Yes)
      cast1 <- cbind(cast1, prop=cast1$Yes/cast1$total)
      cast1 <- cbind(cast1, Prevalence=cast1$prop*100)
      cast1 <- cbind(cast1, SNAME=fips$STATE[match(cast1$STATE, fips$FIPS)])
      cast1 <- cbind(cast1, REGION= fips$region[match(cast1$STATE, fips$FIPS)])  
      
      cast1$lstate <- tolower(cast1$SNAME)
      cast1 <- merge(cast1, fmf, by.x = "lstate", by.y = "statename")
      farmermkt <- cast1[ , c("prop", "percapfarmkt")]
      
      return(farmermkt)
   })
   
   output$scatter_fm <- renderGvis({
     
     tab <- melt(round(with(tab_w(), xtabs(STDFQ~METSD+STATE))*100,3))
     cast1 <- dcast(tab, STATE~METSD)
     cast1 <- cbind(cast1, total=cast1$No + cast1$Yes)
     cast1 <- cbind(cast1, prop=cast1$Yes/cast1$total)
     cast1 <- cbind(cast1, Prevalence=cast1$prop*100)
     cast1 <- cbind(cast1, SNAME=fips$STATE[match(cast1$STATE, fips$FIPS)])
     cast1 <- cbind(cast1, REGION= fips$region[match(cast1$STATE, fips$FIPS)])
     
     cast1$lstate <- tolower(cast1$SNAME)
     cast1 <- merge(cast1, fmf, by.x = "lstate", by.y = "statename")
     
     farmer <- cast1[ , c("prop", "percapfarmkt")]
     
     return(gvisScatterChart(farmer, 
                             options=list(legend="none",
                                          title="Farmers' Markets Per Capita",
                                          vAxis ="{title:'Markets Per 100,000 State Residents'}",
                                          hAxis="{title:'Proportion of State Residents with Met. Synd.'}")))
     
   })
   
   output$scatter_ff <- renderGvis({
     
     tab <- melt(round(with(tab_w(), xtabs(STDFQ~METSD+STATE))*100,3))
     cast1 <- dcast(tab, STATE~METSD)
     cast1 <- cbind(cast1, total=cast1$No + cast1$Yes)
     cast1 <- cbind(cast1, prop=cast1$Yes/cast1$total)
     cast1 <- cbind(cast1, Prevalence=cast1$prop*100)
     cast1 <- cbind(cast1, SNAME=fips$STATE[match(cast1$STATE, fips$FIPS)])
     cast1 <- cbind(cast1, REGION= fips$region[match(cast1$STATE, fips$FIPS)])
     
     cast1$lstate <- tolower(cast1$SNAME)
     cast1 <- merge(cast1, fmf, by.x = "lstate", by.y = "statename")
     
     ff <- cast1[ , c("prop", "percapfstfd")]
     
     
     return(gvisScatterChart(ff, 
                             options=list(legend="none",
                                          title="Fast Food Per Capita",
                                          colors="['red']",
                                          vAxis ="{title:'Fast Food Restaurants Per 100,000 State Residents'}",
                                          hAxis="{title:'Proportion of State Residents with Met. Synd.'}")))
     
   })  
    
  })