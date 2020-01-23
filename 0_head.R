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
# convert term length to numeric 
namls <-names(table(df$term))
df$term_num <- 36
df$term_num[df$term==namls[[2]]]<- 60
table(df$term_num)
##################################

##################################
#  Things picked out of the data dictionary that look promising 
# 33+1 features
features <-c("term_num","acc_now_delinq",
             "annual_inc_joint",
             "annual_inc",
             "application_type",
             "avg_cur_bal",
             "collections_12_mths_ex_med",
             "delinq_2yrs",
             "delinq_amnt",
             "earliest_cr_line",
             "effective_int_rate",
             "emp_length",
             "grade",
             "sub_grade",
             "home_ownership",
             "int_rate",
             "list_d",
             "loan_amnt",
             "num_accts_ever_120_pd",
             "num_actv_bc_tl",
             "num_tl_120dpd_2m",
             "num_tl_30dpd",
             "num_tl_90g_dpd_24m",
             "num_tl_op_past_12m",
             "open_acc",
             "pct_tl_nvr_dlq",
             "percent_bc_gt_75",
             "pub_rec_bankruptcies",
             "tax_liens",
             "tot_hi_cred_lim",
             "zip_code",
             "loan_bad_bool")
##################################
ls_namsfeats <- names(df) %in% features
dat <- df[ls_namsfeats]

# NA Handling 
dat <- na.omit(dat)

#should also remove columns which are constant 

names(dat)
length(names(dat))
names(df)

##################################
# NA Handling 
#################
# Drop some columns which have many NA's
#################
# df <-df[,colSums(is.na(df))<7000]
# # drop remaining NAs (faster than handling, this should be a toy example)
# df <-na.omit(df)
# head(df)
# summary(df)
##################################


