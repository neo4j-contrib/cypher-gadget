define [], () ->

  class Cypher

    constructor: (@uuid) -> #

    interpret: (data) ->
      results =
        columns: data.columns
        rows: []

      results.rows = _.map data.json, (row) ->
        _.map row, (datum) ->
          if _.has(datum, "_type") # it is a relationship
            return { type: "relationship", properties: datum }
          else if _.has(datum, "_id") # it is a node
            return { type: "node", properties: datum }
          else if _.isArray(datum) # it is a collection
            return { type: "collection", collection: datum }
          else # it is likely a string
            return datum

      return results

    submitQuery: (query) ->
      $.ajax
        type: "POST"
        url: "http://neo4j-training-backend.herokuapp.com/backend/cypher"
        data: query
        dataType: 'text'
        headers: { "X-Session": 8923982398732 }
        xhrFields: { withCredentials: true }

    empty: ->
      @submitQuery("START n = node(*) MATCH n-[r?]-() DELETE n, r;")