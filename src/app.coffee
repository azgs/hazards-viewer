# Setup a global object to stash our work in
root = @
if not root.app? then app = root.app = {} else app = root.app

#Initialize the map
center = new L.LatLng 33.610044573695625, -111.50024414062501
zoom = 9

app.map = new L.Map "map",
  center: center
  zoom: zoom
  
# Setup Layers
app.mapLayers = [
    new app.LayerModel
      geoserverUrl: "http://data.usgin.org/arizona/ows"
      typeName: "azgs:earthfissures"
      id:"earthFissures"
      layerName:"Earth Fissures"
      styler: "fisstype"
  ,
    new app.LayerModel
      geoserverUrl: "http://data.usgin.org/arizona/ows"
      typeName: "azgs:activefaults"
      id:"activeFaults"
      layerName:"Active Faults"
      styler: "symbol"
  ,
    new app.LayerModel
      # I haven't figured out Geoserver's TMS URLs yet, so this doesn't work yet
      # tileUrl: "http://data.usgin.org/arizona/gwc/service/tms/1.0.0/azgs:floods@EPSG:900913@png/{z}/{x}/{y}.png"
      geoserverUrl: "http://data.usgin.org/arizona/gwc/service/wms"
      typeName: "azgs:floods"
      id:"floodPotential"
      layerName:"Flood Potential"
      useWms: true
  ,
    new app.LayerModel
      geoserverUrl: "http://data.usgin.org/arizona/ows"
      typeName: "azgs:earthquakedata"
      id: "earthquakes"
      straightGeoJson: true
      layerOptions:
        pointToLayer: (feature, latlng) ->
          markerOptions =
            fillOpacity: 0.2
            hands: "feet"

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

      layerName: "Earthquakes"
      styler: "magnitude"
]

app.baseMaps = [
    new app.baseMapModel
      id:"bingRoads"
      mapName:"Bing Maps Roads"
      apiKey:"AvRe9bcvCMLvazRf2jV1W6FaNT40ABwWhH6gRYKxt72tgnoYwHV1BnWzZxbm7QJ2"
      type:"Road"
      useBing:true
      active:true      
  ,  
    new app.baseMapModel
      id:"bingAerial"
      mapName:"Bing Maps Aerial"
      apiKey:"AvRe9bcvCMLvazRf2jV1W6FaNT40ABwWhH6gRYKxt72tgnoYwHV1BnWzZxbm7QJ2"
      type:"Aerial"
      useBing:true
  ,
    new app.baseMapModel
      id:"bingAerialLabels"
      mapName:"Bing Maps Aerial w/ Labels"
      apiKey:"AvRe9bcvCMLvazRf2jV1W6FaNT40ABwWhH6gRYKxt72tgnoYwHV1BnWzZxbm7QJ2"
      type:"AerialWithLabels"
      useBing:true           
]

app.layerCollection = new app.LayerCollection app.mapLayers
app.baseMapCollection = new app.BaseMapCollection app.baseMaps

# Render the sidebar
app.sidebar = new app.SidebarView
  el:$("#layer-list").first()
  collection: app.layerCollection
app.sidebar.render()

app.baseLayers = new app.baseMapView
  el:$("#dropmenu").first()
  collection: app.baseMapCollection
app.baseLayers.render()

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
    apiKey: "AvRe9bcvCMLvazRf2jV1W6FaNT40ABwWhH6gRYKxt72tgnoYwHV1BnWzZxbm7QJ2"
  el: $("#geocoder")
