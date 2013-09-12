define ["views/input", "views/table/table", "views/visualization", "views/error", "models/cypher"], (Input, Table, Visualization, Error, Cypher) ->

  class CypherGadget
    tpl: """
      <div class="cypherGadget">
        <div class="task"></div>
        <div class="visualization"></div>
        <div class="input"></div>
        <div class="query-table"></div>
        <div class="error-container"></div>
      </div>
    """

    constructor: (options) ->
      @$el = options.$el
      @player = options.player
      @player.on "domReady", @render, @
      @config = options.config
      @config.on "change:cypherTask", @setTask, @
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
      options.propertySheetSchema.set('cypherTask', {type:'Text', title:"Task"})

    render: ->
      @$el.html(@tpl)

      @viz = new Visualization(@$el.find('.visualization'))

      _.bindAll @, "submitQuery"

      @table = new Table(@$el.find('.query-table'))
      @error = new Error(@$el.find('.error-container'))

      @setTask()


      @table.on "dismissed", =>
        @viz.showDefault()

      @userstateDfd.done =>
        unless @userstate.get("uuid")
          s4 = -> Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1)
          uuid = s4()+s4()+s4()+s4()+s4()
          @userstate.save({uuid:uuid})
        @createCypher()

        @input = new Input(@$el.find('.input'), @userstate)
        @input.render()
        @input.on 'query', @submitQuery
        @input.on 'reset', =>
          @viz.empty()
          q = new Cypher(@userstate.get("uuid"))
          q.empty()
          @table.dismiss()

    createCypher: ->
      q = new Cypher(@userstate.get("uuid"))
      q.init(@config.get("cypherSetup")).done((res) =>
        @viz.create(res.visualization)
      ).fail((xhr, err, msg) => @error.render(msg))

    setTask: ->
      taskDiv = @$el.find('.task')
      if @config.get("cypherTask")
        taskDiv.show()
        taskDiv.text(@config.get('cypherTask'))
      else
        taskDiv.hide()

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

      ).fail((xhr, err, msg) => @error.render(msg))

