# Setup a global object to stash our work in
root = @
if not root.app? then app = root.app = {} else app = root.app
if not app.models then models = app.models = {} else models = app.models
if not app.data then data = app.data = {} else data = app.data

class app.models.LayerModel extends Backbone.Model
  defaults:
    layerName: "No Name"
    description: "No Description"
    serviceUrl: null
    legend: new models.Legend [], {}

  initialize: (options) ->
    @set "divid", options.id + ".id"
    @set "datatarget", "#" + options.id
    @id = options.id or "layer-#{Math.floor(Math.random() * 101)}"
    @set "layer", @createLayer(options)
    @originalOptions = options

  createLayer: (options) ->
    return null

  filterLayer: (filters) ->
    return null

  downloadShapefile: (bbox) ->
    url = if @get("wfsUrl")? then @get("wfsUrl") else @get("serviceUrl")
    url += "?service=WFS&version=1.0.0&request=GetFeature&outputFormat=SHAPE-ZIP"
    url += "&typeName=#{@get("typeName")}"
    url += "&bbox=#{bbox}"

    # This way opens a new window for every download
    #window.open url

    # But this way moves too fast and you only get one file
    window.location.assign url

    # This doesn't work
    #link = $("<a href='" + url + "'></a>").appendTo("body")
    #link.click()

    # Better way might be to send all the URLs to Node.js and have it bundle them into one zip file?
    # No. Assemble the URLs then present a modal allowing users to click the links and get files individually

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
        layerType = if options.useD3 then L.GeoJSON.d3 else L.GeoJSON
        layer = new layerType data, options.layerOptions
        thisModel.set "layer", layer
        thisModel.trigger "layerLoaded", layer

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
    @createLayer _.extend { filterClause: filterClause }, @originalOptions

class app.models.BingLayer extends app.models.LayerModel
  createLayer: (options) ->
    if options.apiKey? and options.bingType?
      layer = new L.BingLayer options.apiKey,
        type: options.bingType
      return layer
    return

class app.models.LayerCollection extends Backbone.Collection
  model: app.models.LayerModel
  
