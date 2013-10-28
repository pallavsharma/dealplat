Dealplat.Components ||= { }


class Dealplat.Components.BaseComponent
  constructor : ( view ) ->
    @view = view
    _.extend @, Backbone.Events
    @initialize( )


  $ : ->
    @view.$.apply @view, arguments


  initialize  : ->
    # Stub: this is just an interface


  # This method is called when a parrent view is rendered first time.
  onRender    : ->
    # Stub: this is just an interface


  # This method is called when a parrent view is redrawn
  # (most commonly: we already visited this view and now return here)
  onRedraw    : ->
    # Stub: this is just an interface


  # This method is called when a parrent view is left
  onExit      : ->
    # Stub: this is just an interface


  # This method is called when something siginficant has changed inside our view
  # Default behavior is to call onRedraw, but may be overridden in descendants
  onChange    : ->
    @onRedraw( )
