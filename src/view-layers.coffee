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
      el.append template
        model: model

    return @

  events:
    "click input[type=checkbox]": "toggleLayer"
    "click .icon-list":"toggleLegend"

  toggleLayer: (e) ->
    checkbox = $ e.currentTarget
    boxId = checkbox.attr "id"
    modelId = boxId.split("-")[0]
    model = @collection.get modelId

    if checkbox.is ":checked"
      l = model.get "layer"
      app.map.addLayer l

      for key, value of l._layers
        p = $(value._container).parent()

      p.attr "id", "#{model.id}-layer"

    else
      app.map.removeLayer model.get "layer"
      
  toggleLegend: (e) ->
    element = $ e.currentTarget
    elId = element.attr "id"
    $(elId).collapse('toggle')

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
