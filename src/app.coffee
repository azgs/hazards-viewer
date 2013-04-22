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
      id:"earthquakes"
      layerName:"Earthquakes"
      styler: "magnitude"
]

app.baseMaps = [
    new app.baseMapModel
      id:"bingRoads"
      mapName:"Bing Maps Roads"
      apiKey:"AvRe9bcvCMLvazRf2jV1W6FaNT40ABwWhH6gRYKxt72tgnoYwHV1BnWzZxbm7QJ2"
      type:"Road"
      useBing:true
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
      default:true           
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