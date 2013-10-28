class Dealplat.Views.FormView extends Dealplat.Views.ModelView
  draftable           : true
  redirectAfterSubmit : true


  events: ->
    "submit form"       : "submit"
    "click .btn.cancel" : "cancel"
    "focus input"       : "focus"
    "blur input"        : "blur"


  actionButtons: ->
    super( ).concat [
        "text"   : "generic.save"
        "type"   : "primary"
        "action" : @submit
      ,
        "text"   : "generic.cancel"
        "type"   : "danger"
        "action" : @cancel
    ]


  components: ->
    super( ).concat(
      [ "CustomControls", "Select", "RadioButtons" , "TagManager" ]
    )


  initialize: ( options = { } ) ->
    super options

    unless _.isUndefined options.redirectAfterSubmit
      @redirectAfterSubmit = options.redirectAfterSubmit

    @on "fieldsChanged", @onFieldsChanged

    @errorList  = new Backbone.DeepModel
    @formBinder = new Backbone.ModelBinder


  bindModelInner: ->
    bindings       = { }
    bindingStrings = [ ]
    model          = @model
    view           = @

    @$( ".input-numeric [data-bind-attributes]" ).each ->
      bindingString = $( @ ).attr "data-bind-attributes"
      unless _.contains bindingStrings, bindingString
        bindingStrings.push bindingString
        bindingPairs  = bindingString.split ","
        for i in bindingPairs
          [ modelAttr, htmlAttr ] = i.split ":"
          # Only for size attribute
          if htmlAttr = "size"
            if model
              view.trigger "updateNumeric", modelAttr, model.get( modelAttr )
              model.on "change:#{modelAttr}", ->
                view.trigger "updateNumeric", modelAttr, @get( modelAttr )

    super( )


  onFieldsChanged: ->
    for i in @components
      i.onChange( )

    @bindModel( )


  blur: ( evt ) ->
    $( evt.currentTarget ).parents( ".wrapper" ).removeClass "on-focus"


  focus: ( evt ) ->
    $( evt.currentTarget ).parents( ".wrapper" ).addClass "on-focus"


  cancel: ->
    window.redirectTo Finliner.router.upLink
    @model.clearDraft( )


  submit: ( e, attrs = null, options = { } ) ->
    if e
      e.preventDefault( )
      e.stopPropagation( )

    model = @model
    submitOptions =
      validate  : false
      success   : ( model, response, options ) =>
        @successHandler model, response, options
      error     : ( model, jqXHR   , options ) =>
        @errorHandler model, jqXHR, options

    # special case: remove all attributes linked to hidden inputs
    @$( "[data-show=false] [name]"          ).each ->
      model.unset( $( @ ).attr( "name"           ), silent: true )
    @$( "[data-show=false][data-sub-model]" ).each ->
      model.unset( $( @ ).attr( "data-sub-model" ), silent: true )

    @model.save( attrs, _.extend( { }, options, submitOptions ) )

    false


  successHandler: ( model, response, options ) ->
    # TODO: check if this is necessary
    @model = model

    redirectTo @model if @redirectAfterSubmit
    @modelSaved( )
    @trigger "saveSuccess"


  errorHandler: ( model, jqXHR ) ->
    log jqXHR.responseText
    @errorList.clear( )
    response = JSON.parse( jqXHR.responseText )
    if response["errors"] then @errorList.set( response["errors"] ) else @errorList.set( response )
    @$( "input[data-content]" ).popover "destroy"
    @$( "input[data-content!='']" ).each -> $( @ ).removeData "content"
    @$( "input[data-content!='']" ).popover "trigger" : "focus"
    @trigger "saveError"

  modelSaved: ->


  # Render label element
  #
  # @param  options                [Object]  rendering options
  # @option options elementId      [String]  HTML element id
  # @option options forId          [String]  HTML 'for' attribute value
  # @option options elementClass   [String]  HTML element class
  # @option options required       [Boolean] if true, label will have '*' mark
  # @option options text           [String]  label text (I18n resource id)
  #
  # @return                        [String] generated HTML code
  #
  renderLabel: ( options = { } ) ->
    innerOptions =
      "requiredMark" : true

    _.extend innerOptions, options

    @renderPartial "form_builder/label", options: innerOptions


  # Render set of radio boxes
  #
  # @param  options                [Object]  rendering options
  # @option options elements       [Object]  key/value map of radio elements
  # @option options required       [Boolean] if the field is required or not
  # @option options inline         [Boolean] if true, radio boxes have 'inline'
  #                                          class
  # @option options defaultValue   [String]  default value of the set
  # @option options label          [String]  label text (I18n resource id)
  # @option options name           [String]  name of the set
  # @option options elementClass   [String]  HTML element class
  # @option options labelClass     [String]  HTML class for label element
  # @option options labelId        [String]  HTML id for label element
  # @option options container      [Object]  Container div element properties;
  #                                          supports elementId, elementClass,
  #                                          htmlData, attributes &
  #                                          bindAttributes parameters
  #
  # @return                        [String] generated HTML code
  #
  renderRadioBoxes: ( options = { } ) ->
    innerOptions =
      "elements"     : { }
      "type"         : "radio"
      "required"     : false
      "inline"       : false

    _.extend innerOptions, options

    labelOptions =
      "elementId"    : innerOptions.labelId
      "elementClass" : innerOptions.labelClass
      "text"         : innerOptions.label

    labelOptions = _.extend { }, innerOptions, labelOptions

    res  = @renderPartial "form_builder/wrapper_start" , "options": innerOptions
    if innerOptions.label
      res += @renderLabel labelOptions
    res += @renderPartial "form_builder/radio_boxes"   , "options": innerOptions
    res += @renderPartial "form_builder/wrapper_end"   , "options": innerOptions


  # Render select element
  #
  # @param  options                [Object]  rendering options
  # @option options elementId      [String]  HTML element id
  # @option options collection     [Backbone.Collection]
  #                                          collection of selectable options,
  #                                          elements must have adequate
  #                                          'toString' method implemented
  # @option options required       [Boolean] if the field is required or not
  # @option options multiple       [Boolean] if the field is multiple or not
  # @option options includeEmpty   [Boolean] whether to add an empty element or
  #                                          not
  # @option options label          [String]  label text (I18n resource id)
  # @option options selected_value [String]  early selected value
  # @option options name           [String]  HTML element name
  # @option options elementClass   [String]  HTML element class
  # @option options labelClass     [String]  HTML class for label element
  # @option options labelId        [String]  HTML id for label element
  # @option options htmlData       [Object]  key/value map of HTML data
  #                                          attributes (converts
  #                                          to data-<key> = "<value>")
  # @option options attributes     [Object]  key/value map of HTML attributes
  # @option options bindAttributes [Object]  key/value map of model-to-html
  #                                          attribute bindings
  # @option options bindFetch      [Array]   list of model attribute names that
  #                                          will trigger element's collection
  #                                          fetch on change
  # @option options hideEmptyList  [Boolean] if true, the element will be hidden
  #                                          unless its collection contains
  #                                          elements
  # @option options group          [Object]  grouping data:
  #                                          attribute - container for subitems;
  #                                          key - subitem key attribute;
  #                                          value - subitem value attribute
  # @option options container      [Object]  Container div element properties;
  #                                          supports elementId, elementClass,
  #                                          htmlData, attributes &
  #                                          bindAttributes parameters
  #
  # @return                        [String]  generated HTML code
  #
  renderSelect: ( options = { } ) ->
    innerOptions =
      elementId      : _.uniqueId "select-"
      type           : if options.group then "grouped-select" else "select"
      includeEmpty   : true
      hideEmptyList  : false
      htmlData       : { }
      attributes     : { }
      bindFetch      : [ ]
      selected_value : null

    _.extend innerOptions, options

    # delete disabled attribute if it is false
    # otherwise this method renders disabled select no matter true or false specified
    if innerOptions.attributes.disabled isnt undefined and !innerOptions.attributes.disabled
      delete innerOptions.attributes.disabled

    if innerOptions.collection
      if _.isArray innerOptions.collection
        innerOptions.collection =
          new Finliner.Collections.BaseCollection innerOptions.collection
      @stopListening innerOptions.collection, "add remove reset sort"
      @listenTo      innerOptions.collection, "add remove reset sort", ->
        @$( "##{innerOptions.elementId}" ).html(
          @renderPartial( "form_builder/select_inner"  ,
                           options: innerOptions       )
        )
        @$( "##{innerOptions.elementId}" ).change( )
        $prnt = @$( "##{innerOptions.elementId}" ).parents( ".input.select" )
        if innerOptions.collection.length
          $prnt.removeClass "empty"
        else
          $prnt.addClass    "empty"

      for i in innerOptions.bindFetch
        innerOptions.collection.stopListening( @model                         ,
                                               "change:#{i}"                  )
        innerOptions.collection.listenTo( @model                              ,
                                          "change:#{i}"                       ,
                                          -> innerOptions.collection.fetch( ) )

    labelOptions =
      elementId    : innerOptions.labelId
      elementClass : innerOptions.labelClass
      text         : innerOptions.label
      forId        : innerOptions.elementId

    labelOptions = _.extend { }, innerOptions, labelOptions

    innerOptions.container ||= { }
    innerOptions.container.elementClass ||= ""
    if innerOptions.hideEmptyList
      innerOptions.container.elementClass += " hide-empty"
    unless innerOptions.collection.length
      innerOptions.container.elementClass += " empty"

    res  = @renderPartial "form_builder/wrapper_start" , options: innerOptions
    if innerOptions.label
      res += @renderLabel labelOptions
    res += @renderPartial "form_builder/select"        , options: innerOptions
    res += @renderPartial "form_builder/wrapper_end"   , options: innerOptions

    res


  renderSwitch: ( options = { } ) ->
    innerOptions =
      elementId    : _.uniqueId "input-"

    _.extend innerOptions, options
    @renderPartial "form_builder/switch", options: innerOptions


  renderRadioBtnBoxes: ( options = { } ) ->
    innerOptions =
      "elementId"  : _.uniqueId "input-"
      "type"       : "radio-buttons"
      "label"      : null
      "current"    : @model.get(options.name)

    _.extend innerOptions, options

    labelOptions =
      "elementId"    : innerOptions.labelId
      "elementClass" : innerOptions.labelClass
      "text"         : innerOptions.label
      "forId"        : innerOptions.elementId

    labelOptions = _.extend { }, innerOptions, labelOptions

    res  = @renderPartial "form_builder/wrapper_start" , "options": innerOptions
    if innerOptions.label
      res += @renderLabel labelOptions
    res += @renderPartial "form_builder/radio_btns"    , "options": innerOptions
    res += @renderPartial "form_builder/wrapper_end"   , "options": innerOptions

    res


  renderRadioSwitch: ( options = { } ) ->
    innerOptions =
      elementId    : _.uniqueId "input-"
      label        : null

    _.extend innerOptions, options
    @renderPartial "form_builder/radio_switch", options: innerOptions


  renderTagInput: ( options = { } ) ->
    tags = options.tags || [ ]
    if tags instanceof Backbone.Collection
      tags = tags.map ( item ) -> item.toString( )

    innerOptions =
      htmlData     :
        source     : escape( JSON.stringify( tags ) )

    _.deepExtend innerOptions, options

    innerOptions.elementClass =
      _.str.trim( ( innerOptions.elementClass || "" ) + " tag-manager" )

    @renderInput innerOptions


  # Render input element
  #
  # @param  options                [Object]  rendering options
  # @option options elementId      [String]  HTML element id
  # @option options required       [Boolean] if the field is required or not
  # @option options disabled       [Boolean] if the field is disabled or not
  # @option options inline         [Boolean] if true, input has 'inline' class
  # @option options type           [String]  HTML input type
  # @option options label          [String]  label text (I18n resource id)
  # @option options placeholder    [String]  placeholder text
  # @option options name           [String]  HTML element name
  # @option options elementClass   [String]  HTML element class
  # @option options labelClass     [String]  HTML class for label element
  # @option options labelId        [String]  HTML id for label element
  # @option options htmlData       [Object]  key/value map of HTML data
  #                                          attributes (converts
  #                                          to data-<key> = "<value>")
  # @option options attributes     [Object]  key/value map of HTML attributes
  # @option options bindAttributes [Object]  key/value map of model-to-html
  #                                          attribute bindings
  # @option options container      [Object]  Container div element properties;
  #                                          supports elementId, elementClass,
  #                                          htmlData, attributes &
  #                                          bindAttributes parameters
  #
  # @return                        [String]  generated HTML code
  #
  renderInput: ( options = { } ) ->
    innerOptions =
      elementId    : _.uniqueId "input-"
      type         : "text"
      htmlData     : { }
      attributes   : { }
      #placeholder  : false

    _.extend innerOptions, options

    labelOptions =
      elementId    : innerOptions.labelId
      elementClass : innerOptions.labelClass
      text         : innerOptions.label
      rawText      : innerOptions.rawLabel
      forId        : innerOptions.elementId

    labelOptions = _.extend { }, innerOptions, labelOptions

    res  = @renderPartial "form_builder/wrapper_start" , options: innerOptions

    if _.include [ "checkbox", "radio" ], innerOptions.type
      res += @renderPartial "form_builder/input"       , options: innerOptions
      if innerOptions.label or innerOptions.rawLabel
        res += @renderLabel( _.extend( { }                    ,
                                       labelOptions           ,
                                       "requiredMark" : false ) )
    else if innerOptions.type == "textarea"
      if innerOptions.label or innerOptions.rawLabel
        res += @renderLabel labelOptions
      res += @renderPartial "form_builder/textarea"    , options: innerOptions
    else
      if innerOptions.label or innerOptions.rawLabel
        res += @renderLabel labelOptions
      res += @renderPartial "form_builder/input"       , options: innerOptions

    res += @renderPartial "form_builder/wrapper_end"   , options: innerOptions

    res


  renderInputGroup: ( options = { } ) ->
    innerOptions =
      elementId    : _.uniqueId "input-"
      required     : false
      elements     : { }

    _.extend innerOptions, options

    labelOptions =
      elementId    : innerOptions.labelId
      elementClass : innerOptions.labelClass
      text         : innerOptions.label
      forId        : innerOptions.elementId

    labelOptions = _.extend { }, innerOptions, labelOptions

    res =
      @renderPartial(
        "form_builder/group_wrapper_start" ,
        options      : innerOptions
        labelOptions : labelOptions
      )

    for i in innerOptions.elements
      i.type                   ||= "text"
      i.elementClass           ||= ""
      i.elementClass            += " align-center"
      i.container              ||= { }
      i.container.elementClass ||= ""
      i.container.elementClass  += " input-item"

      res += @renderPartial "form_builder/wrapper_start" , options: i

      res += @renderPartial "form_builder/input"         , options: i

      labelOptions =
        elementId    : i.labelId
        elementClass : i.labelClass
        text         : i.label
        forId        : i.elementId

      labelOptions = _.extend { }, i, labelOptions

      if i.label
        res += @renderLabel labelOptions

      res += @renderPartial "form_builder/wrapper_end"   , options: i


    res += @renderPartial "form_builder/wrapper_end"   , options: innerOptions

    res


  redraw: ( data = { } ) ->
    super data

    @errorList.clear( )


  render: ( data = { } ) ->
    super data
    @makeErrorBindings()
    @

  makeErrorBindings: ->
    # Make sure that our form has the classes we need
    @$( "form" ).addClass "form-builder form-basics"

    bindings = { }
    @$( "[data-wrap]" ).each ->
      path = $( @ ).attr "data-wrap"
      if $( @ ).parent( ).hasClass "nested-collection"
        errorBinding =
          selector    : "[data-error='#{path}']"
      else
        errorBinding =
          selector    : "[name='#{path}'],[data-error='#{path}'],[data-wrap='#{path}'] .tag-manager"
          elAttribute : "data-content"
          converter   : ( direction, value ) ->
            if value then value else ""
      bindings[ path ] = [
        errorBinding
      ,
        selector    : "[data-wrap='#{path}']"
        elAttribute : "class"
        converter   : ( direction, value ) ->
          if value
            "wrapper validation-input error validation-error"
          else
            "wrapper validation-input"
      ]

    @formBinder.bind @errorList, @$el, bindings
