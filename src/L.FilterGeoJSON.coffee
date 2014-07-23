# 
#Original concept by Mapbox: 
#https://www.mapbox.com/mapbox.js/example/v1.0.0/filtering-markers/ 
#Tested with Leaflet v0.7.2.
#
#Vanilla leaflet only allows pre-filtering of json data.  This extension
#makes it possible to post-filter as well.
#
#Usage:
#
#var layer = L.filterGeoJson(data, options);
#
#layer.setFilter(function (f) {
#  return f.properties["lynyrd"] = "skynyrd";
#});
#
L.FilterGeoJSON = L.FeatureGroup.extend(
  options:
    filter: ->
      true

  initialize: (data, options) ->
    L.setOptions this, options
    @_layers = {}
    @_style = options
    @setGeoJSON data  if data isnt null
    return

  addJSON: (data) ->
    @setGeoJSON data
    return

  setGeoJSON: (data) ->
    @_geojson = data
    @clearLayers()
    @filterize data
    this

  setFilter: (f) ->
    @options.filter = f
    if @_geojson
      @clearLayers()
      @filterize @_geojson
    this

  filterize: (json) ->
    f = (if L.Util.isArray(json) then json else json.features)
    i = undefined
    len = undefined
    if f
      i = 0
      while i < f.length
        @filterize f[i]  if f[i].geometries or f[i].geometry or f[i].features
        i++
    else if @options.filter(json)
      pointToLayer = @_style.pointToLayer
      layer = L.GeoJSON.geometryToLayer(json, pointToLayer)
      layer.feature = json
      @addLayer layer
    return
)
L.filterGeoJson = (data, options) ->
  new L.FilterGeoJSON(data, options)