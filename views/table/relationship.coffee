define [], () ->

  class RelationshipTableView extends Backbone.View

    tpl: """
      <td>
        <div class="table-relationship"><i class="icon-long-arrow-right"></i></div>
        <span><%= props._type %></span>
      </td>
    """

    constructor: (cell) ->
      @data = cell

    render: ->
      _.template @tpl, props: @data.properties