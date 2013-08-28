define ["views/input", "views/table/table", "views/visualization", "views/vis2", "models/cypher"], (Input, Table, Visualization, Vis2, Cypher) ->

  # TODO make arrowheads a bit bigger

  class CypherGadget
    tpl: """
      <div class="visualization"></div>
      <div class="input"></div>
      <div class="query-table"></div>
      <div class="error-msg"></div>
    """

    constructor: ->
      @$el = $('.gadget')
      @$el.html(@tpl)

      @viz = new Vis2(@$el.find('.visualization'))

      @input = new Input(@$el.find('.input'))
      @input.render()
      _.bindAll @, "submitQuery"
      @input.on 'query', @submitQuery

      @table = new Table(@$el.find('.query-table'))

      @history = [""]
      @currentIndex = 0
      @input.on "loadHistory", (tempFuture) =>
        return if @currentIndex == 0
        if tempFuture
          @addToHistory(tempFuture)
        @currentIndex--
        @input.setQuery(@history[@currentIndex])

      @input.on "loadFuture", () =>
        return if @currentIndex == @history.length-1
        @currentIndex++
        @input.setQuery(@history[@currentIndex])

      q = new Cypher()
      q.submitQuery("create (n{}) delete n").done (res) =>
        @viz.draw(JSON.parse(res).visualization)
        #@viz.setWidth(700)

    submitQuery: (query) ->
      q = new Cypher()
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

  new CypherGadget()