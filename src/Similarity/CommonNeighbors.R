# Common Neighbors
# File: foo.R
# Desc: Functionality related to foos.
# Imports from other_resources.R

library(igraph)
library(reshape2)
library(Matrix)
library(RBGL)
library(graph)

# sapply(list.files(pattern="[.]R$", path="~/Documents/github/tbwd/src/Similarity/funcs/", full.names=TRUE), source);
source("~/Documents/github/tbwd/src/Similarity/funcs/ProximityMeasure.R")

##### Adjacency matrix #####

# Read cyberlocker sites to CSV
networks <- read.csv("~/Documents/github/tbwd/datasets/networks.csv", header=TRUE, sep=",", as.is = T)
domains <- read.csv("~/Documents/github/tbwd/datasets/domains.csv", header=TRUE, sep=",")
cyberlockers <- read.csv("~/Documents/github/tbwd/datasets/similarity.csv", header=TRUE, sep=",")

# mylabels <- unique(melt(my_data$SS1, my_data$SS2))

# Create an edge iff similarity > t.
# if(html_data != NULL) {
#   df <- acast(html_data, (my_data$SS1) ~ (my_data$SS2), value.var = "Similarity", fill=0, drop = TRUE)
#   Mt<-as.matrix(df)
#   
#   Mt[Mt < 90] <- 0
#   Mt[Mt > 90] <- 1
#   
#   # Set diagonal back to zero
#   diag(Mt) <- 0
#   
#   # Remove the ones with no edge
#   ind_row <- rowSums(Mt == 0) != ncol(Mt)
#   ind_col <- colSums(Mt == 0) != nrow(Mt)
#   
#   Mt<-as.matrix(Mt[ind_row, ind_col])
# }
#################################### LOUV ###################################
nrow(networks)
nrow(unique(networks[,c("source", "target")]))
links <-as.matrix(networks[,c("source", "target")])
dim(links)

net <- graph_from_data_frame(d = networks, directed = FALSE)
net

E(net)
V(net)

G <-graph.edgelist(links)
M <- get.adjacency(G)

G1 = graph.adjacency(M, mode=c("undirected"))
plot(G1, vertex.label.color="black", edge.curved=.1)

cfg_louvain <- cluster_louvain(G1)
pdf("~/Documents/github/tbwd/plots/community-networks-louvain.pdf", width=6, height=6)
pdflouvain <- plot(cfg_louvain, G1)
dev.off()

#################################### SNN ####################################
# Calling SSN function
df <- acast(networks, (networks$source) ~ (networks$target), value.var = "link", fill=0, drop = TRUE)
MSNN<-as.matrix(df)

# Expand your matrix to a full-fledged adjacency matrix
expand.matrix <- function(A){
  m <- nrow(A)
  n <- ncol(A)
  B <- matrix(0,nrow = m, ncol = m)
  C <- matrix(0,nrow = n, ncol = n)
  cbind(rbind(B,t(A)),rbind(A,C))
}

# Remove the ones with no edge
ind_row <- rowSums(MSNN == 0) != ncol(MSNN)
ind_col <- colSums(MSNN == 0) != nrow(MSNN)

MSNN2 <-as.matrix(MSNN[ind_row, ind_col])

G2 <- graph.adjacency(expand.matrix(MSNN2), mode="undirected")
Madj <- get.adjacency(G2)

# Calling SNN function and plotting the SNN graph returned by SNN GRAPH function.
k<-1
GNN <- SNN_GRAPH(Madj, k)
tkid <- tkplot(GNN,vertex.label.color="black", vertex.size=29)
l <- tkplot.getcoords(tkid)
tk_close(tkid, window.close = T)

pdf("~/Documents/github/tbwd/plots/community-networks-snn.pdf", width=6, height=6)
pdfsnn <- plot(GNN, layout=l)
dev.off()

# Plot the SNN graph returned by SNN_GRAPH with Louvain function
pdf("~/Documents/github/tbwd/plots/community-networks-snn-louvain.pdf", width=6, height=6)
cfg_louvain_snn <- cluster_louvain(GNN)
pdfsnnlouvain <- plot(cfg_louvain_snn, GNN)
dev.off()

# G = graph.data.frame(d = as.data.frame(MSNN), directed = FALSE)
# Output = SNN_Clustering(G,3)
# Output
#################################### END ####################################
# Newman: greedy modularity
# cfg_newman <- cluster_fast_greedy(as.undirected(G2))