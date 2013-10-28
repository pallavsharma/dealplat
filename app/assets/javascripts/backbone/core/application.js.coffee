class Dealplat.Application
  modules: { }

  constructor: ->
    _.extend @, Backbone.Events

  create: ( modules ) ->
    for k, v of modules
      @modules[ k ] = new Dealplat.Module
      for i in v
        router        = new i
        router.module = @modules[ k ]

        @modules[ k ].routers.push router


  start: ( options = { } ) ->
    Backbone.history.start( _.extend { }, { "hashChange" : true }, options )
