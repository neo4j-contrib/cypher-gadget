define [], () ->
  {
    "all_relationships": "MATCH (n)-[r]->(m)
                        \nRETURN n as node_a, r as relates_to, m as node_b"
    "all_nodes": "MATCH (x)
                  \nRETURN x"
    "create_node": "create ({name:'Bob'})"
    "create_rel": "MATCH a, b
                  \nWHERE a.name = 'Bert' AND b.name = 'Ernie'
                  \nCREATE a-[r:LIKES]->b
                  \nRETURN r"
    "delete_node": "START b=node(*)
                  \nWHERE b.name='Bob'
                  \nDELETE b"
    "a_nodes_relationships": "MATCH a:Actor-[r]->b
                            \nWHERE a.name = 'Keanu Reeves'
                            \nRETURN a, r, b"
    "colors":"CREATE (r {name:'red'}), (b {name:'blue'})
              \nCREATE (col {name:'color'})
              \nCREATE r-[:IS]->col, b-[:IS]->col"
    "matrix":"CREATE (matrix1:Movie {id : '603', title : 'The Matrix', year : '1999-03-31'}),
              \n(matrix2:Movie {id : '604', title : 'The Matrix Reloaded', year : '2003-05-07'}),
              \n(matrix3:Movie {id : '605', title : 'The Matrix Revolutions', year : '2003-10-27'}),
              \n(neo:Actor {name:'Keanu Reeves'}),
              \n(morpheus:Actor {name:'Laurence Fishburne'}),
              \n(trinity:Actor {name:'Carrie-Anne Moss'}),
              \n(matrix1)<-[:ACTS_IN {role : 'Neo'}]-(neo),
              \n(matrix2)<-[:ACTS_IN {role : 'Neo'}]-(neo),
              \n(matrix3)<-[:ACTS_IN {role : 'Neo'}]-(neo),
              \n(matrix1)<-[:ACTS_IN {role : 'Morpheus'}]-(morpheus),
              \n(matrix2)<-[:ACTS_IN {role : 'Morpheus'}]-(morpheus),
              \n(matrix3)<-[:ACTS_IN {role : 'Morpheus'}]-(morpheus),
              \n(matrix1)<-[:ACTS_IN {role : 'Trinity'}]-(trinity),
              \n(matrix2)<-[:ACTS_IN {role : 'Trinity'}]-(trinity),
              \n(matrix3)<-[:ACTS_IN {role : 'Trinity'}]-(trinity)"
    "shakespeare":"CREATE (shakespeare:Author { firstname: 'William' , lastname: 'Shakespeare' }),\n(juliusCaesar:Character { title: 'Julius Caesar' }),\n(shakespeare)-[:WROTE_PLAY { year: 1599 }]->(juliusCaesar),\n(theTempest:Play { title: 'The Tempest' }),\n(shakespeare)-[:WROTE_PLAY { year: 1610 }]->(theTempest),\n(rsc:Company { name: 'RSC' }),\n(production1:Production { name: 'Julius Caesar' }),\n(rsc)-[:PRODUCED]->(production1),\n(production1)-[:PRODUCTION_OF]->(juliusCaesar),\n(performance1:Performance { date: 20120729 }),\n(performance1:Performance)-[:PERFORMANCE_OF]->(production1),\n(production2:Production { name: 'The Tempest' }),\n(rsc)-[:PRODUCED]->(production2),\n(production2)-[:PRODUCTION_OF]->(theTempest),\n(performance2:Performance { date: 20061121 }),\n(performance2)-[:PERFORMANCE_OF]->(production2),\n(performance3:performance { date: 20120730 }),\n(performance3)-[:PERFORMANCE_OF]->(production1),\n(billy:Person { name: 'Billy' }),\n(review:Review { rating: 5, review: 'This was awesome!' }),\n(billy)-[:WROTE_REVIEW]->(review),\n(review)-[:RATED]->(performance1),\n(theatreRoyal:Venue { name: 'Theatre Royal' }),\n(performance1)-[:VENUE]->(theatreRoyal),\n(performance2)-[:VENUE]->(theatreRoyal),\n(performance3)-[:VENUE]->(theatreRoyal),\n(greyStreet:Street { name: 'Grey Street' }),\n(theatreRoyal)-[:STREET]->(greyStreet),\n(newcastle:City { name: 'Newcastle' }),\n(greyStreet)-[:CITY]->(newcastle),\n(tyneAndWear:County { name: 'Tyne and Wear' }),\n(newcastle)-[:COUNTY]->(tyneAndWear),\n(england:Country { name: 'England' }),\n(tyneAndWear)-[:COUNTRY]->(england),\n(stratford:City { name: 'Stratford upon Avon' }),\n(stratford)-[:COUNTRY]->(england),\n(rsc)-[:BASED_IN]->(stratford),\n(shakespeare)-[:BORN_IN]->stratford"
    "small_movies":"CREATE (TheMatrix:Movie {title:'The Matrix', released:1999, tagline:'Welcome to the Real World'})
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

