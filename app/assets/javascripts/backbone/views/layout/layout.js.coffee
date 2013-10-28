class Dealplat.Views.Layout extends Backbone.View
  el                : "body"
  header            : ""
  sidebar           : ""
  view              : ""

  container: -> @$('.container')

  getHeaderSideBar  : -> @header
  getSideBar        : -> @sidebar
  getView           : -> @view

  setHeader: (header) ->
    @header ||= new header
    @container().prepend( @header.render().$el )

  setSideBar: (sidebar) ->
    @sidebar ||= new sidebar
    @container().find('#bb-sidebar').append( @sidebar.render().$el )

  setView: (view) ->
    @container().find('#bb-content-view').append( view.render().$el )


