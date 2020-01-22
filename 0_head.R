#libraries
library(gmodels)#CrossTable for cat variables
library(ggplot2) #plotting
library(corrplot) #correlation matrix
library(lattice)#for caret
library(caret) #for k fold cross val
library(mlbench)
library(splines)
library(MASS)
library(e1071)
library(plyr)
library(data.table)
#library(dplyr)

# Response variable: loan status




#Import data from csv
#################
# Trim file to reasonable size by reading in first 10000 rows
# related https://stackoverflow.com/questions/15115911/convert-r-read-csv-to-a-readlines-batch#15116174
#################
filename <- "data/loan.csv"
raw <- read.csv("data/loan.csv",head=TRUE, nrows=50000, sep=",", stringsAsFactors=FALSE)
head(raw)
names(raw)
str(raw)
summary(raw)

#################
# create bool response variable. 1 bad, 0 good 
#################
df <- raw
ls_names <-names(table(df$loan_status))
ls_pos <- ls_names[c(2,3,4)]
ls_neg <- ls_names[-c(2,3,4)]
df$loan_bad_bool<-1
df$loan_bad_bool[c(df$loan_status)%in% ls_pos]<-0
table(df$loan_bad_bool)

##################################
# NA Handling 

#################
# Drop some columns which are 80% or more NA's
#################
df <-df[,colSums(is.na(df))<8000]
head(df)
str(df)


##################################
# convert term length to numeric 
namls <-names(table(df$term))
df$term_num <- 36
df$term_num[df$term==namls[[2]]]<- 60
table(df$term_num)

  

