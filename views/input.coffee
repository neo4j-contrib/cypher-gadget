define ["data/presets.js", "libs/codemirror", "libs/cm-cypher", "libs/cm-placeholder", "libs/bootstrap-dropdown.js"], (presets) ->

  class Input extends Backbone.View

    tpl: """
      <div class='input-field'>
        <div>
          <textarea class='query' placeholder='Type a query here!'></textarea>
        </div>
        <div class='input-controls'>
          <ul class='directional-controls'>
            <li><div class='back-button'><i class='icon-arrow-left'></i></div></li>
            <li><div class='forward-button'><i class='icon-arrow-right'></i></div></li>
          </ul>
          <div class='execute-button'><i class='icon-play'></i></div>
        </div>
      </div>
      <div class='input-subcontrols'>
        <button class='empty'><i class='icon-trash'></i> Clear db</button>
        <div class="presets-dropdown btn-group">
          <a class="btn dropdown-toggle" data-toggle="dropdown" href="#">
            Presets
            <span class="caret"></span>
          </a>
          <ul class="presets dropdown-menu">
            <li class="preset" data-value=''>Presets (undesigned)</li>
            <% _.each(presets, function(key){ %>
              <li class="preset" data-value=<%= key %>><%= key %></li>
            <% }); %>
          </ul>
        </div>
      </div>
    """

    events:
      'click .execute-button': 'execute'
      'click .empty': 'onEmptyDBClick'
      'click .preset': 'onPresetSelect'
      'keyup .query': 'onQueryKeyup'

    initialize: (@$el) ->
      _.bindAll @, "onQueryKeyup"

    render: ->
      @$el.html _.template @tpl, presets:_.keys(presets)
      cmOptions =
        mode: "cypher"
        theme:"neo"
        lineNumbers:true
        lineWrapping:false
        fixedGutter:false
        viewportMargin: 20
      @cm = new CodeMirror.fromTextArea(@$el.find('.query')[0], cmOptions)
      @cm.on "keyup", @onQueryKeyup
      @cursorPos = @cm.getCursor()

    execute: ->
      @trigger 'query', @cm.getValue()

    onEmptyDBClick: ->
      @trigger 'query', "START n = node(*) MATCH n-[r?]-() DELETE n, r;"

    onPresetSelect: (e) ->
      presetText = presets[$(e.target).data("value")]
      @setQuery(presetText)

    onQueryKeyup: (cm, e) ->
      # codemirror lets you move cursor position before this event is fired so
      # pressing up puts cursor to 0 and then if we did getCursor() it'd be 0.
      cp = @cm.getCursor()
      if e.keyCode == 38 # up
        if @cursorPos.line == 0 && @cursorPos.ch == 0 && cp.line == 0 && cp.ch == 0
          @trigger "loadHistory"
      else if e.keyCode == 40 # down
        lastLine = @cm.lastLine()
        lastLineLength = @cm.getLine(lastLine).length
        if @cursorPos.line == lastLine && @cursorPos.ch == lastLineLength && cp.line == lastLine && cp.ch == lastLineLength
          @trigger "loadFuture"
      @cursorPos = @cm.getCursor()

    clear: ->
      @cm.setValue("")

    setQuery: (query) ->
      @cm.setValue(query)