define ["./node", "./relationship"], (Node, Relationship) ->

  class TableView extends Backbone.View
    tpl: """
      <div class="query-echo"><%= echo %></div>
      <div class="table-container">
        <table>
          <tr class="header">
            <td style="visibility:hidden;"></td>
            <% _.each(columns, function(col) { print('<td>'+col+'</td>') }); %>
          </tr>
        </table>
      </div>
      <button class='dismiss'>Dismiss <i class='icon-double-angle-right'></i></button>
    """
    events:
      'click .dismiss': 'onDismissClick'

    initialize: (@$el) -> #

    render: (data, queryEcho) ->
      @$el.html _.template @tpl, _.extend data, {echo:""} # {echo:queryEcho}
      nodeOrRel = false # flag to hide expanders
      _.each data.rows, (row) =>
        tr = $("<tr>")
        @$el.find('table').append(tr)
        _.each row, (cell) ->
          if cell.type == "node"
            cellview = new Node(cell)
            tr.append cellview.render()
            nodeOrRel = true
          else if cell.type == "relationship"
            cellview = new Relationship(cell)
            tr.append cellview.render()
            nodeOrRel = true
          else
            tr.append $("<td>"+cell+"</td>")

        if nodeOrRel
          expander = $("<td><i class='icon-caret-right expand-properties'></i></td>")
          tr.prepend(expander)
          tr.find('.node-properties').hide()
          expander.on "click", ->
            i = $(@).find("i")
            if i.hasClass('icon-caret-right')
              i.addClass('icon-caret-down').removeClass('icon-caret-right')
              tr.find('.node-properties').show()
            else if i.hasClass('icon-caret-down')
              i.addClass('icon-caret-right').removeClass('icon-caret-down')
              tr.find('.node-properties').hide()
        else
          @$el.find(".header").children().first().hide()

    onDismissClick: ->
      @$el.empty()
      @trigger "dismissed"
