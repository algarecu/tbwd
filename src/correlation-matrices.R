# Required packages
require(ggpubr)
require(tidyverse)
require(Hmisc)
require(varhandle)
require(dplyr)
library(corrplot)
############### ############### ###############

# Streaming sites to CSV
cyberlockers <- read.csv("~/Documents/github/tbwd/datasets/similarity.csv", header=TRUE, sep=",")
my_data <- cyberlockers

library(reshape2)
df <- acast(my_data, (my_data$SS1) ~ (my_data$SS2), value.var = "Similarity", fill=0, drop = FALSE)
M<-as.matrix(df)
library('corrplot')
corrplot(M, method='circle')
corrplot(M, is.corr = FALSE, method = "circle")

