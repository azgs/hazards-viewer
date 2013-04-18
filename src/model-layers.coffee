class app.Model extends Backbone.Model
  defaults:
    model:""
    id:""
    layerName:""
    geoJSON_URL:""
    layer:""
    
  initialize: (options) ->
    @set "id",options.id
    @set "layerName",options.layerName
    @set "geoJSON_URL",options.geoJSON_URL
    @set "layer", @createLayer()

  createLayer: () ->
    return new L.GeoJSON.d3.async @get("geoJSON_URL"), styler: {}
    
app.fissuresLayer=new app.Model
  model:"Model"
  id:"earthFissures"
  layerName:"Earth Fissures"
  geoJSON_URL:"http://services.usgin.org/geoserver/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=azgs:earthfissures&outputFormat=json"
  
app.faultsLayer=new app.Model
  model:"Model"
  id:"activeFaults"
  layerName:"Active Faults"
  geoJSON_URL:"http://services.usgin.org/geoserver/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=azgs:activefaults&outputFormat=json"

app.floodsLayer=new app.Model
  mode:"Model"
  id:"floodPotential"
  layerName:"Flood Potential"
  geoJSON_URL:"http://services.usgin.org/geoserver/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=azgs:floodhazards&outputFormat=json"

app.quakesLayer=new app.Model
  mode:"Model"
  id:"earthquakes"
  layerName:"Earthquakes"
  geoJSON_URL:"http://services.usgin.org/geoserver/ows?service=WFS&version=1.0.0&request=GetFeature&typeName=azgs:earthquakedata&outputFormat=json"

class app.Collection extends Backbone.Collection
  model:app.Model

app.layerCollection=new app.Collection [app.fissuresLayer,app.faultsLayer,app.floodsLayer,app.quakesLayer]

