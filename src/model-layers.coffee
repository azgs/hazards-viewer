# Setup a global object to stash our work in
root = @
if not root.app? then app = root.app = {} else app = root.app

app.models = {}
app.data = {}

class app.models.LayerModel extends Backbone.Model
  defaults:
    id: "layer-#{Math.floor(Math.random() * 101)}"
    layerName: "No Name"
    description: "No Description"
    serviceUrl: null

  initialize: (options) ->
    @set "layer", @createLayer(options)

  createLayer: (options) ->
    return null

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

      thisModel = @

      app.data[callbackName] = (data) ->
        layerType = if options.useD3 then L.GeoJSON.d3 else L.GeoJSON
        layer = new layerType data, options.layerOptions
        thisModel.set "layer", layer

      $.ajax
        url: jsonp
        dataType: "jsonp"

      return

    else
      console.log "Error creating #{@get("layerName")}:\n\tMake sure to specify serviceUrl, typeName and layerOptions when creating a GeoJSONLayer."
      return

class app.models.BingLayer extends app.models.LayerModel
  createLayer: (options) ->
    if options.apiKey? and options.bingType?
      layer = new L.BingLayer options.apiKey,
        type: options.bingType
      return layer
    return

class app.models.LayerCollection extends Backbone.Collection
  model: app.models.LayerModel
  
class app.models.navToolModel extends Backbone.Model
  defaults:
    id:""
    datatarget:""
    display:""
    title:""
    body:""

class app.models.NavToolCollection extends Backbone.Collection
  model:app.models.navToolModel