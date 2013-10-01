versal-cypher-gadget
====================

Versal course gadget for Cypher problem solving.

To run, you'll need to publish to versal with the versal sdk (since it depends on the course player for some things). email mikes@versal.com for help as this isn't open to the public yet!

There is no build process, just `coffee -c .` to compile from coffeescript and publish.


Tasks
========

You can either create tasks [here](https://github.com/neo4j-contrib/versal-cypher-gadget/blob/master/data/tasks.coffee) which will give you scripting access (will require to republish gadget) or you can input a json blob for tasks in the gadget's properties.

Here is an example task blob:


`{
  "message": "Lab: Find the 5 busiest actors in this dataset, use what you've learned",
  "tasks": [
    {
      "check": "input",
      "test": ":ACTED_IN",
      "failMsg": "Your paths should use the ACTED_IN relationship"
    },
    {
      "check": "output",
      "results": "Gene Hackman",
      "failMsg": "We expected someone else."
    }
  ]
}`

There are two types of task checks, "input" and "output," input checks the query text (as a case-insensitive regex) before it's sent. Output will check the response from the server in **only one** of two ways, either by checking the query response with "results" or by checking the entire graph with "test."

For example:

`{
  "message": "Create a node named 'Keanu Reeves'",
  "tasks": [
    {
      "check": "output",
      "results": "Keanu Reeves",
      "failMsg": "FAIL"
    }
  ]
}`

 will fail with `CREATE {name:"Keanu"}` because "results" checks the response that populates the gadget's query response table.  `CREATE (m {name:"Keanu"}) RETURN m` will succeed, however. As well, instead of "results", `"test": "Keanu Reeves"` in the json above will succeed because now it's checking against the whole graph.

Each input task will be checked in order, then each output task in order - if a task fails it will display the failMsg and **not** check subsequent tasks, so one error shows at a time.

The order of precedence for errors is:

- Syntax (generated by backed)
- Input
- Output "results" (check query response)
- Output "test" (check graph after query)
