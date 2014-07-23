# Setup a global object to stash our work in
root = @
if not root.app? then app = root.app = {} else app = root.app
if not app.views? then app.views = views = {} else views = app.views

class views.LegendView extends Backbone.View
  initialize: (options) ->
    @template = _.template $("#legend-template").html()
    ##@itemTemplate = _.template $("#legendItem-template").html()
    @layerModel = options.layerModel or null

  render: () ->
    # Append the legend container
    @$el.append @template
      model: @collection

    children = @$el.find ".legendItems"

    @collection.forEach (model) ->
      child = children.append("<tr class='legend-item-fisstype'></tr>")
      @model = model
      @legenditemview = new views.LegendItemView
        model: @model
        el: child
      @legenditemview.render()

    return @

  events:
    "click .filter": "applyFilter"

  applyFilter: (e) ->
    # Find which boxes are currently checked
    filterObj = (boxEl) ->
      obj = {}
      obj[$(box).attr("column")] = $(box).attr("columnvalue")
      return obj

    oldLayer = @layerModel.get("layer")
    @layerModel.once "layerLoaded", (newLayer) ->
      if app.map.hasLayer oldLayer
        app.map.removeLayer oldLayer
        newLayer.addTo app.map

    filters = ( filterObj(box) for box in @$el.find(".filter") when $(box).is(":checked") )
    @layerModel.filterLayer filters




class views.LegendItemView extends Backbone.View
  initialize: (options) ->
    @itemTemplate = _.template $("#legendItem-template").html()
    @filterAttr = options.model.collection.filterable
    @filterable = if @filterAttr? then @filterAttr else true

  render: () ->
    itemTemplate = @itemTemplate
    # Append the legend item template
    thisone = $(itemTemplate({model: @model, filter: @filterable}).replace(/\n|\r|\t|  /g, "")).appendTo @$el

    # Append the legend image template
    attribute = model.get "attribute"
    thisone.children(".legend-image-"+attribute).append model.get "image"
    return @

  events:
    "click .filter": "setActive"

  setActive: (e) ->
    @model.set "active", false




class views.PrintLegendView extends Backbone.View
  initialize: (options) ->
    @template = _.template $("#print-legend-template").html()
    @itemTemplate = _.template $("#print-legend-items").html()
    @layerModel = options.layerModel or null

  render: () ->
    # Append the legend container
    @$el.append @template
      model: @collection

    # Setup to append legend item templates
    el = @$el
    itemTemplate = @itemTemplate
    filterable = @collection.filterable

    @collection.forEach (model) ->
      # Append the legend item template
      thisone = $(itemTemplate({model: model, filter: filterable}).replace(/\n|\t|\r|  /g, "")).appendTo el
      # Append the legend image template
      attribute = model.get "attribute"
      thisone.children(".legend-image-"+attribute).append model.get "image"

    return @

class views.EqSliderLegendView extends Backbone.View
  initialize: (options) ->
    @sliderTemplate = _.template $("#eqTimeSlider").html()

  render: () ->
    $("#eq-time-slider-container").remove()
    @$el.prepend @sliderTemplate
    maxDate = @options.maxDate
    minDate = @options.minDate
    layer = @model.get "layer"

    $ ->
      $("#eq-slider-widget").slider
        range: "min"
        value: new Date(maxDate).valueOf()
        min: new Date(minDate).valueOf()
        max: new Date(maxDate).valueOf()
        slide: (event, ui) ->
          layer.setFilter (f) ->
            return new Date(f.properties.date).valueOf() < ui.value