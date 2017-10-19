# Required packages
require(ggpubr)
require(tidyverse)
require(Hmisc)
require(varhandle)
require(dplyr)
library(corrplot)
library(gplots)
############### ############### ###############

# Read cyberlocker sites to CSV

cyberlockers_long <- read.csv("~/Documents/github/tbwd/datasets/similarity.csv", header=TRUE, sep=",")
cyberlockers_threshold <- read.csv("~/Documents/github/tbwd/datasets/similarity-threshold-90.csv", header=TRUE, sep=",")

my_data <- cyberlockers_threshold

library(corrplot)
library(reshape2)
library(gplots)

df <- acast(my_data, (my_data$SS1) ~ (my_data$SS2), value.var = "Similarity", fill = 0, drop =TRUE)
M<-as.matrix(df)

# Get some colors
col <- colorRampPalette(c("blue", "darkblue"))(100)
brewer.div <- colorRampPalette(colors = col, interpolate = "spline")

pdf("~/Documents/github/tbwd/plots/ss-cor-number.pdf", width=8, height=8)
pdfnumbers <- corrplot(M, is.corr = FALSE, method = "number")

pdf("~/Documents/github/tbwd/plots/ss-cor-circle.pdf", width=8, height=8)
pdfcircles <- corrplot(M, is.corr = FALSE, method = "circle")

# Heatmap
pdf("~/Documents/github/tbwd/plots/ss-heatmap.pdf", width=8, height=8)
heatmap(x = M, col = col, scale='column', trace="none",Colv=NULL,Rowv=NULL)

# Levelplot
library(RColorBrewer)
library(lattice)

pdf("~/Documents/github/tbwd/plots/ss-level-circle.pdf", width=8, height=8)
levelplot(M, col.regions = brewer.div(4), aspect = "iso", scale=list(x=list(rot=45)))

dev.off()

