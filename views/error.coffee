define [], () ->

  class Error extends Backbone.View

    tpl: """
      <div class="error-msg"></div>
      <div class="error-dismiss"><i class="icon-remove"></i></div>
    """

    events:
      'click .error-dismiss': 'dismiss'

    initialize: (@$el) -> #

    render: (errorMsg) ->
      @$el.html(@tpl)
      @$el.show()
      @$el.find('.error-msg').text(errorMsg)

    dismiss: ->
      @$el.hide()