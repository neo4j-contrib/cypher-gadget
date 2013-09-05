define ["gadget"], (CypherGadget) ->

  us = new Backbone.Model()
  x = new CypherGadget($el: $('.gadget'), player: _.extend({}, Backbone.Events), propertySheetSchema: new Backbone.Model(), config: new Backbone.Model(), userState: us)
  x.render()