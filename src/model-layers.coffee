# Setup a global object to stash our work in
root = @
if not root.app? then app = root.app = {} else app = root.app
if not app.models then models = app.models = {} else models = app.models
if not app.views? then app.views = views = {} else views = app.views
if not app.data then data = app.data = {} else data = app.data

class app.models.LayerModel extends Backbone.Model
  defaults:
    layerName: "No Name"
    description: "No Description"
    serviceUrl: null
    legend: new models.Legend [], {}

  initialize: (options) ->
    #@set "divid", options.id + ".id"
    #@set "datatarget", "#" + options.id
    @id = options.id or "layer-#{Math.floor(Math.random() * 101)}"
    @set "layer", @createLayer(options)
    @originalOptions = options

  createLayer: (options) ->
    return null

  filterLayer: (filters) ->
    return null

  dataUrl: () ->
    return @get("downloadUrlTemplate") if @get("downloadUrlTemplate")?
    url = if @get("wfsUrl")? then @get("wfsUrl") else @get("serviceUrl")
    url += "?service=WFS&version=1.0.0&request=GetFeature"
    url += "&typeName=#{@get("typeName")}"
    return url

  download: (bbox) ->
    url = @dataUrl()
    if url.indexOf("{{bbox}}") isnt -1
      url = url.replace("{{bbox}}", bbox)
    else
      url += "&outputFormat=SHAPE-ZIP&bbox=#{bbox}"

    # Download the file. Hopefully this is cross-browser compatible
    window.location.assign url

class app.models.WmsLayer extends app.models.LayerModel
  createLayer: (options) ->
    if options.serviceUrl? and options.typeName?
      layer = new L.TileLayer.WMS options.serviceUrl,
        layers: options.typeName
        format: options.format or "image/png"
        transparent: options.transparent or true
      layer.setZIndex 4
      return layer

    console.log "Error creating #{@get("layerName")}:\n\tMake sure to specify serviceUrl and typeName when creating a WmsLayer."
    return

class app.models.GeoJSONLayer extends app.models.LayerModel
  createLayer: (options) ->
    if options.serviceUrl? and options.typeName? and options.layerOptions?
      callbackName = "#{@id}Data"
      jsonp = options.serviceUrl
      jsonp += "?service=WFS&version=1.0.0&request=GetFeature&outputFormat=text/javascript"
      jsonp += "&typeName=#{options.typeName}"
      jsonp += "&format_options=callback:app.data.#{callbackName}"
      jsonp += options.filterClause if options.filterClause?

      thisModel = @

      app.data[callbackName] = (data) ->
        layerType = if options.useD3 and not L.Browser.ielt9 then L.GeoJSON.d3 else L.filterGeoJson
        layer = new layerType data, options.layerOptions
        thisModel.set "layer", layer
        thisModel.trigger "layerLoaded", layer
        thisModel.set "currentData", data

        # Render earthquakes time slider view
        if options.id is "earthquakes"
          dates = []
          _.each data.features, (d) ->
            dates.push new Date d.properties.date

          minDate = new Date(Math.min.apply(null, dates)).toISOString()
          maxDate = new Date(Math.max.apply(null, dates)).toISOString()

          thisModel.set "minDate", minDate
          thisModel.set "maxDate", maxDate

          eqSliderLegendView = new views.EqSliderLegendView
            model: thisModel
            minDate: thisModel.get "minDate"
            maxDate: thisModel.get "maxDate"
            el: $("#layer-list").find("##{options.id}-legend-collapse")
          eqSliderLegendView.render()

      $.ajax
        url: jsonp
        dataType: "jsonp"

      return

    else
      console.log "Error creating #{@get("layerName")}:\n\tMake sure to specify serviceUrl, typeName and layerOptions when creating a GeoJSONLayer."
      return

  filterLayer: (filters) ->
    f = new models.Filter filters
    filterClause = "&filter=#{f.urlEncoded()}"
    @createLayer _.extend @originalOptions, { filterClause: filterClause }

class app.models.BingLayer extends app.models.LayerModel
  createLayer: (options) ->
    if options.apiKey? and options.bingType?
      layer = new L.BingLayer options.apiKey,
        type: options.id
      return layer
    return

class app.models.TileLayer extends app.models.LayerModel
  createLayer: (options) ->
    if options.url?
      return new L.TileLayer options.url, options
    return

class app.models.LayerCollection extends Backbone.Collection
  model: app.models.LayerModel
  
