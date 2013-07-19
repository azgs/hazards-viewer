# Setup a global object to stash our work in
root = @
if not root.app? then app = root.app = {} else app = root.app

#Initialize the map
center = new L.LatLng 34.11180455556899, -111.7144775390625
zoom = 7

app.map = new L.Map "map",
  center: center
  zoom: zoom
  minZoom: 7
  maxZoom: 12

app.geoserverUrl = "http://data.usgin.org/arizona/ows"

# Setup data layers
dataLayers = [
    new app.models.GeoJSONLayer
      id: "earthFissures"
      layerName: "Earth Fissures"
      serviceUrl: app.geoserverUrl
      typeName: "azgs:earthfissures"
      useD3: true
      description: "Earth fissure maps are prepared by the Arizona Geological Survey (\"AZGS\") in accordance \
        with Ariz. Rev. Stat. § 27-152.01(3)."
      legend: new app.models.Legend [
          caption: "Continuous Earth Fissure"
          attribute: "fisstype"
          value: "Continuous Earth Fissure"
          imageTemplateId: "fissureImage"
          active: true
          imageInfo:
            color: "#000000"
        ,
          caption: "Discontinuous Earth Fissure"
          attribute: "fisstype"
          value: "Discontinuous Earth Fissure"
          imageTemplateId: "fissureImage"
          active: true
          imageInfo:
            color: "#FF0000"
        ,
          caption: "Reported, Unconfirmed Earth Fissure"
          attribute: "fisstype"
          value: "Reported, Unconfirmed Earth Fissure"
          imageTemplateId: "fissureImage"
          active: true
          imageInfo:
            color: "#008000"
            dashed: "10 4"
      ],
        heading: "Fissure Type"
      layerOptions:
        styler: "fisstype"
  ,
    new app.models.GeoJSONLayer
      id: "activeFaults"
      layerName: "Active Faults"
      serviceUrl: app.geoserverUrl
      typeName: "azgs:activefaults"
      useD3: true
      legend: new app.models.Legend [
          caption: "Holocene ( <10 ka )"
          attribute: "activefaults"
          value: "2.13.2"
          imageTemplateId: "faultImage"
          active: true
          imageInfo:
            color: "#FFA500"
        ,
          caption: "Late Quaternary ( <750 ka )"
          attribute: "activefaults"
          value: "2.13.3"
          imageTemplateId: "faultImage"
          active: true
          imageInfo:
            color: "#008000"
        ,
          caption: "Quaternary (Undifferentiated)"
          attribute: "activefaults"
          value: "2.13.4"
          imageTemplateId: "faultImage"
          active: true
          imageInfo:
            color: "#800080"
      ],
        heading: "Latest Motion"
      layerOptions:
        styler: "symbol"
  ,
    new app.models.GeoJSONLayer
      id: "earthquakes"     
      layerName: "Earthquake Hypocenters"
      serviceUrl: app.geoserverUrl
      typeName: "azgs:earthquakedata"
      legend: new app.models.Legend [
          caption: "0 - 1"
          attribute: "calculated_magnitude"
          value: "[-0.1, 1.1]"
          imageTemplateId: "quakeImage"
          active: true
          imageInfo:
            radius: 5
            color: "#FFFF00"
        ,
          caption: "1 - 2"
          attribute: "calculated_magnitude"
          value: "[0.9, 2.1]"
          imageTemplateId: "quakeImage"
          active: true
          imageInfo:
            radius: 10
            color: "#FFDD00"
        ,
          caption: "2 - 3"
          attribute: "calculated_magnitude"
          value: "[1.9, 3.1]"
          imageTemplateId: "quakeImage"
          active: true
          imageInfo:
            radius: 15
            color: "#FFBF00"
        ,
          caption: "3 - 4"
          attribute: "calculated_magnitude"
          value: "[2.9, 4.1]"
          imageTemplateId: "quakeImage"
          active: true
          imageInfo:
            radius: 20
            color: "#FF9D00"
        ,
          caption: "4 - 5"
          attribute: "calculated_magnitude"
          value: "[3.9, 5.1]"
          imageTemplateId: "quakeImage"
          active: true
          imageInfo:
            radius: 25
            color: "#FF8000"
        ,
          caption: "5 - 6"
          attribute: "calculated_magnitude"
          value: "[4.9, 6.1]"
          imageTemplateId: "quakeImage"
          active: true
          imageInfo:
            radius: 30
            color: "#FF5E00"
        ,
          caption: "6 - 7"
          attribute: "calculated_magnitude"
          value: "[5.9, 7.1]"
          imageTemplateId: "quakeImage"
          active: true
          imageInfo:
            radius: 35
            color: "#FF4000"
        ,
          caption: "7 - 8"
          attribute: "calculated_magnitude"
          value: "[6.9, 8.1]"
          imageTemplateId: "quakeImage"
          active: true
          imageInfo:
            radius: 40
            color: "#FF0000"
      ],
        heading: "Magnitude"
      layerOptions:
        pointToLayer: (feature, latlng) ->
          markerOptions =
            fillOpacity: 0.2

          mag = feature.properties.calculated_magnitude

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
      layerName: "Flood Potential"
      serviceUrl: "http://data.usgin.org/arizona/gwc/service/wms"
      wfsUrl: "http://data.usgin.org/arizona/ows"
      typeName: "azgs:floods"
      legend: new app.models.Legend [
          caption: "High"
          imageTemplateId: "floodImage"
          imageInfo:
            color: "#0039BF"
        ,
          caption: "Medium"
          imageTemplateId: "floodImage"
          imageInfo:
            color: "#6FCFF7"
      ],
        heading: "Flood Potential"
        filterable: false
  ,
    new app.models.TileLayer
      id: "fireRisk"
      layerName: "Fire Risk Index"
      url: "http://{s}.tiles.usgin.org/fire-risk-index/{z}/{x}/{y}.png"
      opacity: 0.5,
      downloadUrlTemplate: "http://data.usgin.org/arizona/wcs?service=WCS&version=1.0.0&request=GetCoverage&coverage=fireriskindex&crs=epsg:4326&bbox={{bbox}}&format=GeoTIFF&resy=3.0495095356186517E-4&resx=3.0495095356186517E-4",
      legend: new app.models.Legend [
          caption: "Lowest"
          imageTemplateId: "fireImage"
          imageInfo:
            color: "rgb(130,160,104)"
        ,
          caption: ""
          imageTemplateId: "fireImage"
          imageInfo:
            color: "rgb(177,207,158)"
        ,
          caption: ""
          imageTemplateId: "fireImage"
          imageInfo:
            color: "rgb(205,197,138)"
        ,
          caption: ""
          imageTemplateId: "fireImage"
          imageInfo:
            color: "rgb(255,255,175)"
        ,
          caption: ""
          imageTemplateId: "fireImage"
          imageInfo:
            color: "rgb(254,202,104)"
        ,
          caption: ""
          imageTemplateId: "fireImage"
          imageInfo:
            color: "rgb(253,154,8)"
        ,
          caption: ""
          imageTemplateId: "fireImage"
          imageInfo:
            color: "rgb(251,61,8)"
        ,
          caption: ""
          imageTemplateId: "fireImage"
          imageInfo:
            color: "rgb(193,0,6)"
        ,
          caption: "Highest"
          imageTemplateId: "fireImage"
          imageInfo:
            color: "rgb(95,0,2)"
      ],
        heading: "Relative Risk"
        filterable: false
]

