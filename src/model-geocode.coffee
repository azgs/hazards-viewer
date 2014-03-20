# Setup a global object to stash our work in
root = @
if not root.app? then app = root.app = {} else app = root.app

COUNTY_CONTACTS = {
  "apache":{
    "name":"Apache County",
    "county":"http://www.co.apache.az.us/",
    "emergency":"http://www.co.apache.az.us/Departments/EmergencyRisk/Emergency.htm",
    "flood":"http://www.co.apache.az.us/Departments/Engineering/Engineering.htm"
  },
  "cochise":{
    "name":"Cochise County",
    "county":"http://www.cochise.az.gov/",
    "emergency":"http://cochise.az.gov/cochise_emergency_services.aspx?id=244",
    "flood":"http://cochise.az.gov/cochise_highways_floodplain.aspx?id=266"
  },
  "coconino":{
    "name": "Coconino County",
    "county":"http://www.coconino.az.gov/",
    "emergency":"http://www.coconino.az.gov/index.aspx?nid=207",
    "flood":"http://www.coconino.az.gov/index.aspx?NID=838"
  },
  "gila":{
    "name":"Gila County",
    "county":"http://www.gilacountyaz.gov/",
    "emergency":"http://www.gilacountyaz.gov/government/health_and_emergency_services/emergency_management/index.php",
    "flood":"http://www.gilacountyaz.gov/government/public_works/floodplain/index.php"
  },
  "graham":{
    "name":"Graham County",
    "county":"http://72.165.8.69/GrahamWEB13/",
    "emergency":"http://72.165.8.69/GrahamWEB13/emergency-management/",
    "flood":"http://72.165.8.69/GrahamWEB13/county-engineer/"
  },
  "greenlee":{
    "name":"Greenlee County",
    "county":"http://www.co.greenlee.az.us/",
    "emergency":"http://www.co.greenlee.az.us/emergency/",
    "flood":"http://www.co.greenlee.az.us/engineering/"
  },
  "la":{
    "name":"La Paz County",
    "county":"http://www.co.la-paz.az.us/Index.html",
    "emergency":"http://www.co.la-paz.az.us/Emergency_Services.html",
    "flood":"http://www.co.la-paz.az.us/Community_Development.html"
  },
  "maricopa":{
    "name":"Maricopa County",
    "county":"http://www.maricopa.gov/",
    "emergency":"http://www.maricopa.gov/Emerg_Mgt/",
    "flood":"http://www.fcd.maricopa.gov/"
  },
  "mohave":{
    "name":"Mohave County",
    "county":"http://www.mohavecounty.us/",
    "emergency":"http://www.mohavecounty.us/ContentPage.aspx?id=124&cid=407",
    "flood":"http://www.mohavecounty.us/ContentPage.aspx?id=124&cid=392"
  },
  "navajo":{
    "name":"Navajo County",
    "county":"http://www.navajocountyaz.gov/Default.aspx",
    "emergency":"http://www.navajocountyaz.gov/emergencymanagement/Default.aspx",
    "flood":"http://www.navajocountyaz.gov/pubworks/"
  },
  "pima":{
    "name":"Pima County",
    "county":"http://webcms.pima.gov/",
    "emergency":"http://webcms.pima.gov/government/office_of_emergency_management_homeland_security/",
    "flood":"http://rfcd.pima.gov/"
  },"pinal":{
    "name":"Pinal County",
    "county":"http://pinalcountyaz.gov/Pages/Home.aspx",
    "emergency":"http://pinalcountyaz.gov/Departments/PublicWorks/EmergencyManagement/Pages/Home.aspx",
    "flood":"http://www.pinalcountyaz.gov/departments/publicworks/floodcontroldistrict/floodplain/Pages/Home.aspx"
  },
  "santa":{
    "name":"Santa Cruz County",
    "county":"http://www.co.santa-cruz.az.us/index.html",
    "emergency":"http://www.co.santa-cruz.az.us/es/oem/index.html",
    "flood":"http://www.co.santa-cruz.az.us/public_works/flood/index.html"
  },
  "yavapai":{
    "name":"Yavapai County",
    "county":"http://www.yavapai.us/",
    "emergency":"http://www.regionalinfo-alert.org/",
    "flood":"http://www.ycflood.com/"},
  "yuma":{
    "name":"Yuma County",
    "county":"http://www.co.yuma.az.us/index.aspx?page=1",
    "emergency":"http://www.co.yuma.az.us/index.aspx?page=266",
    "flood":"http://www.co.yuma.az.us/index.aspx?page=780"
  }
}



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
        countyInfo = COUNTY_CONTACTS[data.resourceSets[0].resources[0].address.adminDistrict2.toLowerCase().split(' ')[0]]
        callback bbox, point, name, countyInfo
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
    @getLocation query, (box, point, name, countyInfo) ->
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
        contacts: countyInfo

      # Okay, now for each layer
      for layer in hazardLayers
        output[layer.get("layerName")] = thisOne = {}

        # Check if we have currentData
        data = layer.get "currentData"

        # If there isn't any, we have to go get it
        if not data and layer.get("id") is not "floodPotential"?
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
          thisOne.mitigationUrl = layer.get "mitigationUrl"

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
          thisOne.mitigationUrl = layer.get "mitigationUrl"

      return