from igraph import *
import louvain
import utility


def louvain_communities ():

    try:

        #vertices = [i for i in range(7)]

        vertices = utility.nodes_redone()

        #edges = [(0, 2), (0, 1), (0, 3), (1, 0), (1, 2), (1, 3), (2, 0), (2, 1), (2, 3), (3, 0), (3, 1), (3, 2), (2, 4),
         #        (4, 5), (4, 6), (5, 4), (5, 6), (6, 4), (6, 5)]

        #g = Graph(vertex_attrs={"label": vertices}, edges=edges, directed=True)

        #part =  louvain.find_partition(g, method='Modularity')

        #print(part)

        edges = utility.edges_redone()

        #nodes = utility.nodes_label()

        G = Graph(vertex_attrs={"label":vertices}, edges=edges, directed=False)

        part = louvain.find_partition(G, method='Modularity')

        print(part)




        #print(G)

    except Exception as e:
        print(e)



def louvain_communities_autonomous_system ():

    try:

        #vertices = [i for i in range(7)]

        vertices = utility.as_nodes()

        #edges = [(0, 2), (0, 1), (0, 3), (1, 0), (1, 2), (1, 3), (2, 0), (2, 1), (2, 3), (3, 0), (3, 1), (3, 2), (2, 4),
         #        (4, 5), (4, 6), (5, 4), (5, 6), (6, 4), (6, 5)]

        #g = Graph(vertex_attrs={"label": vertices}, edges=edges, directed=True)

        #part =  louvain.find_partition(g, method='Modularity')

        #print(part)

        edges = utility.as_adges()

        #nodes = utility.nodes_label()

        G = Graph(vertex_attrs={"label":vertices}, edges=edges, directed=False)

        part = louvain.find_partition(G, method='Modularity')

        print(part)




        #print(G)

    except Exception as e:
        print(e)