app.dataLayerCollection = new app.models.LayerCollection dataLayers

# Setup base layers
app.bingApiKey = "AvRe9bcvCMLvazRf2jV1W6FaNT40ABwWhH6gRYKxt72tgnoYwHV1BnWzZxbm7QJ2"
baseLayers = [
    new app.models.BingLayer
      id: "Road"
      layerName: "Road Map"
      apiKey: app.bingApiKey
      bingType: "Road"
      active: true
  ,
    new app.models.BingLayer
      id: "Aerial"
      layerName: "Satellite Imagery"
      apiKey: app.bingApiKey
      bingType: "Aerial"
  ,
    new app.models.BingLayer
      id: "AerialWithLabels"
      layerName: "Imagery with Labels"
      apiKey: app.bingApiKey
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
      toolName: "Download Data"
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

# Render the Navbar tools
app.navbar = new app.views.NavToolView
  el: $ "body"
  collection: app.navToolCollection
app.navbar.render()

# Insert the print function
app.printFunction = new app.views.PrintToolView
  el: $ "#print-modal"
  collection: app.navToolCollection
app.printFunction.render()

# Insert the export modal body
app.exporter = new app.views.DownloadView
  el: $ "#export-modal"
  collection: app.dataLayerCollection
app.exporter.render()

# Setup the Geocoder
app.geocodeView = new app.GeocodeView
  model: new app.GeocodeModel
    apiKey: app.bingApiKey
  el: $ "#geocoder"

# Add a scalebar
app.map.addControl new L.Control.Scale()
