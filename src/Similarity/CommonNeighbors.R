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

# Read cyberlocker sites to CSV
networks <- read.csv("~/Documents/github/tbwd/datasets/networks.csv", header=TRUE, sep=",", as.is = T)
domains <- read.csv("~/Documents/github/tbwd/datasets/domains.csv", header=TRUE, sep=",", as.is = T)
html <- read.csv("~/Documents/github/tbwd/datasets/html-t90.csv", header=TRUE, sep=",", as.is = T)

# nrow(unique(domains[,c("source", "target")]))
#################################### GRAPH ###################################
# Converting to format to call SSN_GRAPH function
df_domains <- acast(domains, (domains$source) ~ (domains$target), value.var = "link", fill=0)
df_networks <- acast(networks, (networks$source) ~ (networks$target), value.var = "link", fill=0)
df_html <- acast(html, (html$source) ~ (html$target), value.var = "link", fill=0)

links_domains <-as.matrix(domains[,c("source", "target")])
links_networks <-as.matrix(networks[,c("source", "target")])
links_html <-as.matrix(html[,c("source", "target")])

net_domains <- graph_from_data_frame(d = domains, directed = FALSE)
net_networks <- graph_from_data_frame(d = networks, directed = FALSE)
net_html <- graph_from_data_frame(d = html, directed = FALSE)

#################################### END GRAPH ####################################

#################################### START DOMAINS ###############################
G_domains <-graph.edgelist(links_domains)
M_domains <- get.adjacency(G_domains)
G1_domains = graph.adjacency(M_domains, mode=c("undirected"))
plot(G1_domains, vertex.label.color="black", edge.curved=.1)

# Matrix for domains
MSNN_domains<-as.matrix(df_domains)

# Labels for domains
domains_labels <- unique(melt(domains$source, domains$target))

# Expand your matrix to a full-fledged adjacency matrix
expand.matrix <- function(A){
  m <- nrow(A)
  n <- ncol(A)
  B <- matrix(0,nrow = m, ncol = m)
  C <- matrix(0,nrow = n, ncol = n)
  cbind(rbind(B,t(A)),rbind(A,C))
}

# Remove the ones with no edge
ind_row <- rowSums(MSNN_domains == 0) != ncol(MSNN_domains)
ind_col <- colSums(MSNN_domains == 0) != nrow(MSNN_domains)

# MSNN2 <-as.matrix(MSNN_domains[ind_row, ind_col])
G2_domains <- graph.adjacency(expand.matrix(MSNN_domains), mode="undirected")
Madj <- get.adjacency(G2_domains)

# Calling SNN function and plotting the SNN graph returned by SNN GRAPH function.
k<-1
GNN_domains <- SNN_GRAPH(Madj, k)

# Plot the SNN graph returned by SNN_GRAPH
pdf("~/Documents/github/tbwd/plots/community-domains-snn.pdf", width=10, height=10)
pdfdomainssnn <- plot(GNN_domains, vertex.label=domains_labels$value, vertex.label.color="black", edge.curved=.3)
dev.off()

domains_louvain <- cluster_louvain(G1_domains)
pdf("~/Documents/github/tbwd/plots/community-domains-louvain.pdf", width=10, height=10)
domainslouvain <- plot(domains_louvain, G1_domains, vertex.label.color="black", edge.curved=.3)
dev.off()

#################################### END DOMAINS ###############################

#################################### START NETWORKS ###############################
G_networks <-graph.edgelist(links_networks)
M_networks <- get.adjacency(G_networks)
G1_networks = graph.adjacency(M_networks, mode=c("undirected"))
plot(G1_networks, vertex.label.color="black", edge.curved=.1)

# Matrix for networks
MSNN_networks <- as.matrix(df_networks)

# Labels for networks
networks_labels <- unique(melt(networks$source, networks$target))

# Calling SNN function and plotting the SNN graph returned by SNN GRAPH function.
k<-1
GNN_networks <- SNN_GRAPH(MSNN_networks, k)

# Plot the SNN graph returned by SNN_GRAPH
pdf("~/Documents/github/tbwd/plots/community-networks-snn.pdf", width=10, height=10)
networks_snn <- plot(GNN_networks, vertex.label=networks_labels$value, vertex.label.color="black", edge.curved=.3)
dev.off()

networks_louvain <- cluster_louvain(G1_networks)
pdf("~/Documents/github/tbwd/plots/community-networks-louvain.pdf", width=10, height=10)
networks_louvain <- plot(networks_louvain, G1_networks,vertex.label.color="black", edge.curved=.3)
dev.off()

#################################### END NETWORK ###############################

#################################### START HTML ####################################  
G_html <-graph.edgelist(links_html)
M_html <- get.adjacency(G_html)
G1_html = graph.adjacency(M_html, mode=c("undirected"))
plot(G1_html, vertex.label.color="black", edge.curved=.1)

# Matrix for html
MSNN_html<-as.matrix(df_html)

# Labels for html
html_labels <- unique(melt(html$source, html$target))

MSNN_html[MSNN_html < 90] <- 0
MSNN_html[MSNN_html > 90] <- 1

# Set diagonal back to zero
diag(MSNN_html) <- 0

# Remove the ones with no edge
ind_row <- rowSums(MSNN_html == 0) != ncol(MSNN_html)
ind_col <- colSums(MSNN_html == 0) != nrow(MSNN_html)

MSNN_html<-as.matrix(MSNN_html[ind_row, ind_col])

# Calling SNN function and plotting the SNN graph returned by SNN GRAPH function.
k<-1
GNN_html <- SNN_GRAPH(MSNN_html, k)

# Plot the SNN graph returned by SNN_GRAPH
pdf("~/Documents/github/tbwd/plots/community-html-t90-snn.pdf", width=10, height=10)
pdfsnn <- plot(GNN_html, vertex.label.color="black", vertex.label=html_labels$value)
dev.off()

html_louvain <- cluster_louvain(G1_html)
pdf("~/Documents/github/tbwd/plots/community-html-t90-louvain.pdf", width=10, height=10)
htmllouvain <- plot(html_louvain, G1_html)
dev.off()

#################################### END HTML #################################### 
# G = graph.data.frame(d = as.data.frame(MSNN), directed = FALSE)
# Output = SNN_Clustering(G,3)
# Output

# Newman: greedy modularity
# cfg_newman <- cluster_fast_greedy(as.undirected(G2))