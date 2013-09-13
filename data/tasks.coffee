define [], () ->

  return {
    "test": {
      message: "Look for Keanu"
      tasks: [
        {
          check: "input"
          test: "Keanu"
          failMsg: "You should be querying on the name \"Keanu\""
        }, {
          check: "input"
          test: (query) ->
            # pass
            return true
            # return msg for failure
        }, {
          check: "output"
          test: (response) ->
            if response.json.length > 3
              return "Too many rows"
            return true
        }
      ]
    }
    test2: {
      message: "A second test"
      tasks: []
    }
  }