# Setup a global object to stash our work in
root = @
if not root.app? then app = root.app = {} else app = root.app

class app.GeocodeView extends Backbone.View
  initialize: (options) ->
    @layer = new L.GeoJSON null,
      onEachFeature: (feature, layer) ->
        layer.bindPopup feature.properties.name

    @layer.addTo app.map

  events:
    "keyup input": "geocode"

  geocode: (e) ->
    if e.keyCode is 13
      l = @layer
      @model.getLocation $(e.currentTarget).val(), (bbox, point, name) ->
        # Zoom to the given bounding box
        sw = [ bbox[0], bbox[1] ]
        ne = [ bbox[2], bbox[3] ]
        app.map.fitBounds [ sw, ne ]

        # Add a marker to the Layer
        geojson = {
          type: "Feature"
          properties:
            name: name
          geometry:
            type: "Point"
            coordinates: [ point.coordinates[1], point.coordinates[0] ]
        }

        l.clearLayers()
        l.addData geojson