# Common Neighbors
library(igraph)
library(dbscan)

##### Adjacency matrix #####

# Read cyberlocker sites to CSV
cyberlockers <- read.csv("~/Documents/github/tbwd/datasets/similarity.csv", header=TRUE, sep=",")
my_data <- cyberlockers

library(reshape2)
df <- acast(my_data, (my_data$SS1) ~ (my_data$SS2), value.var = "Similarity", fill=0, drop = FALSE)
M<-as.matrix(df)

# Create an edge IFF similarity > t.
M[M < 90] <- 0
M[M > 90] <- 1
diag(M) <- 0

G = graph.adjacency(M, mode=c("undirected"),weighted=FALSE)
#Set minimum k<-2;number of shared neighbors in SNN graph
k<-1
# Calling SSN function
G2<-SNN_GRAPH(G,k);
# Plot the SNN graph returned by SNN_GRAPH function
tkid <- tkplot(G2,vertex.label.color="black", vertex.size=29)
l <- tkplot.getcoords(tkid)
tk_close(tkid, window.close = T)

mylabels <- unique(melt(my_data$SS1, my_data$SS2))


plot(G, layout=l,
     vertex.label=mylabels$value,
     vertex.label.color="black",
     edge.curved=.1)
plot(G2, layout=l,
     vertex.label=mylabels$value,
     vertex.label.color="black")


# Modularity
cfg <- cluster_fast_greedy(as.undirected(G))

pdf("~/Documents/github/tbwd/plots/community-html-modularity-all.pdf", width=8, height=8)
pdfcommunity <- plot(cfg, as.undirected(G))

dev.off()

# SNN
# cl <- sNNclust(M, k = 2, eps = 1, minPts = 0)
# plot(M, col = cl$cluster + 1L, cex = .5)

# KNN
# nn <- kNN(M, k=1)
# nn
# plot(nn, M)