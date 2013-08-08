# Setup a global object to stash our work in
root = @
if not root.app? then app = root.app = {} else app = root.app
if not app.views? then app.views = views = {} else views = app.views

class app.views.SidebarView extends Backbone.View
  initialize: (options) ->
    @template = _.template $("#model-template").html()
    @modalTemplate = _.template $("#layer-modal").html()

  render: () ->
    el = @$el
    template = @template
    modal = @modalTemplate

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

      # Setup a Modal dialog
      $("body").append modal
        model: model

    # All filterable boxes should start checked
    el.find(".filter").prop "checked", true

    # Hacky -- bind event to part of the modals
    $(".info-collapse").on "click", @toggleCollapseIcon

    return @

  events:
    "click input.layerToggle": "toggleLayer"
    "click .info-collapse": "toggleCollapseIcon"

  findActiveLayers: () -> return (model for model in @collection.models when model.get("active"))

  toggleCollapseIcon: (e) ->
    console.log "are, are we here?"
    id = "#{$(e.currentTarget).attr("data-target")}-icon"
    icon = $ id
    if icon.hasClass "icon-chevron-down"
      icon.removeClass "icon-chevron-down"
      icon.addClass "icon-chevron-right"
    else if icon.hasClass "icon-chevron-right"
      icon.removeClass "icon-chevron-right"
      icon.addClass "icon-chevron-down"

  toggleLayer: (e) ->
    checkbox = $ e.currentTarget
    boxId = checkbox.attr "id"
    modelId = boxId.split("-")[0]
    model = @collection.get modelId

    # Toggle the legend
    @$el.find("##{boxId.split("-")[0]}-legend-collapse").collapse "toggle"

    if checkbox.is ":checked"
      # Get the layer added to the map
      l = model.get "layer"
      app.map.addLayer l
      model.set "active", true

      # Give an ID to the DOM representation of a GeoJSON layer
      for key, value of l._layers
        p = $(value._container).parent()

      if p?
        p.attr "id", "#{model.id}-layer"
    else
      app.map.removeLayer model.get "layer"
      model.set "active", false

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

    l = model.get "layer"
    app.map.addLayer l
    l.bringToBack()
    model.set "active", true

    app.map.removeLayer activeModel.get "layer"
    activeModel.set "active", false

class views.DownloadView extends Backbone.View
  # Expects to be given a models.LayerCollection, and expects its el to be a modal
  # leaflet-control-draw-rectangle
  template: _.template $("#downloadBody").html()

  initialize: () ->
    # Setup a Leaflet.Draw handler
    @drawHandler = new L.Draw.BoundedRectangle app.map, {}

  render: () ->
    # Find the modal body and append the template
    body = @$el.find ".modal-body"
    body.empty()
    body.append @template
      layers: @collection.models

    # Adjust the footer buttons
    @$el.find(".modal-footer .btn-primary").remove()

    # jQuery to make the buttons change color when you click them
    body.find(".btn").on "click", (e) ->
      body.find(".btn-success").toggleClass "btn-success"
      $(e.currentTarget).toggleClass "btn-success"

    # Setup a listener for leaflet.draw events
    thisCollection = @collection
    thisDrawHandler = @drawHandler

    app.map.on 'draw:created', (e) ->
      # Which layers were checked?
      layers = ( thisCollection.get($(btn).attr("id").split("-")[0]) for btn in body.find "button.active" )

      # Pass the drawn rectangle into a Leaflet LatLngBounds
      bounds = new L.latLngBounds(e.layer._latlngs)
      bbox = bounds.toBBoxString()
      ( l.download(bbox) for l in layers )

    return @

  events:
    "click #draw-a-box": "drawArea"

  drawArea: (e) ->
    # Click the Leaflet.draw control?!
    @drawHandler.enable()

