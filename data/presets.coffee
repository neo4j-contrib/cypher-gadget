define [], () ->
  {
    "all_relationships": "MATCH (n)-[r]->(m)
                        \nRETURN n as node_a, r as relates_to, m as node_b"
    "all_nodes": "MATCH (x)
                  \nRETURN x"
    "colors":"CREATE (r {name:'red'}), (b {name:'blue'})
              \nCREATE (col {name:'color'})
              \nCREATE r-[:IS]->col, b-[:IS]->col"
    "matrix":"CREATE (matrix1 {id : '603', title : 'The Matrix', year : '1999-03-31'}),
              \n(matrix2 {id : '604', title : 'The Matrix Reloaded', year : '2003-05-07'}),
              \n(matrix3 {id : '605', title : 'The Matrix Revolutions', year : '2003-10-27'}),
              \n(neo {name:'Keanu Reeves'}),
              \n(morpheus {name:'Laurence Fishburne'}),
              \n(trinity {name:'Carrie-Anne Moss'}),
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
  }

