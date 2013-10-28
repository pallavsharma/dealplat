#DOM Ready

$ ->
  moduleAccessor = ( moduleName ) -> Dealplat.app.modules[ moduleName ]
  Dealplat.app   = _.extend moduleAccessor, Dealplat.app

  window.Layout  = new Dealplat.Views.Layout

  Dealplat.app.create
    "home"       : [
      Dealplat.Routers.Home
    ]

  Dealplat.app.start( )

  $("a[rel~=popover], .has-popover").popover()
  $("a[rel~=tooltip], .has-tooltip").tooltip()