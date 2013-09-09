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
      @userstate = options.userState
      @userstateDfd = if @userstate.gadget.get("id") then @userstate.fetch() else new $.Deferred().resolve()

      options.propertySheetSchema.set('cypherSetup', {type:'Text', title:"DB setup query (unimplemented)"})
      options.propertySheetSchema.set('cypherSetup2', {type:'Text', title:"Initial viz (unimplemented)"})
      options.propertySheetSchema.set('cypherTask', {type:'Text', title:"Task"})
      options.propertySheetSchema.set('cypherSetup4', {type:'Text', title:"Task-check (unimplemented)"})

    render: ->
      @$el.html(@tpl)

      @viz = new Visualization(@$el.find('.visualization'))

      applyResetButton = @config.get('cypherTask') && @config.get('cypherTask').length > 1
      @input = new Input(@$el.find('.input'), applyResetButton)
      @input.render()
      _.bindAll @, "submitQuery"
      @input.on 'query', @submitQuery

      @table = new Table(@$el.find('.query-table'))
      @error = new Error(@$el.find('.error-container'))

      @setTask()

      @history = []
      @currentIndex = 0
      @input.on "loadHistory", (tempFuture) =>
        return if @currentIndex == 0
        if tempFuture
          @addToHistory(tempFuture)
        @currentIndex--
        @input.setQuery(@history[@currentIndex])
        @input.enableFuture()
        if @currentIndex == 0
          @input.disablePast()

      @input.on "loadFuture", () =>
        return if @currentIndex == @history.length-1
        @currentIndex++
        @input.setQuery(@history[@currentIndex])
        @input.enablePast() unless @currentIndex == 0
        if @currentIndex == @history.length-1
          @input.disableFuture()

      @input.on "reset", =>
        @viz.empty()
        q = new Cypher(@userstate.get("uuid"))
        q.empty()


      @userstateDfd.done =>
        unless @userstate.get("uuid")
          s4 = -> Math.floor((1 + Math.random()) * 0x10000).toString(16).substring(1)
          uuid = s4()+s4()+s4()+s4()+s4()
          @userstate.save({uuid:uuid})
        @createCypher()
      #@createCypher()

    createCypher: ->
      q = new Cypher(@userstate.get("uuid"))
      q.submitQuery("create (n{}) delete n").done((res) =>
        @viz.create(JSON.parse(res).visualization)
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
          @addToHistory query
          @table.render q.interpret(json), query
          @viz.draw(json.visualization)
          @viz.setPadding(20+@table.$el.width())
      ).fail((xhr, err, msg) => @error.render(msg))

    addToHistory: (query) ->
      @history.push(query)
      @currentIndex = @history.length-1
      @input.enablePast() unless @currentIndex == 0
      @input.disableFuture()