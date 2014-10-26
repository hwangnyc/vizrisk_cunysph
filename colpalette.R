
getCols <- function(x=NULL, #Numeric vector to calculated colors for
	fixed.cutpoints, #Vector of cutpoints including the minimum (e.g. zero)
	missing.col="lightgrey", #Color to use for NA or negative values
	zero.col="white", #color to use for bottom of color scale, e.g. zero
	saturated.col="darkred", #saturated color
	plotlegend=TRUE, #plot a legend?
	append.labs=" per 100,000", #append this to labels
	missing.lab="missing", #what to call missing values in legend
	box.cex=3, #expansion factor for color boxes
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

par(family="serif")
getCols(y, fixed.cutpoints=c(0,1,5,10,15,22,32,46,68,100), missing.col="lightgrey", zero.col="#F7FCF5", saturated.col="#00441B", append.labs=" %", text.offset=0.5, text.cex=1.5)
dev.copy(png,"legend.png", height=480, width=320)
dev.off()


cp <- c(0,1, 5,10,15,22,32,46,68,100)

paste(brewer.pal(9,"Greens"))
  
g3 <- c('#FFF5EE', '#E1FCDE', '#C7E9C0', '#A1D99B', '#74C476', '#41AB5D', '#238B45', '#006D2C', '#1B5833' ,'#00441B')
  
  #lightgrey = "#D3D3D3"
par(bg="white", family="serif")

plot(0:11, 0:11, type="n", xaxt="n", yaxt="n", bty="n", xlab="", ylab="")
points(x=rep(1, 11), y=11:1, pch=15, cex=3, col=rev(c('lightgrey',paste(g3))))
labs <- c('Missing', paste(cp[1]), paste(cp[-c(1,length(cp))], cp[-c(1,2)]-1, sep=" - "), paste(cp[length(cp)] ))
text(c(paste(rev(labs)[-length(rev(labs))],"%", sep=" "), paste(rev(labs)[length(rev(labs))])), x=rep(1.25,11), y=11:1, pos=4,cex=1, font=2)
  dev.copy(png,"legend.png", height=480, width=320)
  dev.off()
