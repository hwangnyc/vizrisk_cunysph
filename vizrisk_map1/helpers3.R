#adapted from percent_map in helpers.R

percent_map2 <- function(data, color, legend.title, min = 0, max = 100) {

  # generate vector of fill colors for map
  num_shades <- max - min + 1
  shades <- colorRampPalette(c("white", color))(num_shades)
  
  # constrain gradient to percents that occur between min and max
  percents <- as.integer(cut(as.numeric(data$percent), num_shades, 
    include.lowest = TRUE, ordered = TRUE))
  fills <- shades[percents]
  
  colorsmatched <- as.numeric(data$percent)[match(state.fips$fips, data$STATE)]
  
  map("state", col = shades[colorsmatched], fill = TRUE, resolution = 0, 
      lty = 0, projection = "polyconic")

  # overlay state borders
  map("state", col = "white", fill = FALSE, add = TRUE,
    lty = 1, lwd = 1, projection = "polyconic", 
    myborder = 0, mar = c(0,0,0,0))
  
  # add a legend
  inc <- (max - min) / 4
  legend_shades <- c(1, (min+inc), (min+2*inc), (min+3*inc), length(shades))
  legend.text <- c(paste0(min, " % or less"),
    paste0(min + inc, " %"),
    paste0(min + 2 * inc, " %"),
    paste0(min + 3 * inc, " %"),
    paste0(max, " % or more"))
  
  legend("bottomleft", 
    legend = legend.text,
    fill = shades[legend_shades], 
    title = legend.title)
}
