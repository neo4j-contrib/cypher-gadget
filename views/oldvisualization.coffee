define [], () ->

  class Visualization

    constructor: (@$el) ->
      width = 400
      height = 300
      @svg = d3.select(".visualization")
                .attr("width", width)
                .attr("height", height)
                .attr("viewBox", "0 0 "+width+" "+height)

      @force = d3.layout.force()
                        .charge(-2000)
                        .linkDistance(100)
                        .friction(0.7)
                        .gravity(0.9)
                        .size([width, height])

      @force.on "tick", =>
        ###
        # arcs
        @links.attr "d", (d) ->
          dx = d.target.x - d.source.x
          dy = d.target.y - d.source.y
          dr = Math.sqrt(dx * dx + dy * dy)
          return "M" + d.source.x + "," + d.source.y + "A" + dr + "," + dr + " 0 0,1 " + d.target.x + "," + d.target.y
        ###
        # straight lines
        @links.attr("x1", (d) -> d.source.x)
            .attr("y1", (d) -> d.source.y)
            .attr("x2", (d) -> d.target.x)
            .attr("y2", (d) -> d.target.y)

        @svg.selectAll("circle")
          .attr("cx", (d) -> Math.max(10, Math.min(width-10, d.x)))
          .attr("cy", (d) -> Math.max(10, Math.min(width-10, d.y)))

        @nodeTexts.selectAll("text")
          .attr("x", (d) -> Math.max(10, Math.min(width-10, d.x))+12)
          .attr("y", (d) -> Math.max(10, Math.min(width-10, d.y))+3)

        @pathTexts.attr "transform", (d) ->
                dx = ( d.target.x - d.source.x )
                dy = ( d.target.y - d.source.y )
                dr = Math.sqrt(dx * dx + dy * dy)
                sinus = dy / dr
                cosinus = dx / dr
                l = d.type.length * 4
                offset = ( 1 - ( (l+10) / dr ) ) / 2
                x = ( d.source.x + dx * offset )
                y = ( d.source.y + dy * offset )
                return "translate(" + x + "," + y + ") matrix(" + cosinus + ", " + sinus + ", " + -sinus + ", " + cosinus + ", 0 , 0)"

    draw: (graph) ->
      selective = false
      _.each graph, (g) -> _.each g, (d) -> selective = true if d.selected

      d = 2*(@width || 725) /graph.nodes.length
      @force.linkDistance(d)

      @svg.selectAll("g").remove()
      @force.nodes(graph.nodes).links(graph.links).start()

      @links = @svg.append("g").selectAll("g")
                .data(graph.links)
              .enter().append("line")
                .attr("marker-end", (d) -> if selective && !d.selected then "url(#faded-arrowhead)" else "url(#arrowhead)")
                .attr("class", (d) -> if selective && !d.selected then "faded-relationship" else "relationship")

      @pathTexts = @svg.append("g").selectAll("g")
                      .data(graph.links)
                    .enter().append("g")
                      .attr("class", "path-texts")

      @pathTexts.append("text")
          .attr("class", "shadow")
          .text (d) -> d.type unless selective && !d.selected

      @pathTexts.append("text").text (d) -> d.type unless selective && !d.selected


      @nodes = @svg.append("g").selectAll("g")
                  .data(graph.nodes)
                .enter().append("circle")
                  .attr("class", (d) -> if selective && !d.selected then "faded-node" else "node")
                  .attr("r", 10)
                  .call(@force.drag)

      @nodeTexts = @svg.append("g").selectAll("g")
                      .data(graph.nodes)
                    .enter().append("g")
                      .attr("class", "node-texts")

      @nodeTexts.append("text")
          .attr("class", "shadow")
          .text (d) -> d.name || d.title unless selective && !d.selected

      @nodeTexts.append("text").text (d) -> d.name || d.title unless selective && !d.selected

    setWidth: (@width) ->
      d3.select('svg').transition().attr('width', @width+65)
