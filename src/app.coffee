# Setup a global object to stash our work in
root = @
if not root.app? then app = root.app = {} else app = root.app

#Initialize the map
layer = new L.BingLayer "AkfIUAQ4-XFxEC6NQsNO1aDX9iMCXrKYeE5Fqd8Y9ie0zB1MJUM_Ag_S1XUjEIuG",
  type: "Road"
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