define ["views/input", "views/table/table", "views/visualization", "views/vis2", "models/cypher"], (Input, Table, Visualization, Vis2, Cypher) ->

  class CypherGadget
    tpl: """
      <div class="cypherGadget">
        <div class="task"></div>
        <div class="visualization"></div>
        <div class="input"></div>
        <div class="query-table"></div>
        <div class="error-msg"></div>
      </div>
    """

    constructor: (options) ->
      @$el = options.$el
      @player = options.player
      @player.on "domReady", @render, @
      @config = options.config
      @config.on "change:task", @setTask, @
      @userstate = options.userstate
      #@userstateDfd = @userstate.fetch()

      options.propertySheetSchema.set('cypherSetup', {type:'Text', title:"DB setup query (unimplemented)"})
      options.propertySheetSchema.set('cypherSetup2', {type:'Text', title:"Initial viz (unimplemented)"})
      options.propertySheetSchema.set('cypherSetup3', {type:'Text', title:"Task (unimplemented)"})
      options.propertySheetSchema.set('cypherSetup4', {type:'Text', title:"Task-check (unimplemented)"})

    render: ->
      @$el.html(@tpl)

      @viz = new Vis2(@$el.find('.visualization'))

      applyResetButton = @config.get('task') && config.get('task').length > 1
      @input = new Input(@$el.find('.input'), applyResetButton)
      @input.render()
      _.bindAll @, "submitQuery"
      @input.on 'query', @submitQuery

      @table = new Table(@$el.find('.query-table'))

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
        if @currentIndex == @history.length-1
          @input.disableFuture()

      #@userstateDfd.done => @createCypher()
      @createCypher()

    createCypher: ->
      q = new Cypher(@userstate.get("uuid"))
      q.submitQuery("create (n{}) delete n").done (res) =>
        @viz.draw(JSON.parse(res).visualization)

    setTask: ->
      taskDiv = @$el.find('.task')
      if @config.get("task")
        taskDiv.show()
        taskDiv.text(@config.get('task'))
      else
        taskDiv.hide()

    submitQuery: (query) ->
      q = new Cypher(@userstate.get("uuid"))
      q.submitQuery(query).done (res) =>
        json = JSON.parse(res)
        if json.error
          @$el.find('.error-msg').text(json.error)
        else
          @addToHistory query
          @table.render q.interpret(json), query
          @viz.draw(json.visualization)
          #@viz.setWidth(700-@table.$el.width())

    addToHistory: (query) ->
      @history = @history.splice 0, @currentIndex+1
      @history.push(query)
      @currentIndex = @history.length-1
      @input.enablePast()
      @input.disableFuture()