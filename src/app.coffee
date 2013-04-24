# Setup a global object to stash our work in
root = @
if not root.app? then app = root.app = {} else app = root.app

#Initialize the map
center = new L.LatLng 33.610044573695625, -111.50024414062501
zoom = 9

app.map = new L.Map "map",
  center: center
  zoom: zoom

geoserverUrl = "http://data.usgin.org/arizona/ows"

# Setup data layers
dataLayers = [
    new app.models.GeoJSONLayer
      id: "earthFissures"
      div_id: "earthFissures.id"
      datatarget:"#earthFissures"
      layerName: "Earth Fissures"
      legend:"Earth fissures legend"
      serviceUrl: geoserverUrl
      typeName: "azgs:earthfissures"
      useD3: true
      layerOptions:
        styler: "fisstype"
  ,
    new app.models.GeoJSONLayer
      id: "activeFaults"
      div_id: "activeFaults.id"
      datatarget:"#activeFaults"
      layerName: "Active Faults"
      legend:"Active faults legend"
      serviceUrl: geoserverUrl
      typeName: "azgs:activefaults"
      useD3: true
      layerOptions:
        styler: "symbol"
  ,
    new app.models.GeoJSONLayer
      id: "earthquakes"
      div_id: "earthquakes.id"
      datatarget:"#earthquakes"      
      layerName: "Earthquake Hypocenters"
      legend:"Earthquake hypocenters legend"
      serviceUrl: geoserverUrl
      typeName: "azgs:earthquakedata"
      layerOptions:
        pointToLayer: (feature, latlng) ->
          markerOptions =
            fillOpacity: 0.2

          # Try to make a float from the magnitude
          if isNaN parseFloat feature.properties.magnitude
            switch feature.properties.magnitude
              when "I" then mag = 1
              when "II" then mag = 2
              when "III" then mag = 3
              when "IV" then mag = 4
              when "V" then mag = 5
              when "VI" then mag = 6
              when "VII" then mag = 7

          else
            mag = parseFloat feature.properties.magnitude

          if 0 < mag <= 1 then color = "#FFFF00" # Dead yellow, hsl: 60,100,100
          else if 1 < mag <= 2 then color = "#FFDD00"
          else if 2 < mag <= 3 then color = "#FFBF00"
          else if 3 < mag <= 4 then color = "#FF9D00"
          else if 4 < mag <= 5 then color = "#FF8000"
          else if 5 < mag <= 6 then color = "#FF5E00"
          else if 6 < mag <= 7 then color = "#FF4000"
          else if 7 < mag <= 8 then color = "#FF0000" # Dead red, hsl: 0, 100, 100

          markerOptions.radius = mag * 5
          markerOptions.color = markerOptions.fillColor = color

          return L.circleMarker latlng, markerOptions

        onEachFeature: (feature, layer) ->
          layer.bindPopup feature.properties.magnitude
  ,
    new app.models.WmsLayer
      id: "floodPotential"
      div_id: "floodPotential.id"
      datatarget:"#floodPotential"      
      layerName: "Flood Potential"
      legend:"Flood potential legend"
      serviceUrl: "http://data.usgin.org/arizona/gwc/service/wms"
      typeName: "azgs:floods"
]

app.dataLayerCollection = new app.models.LayerCollection dataLayers

# Setup base layers
bingApiKey = "AvRe9bcvCMLvazRf2jV1W6FaNT40ABwWhH6gRYKxt72tgnoYwHV1BnWzZxbm7QJ2"
baseLayers = [
    new app.models.BingLayer
      id: "bingRoads"
      layerName: "Road Map"
      apiKey: bingApiKey
      bingType: "Road"
      active: true
  ,
    new app.models.BingLayer
      id: "bingAerial"
      layerName: "Satellite Imagery"
      apiKey: bingApiKey
      bingType: "Aerial"
  ,
    new app.models.BingLayer
      id: "bingAerialWithLabels"
      layerName: "Imagery with Labels"
      apiKey: bingApiKey
      bingType: "AerialWithLabels"
]

app.baseLayerCollection = new app.models.LayerCollection baseLayers

navTools = [
    new app.models.NavToolModel
      id: "addLayer"
      toolName: "Add Layer"
      modalName: "Add a Layer"
      modalBody: "Not Implemented Yet"
  , 
    new app.models.NavToolModel
      id: "print"
      toolName: "Print"
      modalName: "Print a Map"
      modalBody: "Not Implemented Yet"
  , 
    new app.models.NavToolModel
      id: "export"
      toolName: "Export"
      modalName: "Download Data"
      modalBody: "Not Implemented Yet"
  ,
    new app.models.NavToolModel
      id: "mainHelp"
      toolName: "Help"
      modalName: "How Do I Do This?"
      modalBody: "Not Implemented Yet"
]

app.navToolCollection = new app.models.NavToolCollection navTools

# Render the sidebar
app.sidebar = new app.views.SidebarView
  el: $("#layer-list").first()
  collection: app.dataLayerCollection
app.sidebar.render()

# Render the base layer dropdown
app.baseLayers = new app.views.BasemapView
  el: $("#dropmenu").first()
  collection: app.baseLayerCollection
app.baseLayers.render()

app.navbar = new app.views.NavToolView
  el: $ "body"
  collection: app.navToolCollection
app.navbar.render()

# Setup the Leaflet Draw extension
app.drawControl = new L.Control.Draw
  position: "topleft"
  rectangle:
    shapeOptions:
      color:"#33cc33"
      weight:5
  polygon: null
  polyline: null
  circle: null
  marker: null

app.map.addControl app.drawControl

# Setup the Geocoder
app.geocodeView = new app.GeocodeView
  model: new app.GeocodeModel
    apiKey: bingApiKey
  el: $ "#geocoder"
