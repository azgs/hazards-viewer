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
    @set "typeName", options.typeName
    @set "layerName", options.layerName
    @set "geoserverUrl", options.geoserverUrl
    @set "styleAttribute", options.styler or ""
    @set "d3Layer", @createD3Layer()
    @set "wmsLayer", @createWmsLayer()
    @set "defaultLayer", if options.useWms then @get("wmsLayer") else @get("d3Layer")
    if options.tileUrl?
      @set "tileUrl", options.tileUrl
      @set "defaultLayer", @createTileLayer()

  createD3Layer: () ->
    url = "#{@get("geoserverUrl")}?service=WFS&version=1.0.0&request=GetFeature&typeName=#{@get("typeName")}&outputFormat=json"
    return new L.GeoJSON.d3.async url, styler: @get("styleAttribute")

  createWmsLayer: () ->
    url = "#{@get("geoserverUrl")}"
    return new L.TileLayer.WMS url,
      layers: @get "typeName"
      format: "image/png"
      transparent: true

  createTileLayer: () ->
    return new L.TileLayer @get("tileUrl")

class app.LayerCollection extends Backbone.Collection
  model:app.LayerModel