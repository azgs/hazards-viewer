# Setup a global object to stash our work in
root = @
if not root.app? then app = root.app = {} else app = root.app

class app.GeocodeView extends Backbone.View

  initialize: (options) ->
    popupTemplate = _.template $("#localHazards").html()

    @layer = new L.GeoJSON null,
      onEachFeature: (feature, layer) ->
        popup = layer.bindPopup popupTemplate feature.properties

    @layer.addTo app.map

  events:
    "keyup input": "geocode"

  geocode: (e) ->
    if e.keyCode is 13
      l = @layer
      bufferDistance = 5000 # in meters
      @model.getLocalHazards $(e.currentTarget).val(), bufferDistance, app.dataLayerCollection.models, (bbox, point, name, result) ->
        # Zoom to the given bounding box
        sw = [ bbox[0], bbox[1] ]
        ne = [ bbox[2], bbox[3] ]
        app.map.fitBounds [ sw, ne ]

        # Add a marker to the Layer
        geojson = {
          type: "Feature"
          properties:
            location: name
            bufferDistance: bufferDistance
            result: result
          geometry:
            type: "Point"
            coordinates: [ point.coordinates[1], point.coordinates[0] ]
        }

        l.clearLayers()
        l.addData geojson

        # Open the Popups immediately
        ( layer.openPopup() for key, layer of l._layers )
