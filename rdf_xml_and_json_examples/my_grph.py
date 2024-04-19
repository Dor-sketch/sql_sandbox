from rdflib import Graph

# Load the RDF data from the file
g = Graph()
g.parse("q1_rdf.rdf")

# Iterate over the triples in the graph and print them
for s, p, o in g:
    print(s, p, o)