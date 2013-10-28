#Leontev Aleksandr
class Dealplat.Routers.BaseRouter extends Backbone.Router
  resource       : ""
  section        : ""
  sidebarAction  : ""
  sidebarActions : { }


  initialize: ( options ) ->
    super     options
    @layout = window.Layout

  render: (view) ->
    @layout.setView(view)
    view.display()
