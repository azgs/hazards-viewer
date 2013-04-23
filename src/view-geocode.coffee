# Setup a global object to stash our work in
root = @
if not root.app? then app = root.app = {} else app = root.app

class app.GeocodeView extends Backbone.View
  initialize: (options) ->
    console.log "hello"

  events:
    "keyup input": "geocode"

  geocode: (e) ->
    if e.keyCode is 13
      @model.getLocation $(e.currentTarget).val(), (bbox, point) ->
        # Zoom to the given bounding box
        sw = [ bbox[0], bbox[1] ]
        ne = [ bbox[2], bbox[3] ]
        app.map.fitBounds [ sw, ne ]