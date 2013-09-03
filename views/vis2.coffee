define ["../color_manager", "libs/d3.min"], (colorManager) ->

  class Visualization

    constructor: (@$el) ->
      @width = 725
      @height = 600
      svg = d3.select(".visualization").append("svg")
                .attr("width", @width)
                .attr("height", @height)
                #.attr("viewBox", "0 0 "+@width+" "+@height)
      @viz = svg.append("g")

      # create markerheads
      @viz.append("defs").selectAll("marker")
            .data(["arrowhead", "faded-arrowhead"])
          .enter().append("marker")
            .attr("id", String)
            .attr("viewBox", "0 0 10 10")
            .attr("refX", 17)
            .attr("refY", 5)
            .attr("markerUnits", "strokeWidth")
            .attr("markerWidth", 4)
            .attr("markerHeight", 3.5)
            .attr("orient", "auto")
            .attr("preserveAspectRatio", "xMinYMin")
          .append("path")
            .attr("d", "M 0 0 L 10 5 L 0 10 z")

      @force = d3.layout.force()
                        .charge(-380)
                        .linkDistance(100)
                        .friction(0.5)
                        .gravity(0.5)
                        .size([@width, @height])

      throttledFrame = _.throttle(((a,b,c,d)=>@frameViz(a,b,c,d, 40, 360)), 3000)

      @force.on "tick", =>
        ### in case different links between two nodes are ever needed
        # arcs
        @links.attr "d", (d) ->
          dx = d.target.x - d.source.x
          dy = d.target.y - d.source.y
          dr = Math.sqrt(dx * dx + dy * dy)
          return "M" + d.source.x + "," + d.source.y + "A" + dr + "," + dr + " 0 0,1 " + d.target.x + "," + d.target.y
        ###
        xMax = 0
        xMin = Infinity
        yMax = 0
        yMin = Infinity

        @viz.selectAll("circle")
          .attr("cx", (d) =>
            cx = Math.min(@width, Math.max(0, d.x))
            xMax = cx if cx > xMax
            xMin = cx if cx < xMin
            return cx)
          .attr("cy", (d) => 
            cy = Math.min(@height, Math.max(0, d.y))
            yMax = cy if cy > yMax
            yMin = cy if cy < yMin
            return cy)

        #throttledFrame(xMin, xMax, yMin, yMax)

        @nodeTexts.selectAll("text")
          .attr("x", (d) => Math.min(@width, Math.max(0, d.x))+8)
          .attr("y", (d) => Math.min(@height, Math.max(0, d.y))+3)

        # straight lines
        @links.attr("x1", (d) => Math.min(@width, Math.max(0, d.source.x)))
            .attr("y1", (d) => Math.min(@height, Math.max(0, d.source.y)))
            .attr("x2", (d) => Math.min(@width, Math.max(0, d.target.x)))
            .attr("y2", (d) => Math.min(@height, Math.max(0, d.target.y)))

        # @pathTexts.attr "transform", (d) ->
        #         dx = ( d.target.x - d.source.x )
        #         dy = ( d.target.y - d.source.y )
        #         dr = Math.sqrt(dx * dx + dy * dy)
        #         sinus = dy / dr
        #         cosinus = dx / dr
        #         l = d.type.length * 4
        #         offset = ( 1 - ( (l+10) / dr ) ) / 2
        #         x = ( d.source.x + dx * offset )
        #         y = ( d.source.y + dy * offset )
        #         return "translate(" + x + "," + y + ") matrix(" + cosinus + ", " + sinus + ", " + -sinus + ", " + cosinus + ", 0 , 0)"

    draw: (graph) ->
      selective = false
      _.each graph, (g) -> _.each g, (d) -> selective = true if d.selected

      # used later to tell if two nodes are connected to each other
      @indexLinkRef = _.map graph.links, (link) -> link.start+','+link.end

      d = 2*(@width || 725) /graph.nodes.length
      @force.linkDistance(d)

      @viz.selectAll("g").remove()
      @force.nodes(graph.nodes).links(graph.links).start()

      @links = @viz.append("g").selectAll("g")
                .data(graph.links)
              .enter().append("line")
                .attr("marker-end", (d) -> if selective && !d.selected then "url(#faded-arrowhead)" else "url(#faded-arrowhead)")
                .attr("class", (d) -> if selective && !d.selected then "faded-relationship" else "relationship")
                .style("stroke", "#ccc")

      # @pathTexts = @viz.append("g").selectAll("g")
      #                 .data(graph.links)
      #               .enter().append("g")
      #                 .attr("class", "path-texts")

      # @pathTexts.append("text")
      #     .attr("class", "shadow")
      #     .text (d) -> d.type unless selective && !d.selected

      # @pathTexts.append("text").text (d) -> d.type unless selective && !d.selected


      @nodes = @viz.append("g").selectAll("g")
                  .data(graph.nodes)
                .enter().append("circle")
                  .attr("class", (d) -> if selective && !d.selected then "faded-node" else "node")
                  .attr("r", 5)
                  .style("fill", (d) => if d.labels then colorManager.getColorForLabels(d.labels) else "#ccc")
                  .call(@force.drag)
                  .on("mouseover", (d) => @onNodeHover(d))
                  .on("mouseout", => @onNodeUnhover())

      @nodeTexts = @viz.append("g").selectAll("g")
                      .data(graph.nodes)
                    .enter().append("g")
                      .attr("class", "node-texts")
                      .attr("opacity", 0)
                      .style("font", "8px sans-serif")

      @nodeTexts.append("text")
          .attr("class", "shadow")
          .text (d) -> d.name || d.title unless selective && !d.selected

      @nodeTexts.append("text").text (d) -> d.name || d.title unless selective && !d.selected

    onNodeHover: (d) ->
      @nodes.style("fill", (n) =>
        if _.indexOf(@indexLinkRef, d.id+","+n.id) > -1 ||
            _.indexOf(@indexLinkRef, n.id+","+d.id) > -1 ||
            n.id == d.id
          return if n.labels then colorManager.getColorForLabels(n.labels) else "rgb(82, 88, 100)"
        else return "#ccc")
        .each (n) ->
          @parentNode.appendChild(@) if n.id == d.id

      @links.filter((l) -> l.start == d.id || l.end == d.id)
          .style("stroke", "rgb(82, 88, 100)")
          .attr("marker-end", "url(#arrowhead)")
          .each((l) -> @parentNode.appendChild(@)) # put elements on top of non-highlighted elements
        .append("g")
          .attr("class", "path-texts")
        .append("text")
          .attr("class", "shadow")
          .text (d) -> d.type #unless selective && !d.selected

      @nodeTexts.attr("opacity", (n) =>
        if _.indexOf(@indexLinkRef, d.id+","+n.id) > -1 ||
            _.indexOf(@indexLinkRef, n.id+","+d.id) > -1 ||
            n.id == d.id
          return 0.5
        else return 0)
        .each (l) ->
          if l.id == d.id
            d3.select(@).attr("opacity", 1)
            @parentNode.appendChild(@)

      # @pathTexts = @viz.append("g").selectAll("g")
      #                 .data(graph.links)
      #               .enter().append("g")
      #                 .attr("class", "path-texts")

      # @pathTexts.append("text")
      #     .attr("class", "shadow")
      #     .text (d) -> d.type unless selective && !d.selected

      # @pathTexts.append("text").text (d) -> d.type unless selective && !d.selected

    onNodeUnhover: ->
      @nodes.style "fill", "#ccc"
      @links.style("stroke", "#ccc")
            .attr("marker-end", "url(#faded-arrowhead)")
      @nodeTexts.attr("opacity", 0)
            .style("font", "8px sans-serif")

    setWidth: (@width) ->
      #d3.select('svg').transition().attr('width', @width+65)

    frameViz: (x1, x2, y1, y2, padding, rightPadding) ->
      if padding
        x1 = x1-padding
        x2 = if rightPadding then x2+padding+rightPadding else x2+padding
        y1 = y1-padding
        y2 = y2+padding
      if @height/(y2-y1) < @width/(x2-x1)
        scale = @height/(y2-y1)
        translate = (-x1+(((y2-y1)*@width/@height-(x2-x1))/2))+", "+(-y1)
      else
        scale = @width/(x2-x1)
        translate = (-x1)+", "+(-y1+(((x2-x1)*@height/@width-(y2-y1))/2))
      @viz.transition().attr("transform", "scale("+scale+")translate("+translate+")")


