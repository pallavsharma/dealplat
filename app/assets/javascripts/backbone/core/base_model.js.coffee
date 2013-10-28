class Dealplat.Models.BaseModel extends Backbone.DeepModel

  toString: ->
    @get( "name" ) || super( )