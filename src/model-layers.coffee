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
    @set "id",options.id
    @set "layerName", options.layerName
    @set "geoJSON_URL", options.geoJSON_URL
    @set "layer", @createLayer()

  createLayer: () ->
    return new L.GeoJSON.d3.async @get("geoJSON_URL"), styler: {}

class app.LayerCollection extends Backbone.Collection
  model:app.LayerModel

