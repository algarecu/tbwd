Neumann_Kernel<-function(g)
{
	#Get adjacency matrix for graph g and get transpose of it.
 	A<-get.adjacency(g)
 	A_Transpose<-t(A)
 	#K and M are two matrix calculated using adjacency
 	#matrix and its transpose.
 	K<-A_Transpose %*% A
 	M<-A %*% A_Transpose
 	#Calculate number of nodes referring the current node
 	#and the number of nodes current node is referring.
	inDegree<-degree(g,mode=c("in"))
	outDegree<-degree(g,mode=c("out"))
 	#Get the maximum out of both inDegree and outDegree.
	maxInDegree<-max(inDegree)
 	maxOutDegree<-max(outDegree)
 	#Calculate the decay factor.
	Gamma<-1/min(maxInDegree,maxOutDegree)
 	A_Dimension<-dim(A)
	#Get identity matrix of dimension of A.
 	I=diag(nrow=A_Dimension[1],ncol=A_Dimension[2])
 	#Inverse1 and Inverse2 is calculated to use it
 	#in final Neumann Kernel matrix calculation.
 	#Here solve function gives inverse of the matrix.
	Inverse1<-solve(I-(Gamma*K))
 	Inverse2<-solve(I-(Gamma*M))
 	#Below are the two Neumann Kernel Matrix calculations.
 	K_Gamma<-K %*% Inverse1
 	M_Gamma<-M %*% Inverse2
 	#These two matrices are combined using cbind command and then returned.
	ans<-cbind(K_Gamma,M_Gamma)
	return(ans)
 	
}
SNN_GRAPH<-function(adj_mat,K) 
{
	# Get number of nodes in adjacency matrix
       no_of_nodes=ncol(adj_mat);
	# Create square matrix of size same as adjacency matrix and initialize it to zero
       KNN_ADJ=matrix(c(0),nrow=no_of_nodes,ncol=no_of_nodes);
	# Loop through each row of adjacency matrix
       for ( rows in 1:(no_of_nodes) )
       {
		# Loop through all next rows of current row till we reach last row
               for (next_rows in (rows+1):(no_of_nodes))
               {

			
                       if((next_rows <= no_of_nodes) && (rows != next_rows))
                       {
				# Counter is used to measure number of shared neighbours
                               counter<-c(0);
				# Loop through each column of adjacency matrix
                               for(no_cols in 1:(no_of_nodes))
                               {
					#Common neighbours between two rows ia found and counter is incremented
                                       if((adj_mat[rows,no_cols]==1) && (adj_mat[next_rows,no_cols]==1))
                                       {
                                       		counter<-(counter+1);
                               	       }
                       	       }
				# If common neighbours between two rows of matrix are more than or equal to K
				# then make its entry in output adjacency matrix by putting 1 in corresponding position
                       	       if ( counter >= K )
                               {
                                       KNN_ADJ[rows,next_rows]<-c(1);        
                                       KNN_ADJ[next_rows,rows]<-c(1);
                               }
                       }
               }
       } 
	#Convert adjacency matrix to undirected,unweighted graph and return it
	G1<-graph.adjacency(KNN_ADJ , mode=c("undirected"), weighted=NULL);
	return (G1)
}
