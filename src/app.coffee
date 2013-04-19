# Setup a global object to stash our work in
root = @
if not root.app? then app = root.app = {} else app = root.app

#Initialize the map
layer = new L.TileLayer "http://a.tiles.mapbox.com/v3/rclark.map-x9c4guq4/{z}/{x}/{y}.png"
center = new L.LatLng 33.610044573695625, -111.50024414062501
zoom = 9

app.map = new L.Map "map",
  center: center
  zoom: zoom
  layers: layer
  
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
      geoserverUrl: "http://services.usgin.org/geoserver/ows"
      typeName: "azgs:floodhazards"
      id:"floodPotential"
      layerName:"Flood Potential"
      useWms: true
  ,
    new app.LayerModel
      geoserverUrl: "http://services.usgin.org/geoserver/ows"
      typeName: "azgs:earthquakedata"
      id:"earthquakes"
      layerName:"Earthquakes"
      styler: "magnitude"
]

app.layerCollection = new app.LayerCollection app.mapLayers

# Render the sidebar
app.sidebar = new app.SidebarView
  el:$("#layer-list").first()
  collection: app.layerCollection

app.sidebar.render()