define [], () ->
  return {
    addingMysticRiver: {
      message: "Adding 'Mystic River'"
      tasks: [
          {
            "check": "input",
            "test": ":Movie",
            "failMsg": "You probably want to use the :Movie label"
          },
          {
            "check": "input",
            "test": "title",
            "failMsg": "There should be a title property in your query"
          },
          {
            "check": "input",
            "test": "Mystic River",
            "failMsg": "This movie is titled 'Mystic River'"
          },
          {
            "check": "output",
            "test": "Mystic River",
            "failMsg": "It makes sense to return the movie too. For validation"
          }
      ]
    }
    deleteEmil: {
      message: "Delete Emil and his relationships",
      tasks: [
        {
          "check": "input",
          "test": ":Person",
          "failMsg": "You'll want to start at nodes labeled Person"
        },
        {
          "check": "input",
          "test": "name.+Emil Eifrem",
          "failMsg": "You probably want to check the name property for 'Emil Eifrem'"
        },
        {
          "check": "input",
          "test": "OPTIONAL\\s+MATCH",
          "failMsg": "Remember not only to delete Emil but also to match his potential relationships and delete them."
        },
        {
          "check": "input",
          "test": "\\[\\w+\\]",
          "failMsg": "You probably wanted to assign an identifier to your relationship"
        },
        {
          "check": "input",
          "test": "DELETE",
          "failMsg": "You most probably want to DELETE Emil and his relationships"
        }
      ]
    }
    matchByNodeLabel: {
      message: "Run the simple queries you've just learned",
      tasks: [
        {
          "check": "input",
          "test": "match.+return",
          "failMsg": "Your query should contain at least a MATCH and RETURN clause"
        }
      ]
    }
    allCharactersMatrix: {
      message: "Lab: All Characters in the Matrix",
      tasks: [
        {
          "check": "input",
          "test": ":Movie",
          "failMsg": "You'll want to limit your nodes to ones labeled Movie"
        },
        {
          "check": "input",
          "test": "(\\.title|title:)",
          "failMsg": "You probably want to check the title property"
        },
        {
          "check": "input",
          "test": "The Matrix",
          "failMsg": "You wanted to look for the movie titled 'The Matrix'"
        },
        {
          "check": "input",
          "test": ":ACTED_IN",
          "failMsg": "Your paths should use the ACTED_IN relationship"
        },
        {
          "check": "input",
          "test": "\\w+:ACTED_IN",
          "failMsg": "You probably wanted to assign an identifier to your relationship"
        },
        {
          "check": "input",
          "test": "\\.roles",
          "failMsg": "You wanted to RETURN the roles property of the relationship"
        },
        {
          "check": "output",
          "results": "Neo",
          "failMsg": "We expected some other characters"
        }
      ]
    }
    allCharactersActedWithAndOlderThanTom: {
      message: "All the actors who acted with Tom Hanks and are older than him.",
      tasks: [
        {
          "check": "input",
          "test": ":Person",
          "failMsg": "You'll want to limit your nodes to ones labeled Person"
        },
        {
          "check": "input",
          "test": ":ACTED_IN",
          "failMsg": "Your paths should use the ACTED_IN relationship"
        },
        {
          "check": "input",
          "test": "\\.name",
          "failMsg": "You probably want to check the name property"
        },
        {
          "check": "input",
          "test": "Tom Hanks",
          "failMsg": "You wanted to look for Tom Hanks's colleagues"
        },
        {
          "check": "input",
          "test": "\\.born [<>]",
          "failMsg": "Compare the born (year) property"
        },
        {
          "check": "output",
          "results": "Jim Broadbent",
          "failMsg": "We expected someone else."
        }
      ]
    }  
  }

# stopped here: https://versal.com/c/z3mdw4/edit/lessons/14