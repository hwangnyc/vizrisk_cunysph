
getCols <- function(x=NULL,  #Numeric vector to calculated colors for
                    fixed.cutpoints, #Vector of cutpoints including the minimum (e.g. zero)
                    missing.col="lightgrey", #Color to use for NA or negative values
                    zero.col="white",  #color to use for bottom of color scale, e.g. zero
                    saturated.col="darkred",  #saturated color
                    plotlegend=TRUE,  #plot a legend?
                    append.labs=" per 100,000",  #append this to labels
                    missing.lab="missing", #what to call missing values in legend
                    box.cex=3,  #expansion factor for color boxes
                    text.cex=1, #expansion factor for text
                    text.offset=1){ #amount by which to offset text
  n.categories <- length(fixed.cutpoints)
  col.palette = colorRampPalette(c(zero.col, saturated.col))(n.categories)
  if(!is.null(x)){
      x[x < min(fixed.cutpoints)] <- NA
      x[is.na(x)] <- -Inf
      mycols <- as.character(cut(x, c(fixed.cutpoints, Inf), labels=col.palette, include.lowest=TRUE))
      mycols[is.na(mycols)] <- missing.col
  }else{
      mycols <- NULL
  }
  if(plotlegend){
    labs <- c(paste(fixed.cutpoints[-length(fixed.cutpoints)], fixed.cutpoints[-1], sep=" - "),
              paste(">", fixed.cutpoints[length(fixed.cutpoints)], sep=""))
    labs <- paste(rev(labs), append.labs, sep="")
    if(missing.col %in% mycols){
      labs <- c(labs, missing.lab)
      col.palette <- c(missing.col, col.palette)
    }
    plot(0:10, 0:10, type="n", xaxt="n", yaxt="n", bty="n", xlab="", ylab="")
    points(x=rep(1, length(col.palette)), y=length(col.palette):1,
           pch=15, cex=box.cex, col=rev(col.palette))
    text(labs, x=rep(1+text.offset, length(col.palette)),
         y=length(col.palette):1, pos=4, cex=text.cex)
  }
  return(mycols)
}

##Generate some data with missing values
y <- 0:100
y[10:15] <- NA
y[70:75] <- -99

##Create a legend and
mycols <- getCols(y, fixed.cutpoints=c(0, 20, 50, 75))
plot(0:100, col=mycols)
