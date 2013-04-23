# Setup a global object to stash our work in
root = @
if not root.app? then app = root.app = {} else app = root.app

class app.GeocodeModel extends Backbone.Model
  initialize: (options) ->
    @set "key", options.apiKey or null
    @set "baseUrl", "http://dev.virtualearth.net/REST/v1/Locations/"
    @set "proxy", options.proxy or "/proxy"

  # Utilize Bing Geocoding
  getLocation: (query, callback) ->
    $.ajax
      url: "#{@get("proxy")}?url=#{@get("baseUrl")}/#{query}?key=#{@get("key")}"
      dataType: "json"
      success: (data) ->
        # Find the coordinates
        bbox = data.resourceSets[0].resources[0].bbox
        point = data.resourceSets[0].resources[0].point
        callback bbox, point
      error: (err) ->
        console.log err