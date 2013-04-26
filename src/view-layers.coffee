# Setup a global object to stash our work in
root = @
if not root.app? then app = root.app = {} else app = root.app
if not app.views? then app.views = views = {} else views = app.views

class app.views.SidebarView extends Backbone.View
  initialize: (options) ->
    @template = _.template $("#model-template").html()

  render: () ->
    el = @$el
    template = @template

    @collection.forEach (model) ->
      # Append the model's template
      el.append template
        model: model

      # Append the model's legend's template
      legendView = new views.LegendView
        layerModel: model
        collection: model.get("legend")
        el: el.find("##{model.get("id")}-legend")
      legendView.render()

      # Setup the info popover
      el.find(".layer-info-button").popover
        title: "Layer Information"
        content: model.get "description"
        placement: "bottom"
        trigger: "manual"

    # All filterable boxes should start checked
    el.find(".filter").prop "checked", true

    return @

  events:
    "click input.layerToggle": "toggleLayer"
    "click .icon-list": "toggleLegend"
    "click .layer-info-button": "showInfo"

  toggleLayer: (e) ->
    checkbox = $ e.currentTarget
    boxId = checkbox.attr "id"
    modelId = boxId.split("-")[0]
    model = @collection.get modelId

    if checkbox.is ":checked"
      # Get the layer added to the map
      l = model.get "layer"
      app.map.addLayer l

      # Give an ID to the DOM representation of a GeoJSON layer
      for key, value of l._layers
        p = $(value._container).parent()

      if p?
        p.attr "id", "#{model.id}-layer"
    else
      app.map.removeLayer model.get "layer"
      
  toggleLegend: (e) ->
    element = $ e.currentTarget
    elId = element.attr "id"
    $(elId).collapse('toggle')

  showInfo: (e) ->
    # Show this popover
    ele = $ e.currentTarget
    ele.popover "show"

    # Setup to hide this one if someone clicks somewhere else
    hideIt = (e) ->
      if not $(e.target).is(ele)
        ele.popover "hide"
        $("body").off "click", hideIt

    # Bind an event to hide this popover if user clicks anywhere
    $("body").on "click", hideIt

class app.views.BasemapView extends Backbone.View
  initialize: (options) ->
    @template = _.template $("#basemap-template").html()
    active = @findActiveModel()
    app.map.addLayer(active.get("layer")) if active?

  render: () ->
    el = @$el
    template = @template

    @collection.forEach (model) ->
      el.append template
        model: model

    return @

  events:
    "click a": "switchBaseMap"

  findActiveModel: () ->
    for model in @collection.models
      return model if model.get "active"

  switchBaseMap: (e) ->
    toggle = $ e.currentTarget
    toggleId = toggle.attr "id"
    modelId = toggleId.split("-")[0]
    model = @collection.get modelId
    activeModel = @findActiveModel()

    return if model is activeModel

    app.map.addLayer model.get "layer"
    model.set "active", true

    app.map.removeLayer activeModel.get "layer"
    activeModel.set "active", false
