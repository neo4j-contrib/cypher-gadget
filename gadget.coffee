define ["views/input", "views/table/table", "views/visualization", "views/error", "models/cypher", "./taskchecker", "data/tasks"], (Input, Table, Visualization, Error, Cypher, taskchecker, taskslib) ->

  class CypherGadget
    tpl: """
      <div class="cypherGadget">
        <div class="task-msg"></div>
        <div class="not-task">
          <div class="visualization"></div>
          <div class="input"></div>
          <div class="query-table"></div>
          <div class="error-container"></div>
        </div>
      </div>
    """

    constructor: (options) ->
      @$el = options.$el
      @player = options.player
      @player.on "domReady", @render, @
      @config = options.config
      @config.on "change:cypherTask", @setTaskMsg, @
      @config.on "change:cypherSetup", @createCypher, @
      @userstate = options.userState
      @userstateDfd = if @userstate.gadget.get("id") then @userstate.fetch() else new $.Deferred().resolve()

      options.propertySheetSchema.set('cypherSetup',
        {
          type:'Select',
          title:"DB setup key",
          options:
            [
              {val:"", label:"None"},
              {val:"users-graph", label:"Actors"}
            ]
        }
      )
      options.propertySheetSchema.set('cypherSetup2', {type:'Text', title:"Initial viz (unimplemented)"})
      options.propertySheetSchema.set('cypherTask', {type:'Select', title:"Task", options:["None"].concat(_.keys(taskslib))})

    render: ->
      @$el.html(@tpl)

      @$el.on("click", => @setSuccessful())

      @viz = new Visualization(@$el.find('.visualization'))

      _.bindAll @, "onQuery"

      @table = new Table(@$el.find('.query-table'))
      @error = new Error(@$el.find('.error-container'))

      @setTaskMsg()

      @table.on "dismissed", =>
        @viz.showDefault()

      @userstateDfd.done =>
        unless @userstate.get("uuid")
          s4 = -> Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1)
          uuid = s4()+s4()+s4()+s4()+s4()
          @userstate.save({uuid:uuid})
        @createCypher()

        if @userstate.get("successful")
          @setSuccessful()

        @input = new Input(@$el.find('.input'), @userstate)
        @input.render()
        @input.on 'query', @onQuery
        @input.on 'reset', =>
          @viz.empty()
          q = new Cypher(@userstate.get("uuid"))
          q.empty()
          @table.dismiss()

    createCypher: ->
      q = new Cypher(@userstate.get("uuid"))
      q.init(@config.get("cypherSetup")).done((res) =>
        @viz.create(res.visualization)
        @table.setMaxHeight @viz.height
      ).fail((xhr, err, msg) => @error.render(msg))

    setTaskMsg: ->
      taskDiv = @$el.find('.task-msg')
      task = @config.get("cypherTask")
      if task && task != "None"
        taskDiv.show()
        taskDiv.text(taskslib[task].message)
      else
        taskDiv.hide()

    setTaskError: (errMsg) ->
      @$el.find('.task-error').text(errMsg)

    onQuery: (query) ->
      if cypherTask = @config.get("cypherTask")
        @errors = taskchecker.checkInputTasks taskslib[cypherTask], query
        if errors.length > 0
          @error.render errors[0]
      @submitQuery(query)

    setSuccessful: ->
      @$el.find('.task-msg').addClass("successful")

    submitQuery: (query) ->
      q = new Cypher(@userstate.get("uuid"))
      q.submitQuery(query).done((res) =>
        @error.dismiss()
        json = JSON.parse(res)
        if json.error
          @$el.find('.error-msg').text(json.error)
        else
          @input.addToHistory query
          interpreted = q.interpret(json)
          @viz.draw(json.visualization)
          if interpreted.rows.length > 0
            @table.render q.interpret(json), query
            @viz.setPadding(20+@table.$el.width())
          else
            @table.dismiss()
          if cypherTask = @config.get("cypherTask")
            @errors.concat taskchecker.checkOutputTasks taskslib[cypherTask], json
            if @errors.length > 0
              @error.render @errors[0]
            else
              @setSuccessful()
              @userstate.save("successful", true)

      ).fail((xhr, err, msg) => @error.render(msg))

