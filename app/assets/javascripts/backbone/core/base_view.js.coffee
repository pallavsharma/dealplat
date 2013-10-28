class Dealplat.Views.BaseView extends Backbone.View
  header    : null

  components: ->
    [ ]


  initialize: ( options = { } ) ->
    super options

    @layout = window.Layout

    @fetchList = options.fetchList || [ ]
    @pending = [ ].concat @fetchList

    @once "ready", @render

    @components = @components( ) if _.isFunction @components
    @components = _.map @components, ( component ) =>
      new Dealplat.Components[ "#{component}Component" ] @


  onFetch: ( item ) =>
    if @pending.length
      @pending = _.without @pending, item
      unless @pending.length
        @trigger "ready"


  fetchAll: ->
    for i in @fetchList
      i.off "fetched", @onFetch
      i.off "reset"
      i.on  "fetched", @onFetch
      i.on  "reset", ->
        @trigger "fetched", @

    @pending = [ ].concat @fetchList
    for i in @fetchList
      if i.fetched
        @onFetch i
      else
        i.fetch( )


  display: ->
    @isDisplayed = false

    @stopListening @, "displayed"
    @listenTo      @, "displayed", -> @isDisplayed = true

    if @fetchList.length
      @fetchAll( )
    else
      @trigger "ready"


  redraw: ->
    for i in @components
      i.onRedraw( )

    @trigger "rendered", @$el


  renderPartial: ( partialName, data ) ->
    parts = partialName.split "/"

    if parts[ 0 ] == "backbone"
      # nothing to do: the path starts from the root
    else if parts[ 0 ] == "templates"
      # add 'backbone' to the path
      parts.unshift "backbone"
    else
      # add 'backbone/templates' to the path
      parts.unshift "backbone", "templates"

    # add leading '_' to partial name (Rails-like convention)
    parts.push "_#{parts.pop( )}"

    JST[ parts.join( "/" ) ] _.extend { bindAttributes: null }, data, view: @


  afterRender: ->

  afterCallback: (f) ->
    @callbacks ||= []
    @callbacks.push f


  runCallbacks: ->
    _.each(@callbacks, (f) -> f())


  render: ( data = { } ) ->
    super data

    @off "ready"
    @on  "ready", @redraw

    @$el.html @template? _.extend { }, data, view: @

    for i in @components
      i.onRender( )

    @trigger "rendered", @$el

    @afterRender()
    @runCallbacks()

    @


  exit: ->
    for i in @components
      i.onExit( )


  renderLink: ( options = { } ) ->
    @renderPartial "generic/link" , options: options


  renderImage: ( options = { } ) ->
    @renderPartial "generic/image" , options: options
