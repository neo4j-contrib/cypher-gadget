define [], () ->

  class Taskchecker

    checkOutputTasks: (task, json) ->
      outputTasks = _.filter task.tasks, (t) -> t.check == "output"
      results = _.map outputTasks, (task) =>
        return task.test(json)
      return _.reject results, (r) -> r == true

    # checks the input before it is being sent
    checkInputTasks: (task, query) ->
      inputTasks = _.filter task.tasks, (t) -> t.check == "input"
      results = _.map inputTasks, (task) =>
        if typeof task.test == "string"
          regexMatch = query.match(task.test)
          if regexMatch
            return true
          else
            return task.failMsg
        else
          return task.test(query)
      return _.reject results, (r) -> r == true

  new Taskchecker()
