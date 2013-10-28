class Dealplat.Collections.BaseCollection extends Backbone.Collection
  model      : Dealplat.Models.BaseModel
  comparator : "id"


  displayUrl: ->
    _.result @, "url"


  fetch: ( options = { } ) ->
    super _.extend { }, { "reset" : true }, options


  serialize: ( context ) ->
    @reduce( ( ( res, el ) -> res.concat( [ el.serialize( context ) ] ) ), [ ] )
