# Setup a global object to stash our work in
root = @
if not root.app? then app = root.app = {} else app = root.app

class app.LayerModel extends Backbone.Model
  defaults:
    id:""
    layerName:""
    geoJSON_URL:""
    layer:""
    
  initialize: (options) ->
    @set "id", options.id
    @set "layerName", options.layerName
    if options.layerId?
      @set "layerId", options.layerId

    @set "geoserverUrl", options.geoserverUrl
    @set "typeName", options.typeName
    @set "styleAttribute", options.styler or ""

    @set "wmsLayer", @createWmsLayer()

    if options.useWms
      @set "defaultLayer", @createWmsLayer()
    else if options.useTms
      @set "tileUrl", options.tileUrl
      @set "defaultLayer", @createTileLayer()
    else if options.straightGeoJson
      @set "defaultLayer", @createGeoJSONLayer(options.layerOptions or null)
    else
      @createD3Layer()

  createGeoJSONLayer: (layerOptions) ->
    thisLayer = @
    callbackName = "#{@get("id")}Data"
    jsonpUrl = "#{@get("geoserverUrl")}?service=WFS&version=1.0.0&request=GetFeature&typeName=#{@get("typeName")}&outputFormat=text/javascript&format_options=callback:app.#{callbackName}"

    app[callbackName] = (data) ->
      l = new L.GeoJSON data, layerOptions
      thisLayer.set "defaultLayer", l

    $.ajax
      url: jsonpUrl
      dataType: "jsonp"

  createD3Layer: () ->
    callbackName = "#{@get("id")}Data"
    styler = @get "styleAttribute"
    jsonpUrl = "#{@get("geoserverUrl")}?service=WFS&version=1.0.0&request=GetFeature&typeName=#{@get("typeName")}&outputFormat=text/javascript&format_options=callback:app.#{callbackName}"
    thisLayer = @
    layerId = @get("layerId")

    # Define the function that'll run when the JSONP comes back. This should generate the d3 layer
    app[callbackName] = (data) ->
      options =
        styler: styler
      options.layerId = layerId if layerId?

      l = new L.GeoJSON.d3 data, options
      thisLayer.set "defaultLayer", l

    # Make the JSONP request
    $.ajax
      url: jsonpUrl
      dataType: "jsonp"


  createWmsLayer: () ->
    url = "#{@get("geoserverUrl")}"
    layer = new L.TileLayer.WMS url,
      layers: @get "typeName"
      format: "image/png"
      transparent: true
    layer.setZIndex 4
    return layer

  createTileLayer: () ->
    layer = new L.TileLayer @get("tileUrl")
    layer.setZIndex 4
    return layer

class app.baseMapModel extends Backbone.Model
  defaults:
    id:""
    mapName:""
    apiKey:""
    isActive:""
  
  initialize: (options) ->
    @set "id", options.id
    @set "mapName", options.mapName
    @set "apiKey", options.apiKey
    @set "defaultBaseLayer", @defaultBaseLayer()
    @set "createBaseLayer", @createBaseLayer()
    @set "baseLayer", if options.default then @get "defaultBaseLayer" else @get "createBaseLayer"
    
  defaultBaseLayer: () ->
    url = @get "apiKey"
    if @get "default"
      return new L.BingLayer url, 
        type:@get "type"    

  createBaseLayer: () ->
    url = @get "apiKey"
    if @get "useBing"
      return new L.BingLayer url, 
        type:@get "type"

class app.LayerCollection extends Backbone.Collection
  model:app.LayerModel
  
class app.BaseMapCollection extends Backbone.Collection
  model:app.baseMapModel