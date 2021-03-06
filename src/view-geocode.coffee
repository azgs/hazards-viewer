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
      query = if @model.get('value') then @model.get('value') else $(e.currentTarget).val()
      bufferDistance = 5000 # in meters
      @model.getLocalHazards query, bufferDistance, app.dataLayerCollection.models, (bbox, point, name, result) ->
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
        
        # Fire toggler
        $('#turn-on-fires').one 'click', (evt) ->
          fires = _.first app.dataLayerCollection.filter (model) ->
            return model.id is 'fireRisk'

          if not fires.get 'active'
            $('#fireRisk-toggle').trigger 'click'
            ( layer.closePopup() for key, layer of l._layers )

        return