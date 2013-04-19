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
app.fissuresLayer=new app.LayerModel
  id:"earthFissures"
  layerName:"Earth Fissures"
  geoJSON_URL:"http://data.usgin.org/arizona/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=azgs:earthfissures&outputFormat=json"
  styler: "fisstype"

app.faultsLayer=new app.LayerModel
  id:"activeFaults"
  layerName:"Active Faults"
  geoJSON_URL:"http://services.usgin.org/geoserver/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=azgs:activefaults&outputFormat=json"

app.floodsLayer=new app.LayerModel
  id:"floodPotential"
  layerName:"Flood Potential"
  geoJSON_URL:"http://services.usgin.org/geoserver/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=azgs:floodhazards&outputFormat=json"

app.quakesLayer=new app.LayerModel
  id:"earthquakes"
  layerName:"Earthquakes"
  geoJSON_URL:"http://services.usgin.org/geoserver/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=azgs:earthquakedata&outputFormat=json"

app.layerCollection=new app.LayerCollection [app.fissuresLayer,app.faultsLayer,app.floodsLayer,app.quakesLayer]

# Render the sidebar
app.sidebar = new app.SidebarView
  el:$("#layer-list").first()
  collection: app.layerCollection

app.sidebar.render()