#libraries
library(gmodels)#CrossTable for cat variables
library(ggplot2) #plotting
library(reshape2)
library(corrplot) #correlation matrix
library(lattice)#for caret
library(caret) #for k fold cross val
library(mlbench)
library(splines)
library(MASS)
library(e1071)
library(plyr)
library(data.table)
#devtools::install_github("kassambara/ggcorrplot")
library(ggcorrplot)

#update.packages(ask = FALSE)
#personalFunctions
#source("../../roFunctions.R")

###########
# Generating corr heat map 
###########
# http://www.sthda.com/english/wiki/correlation-matrix-a-quick-start-guide-to-analyze-format-and-visualize-a-correlation-matrix-using-r-software
# http://www.sthda.com/english/wiki/ggcorrplot-visualization-of-a-correlation-matrix-using-ggplot2

#step 1 restrict to numeric info 
nums <- unlist(lapply(dat, is.numeric))  
cordat <- dat[,nums]
head(cordat)

cormat <- round(cor(cordat),1)
head(cormat)
# troubleshout why so many NAs

#throw out NA columns (no variance)? 
#cor2 <-cormat[,colSums(is.na(cormat))<7000]


#corHeatMap(cordat)
filename<-paste0("gfx/",Sys.Date(),"-heatmap.jpg")
ggsave(filename, plot = last_plot(), device = "jpg", path = NULL,
       scale = 2, #width = 8, height = 6, 
       #units = c("cm"),
       dpi = 600, limitsize = TRUE)


cormat <- round(cor(cordat[,-31]),2)



###########
#use caret to remove one of each highly correlated pair
#where high means more than 0.9
#https://www.rdocumentation.org/packages/caret/versions/6.0-84/topics/findCorrelation
###########
highCorr <- findCorrelation(cormat, cutoff=0.9)
highCorr <-sort(highCorr)
raw3 <- raw2[,-c(highCorr)]
names(raw3)
