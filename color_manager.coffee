define [], () ->

  prettyColors = ["#3498db", "#1abc9c", "#e74c3c", "#d2a8e9"]

  class ColorManager

    constructor: ->
      @registeredLabelColors = {}

    getColorForLabels: (labels) ->
      labelToUse = labels[labels.length-1]
      if !@registeredLabelColors[labelToUse]
        return "#ccc" if prettyColors.length == 0
        color = prettyColors[_.random(0, prettyColors.length-1)]
        prettyColors.splice(_.indexOf(prettyColors, color), 1)
        @registeredLabelColors[labelToUse] = color
      return @registeredLabelColors[labelToUse]

  # singleton
  return new ColorManager()