# Common Neighbors

library(igraph)
library(dbscan)
library(ProximityMeasure)

##### Adjacency matrix #####

# Read cyberlocker sites to CSV
cyberlockers_threshold <- read.csv("~/Documents/github/tbwd/datasets/similarity-threshold-90.csv", header=TRUE, sep=",")
my_data <- cyberlockers_threshold

library(reshape2)
df <- acast(my_data, (my_data$SS1) ~ (my_data$SS2), value.var = "Similarity", fill=0, drop = FALSE)
M<-as.matrix(df)

# Create an edge IFF similarity > t.
M[M > 90] <- 1

G = graph.adjacency(M, mode=c("undirected"),weighted=NULL)
#Set minimum k<-2;number of shared neighbors in SNN graph
k<-1
# Calling SSN function
G2<-SNN_GRAPH(M,k);
# Plot the SNN graph returned by SNN_GRAPH function
library("tkplot")
tkid <- tkplot(G2,vertex.label.color="black", vertex.size=29)
l <- tkplot.getcoords(tkid)
tk_close(tkid, window.close = T)
plot(G2, layout=l)

# SNN
# cl <- sNNclust(M, k = 2, eps = 1, minPts = 0)
# plot(M, col = cl$cluster + 1L, cex = .5)

# KNN
# nn <- kNN(M, k=1)
# nn
# plot(nn, M)