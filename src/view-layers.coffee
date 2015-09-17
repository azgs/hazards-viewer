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
    
    # Remove checkbox from Study_areas layer
    $("input[columnvalue*=x]").remove()
    

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
    @collection2 = app.dataLayerCollection2
    
    if modelId is "floodPotential"
      model2 = @collection2.get ("MajorR")
      MR = model2.get "layer"
      app.map.addLayer MR
      model2.set "active", true
      
      for key, value4 of MR._layers
        for key, value5  of value4._layers
          pr = $(value5._container).children()
          pr.attr "class", "#{model2.id}-layer"
      
    if modelId is "earthFissures"
        model3 = app.dataLayerCollection2.get ("study_area_wgs84")
        SA = model3.get "layer"
        app.map.addLayer SA
        model3.set "active", true
        
        for key, value2 of SA._layers
          for key, value3  of value2._layers
            pr = $(value3._container).children()
            pr.attr "class", "#{model3.id}-layer"

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
        
        
    else if modelId is "floodPotential"
      app.map.removeLayer model2.get "layer"
      model2.set "active", false
      app.map.removeLayer model.get "layer"
      model.set "active", false
      
    else if modelId is "earthFissures"
      app.map.removeLayer model3.get "layer"
      model3.set "active", false
      app.map.removeLayer model.get "layer"
      model.set "active", false
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
    body.find(".toggler").on "click", (e) ->
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
    "click #get-a-layer": "downloadALayer"
    "click #download-all": "downloadAll"
    "click #download-metadata": "downloadMetadata"

  drawArea: (e) ->
    # Click the Leaflet.draw control?!
    @drawHandler.enable()

  downloadALayer: () ->
    layerId = @$el.find('.btn-success').attr('id').split('-')[0]
    url = 'http://data.azgs.az.gov/static/downloadable-files/hazard-data/'
    if layerId is 'earthFissures'
      url += 'earthfissures.zip'
    if layerId is 'activeFaults'
      url += 'activefaults.zip'
    if layerId is 'earthquakes'
      url += 'earthquakes.zip'
    if layerId is 'floodPotential'
      url += 'floods.zip'
    if layerId is 'fireRisk'
      url += 'wildfires.zip'

    window.location.assign url

  downloadMetadata: () ->
    layerId = @$el.find('.btn-success').attr('id').split('-')[0]
    url = 'http://data.azgs.az.gov/static/downloadable-files/hazard-data/'
    if layerId is 'earthFissures'
      url += 'earthfissures'
    if layerId is 'activeFaults'
      url += 'activefaults'
    if layerId is 'earthquakes'
      url += 'earthquakes'
    if layerId is 'floodPotential'
      url += 'floods'
    if layerId is 'fireRisk'
      url += 'wildfires'

    window.location.assign url + '-metadata.xml'

  downloadAll: () ->
    window.location.assign 'http://data.azgs.az.gov/static/downloadable-files/hazard-data/hazard-data.zip'