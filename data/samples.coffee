define [], () ->
  {
    read: [
      {
        desc: "Get all of the nodes in a graph"
        query: "MATCH (x)
              \nRETURN x;"
      }, {
        desc: "Get all nodes and relationships between nodes, naming the columns"
        query: "MATCH (n)-[r]->(m)
              \nRETURN n as node_a, r as relates_to, m as node_b;"
      }, {
        desc: "Find a specific node (within all-nodes)"
        query: "MATCH (n)
              \nWHERE has(n.name) AND n.name = \"Hugo Weaving\"
              \nRETURN n;"
      }, {
        desc: "Naming a relationship and returning its type"
        query: "MATCH (a)-[r]-> ()
              \nRETURN a.name, type(r);"
      }, {
        desc: "Matching a relationship type"
        query: "MATCH (a) -[:ACTED_IN]-> (m)
              \nRETURN a, m;"
      }
    ], write: [
      {
        desc: "Create a node with the name \"Mystic River\" and label \"Movie\""
        query: "CREATE (m:Movie {title:\"Mystic River\", released:1993})"
      }, {
        desc: "Add a property (tagline) to a node (Mystic River)."
        query: "MATCH (movie:Movie)
              \nWHERE movie.title=\"Mystic River\"
              \nSET movie.tagline = \"We bury our sins here, Dave. We wash them clean\"
              \nRETURN movie;"
      }, {
        desc: "Create a relationship between two nodes (Kevin Bacon in Mystic River)"
        query: "MATCH (movie:Movie),(kevin:Person)
              \nWHERE movie.title=\"Mystic River\" AND kevin.name=\"Kevin Bacon\"
              \nCREATE UNIQUE (kevin)-[:ACTED_IN {roles:[\"Sean\"]}]->(movie)"
      }, {
        desc: "Delete all nodes with the name \"Mystic River\""
        query: "START b=node(*)
              \nWHERE b.name=\"Mystic River\"
              \nDELETE b;"
      }
    ]
  }

