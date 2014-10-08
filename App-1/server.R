library(shiny)


shinyServer(function(input, output) {



  output$distPlot <- renderPlot({
    Bike_Time    <- read.csv("imlp_r.csv")[,1]  # dataset
    bins <- seq(min(Bike_Time), max(Bike_Time), length.out = input$bins + 1)

    hist(Bike_Time, breaks = bins, col = 'grey', border = 'black')
  })

})
