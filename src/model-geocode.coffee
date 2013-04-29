# Setup a global object to stash our work in
root = @
if not root.app? then app = root.app = {} else app = root.app

class app.GeocodeModel extends Backbone.Model
  initialize: (options) ->
    @set "key", options.apiKey or null
    @set "baseUrl", "http://dev.virtualearth.net/REST/v1/Locations/"
    @set "proxy", options.proxy or "proxy"

  # Utilize Bing Geocoding
  getLocation: (query, callback) ->
    $.ajax
      url: "#{@get("proxy")}?url=#{@get("baseUrl")}/#{query}?key=#{@get("key")}"
      dataType: "json"
      success: (data) ->
        # Find the coordinates
        bbox = data.resourceSets[0].resources[0].bbox
        point = data.resourceSets[0].resources[0].point
        name = data.resourceSets[0].resources[0].name
        callback bbox, point, name
      error: (err) ->
        console.log err

  # Lookup hazards in the area based on a spatial query
  getLocalHazards: (query, bufferDistance, hazardLayers, callback) ->

    # Helper function to buffer a bbox and return L.LatLngBounds object
    bufferedBBox = (bbox, buffer) ->
      # Buffer the bbox: 1st generate geographic corner coordinates
      sw = new L.LatLng bbox[0], bbox[1]
      ne = new L.LatLng bbox[2], bbox[3]

      # 2nd project to spherical mercator
      sw_proj = L.Projection.Mercator.project sw
      ne_proj = L.Projection.Mercator.project ne

      # 3rd extend the coords by the bufferDistance
      buffered_sw_proj = new L.Point sw_proj.x - buffer, sw_proj.y - buffer
      buffered_ne_proj = new L.Point ne_proj.x + buffer, ne_proj.y + buffer

      # 4th unproject back into geographic coordinates
      buffered_sw = L.Projection.Mercator.unproject buffered_sw_proj
      buffered_ne = L.Projection.Mercator.unproject buffered_ne_proj

      # 5th generate the L.LatLng bounds
      return new L.LatLngBounds buffered_sw, buffered_ne


    # First find the location using the Bing Geocoder
    @getLocation query, (box, point, name) ->
      # Should not do anything if the location is outside Arizona

      # Get the buffered BBOX
      buffered = bufferedBBox box, bufferDistance

      # Read the BBOX into JSTS
      wktReader = new jsts.io.WKTReader
      bboxWkt = "POLYGON((\
        #{buffered.getWest()} #{buffered.getSouth()}, \
        #{buffered.getEast()} #{buffered.getSouth()}, \
        #{buffered.getEast()} #{buffered.getNorth()}, \
        #{buffered.getWest()} #{buffered.getNorth()}, \
        #{buffered.getWest()} #{buffered.getSouth()}))"

      bbox = wktReader.read bboxWkt

      output =
        buffer: buffered

      # Okay, now for each layer
      for layer in hazardLayers
        output[layer.get("layerName")] = thisOne = {}

        # Check if we have currentData
        data = layer.get "currentData"

        # If there isn't any, we have to go get it
        if not data?
          # This is currently hard-wired for floods, although this will get hit by any not-WFS layer
          callbackName = "localFloods"
          dataUrl = layer.dataUrl()
          dataUrl += "&outputFormat=text/javascript"
          dataUrl += "&format_options=callback:app.data.#{callbackName}"

          bboxFilter = new app.models.filters.BBoxFilter [
            "shape",
            [
              output.buffer.getWest(),
              output.buffer.getSouth(),
              output.buffer.getEast(),
              output.buffer.getNorth()
            ]
          ]

          attrFilter = new app.models.filters.OrFilter [
              new app.models.filters.PropertyFilter ["haz_rating", "Medium"]
            ,
              new app.models.filters.PropertyFilter ["haz_rating", "High"]
          ]

          filter = new app.models.filters.AndFilter [bboxFilter, attrFilter], version: "1.0.0"
          dataUrl += "&filter=#{filter.urlEncoded()}"
          floodCount = thisOne

          app.data[callbackName] = (data) ->
            output["Flood Potential"].count = data.features.length

            # Now we've looped through everything, respond via callback
            callback box, point, name, output

          $.ajax
            url: dataUrl
            dataType: "jsonp"

        else
          # If there is any, we can intersect it with the bbox by...
          # Read the GeoJSON
          geoJsonReader = new jsts.io.GeoJSONReader()
          data = geoJsonReader.read data

          # Iterate through features and see if they intersect
          count = 0
          for feature in data.features
            count++ if bbox.intersects feature.geometry

          # Append the count to the output obj
          thisOne.count = count


      return