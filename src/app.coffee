# Setup a global object to stash our work in

console.log = () -> window.buff_temp = arguments

root = @
if not root.app? then app = root.app = {} else app = root.app

#Initialize the map
center = new L.LatLng 34.11180455556899, -111.7144775390625
zoom = 7

app.map = new L.Map "map",
  center: center
  zoom: zoom
  minZoom: 6
  maxZoom: 15

app.geoserverUrl = "http://data.usgin.org/arizona/ows"

# Setup data layers
dataLayers = [
    new app.models.GeoJSONLayer
      id: "earthFissures"
      layerName: "Earth Fissures"
      serviceUrl: app.geoserverUrl
      serviceType: "WFS"
      typeName: "azgs:earthfissures"
      active: false
      useD3: true
      citation: "Arizona Geological Survey"
      details: '<p>Earth fissures are open surface fractures that may be as much as a mile in length, up to 15 ft wide, and 10s of feet deep. In Arizona, earth fissures form as a result of land subsidence driven by groundwater withdrawal. The Arizona Geological Survey has mapped and reported earth fissures throughout south-central and southeastern Arizona since the 1990s and published earth fissure study area maps in accordance with Arizona Revised Statute § 27-152.01(3) since 2007.  Mapping of fissures involves incorporating mapped earth fissures from previous studies, examining remotely sensed subsidence data and aerial imagery, and on-site field mapping using high-precision GPS receivers.</p><p>Between 2007 and 2012, AZGS identified 24 discreet areas throughout southern and central Arizona with concentrations of earth fissures totaling more than 150 miles of mapped fissures. These include uninterrupted open fissures and fissure gullies and discontinuous linear trends of potholes, abbreviated open cracks, elongated depressions, and other collapse features. An additional 180 miles of reported/unconfirmed earth fissures appear on AZGS maps. These features include fissures previously mapped by professional geologists appearing in published maps or figures which could not be confirmed through recent surface mapping by AZGS Geologists. </p><p>A reasonable effort was made to identify all earth fissures in the study area although some fissures may remain unmapped due to overprinting or disturbance by development, agricultural tilling, or lack of surface expression along the fissure at the time mapping was conducted. In addition, earth fissures are not static features. They may change in width, depth or length, and new fissures may appear after an area has been mapped. For these reasons the State of Arizona does not guarantee the maps are error free. Blank areas within study area boundaries have been investigated and no surface evidence of fissures was found as of the date of map publication.</p><p>For additional information on the origin and impacts of earth fissures and free PDF maps of earth fissure study areas, visit the <a href="http://www.azgs.az.gov/EFC.shtml">Arizona Geological Survey’s Earth Fissure Center</a>.</p>'
      brief: 'Earth fissures are open surface fractures that may be as much as a mile in length, up to 15 ft wide, and 10s of feet deep.'
      links: [
          text: "AZGS Earth Fissure Center"
          url: "http://www.azgs.az.gov/EFC.shtml"
        , 
          text: "Mitigation Tips"
          url: "mitigation/fissures.html"
      ]
      mitigationUrl: "mitigation/fissures.html"
      lastUpdate: "Summer, 2013"
      description: '<h4>Layer Description</h4>'
      legend: new app.models.Legend [
          caption: "Continuous Earth Fissure"
          attribute: "fisstype"
          value: "Continuous"
          imageTemplateId: "fissureImage"
          active: true
          imageInfo:
            color: "#000000"
        ,
          caption: "Discontinuous"
          attribute: "fisstype"
          value: "Discontinuous"
          imageTemplateId: "fissureImage"
          active: true
          imageInfo:
            color: "#FF0000"
        ,
          caption: "Reported/Unconfirmed"
          attribute: "fisstype"
          value: "Reported/Unconfirmed"
          imageTemplateId: "fissureImage"
          active: true
          imageInfo:
            color: "#008000"
            dashed: "10 4"
      ],
        legendHeading: "Earth Fissure Type"
        heading: "Fissure Type"
      layerOptions:
        styler: "fisstype"
        style: (feature) ->
          defaultStyle =
            weight: 2
            fillOpacity: 0
            opacity: 1
          if feature.properties.fisstype is "Continuous"
            defaultStyle.color = "black"
          if feature.properties.fisstype is "Discontinuous"
            defaultStyle.color = "red"
          if feature.properties.fisstype is "Reported/Unconfirmed"
            defaultStyle.color = "green"
            defaultStyle.dashArray = "10 4"

          return defaultStyle
  ,
    new app.models.GeoJSONLayer
      id: "activeFaults"
      layerName: "Active Faults"
      serviceUrl: app.geoserverUrl
      serviceType: "WFS"
      typeName: "azgs:activefaults"
      active: false
      useD3: true
      citation: "Arizona Geological Survey"
      details: '<p>This layer summarizes available data on active Arizona faults. If faults have been active during the past 2.5 million years (Quaternary period), then we consider that there is some chance they could generate large earthquakes. Generally, the more active the fault zone is, the more likely it is to generate earthquakes, and earthquakes are more likely to occur in regions with many Quaternary faults.</p><p>These data were originally compiled in 1998 as part of an effort coordinated by the USGS to compile data and map information on Quaternary faults throughout the world. The database has recently been revised with much more accurate fault mapping, incorporation of new data on fault activity, and inclusion of additional fault zones, primarily in northern Arizona. This database depends heavily on several previous compilations of data on Quaternary faults in Arizona. The first and most comprehensive of these is the state-wide compilation of neotectonic faults by Menges and Pearthree (1983), supplemented by a state-wide compilation of young faults by Euge and others (1992). More detailed regional geologic maps provided most of the data in northern Arizona and southeastern Arizona. The database includes information from all detailed investigations of fault zones in Arizona.</p><p>The data structure is set up to provide systematic information on each fault zone. Fault names are based primarily on published maps or reports. In cases where different names have been used for the fault, the alternative names are listed within the database. All of the faults are listed by name and number in the table on the following page. This table indicates where the data summary for each fault can be found, as well as the age of youngest activity and fault slip rate category. The individual fault data sheets include information on map and data sources, fault location, geologic setting of the fault, the geomorphic expression of the fault, recency of fault movement, fault slip rate(s), and fault zone length and orientation. Faults are grouped into slip rate categories of <0.02 mm/yr, < 0.2 mm/yr, and <1 mm/yr. Most faults in Arizona fall into the lowest slip-rate category, with a few faults in the higher categories. Reported lengths are for the whole fault zone, not cumulative length of each individual fault in the zone, and orientations are averages for the fault zone.</p><p>Citations:</p><p>Euge, K.M., Schell, B.A. and Lam, I.P., 1992, Development of seismic acceleration maps for Arizona: Arizona Department of Transportation Report No. AZ92-344, 327 p., 5 sheets, scale 1:1,000,000. </p><p>Menges, C.M. and Pearthree, P.A., 1983, Map of neotectonic (latest Pliocene - Quaternary) deformation in Arizona: Arizona Bureau of Geology and Mineral Technology Open-File Report 83-22, 48 p., map scale 1:500,000, 4 map sheets.</p>'
      brief: 'Faults that are known to have been active within the last 2.5 million years (Quaternary period), and thus have some chance that they could generate a large earthquake.'
      links: []
      mitigationUrl: ""
      lastUpdate: "Fall, 2012"
      description: '<h4>Layer Description</h4>'
      legend: new app.models.Legend [
          caption: "Within 10,000 years"
          attribute: "symbol"
          value: "2.13.2"
          imageTemplateId: "faultImage"
          active: true
          imageInfo:
            color: "#FFA500"
        ,
          caption: "Within 750,000 years"
          attribute: "symbol"
          value: "2.13.3"
          imageTemplateId: "faultImage"
          active: true
          imageInfo:
            color: "#008000"
        ,
          caption: "Within 2.5 million years"
          attribute: "symbol"
          value: "2.13.4"
          imageTemplateId: "faultImage"
          active: true
          imageInfo:
            color: "#800080"
      ],
        legendHeading: "Active Faults Latest Motion"
        heading: "Most Recent Motion"
      layerOptions:
        styler: "symbol"
        style: (feature) ->
          defaultStyle =
            weight: 2
            fillOpacity: 0
            opacity: 1
          if feature.properties.symbol is "2.13.2"
            defaultStyle.color = "#FFA500"
          if feature.properties.symbol is "2.13.3"
            defaultStyle.color = "#008000"
          if feature.properties.symbol is "2.13.4"
            defaultStyle.color = "#800080"
          return defaultStyle
  ,
    new app.models.GeoJSONLayer
      id: "earthquakes"
      layerName: "Earthquake Epicenters"
      serviceUrl: app.geoserverUrl
      serviceType: "WFS"
      typeName: "azgs:earthquakedata"
      citation: "Arizona Geological Survey"
      details: '<p>The earthquakes displayed are from the AZGS Earthquake Catalog, and are the minimum number of earthquakes that have occurred in historical times.  Older events are represented by estimated Modified Mercalli Intensity Scale (MMI) roman-numeral values which reflect the amount of shaking experienced by those who felt and reported the earthquake. For a full description of the MMI scale, please refer to: <a href="http://earthquake.usgs.gov/learn/topics/mercalli.php">http://earthquake.usgs.gov/learn/topics/mercalli.php</a></p><p>The earthquake layer in the AZGS Hazard Viewer includes an epicentral location denoted in Latitude and Longitude, depth (in kilometers), date and time (UTC; -7:00 for MST). There are several magnitude scales employed to estimate the size (i.e., energy release) of an earthquake, such as Md - duration magnitude, ML - local magnitude, Mw - moment magnitude.  AZGS calculates duration magnitude, Md; however, the catalog includes all three types of magnitude scales depending on who located the event. For example, northern Arizona earthquakes located by the University of Utah are frequently assigned a local magnitude (Ml).  Sources of earthquake data reported in the AZGS Earthquake Catalog, include: AZGS (Arizona Geological Survey), USGS (United States Geological Survey), AEIC (Arizona Earthquake Information Center), UU (University of Utah), CI (California Integrated Seismic Network), and ASU (thesis work by Lockridge, Arizona State University). The earthquake layer does not include small magnitude events (< 2.0) because of the difficulty inherent in identifying and locating such events.</p>'
      brief: 'The earthquakes displayed are from the AZGS Earthquake Catalog, and are the minimum number of earthquakes that have occurred in the historical period dating to about 1850.'
      links: [
          text: "Description of Modified Mercalli Intensity Scale"
          url: "http://earthquake.usgs.gov/learn/topics/mercalli.php"
        , 
          text: "Mitigation Tips"
          url: "mitigation/earthquakes.html"
        ,
          text: "Arizona Emergency Information Network"
          url: "http://www.azein.gov/azein/Hazards%20%20Arizona/Earthquake.aspx?PageView=Shared"
      ]
      mitigationUrl: "mitigation/earthquakes.html"
      lastUpdate: "Aug. 7, 2013"
      description: '<h4>Layer Description</h4>'
      filterClause: "&filter=#{(new app.models.Filter([{calculated_magnitude: "[2.0,9.0]"}])).urlEncoded()}"
      active: false
      legend: new app.models.Legend [
          caption: "Older Earthquakes"
          attribute: "magnitude"
          value: "contains(I,II,III,IV,V,VI,VII,VIII)"
          imageTemplateId: "quakeIntensityImage"
          active: true
        ,
          caption: "2 - 3"
          attribute: "magnitude"
          value: "[1.9, 3.1]"
          imageTemplateId: "quakeImage"
          active: true
          imageInfo:
            radius: 15
            color: "#FFBF00"
        ,
          caption: "3 - 4"
          attribute: "magnitude"
          value: "[2.9, 4.1]"
          imageTemplateId: "quakeImage"
          active: true
          imageInfo:
            radius: 20
            color: "#FF9D00"
        ,
          caption: "4 - 5"
          attribute: "magnitude"
          value: "[3.9, 5.1]"
          imageTemplateId: "quakeImage"
          active: true
          imageInfo:
            radius: 25
            color: "#FF8000"
        ,
          caption: "5 - 6"
          attribute: "magnitude"
          value: "[4.9, 6.1]"
          imageTemplateId: "quakeImage"
          active: true
          imageInfo:
            radius: 30
            color: "#FF5E00"
        ,
          caption: "6 - 7"
          attribute: "magnitude"
          value: "[5.9, 7.1]"
          imageTemplateId: "quakeImage"
          active: true
          imageInfo:
            radius: 35
            color: "#FF4000"
        ,
          caption: "7 - 8"
          attribute: "magnitude"
          value: "[6.9, 8.1]"
          imageTemplateId: "quakeImage"
          active: true
          imageInfo:
            radius: 40
            color: "#FF0000"
      ],
        legendHeading: "Earthquake Magnitude"
        heading: "Magnitude"
      layerOptions:
        pointToLayer: (feature, latlng) ->
          markerOptions =
            fillOpacity: 0.2

          if isNaN Number feature.properties.magnitude
            markerOptions.size = 15
            markerOptions.color = markerOptions.fill = "#F24BE7"
            markerOptions.opacity = 1
            return new L.TriangleMarker [latlng], markerOptions

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

          d = new Date Date.parse feature.properties.date

          props = [
            key: "Date"
            value: d.toDateString()
          ]

          if isNaN feature.properties.magnitude
            lookup =
              I: "<strong>I.</strong> Not felt except by a very few under especially favorable conditions."
              II: "<strong>II.</strong> Felt only by a few persons at rest, especially on upper floors of buildings."
              III: "<strong>III.</strong> Felt quite noticeably by persons indoors, especially on upper floors of buildings. Many people do not recognize it as an earthquake. Standing motor cars may rock slightly. Vibrations similar to the passing of a truck. Duration estimated."
              IV: "<strong>IV.</strong> Felt indoors by many, outdoors by few during the day. At night, some awakened. Dishes, windows, doors disturbed; walls make cracking sound. Sensation like heavy truck striking building. Standing motor cars rocked noticeably."
              V: "<strong>V.</strong> Felt by nearly everyone; many awakened. Some dishes, windows broken. Unstable objects overturned. Pendulum clocks may stop."
              VI: "<strong>VI.</strong> Felt by all, many frightened. Some heavy furniture moved; a few instances of fallen plaster. Damage slight."
              VII: "<strong>VII.</strong> Damage negligible in buildings of good design and construction; slight to moderate in well-built ordinary structures; considerable damage in poorly built or badly designed structures; some chimneys broken."
              VIII: "<strong>VIII.</strong> Damage slight in specially designed structures; considerable damage in ordinary substantial buildings with partial collapse. Damage great in poorly built structures. Fall of chimneys, factory stacks, columns, monuments, walls. Heavy furniture overturned."
              IX: "<strong>IX.</strong> Damage considerable in specially designed structures; well-designed frame structures thrown out of plumb. Damage great in substantial buildings, with partial collapse. Buildings shifted off foundations."

            props.push
              key: "Intensity"
              value: "<p>#{lookup[feature.properties.magnitude]}</p><p><a href='http://earthquake.usgs.gov/learn/topics/mercalli.php' target='_blank'>Read more about Intensity...</a></p>"
          else
            props.push
              key: "Magnitude"
              value: "#{feature.properties.magnitude}"

          layer.bindPopup _.template $("#defaultPopup").html(),
            properties: props
  ,
    new app.models.WmsLayer
      id: "floodPotential"
      layerName: "Flood Potential"
      serviceUrl: "http://data.usgin.org/arizona/gwc/service/wms"
      serviceType: "WMS"
      wfsUrl: "http://data.usgin.org/arizona/ows"
      typeName: "azgs:floods"
      active: false
      citation: "Arizona Division of Emergency Management"
      details: '<p>This layer shows areas with potentially High and Medium Risk of flooding. Data are drawn from the Federal Emergency Management Agency (FEMA) digital flood insurance rate maps (DFIRM) database, dated May 2010. High flooding potential includes areas covered by all of the “A” Special Flood Hazard zones. These areas have a 1% annual chance of flooding, also known as the 100-year flood, and a 26% chance of flooding within the span of a 30-year mortgage. Medium flood potential includes  areas within the “Shaded X” zones. These are areas between the limits of the 100-year and 500-year flood zones.</p><p>The flood potential layer was created by JE Fuller/Hydrology and Geomorpholgy, Inc. for the Arizona Division of Emergency Management (ADEM), as part of a larger study for the <a href="http://www.dem.azdema.gov/operations/mitigation/hazmitplan/hazmitplan.html">2010 State of Arizona Multi-Hazard Mitigation Plan</a>. Data is current as of May 2010. These data are provided as guidance only. Local Flood Control Districts should be consulted for additional or more detailed information.</p>'
      brief: 'Areas with High and Medium flooding potential as represented by the 100- and 500- flood zones determined by the Federal Emergency Management Agency (FEMA) digital flood insurance rate maps (DFIRM) database, dated May 2010.'
      links: [
          text: "2010 State of Arizona Multi-Hazard Mitigation Plan"
          url: "http://www.dem.azdema.gov/operations/mitigation/hazmitplan/hazmitplan.html"
        , 
          text: "Mitigation Tips"
          url: "mitigation/floods.html"
        ,
          text: "Arizona Emergency Information Network"
          url: "http://www.azein.gov/azein/Hazards%20%20Arizona/Flooding.aspx?PageView=Shared"
      ]
      mitigationUrl: "mitigation/floods.html"
      lastUpdate: "May, 2010"
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
        legendHeading: "Flood Potential"
        heading: "Flood Potential"
        filterable: false
  ,
    new app.models.TileLayer
      id: "fireRisk"
      layerName: "Fire Risk Index"
      url: "http://{s}.tiles.usgin.org/fire-risk-index/{z}/{x}/{y}.png"
      serviceType: "WMS"
      opacity: 0.5,
      downloadUrlTemplate: "http://data.usgin.org/arizona/wcs?service=WCS&version=1.0.0&request=GetCoverage&coverage=fireriskindex&crs=epsg:4326&bbox={{bbox}}&format=GeoTIFF&resy=3.0495095356186517E-4&resx=3.0495095356186517E-4",
      citation: 'Oregon Department of Forestry, 2013, West Wide Wildfire Risk Assessment, final report, Prepared by the Sanborn Map Company.'
      details: '<p>The Fire Risk Index (FRI) layer, as shown here, depicts relative risks of areas susceptible to wildfires with 1 (dark green) representing the lowest risk and 9 (dark red) representing the highest risk. The data was developed through the West Wide Wildfire Risk Assessment (WWA) project to identify areas susceptible to wildfires in 17 western states and some U.S. affiliated Pacific Islands. The Oregon Department of Forestry (2013) implemented this project on behalf of the Council of Western State Foresters and the Western Forestry Leadership Coalition. The goal of the project was to provide a wildfire risk assessment appropriate for comparing areas at risks to wildfires across geographic regions, or within individual states, and to aid in mitigation of areas at risk, to identify the level of risks within communities and to communicate those risks to the public.</p><p>The FRI layer was created from the Fire Effect Index (FEI) and Fire Threat Index (FTI). FEI identifies areas that have important values at risk to wildfire and where wildland fires would be difficult and/or costly to suppress. FTI describes the likelihood of an acre burning and the expected final fire size based on conditions of fuels and potential fire behavior under different weather scenarios. FEI and FTI data were combined to create the FRI layer which describes relative probabilities of areas at risk to wildfires. The data used to develop FEI, FTI and FRI reflects conditions between 2008 and 2010, depending on the type of data (i.e. fuels, wildland development areas, and historic fire locations, etc.).</p><hr /><h4>Disclaimer</h4><p>The Oregon Department of Forestry implemented conducting this assessment on behalf of the Council of Western State Foresters with funding from the USDA Forest Service. Anyone utilizing this layer is asked to credit the Oregon Department of Forestry. Users must read and fully comprehend the metadata prior to data use. The spatial data to develop this layer were derived from a variety of sources. Care was taken in the creation of these themes, but they are provided "as is." The Oregon Department of Forestry, State of Oregon, WWA Project Partners, or any of the data providers cannot accept any responsibility for errors, omissions, or positional accuracy in the digital data or underlying records. There are no warranties, expressed or implied, including the warranty of merchantability or fitness for a particular purpose, accompanying any of these products.</p><p>The West Wide Risk Assessment was conducted to support strategic planning at regional, state, and landscape scale. WWA data is intended for planning purposes only and should not to be used for engineering or legal purposes. Further investigation by local and regional experts should be conducted to inform decisions regarding local applicability. It is the sole responsibility of the local user, using product metadata and local knowledge, to determine if and/or how WWA data can be used for particular areas of interest. It is the responsibility of the user to be familiar with the value, assumptions, and limitations of WWA products. Managers and planners must evaluate WWA data according to the scale and requirements specific to their needs. Please note that the WWA Published Results may not match other assessments conducted that use different data, technical methods, or scale of analysis. Having two assessments that do not match does not mean that either one of them is incorrect. The use of different data sources, often from different collection dates and with spatial accuracy and resolutions, combined with different modeling assumptions or definitions will result in different results and can have different interpretations and uses. The WWA results are not intended to replace local and state products as a decision-making tool. The WWA is meant to serve as a regional policy analysis tool that provides results comparable across geographic areas in the West.</p>',
      brief: 'Shows the relative risks of wildfire based on values at risk (i.e. development, infrastructure, etc.), the likelihood of an acre to burn, the expected final fire size based on fuels conditions and potential fire behavior and the difficulty or expense of suppression.'
      links: [ 
          text: "Mitigation Tips"
          url: "mitigation/fires.html"
        ,
          text: "Arizona Emergency Information Network"
          url: "http://www.azein.gov/azein/Hazards%20%20Arizona/Wildfire.aspx"
      ]
      mitigationUrl: "mitigation/fires.html"
      lastUpdate: "Fall 2013"
      active: false
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
        legendHeading: "FRI Relative Risk"
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
      id: "print"
      toolName: "Print a Map"
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

helpers = [
    new app.models.HelpModel
      id: "baselayers-help"
      ele: ".dropdown"
      head: "Toggle Basemap Layers"
      description: "Click the 'Base Layers' drop-down list to switch the basemap in the viewer."
  ,
    new app.models.HelpModel
      id: "menu-help"
      ele: ".menu"
      head: "Navigation Menu"
      description: "Description goes here."
]

app.helpersCollection = new app.models.HelpCollection helpers

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

# Setup the help tools
app.helperFunction = new app.views.HelpView
  el: $ "#mainHelp-modal"
  collection: app.helpersCollection
app.helperFunction.render()

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
