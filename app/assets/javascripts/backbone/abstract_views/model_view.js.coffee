class Dealplat.Views.ModelView extends Dealplat.Views.BaseView
  draftable : false
  useCrypto : true


  initialize: ( options = { } ) ->
    @collection ||= Dealplat.router.collection if Dealplat.router

    fetchList = options.fetchList || [ ]
    fetchList.push options.model if options.model?.id

    super _.extend { }, options, fetchList: fetchList

    @modelBinder      = new Backbone.ModelBinder
    @attributesBinder = new Backbone.ModelBinder


  destroy: ( options = { } ) ->
    @model.destroy()
    @remove()
    window.location.hash = options.hash if options.hash
    false


  create: ( attributes = { }, options = { } ) ->
    createOptions = draftable: @draftable
    _.extend createOptions, options

    @collection.add attributes, createOptions

    @model = @collection.last( )

    @modelBinder.bind @model, @$el, @modelBindings()


  setModel: ( model, fetch = false ) ->
    # first remove old model from the fetch list, if any
    exclude = null
    for i in @fetchList
      if @model && ( i.id == @model.id )
        exclude = i
        break
    @fetchList = _.without @fetchList, exclude

    @model           = model
    @model.draftable = @draftable

    # add new model to the fetch list, if needed
    @fetchList.push( @model ) if fetch

  dateConverter = (dir, value, atr, model, els) ->
    if value? and moment(value)?.isValid()
      if value.indexOf('-') > -1 #value come from server
        moment(value).format()
      else
        moment(value, I18n.t('date.formats.default')).format()
    else
      value

  modelBindings: ->
    bindings = Backbone.ModelBinder.createDefaultBindings(@$el, 'name');
    @$("[class~=date-picker]").each ->
      name = $(@).attr('name')
      bindings[name] = {selector: "[name='#{name}']",  converter: dateConverter}
    bindings


  bindModel: ->
    @bindModelInner( )


  bindModelInner: ->
    flat = flattenObject @model.attributes
    for k, v of flat
      if _.isBoolean( v )
        if @$( "[name='#{k}']" ).attr( "type" ) == "radio"
          @model.set k, v.toString( ), silent: true

    @modelBinder.bind @model, @$el, @modelBindings()

    bindings       = { }
    bindingStrings = [ ]

    @$( "[data-bind-attributes]" ).each ->
      bindingString = $( @ ).attr "data-bind-attributes"
      elId          = $( @ ).attr "id"
      unless _.contains bindingStrings, bindingString
        bindingStrings.push bindingString
        bindingPairs  = bindingString.split ","
        for i in bindingPairs
          [ modelAttr, htmlAttr ] = i.split ":"
          bindings[ modelAttr ] ||= [ ]
          bindings[ modelAttr ].push
            selector    : "[data-bind-attributes='#{bindingString}']"
            elAttribute : htmlAttr

    @attributesBinder.bind @model, @$el, bindings

    @trigger "modelBound"


  redraw: ( data = { } ) ->
    super data

    @bindModel( )

    @


  render: ( data = { } ) ->
    #modelData = model: @model.serialize( "client" )
    #super _.extend { }, data, modelData

    super _.extend { }, data, @model.toJSON()
    @bindModel( )

    @
