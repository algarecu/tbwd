betweennessBasedClustering <-
function(G,mode="edge",threshold=0.5,normalize=TRUE)
{

if(class(G)[1]=="igraph")
{
K = igraph.to.graphNEL(G)
G = K
}
Original_G =G
if(mode=="vertex")
{

Clusters=list()
removedVertices = c()
adj_mat = as(G,"matrix")
while(numNodes(G)>0)
{
NormalizeFactor = ((numNodes(G)-1)*(numNodes(G)-2))/2
AllResults = brandes.betweenness.centrality(G)
VertexBetweenness = AllResults$betweenness.centrality.vertices
UnNormalized = VertexBetweenness
if(normalize==TRUE){
VertexBetweenness =VertexBetweenness/NormalizeFactor
}
sortexVertexBetweenness = sort(VertexBetweenness,decreasing=TRUE,index.return=TRUE)
MostBetweennessVertex = sortexVertexBetweenness$ix[1]
removeVertex = nodes(G)[MostBetweennessVertex]
highestValue = sortexVertexBetweenness$x[1]
if(highestValue>=threshold)
{
#print(MostBetweennessVertex)
G = removeNode(paste(removeVertex),G)
removedVertices = c(removedVertices,removeVertex)
}
else
{
break
}

}

if(numNodes(G)>0){
Clusters =  connectedComp(G)
for(j in 1:length(Clusters))
{
currClust = Clusters[[j]]
#print(currClust)
for(k in 1:length(removedVertices)){
currNode = removedVertices[k]
#print(currNode)
if(isConnected(subGraph(c(currClust,paste(currNode)),Original_G))==TRUE){
Clusters[[j]] = c(Clusters[[j]],currNode)
}
}

}

}
NormalizeFactor = ((numNodes(G)-1)*(numNodes(G)-2))/2
AllResults = brandes.betweenness.centrality(G)
VertexBetweenness = AllResults$betweenness.centrality.vertices
UnNormalized = VertexBetweenness
if(normalize==TRUE){
VertexBetweenness =VertexBetweenness/NormalizeFactor
}

return(list("Resulting Graph (G)" =G,"Clusters Identified" =Clusters,"UnNormalized Vertex Betweenness for G"=UnNormalized,"Normalized Vertex Betweenness for G"=VertexBetweenness))

}
else
{if(mode=="edge")
{

while(numEdges(G)>0)
{
#NormalizeFactor = ((numNodes(G)-1)*(numNodes(G)-2))/2
NormalizeFactor = (numNodes(G)*(numNodes(G)-1))/2

AllResults = brandes.betweenness.centrality(G)
EdgeBetweenness = AllResults$betweenness.centrality.edges
UnNormalized = EdgeBetweenness
if(normalize==TRUE){
EdgeBetweenness = EdgeBetweenness/NormalizeFactor
}
sortedEdgeBetweenness = sort(EdgeBetweenness,decreasing=TRUE,index.return=TRUE)
MostBetweennessEdge = sortedEdgeBetweenness$ix[1]
removeEdgeFrom = AllResults$edges[1,MostBetweennessEdge]
removeEdgeTo = AllResults$edges[2,MostBetweennessEdge]
highestValue = sortedEdgeBetweenness$x[1]
if(highestValue>=threshold)
{
G = removeEdge(paste(removeEdgeFrom),paste(removeEdgeTo),G)
}
else
{
break
}

}
NormalizeFactor = (numNodes(G)*(numNodes(G)-1))/2
AllResults = brandes.betweenness.centrality(G)
EdgeBetweenness = AllResults$betweenness.centrality.edges
UnNormalized = EdgeBetweenness
if(normalize==TRUE){
EdgeBetweenness = EdgeBetweenness/NormalizeFactor
}

Clusters =  connectedComp(G)
return(list("Resulting Graph (G)"=G,"Clusters Identified" =Clusters,"UnNormalized Edge Betweenness for G"=UnNormalized,"Normalized Edge Betweenness for G"=EdgeBetweenness))

}

}

}

