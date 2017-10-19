# Common Neighbors
library(igraph)
library(reshape2)

##### Adjacency matrix #####

# Read cyberlocker sites to CSV
cyberlockers <- read.csv("~/Documents/github/tbwd/datasets/similarity.csv", header=TRUE, sep=",")
my_data <- cyberlockers

df <- acast(my_data, (my_data$SS1) ~ (my_data$SS2), value.var = "Similarity", fill=0, drop = TRUE)
M<-as.matrix(df)

# Create an edge IFF similarity > t.
M[M < 90] <- 0
M[M > 90] <- 1
diag(M) <- 0

# Remove the ones with no edge
ind_row <- rowSums(M == 0) != ncol(M)
ind_col <- colSums(M == 0) != nrow(M)

Mt<-as.matrix(M[ind_row, ind_col])

G = graph.adjacency(Mt, mode=c("undirected"))
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
     edge.curved=.3)
plot(G2, layout=l,
     vertex.label=mylabels$value,
     vertex.label.color="black",
     edge.curved=.3)

# Modularity
## Louvain
cfg_louvain <- cluster_louvain(as.undirected(G), weights = NULL)
## Newman: greedy modularity
cfg_newman <- cluster_fast_greedy(as.undirected(G))

pdf("~/Documents/github/tbwd/plots/community-html-modularity-all.pdf", width=6, height=6)
pdfcommunity <- plot(cfg_louvain, as.undirected(G))

dev.off()

# SNN
# library(dbscan)
# cl <- sNNclust(M, k = 2, eps = 1, minPts = 0)
# plot(M, col = cl$cluster + 1L, cex = .5)

# KNN
# nn <- kNN(M, k=1)
# nn
# plot(nn, M)