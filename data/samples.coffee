define [], () ->
  {
    read: [
      {
        desc: "Get all of the nodes in a graph"
        query: "MATCH (x)
              \nRETURN x"
      }, {
        desc: "Get all of the nodes and relationships between nodes."
        query: "MATCH (n)-[r]->(m)
              \nRETURN n as node_a, r as relates_to, m as node_b"
      }, {
        desc: "Get a single node's relationships"
        query: "MATCH (a:Actor)-[r]->(b)
              \nWHERE a.name = 'Keanu Reeves'
              \nRETURN a, r, b"
      }
    ], write: [
      {
        desc: "Create a node with the name \"Bob\" and label \"Person\""
        query: "CREATE (n:Person {name:'Bob'})"
      }, {
        desc: "Create a relationship between two nodes"
        query: "MATCH a, b
              \nWHERE a.name = 'Bert' AND b.name = 'Ernie'
              \nCREATE a-[r:LIKES]->b
              \nRETURN r"
      }, {
        desc: "Delete all nodes with the name \"Bob\""
        query: "START b=node(*)
                  \nWHERE b.name='Bob'
                  \nDELETE b"
      }, {
        desc: "colors (development purposes)"
        query:"CREATE (r {name:'red'}), (b {name:'blue'})
              \nCREATE (col {name:'color'})
              \nCREATE r-[:IS]->col, b-[:IS]->col"
      }, {
        desc: "shakespeare (development purposes)"
        query: "CREATE (shakespeare:Author { firstname: 'William' , lastname: 'Shakespeare' }),\n(juliusCaesar:Character { title: 'Julius Caesar' }),\n(shakespeare)-[:WROTE_PLAY { year: 1599 }]->(juliusCaesar),\n(theTempest:Play { title: 'The Tempest' }),\n(shakespeare)-[:WROTE_PLAY { year: 1610 }]->(theTempest),\n(rsc:Company { name: 'RSC' }),\n(production1:Production { name: 'Julius Caesar' }),\n(rsc)-[:PRODUCED]->(production1),\n(production1)-[:PRODUCTION_OF]->(juliusCaesar),\n(performance1:Performance { date: 20120729 }),\n(performance1:Performance)-[:PERFORMANCE_OF]->(production1),\n(production2:Production { name: 'The Tempest' }),\n(rsc)-[:PRODUCED]->(production2),\n(production2)-[:PRODUCTION_OF]->(theTempest),\n(performance2:Performance { date: 20061121 }),\n(performance2)-[:PERFORMANCE_OF]->(production2),\n(performance3:performance { date: 20120730 }),\n(performance3)-[:PERFORMANCE_OF]->(production1),\n(billy:Person { name: 'Billy' }),\n(review:Review { rating: 5, review: 'This was awesome!' }),\n(billy)-[:WROTE_REVIEW]->(review),\n(review)-[:RATED]->(performance1),\n(theatreRoyal:Venue { name: 'Theatre Royal' }),\n(performance1)-[:VENUE]->(theatreRoyal),\n(performance2)-[:VENUE]->(theatreRoyal),\n(performance3)-[:VENUE]->(theatreRoyal),\n(greyStreet:Street { name: 'Grey Street' }),\n(theatreRoyal)-[:STREET]->(greyStreet),\n(newcastle:City { name: 'Newcastle' }),\n(greyStreet)-[:CITY]->(newcastle),\n(tyneAndWear:County { name: 'Tyne and Wear' }),\n(newcastle)-[:COUNTY]->(tyneAndWear),\n(england:Country { name: 'England' }),\n(tyneAndWear)-[:COUNTRY]->(england),\n(stratford:City { name: 'Stratford upon Avon' }),\n(stratford)-[:COUNTRY]->(england),\n(rsc)-[:BASED_IN]->(stratford),\n(shakespeare)-[:BORN_IN]->stratford"
      }, {
        desc: "small movies (development purposes)"
        query:"CREATE (TheMatrix:Movie {title:'The Matrix', released:1999, tagline:'Welcome to the Real World'})
                    \nCREATE (Keanu:Person {name:'Keanu Reeves', born:1964})
                    \nCREATE (Carrie:Person {name:'Carrie-Anne Moss', born:1967})
                    \nCREATE (Laurence:Person {name:'Laurence Fishburne', born:1961})
                    \nCREATE (Hugo:Person {name:'Hugo Weaving', born:1960})
                    \nCREATE (AndyW:Person {name:'Andy Wachowski', born:1967})
                    \nCREATE (LanaW:Person {name:'Lana Wachowski', born:1965})
                    \nCREATE (JoelS:Person {name:'Joel Silver', born:1952})
                    \nCREATE
                    \n  (Keanu)-[:ACTED_IN {roles:['Neo']}]->(TheMatrix),
                    \n  (Carrie)-[:ACTED_IN {roles:['Trinity']}]->(TheMatrix),
                    \n  (Laurence)-[:ACTED_IN {roles:['Morpheus']}]->(TheMatrix),
                    \n  (Hugo)-[:ACTED_IN {roles:['Agent Smith']}]->(TheMatrix),
                    \n  (AndyW)-[:DIRECTED]->(TheMatrix),
                    \n  (LanaW)-[:DIRECTED]->(TheMatrix),
                    \n  (JoelS)-[:PRODUCED]->(TheMatrix)
                    \n
                    \nCREATE (Emil:Person {name:'Emil Eifrem', born:1978})
                    \nCREATE (Emil)-[:ACTED_IN {roles:['Emil']}]->(TheMatrix)
                    \n
                    \nCREATE (TheMatrixReloaded:Movie {title:'The Matrix Reloaded', released:2003, tagline:'Free your mind'})
                    \nCREATE
                    \n  (Keanu)-[:ACTED_IN {roles:['Neo']}]->(TheMatrixReloaded),
                    \n  (Carrie)-[:ACTED_IN {roles:['Trinity']}]->(TheMatrixReloaded),
                    \n  (Laurence)-[:ACTED_IN {roles:['Morpheus']}]->(TheMatrixReloaded),
                    \n  (Hugo)-[:ACTED_IN {roles:['Agent Smith']}]->(TheMatrixReloaded),
                    \n  (AndyW)-[:DIRECTED]->(TheMatrixReloaded),
                    \n  (LanaW)-[:DIRECTED]->(TheMatrixReloaded),
                    \n  (JoelS)-[:PRODUCED]->(TheMatrixReloaded)
                    \n
                    \nCREATE (TheMatrixRevolutions:Movie {title:'The Matrix Revolutions', released:2003, tagline:'Everything that has a beginning has an end'})
                    \nCREATE
                    \n  (Keanu)-[:ACTED_IN {roles:['Neo']}]->(TheMatrixRevolutions),
                    \n  (Carrie)-[:ACTED_IN {roles:['Trinity']}]->(TheMatrixRevolutions),
                    \n  (Laurence)-[:ACTED_IN {roles:['Morpheus']}]->(TheMatrixRevolutions),
                    \n  (Hugo)-[:ACTED_IN {roles:['Agent Smith']}]->(TheMatrixRevolutions),
                    \n  (AndyW)-[:DIRECTED]->(TheMatrixRevolutions),
                    \n  (LanaW)-[:DIRECTED]->(TheMatrixRevolutions),
                    \n  (JoelS)-[:PRODUCED]->(TheMatrixRevolutions)"
      }
    ]
  }

