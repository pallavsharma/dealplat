Dealplat.Views.Menus ||= { }
class Dealplat.Views.Menus.HeaderMenu extends Dealplat.Views.BaseView
  template: JST["backbone/templates/menus/header_menu"]
  id: "header"
  tagName: "header"

  events:
    'click li': 'navigate'

  navigate: (e) ->
    @$('li').removeClass("active")
    @$(e.currentTarget).addClass("active")

