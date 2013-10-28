class Dealplat.Module
  constructor : ->
    _.extend @, Backbone.Events

    @routers = [ ]


  url: ->
    _.result @routers[ 0 ], "url"
