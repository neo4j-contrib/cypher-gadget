define ["../../color_manager"], (colorManager) ->

  class CollectionTableView extends Backbone.View

    tpl: """
      <td>
        <span>[<%= data.length %> item<% if (data.length > 1) print("s") %>]</span>
        <div class="node-properties">
          <ul>
            <% _.each(data, function(datum) { %>
            <li>
              <%= datum %>
            </li>
            <% }); %>
          </ul>
        </div>
      </td>
    """

    constructor: (cell) ->
      @data = cell

    render: ->
      _.template @tpl, data: @data.collection