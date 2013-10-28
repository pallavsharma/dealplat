class Dealplat.Routers.Home extends Dealplat.Routers.BaseRouter
  routes:
    "" : "index"

  initialize: (options ={}) ->
    super options
    @markers = new Dealplat.Collections.Markers


  index: ->
    @layout.setHeader(Dealplat.Views.Menus.HeaderMenu)
    @layout.setSideBar(Dealplat.Views.Sidebars.MapSidebar)

    @view = new Dealplat.Views.Map.GMap
      collection: @markers
      fetchList: [ @markers ]
    @render @view
