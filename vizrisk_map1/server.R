# server.R

source("helpers3.R")
library(maps)
library(mapproj)
library(reshape2)

data(state.fips)

shinyServer(
  function(input, output) {
    
    met <- read.csv("data/met.csv")
    
    in_sex <- reactive({ input$sex })
    in_agegroup <- reactive({ input$agegroup })
    in_race <- reactive({ input$race })
    
    tab_W <- reactive({
      in_tab <- met[met$SEX %in% as.character(in_sex()), ]
      in_tab <- in_tab[in_tab$AGEG %in% as.character(in_agegroup()), ]
      in_tab <- in_tab[in_tab$IMPRACE %in% as.character(in_race()), ]
      
      tab <- round(with(in_tab, xtabs(Freq~STATE+METSD))/sum(rowSums(with(in_tab, xtabs(Freq~STATE+METSD))))*100,3)
      
      tab_L <- melt(tab)
      tab_W <- dcast(tab_L, STATE ~ METSD)
      tab_W$sum <- tab_W$No + tab_W$Yes
      tab_W$prop <- tab_W$Yes / tab_W$No
      tab_W$percent <- tab_W$prop*100
    })
    
    
    output$map <- renderPlot({
      df <- cbind(unique(met$STATE), as.data.frame(tab_W()))
      colnames(df) <- c("STATE", "percent")
      percent_map2(data = df, color = "darkgreen", 
                     legend.title = "Metabolic Syndrome", max = input$range[2], min = input$range[1])
    })
    
    
    #output$table <- renderTable({
     # as.data.frame(tab_W())
      #})
  })
